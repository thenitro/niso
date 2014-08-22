package niso.world {
    import flash.utils.Dictionary;

    import niso.geom.IsometricGeometry;
    import niso.world.layers.IsometricLayer;
    import niso.world.layers.IsometricLayerSortingType;
    import niso.world.objects.IsometricDisplayObject;

    import npooling.Pool;

    import starling.core.Starling;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.EventDispatcher;
    import starling.events.ResizeEvent;

    public final class IsometricWorld extends EventDispatcher {
        public static const POSITION_UPDATE:String = 'position_update';

		private static var _pool:Pool = Pool.getInstance();
		
		private var _canvas:Sprite;
		private var _layers:Dictionary;

        private var _layersNum:int;
		
		private var _geometry:IsometricGeometry;
		
		public function IsometricWorld() {
            super();

            _geometry = new IsometricGeometry();

            _layersNum = 0;

			_canvas = new Sprite();
			_canvas.addEventListener(Event.ADDED_TO_STAGE, addedToStageEventHandler);
			
			_layers = new Dictionary();
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

        public function setPosition(pX:Number, pY:Number):void {
            _canvas.x = pX;
            _canvas.y = pY;

            dispatchEventWith(POSITION_UPDATE);
        };

		public function relocate():void {
			var centerX:int = Math.ceil(_canvas.stage.stageWidth / 2);
			var centerY:int = Math.ceil((_canvas.stage.stageHeight - _canvas.height) / 2);
			
            setPosition(centerX, centerY);
		};
		
		public function getLayerByID(pID:int):IsometricLayer {
			return _layers[pID] as IsometricLayer;
		};
		
		public function addLayer(pLayer:IsometricLayer):void {
			pLayer.setWorld(this);

			_layers[pLayer.id] = pLayer;
            _layersNum++;
			
			_canvas.addChild(pLayer.canvas);
		};
		
		public function removeLayer(pLayer:IsometricLayer):void {
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
		};
		
		public function removeObject(pLayerID:uint,
									 pObject:IsometricDisplayObject):void {
            if (!pObject) {
                return;
            }

			var layer:IsometricLayer = _layers[pLayerID] as IsometricLayer;
				layer.remove(pObject);
		};
		
		public function clean():void {
			_canvas.removeChildren();
			
			for each (var layer:IsometricLayer in _layers) {
				_pool.put(layer);
			}
			
			for (var layerID:Object in _layers) {
				delete _layers[layerID];
			}
		};

        private function addedToStageEventHandler(pEvent:Event):void {
            _canvas.removeEventListener(Event.ADDED_TO_STAGE, addedToStageEventHandler);
            _canvas.stage.addEventListener(ResizeEvent.RESIZE, resizeEventHandler);
            //_canvas.addEventListener(Event.ENTER_FRAME, enterFrameEventHandler);

            Starling.juggler.repeatCall(sortAll, 0.25);
        };

        private function resizeEventHandler(pEvent:ResizeEvent):void {
            relocate();
        };

        private function enterFrameEventHandler(pEvent:Event):void {
            sortAll();
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