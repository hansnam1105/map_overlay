(function(root, factory) {
  if (typeof define === 'function' && define.amd) {
    // AMD. Register as an anonymous module.
    define(['leaflet'], factory);
  } else if (typeof module === 'object' && module.exports) {
    // Node. Does not work with strict CommonJS, but
    // only CommonJS-like environments that support module.exports,
    // like Node.
    module.exports = factory(require('leaflet'));
  } else if (typeof root !== 'undefined' && root.L) {
    // Browser globals (root is window)
    root.L.echartsLayer = factory(L);
  }
}(this, function(L) {
  L.EchartsLayer = L.Class.extend({
    includes: [L.Mixin.Events],
    _echartsContainer: null,
    _map: null,
    _ec: null,
    _option: null,
    _geoCoord: [],
    _mapOffset: [0, 0],
    _delta: 0,
    _startTime: null,
    _lastMousePos: null,
    initialize: function(map, ec) {
      this._map = map;
      var size = map.getSize();
      var div = this._echartsContainer = document.createElement('div');
      div.style.position = 'absolute';
      div.style.height = size.y + 'px';
      div.style.width = size.x + 'px';
      div.style.top = 0;
      div.style.left = 0;
      map.getPanes().overlayPane.appendChild(div);
      this._init(map, ec);
    },
    _init: function(map, ec) {
      var self = this;
      self._map = map;
      //지도 오버레이 초기화
      /**
       * echarts 컨테이너 받기
       *
       * @return {HTMLElement}
       * @public
       */
      self.getEchartsContainer = function() {
        return self._echartsContainer;
      };

      /**
       * 지도 인스턴스 가져 오기
       *
       * @return {map.Map}
       * @public
       */
      self.getMap = function() {
        return self._map;
      };
      /**
       * 위도와 경도를 화면 픽셀로 변환
       *
       * @param {Array.<number>} geoCoord  위도 및 경도
       * @return {Array.<number>}
       * @public
       */
      self.geoCoord2Pixel = function(geoCoord) {
        var point = new L.latLng(geoCoord[1], geoCoord[0]);
        var pos = self._map.latLngToContainerPoint(point);
        return [pos.x, pos.y];
      };

      /**
       * 위도와 경도로 변환 된 화면 픽셀
       *
       * @param {Array.<number>} pixel  픽셀 좌표
       * @return {Array.<number>}
       * @public
       */
      self.pixel2GeoCoord = function(pixel) {
        var point = self._map.containerPointToLatLng(L.point(pixel[0], pixel[1]));
        return [point.lng, point.lat];
      };

      /**
       * 초기 echarts 인스턴스
       *
       * @return {ECharts}
       * @public
       */
      self.initECharts = function() {
        self._ec = ec.init.apply(self, arguments);
        self._bindEvent();
        self._addMarkWrap();
        return self._ec;
      };

      // 지리적 위치에 따라 바이두 맵에서 위치를 얻기위한 addMark 랩
      // by kener at 2015.01.08
      self._addMarkWrap = function() {
        function _addMark(seriesIdx, markData, markType) {
          var data;
          if (markType == 'markPoint') {
            var data = markData.data;
            if (data && data.length) {
              for (var k = 0, len = data.length; k < len; k++) {
                if (!(data[k].name && this._geoCoord.hasOwnProperty(data[k].name))) {
                  data[k].name = k + 'markp';
                  self._geoCoord[data[k].name] = data[k].geoCoord;
                }
                self._AddPos(data[k]);
              }
            }
          } else {
            data = markData.data;
            if (data && data.length) {
              for (var k = 0, len = data.length; k < len; k++) {
                if (!(data[k][0].name && this._geoCoord.hasOwnProperty(data[k][0].name))) {
                  data[k][0].name = k + 'startp';
                  self._geoCoord[data[k][0].name] = data[k][0].geoCoord;
                }
                if (!(data[k][1].name && this._geoCoord.hasOwnProperty(data[k][1].name))) {
                  data[k][1].name = k + 'endp';
                  self._geoCoord[data[k][1].name] = data[k][1].geoCoord;
                }
                self._AddPos(data[k][0]);
                self._AddPos(data[k][1]);
              }
            }
          }
          self._ec._addMarkOri(seriesIdx, markData, markType);
        }

        self._ec._addMarkOri = self._ec._addMark;
        self._ec._addMark = _addMark;
      };

      /**
       * ECharts 인스턴스 가져 오기
       *
       * @return {ECharts}
       * @public
       */
      self.getECharts = function() {
        return self._ec;
      };

      /**
       * 지도의 오프셋을 가져옵니다
       *
       * @return {Array.<number>}
       * @public
       */
      self.getMapOffset = function() {
        return self._mapOffset;
      };

      /**
       * charts setOption에 하나의 치료 추가
       * x 및 y 좌표를 markPoint 및 markLine에 추가하는 데 사용되며 이름은 geoCoord와 일치해야합니다
       *
       * @public
       * @param option
       * @param notMerge
       */
      self.setOption = function(option, notMerge) {
        self._option = option;
        var series = option.series || {};

        // 记录所有的geoCoord
        for (var i = 0, item; item = series[i++];) {
          var geoCoord = item.geoCoord;
          if (geoCoord) {
            for (var k in geoCoord) {
              self._geoCoord[k] = geoCoord[k];
            }
          }
        }

        //  x, y 추가
        for (var i = 0, item; item = series[i++];) {
          var markPoint = item.markPoint || {};
          var markLine = item.markLine || {};

          var data = markPoint.data;
          if (data && data.length) {
            for (var k = 0, len = data.length; k < len; k++) {
              if (!(data[k].name && this._geoCoord.hasOwnProperty(data[k].name))) {
                data[k].name = k + 'markp';
                self._geoCoord[data[k].name] = data[k].geoCoord;
              }
              self._AddPos(data[k]);
            }
          }

          data = markLine.data;
          if (data && data.length) {
            for (var k = 0, len = data.length; k < len; k++) {
              if (!(data[k][0].name && this._geoCoord.hasOwnProperty(data[k][0].name))) {
                data[k][0].name = k + 'startp';
                self._geoCoord[data[k][0].name] = data[k][0].geoCoord;
              }
              if (!(data[k][1].name && this._geoCoord.hasOwnProperty(data[k][1].name))) {
                data[k][1].name = k + 'endp';
                self._geoCoord[data[k][1].name] = data[k][1].geoCoord;
              }
              self._AddPos(data[k][0]);
              self._AddPos(data[k][1]);
            }
          }
        }

        self._ec.setOption(option, notMerge);
      };

      /**
       * x 및 y 좌표 증가
       *
       * @param {Object} obj markPoint 및 markLine 데이터의 항목 이름이 있어야합니다
       * @param {Object} geoCoord
       */
      self._AddPos = function(obj) {

        var coord = self._geoCoord[obj.name];
        var pos = self.geoCoord2Pixel(coord);
        obj.x = pos[0]; //- self._mapOffset[0];
        obj.y = pos[1]; //- self._mapOffset[1];
      };

      /**
       * 바인딩 맵 이벤트 처리 방법
       *
       * @private
       */
      self._bindEvent = function() {
        self._map.on('move', _moveHandler('moving'));
        self._map.on('moveend', _moveHandler('moveend'));
        self._map.on('zoomstart', function() {
          self._ec.clear();
        }); //zoomstart 이벤트를 제거합니다
        self._map.on('zoomend', _zoomChangeHandler);
        self._ec.getZrender().on('dragstart', _dragZrenderHandler(true));
        self._ec.getZrender().on('dragend', _dragZrenderHandler(false));
        self._ec.getZrender().on('mouseup', function() {
          // self.setOption(self._option);
          //이 문제를 해결하기 위해 echarts 소스 코드를 수정했습니다.
        });
        self._ec.getZrender().on('mousedown', function() {
          // self._ec.clear();
          //이 문제를 해결하기 위해 echarts 소스 코드를 수정했습니다.
        });
        self._ec.getZrender().on('mousewheel', function(e) {
          self._ec.clear(); //지우기 echarts 내용 마우스 휠 시간
          self._lastMousePos = self._map.mouseEventToContainerPoint(e.event);
          var delta = L.DomEvent.getWheelDelta(e.event);
          var map = self._map,
            zoom = map.getZoom();
          delta = delta > 0 ? Math.ceil(delta) : Math.floor(delta);
          delta = Math.max(Math.min(delta, 4), -4);
          delta = map._limitZoom(zoom + delta) - zoom;

          self._delta = 0;
          self._startTime = null;

          if (!delta) {
            return;
          }

          if (map.options.scrollWheelZoom === 'center') {
            map.setZoom(zoom + delta);
          } else {
            map.setZoomAround(self._lastMousePos, zoom + delta);
          }
        });
      };

      /**
       * 지도 확대 / 축소 트리거 이벤트
       *
       * @private
       */
      function _zoomChangeHandler() {
        self.setOption(self._option);
      }

      // function _zoomatartChangeHandler() {
      //   self._ec.clear();
      // }

      /**
       * 트리거 이벤트와 같은지도 이동
       *
       * @param {string} type moving | moveend 
       * @private
       */
      function _moveHandler(type) {
        return function() {
          var domPosition = self._map._getMapPanePos();
          //  레코드 오프셋
          self._mapOffset = [-parseInt(domPosition.x) || 0, -parseInt(domPosition.y) || 0];
          self._echartsContainer.style.left = self._mapOffset[0] + 'px';
          self._echartsContainer.style.top = self._mapOffset[1] + 'px';
          //_fireEvent(type);
          if (type == 'moving') {
            self._ec.clear();
          }
          if (type == 'moveend') {
            self.setOption(self._option);
          }
        }
      }

      /**
       * Zrender트리거 이벤트
       *
       * @param {boolean} isStart
       * @return {Function}
       * @private
       */
      function _dragZrenderHandler(isStart) {

        return function() {
          var func = isStart ? 'disable' : 'enable';
          if (isStart) {
            self._ec.clear();
          } else {
            self.setOption(self._option);
          }
          self._map.dragging[func]();
        };
      }
    }
  });
  L.echartsLayer = function(map, ec) {
    return new L.EchartsLayer(map, ec);
  };
  return L.echartsLayer;
}));