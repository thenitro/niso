package niso.world {
    import flash.utils.Dictionary;

    import ngine.display.scale.IScalable;

    import niso.geom.IsometricGeometry;
    import niso.world.layers.IsometricLayer;
    import niso.world.layers.IsometricLayerSortingType;
    import niso.world.objects.IsometricDisplayObject;

    import nmath.TMath;

    import npooling.Pool;

    import starling.core.Starling;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.EventDispatcher;

    public final class IsometricWorld extends EventDispatcher implements IScalable {
        public static const POSITION_UPDATE:String = 'position_update';

		private static var _pool:Pool = Pool.getInstance();
		
		private var _canvas:Sprite;
		private var _layers:Dictionary;

        private var _layersNum:int;
        private var _objectsNum:int;
		
		private var _geometry:IsometricGeometry;

        private var _scale:Number;
        private var _scaleFactor:Number;

        private var _viewportWidth:Number;
        private var _viewportHeight:Number;

        private var _topOffset:Number;

        private var _width:Number;
        private var _height:Number;

		public function IsometricWorld() {
            super();

            _geometry = new IsometricGeometry();

            _layersNum  = 0;
            _objectsNum = 0;

			_canvas = new Sprite();
			_canvas.addEventListener(Event.ADDED_TO_STAGE, addedToStageEventHandler);

			_layers = new Dictionary();

            _scale = 1.0;
            _scaleFactor = 1.0;

            _viewportWidth = 0.0;
            _viewportHeight = 0.0;
		};

		public function get geometry():IsometricGeometry {
			return _geometry;
		};

        public function get canvas():Sprite {
            return _canvas;
        };

        public function get x():Number {
            return _canvas.x;
        };

        public function get y():Number {
            return _canvas.y;
        };

        public function get layersNum():int {
            return _layersNum;
        };

        public function get objectsNum():int {
            return _objectsNum;
        };

        public function calculateDimensions():void {
            _width  = _canvas.width;
            _height = _canvas.height;
        };

        public function setPosition(pX:Number, pY:Number):void {
            _canvas.x = pX;
            _canvas.y = pY;

            dispatchEventWith(POSITION_UPDATE);
        };

        public function scale(pScale:Number, pScaleFactor:Number):void {
            trace('IsometricWorld.scale:', pScale, pScaleFactor);

            _scale       = pScale;
            _scaleFactor = pScaleFactor;

            clamp(_viewportWidth, _viewportHeight, _topOffset);
        };

		public function center():void {
			var centerX:int = Math.ceil((_canvas.stage.stageWidth * _scaleFactor)  / 2);
			var centerY:int = Math.ceil(((_canvas.stage.stageHeight * _scaleFactor) - _canvas.height) / 2);
			
            setPosition(centerX, centerY);
		};

        public function clamp(pWidth:Number, pHeight:Number, pTopOffset:Number):void {
            _viewportWidth  = pWidth;
            _viewportHeight = pHeight;

            _topOffset = pTopOffset;

            _canvas.x = TMath.clamp(_canvas.x, -(_width / 2 - (pWidth  * _scaleFactor)), _width / 2);
            _canvas.y = TMath.clamp(_canvas.y, -(_height -    (pHeight * _scaleFactor) - (_geometry.tileHeight * _scaleFactor) / 2), pTopOffset);
        };
		
		public function getLayerByID(pID:int):IsometricLayer {
			return _layers[pID] as IsometricLayer;
		};
		
		public function addLayer(pLayer:IsometricLayer):void {
            if (_layers[pLayer.id]) {
                trace('IsometricWorld.addLayer: already have layer with id', pLayer.id);
                return;
            }

			pLayer.setWorld(this);

			_layers[pLayer.id] = pLayer;
            _layersNum++;
			
			_canvas.addChild(pLayer.canvas);
		};
		
		public function removeLayer(pLayer:IsometricLayer):void {
            if (!_layers[pLayer.id]) {
                trace('IsometricWorld.removeLayer: there is not layer with id', pLayer.id);
                return;
            }

			delete _layers[pLayer.id];
            _layersNum--;
			
			_canvas.removeChild(pLayer.canvas);
		};
		
		public function addObject(pLayerID:uint, 
								  pObject:IsometricDisplayObject):void {
            if (!pObject) {
                return;
            }

			var layer:IsometricLayer = _layers[pLayerID] as IsometricLayer;
				layer.add(pObject);

            _objectsNum++;
		};
		
		public function removeObject(pLayerID:uint,
									 pObject:IsometricDisplayObject):void {
            if (!pObject) {
                return;
            }

			var layer:IsometricLayer = _layers[pLayerID] as IsometricLayer;
				layer.remove(pObject);

            _objectsNum--;
		};
		
		public function clean():void {
			_canvas.removeChildren();
			
			for each (var layer:IsometricLayer in _layers) {
				_pool.put(layer);
			}

			for (var layerID:Object in _layers) {
				delete _layers[layerID];
			}

            _layersNum  = 0;
            _objectsNum = 0;
		};

        private function addedToStageEventHandler(pEvent:Event):void {
            _canvas.removeEventListener(Event.ADDED_TO_STAGE, addedToStageEventHandler);

            Starling.juggler.repeatCall(sortAll, 0.1);
        };

		private function sortAll():void {
			for each (var layer:IsometricLayer in _layers) {
				if (layer.sortingType == IsometricLayerSortingType.ALWAYS) {
					layer.sort();	
				}
			}
		};
	};
}