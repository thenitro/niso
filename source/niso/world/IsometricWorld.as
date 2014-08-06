package niso.world {
	import niso.geom.IsometricGeometry;
	import niso.world.layers.IsometricLayer;
	import niso.world.layers.IsometricLayerSortingType;
	import niso.world.objects.IsometricDisplayObject;
	
	import flash.utils.Dictionary;
	
	import npooling.Pool;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.ResizeEvent;
	
	public final class IsometricWorld {
		private static var _pool:Pool = Pool.getInstance();
		
		private var _canvas:Sprite;
		private var _layers:Dictionary;
		
		private var _geometry:IsometricGeometry;
		
		public function IsometricWorld() {
			_canvas = new Sprite();
			_canvas.addEventListener(Event.ADDED_TO_STAGE, addedToStageEventHandler);
			
			_layers = new Dictionary();

            _geometry = new IsometricGeometry();
		};
		
		private function addedToStageEventHandler(pEvent:Event):void {
			_canvas.removeEventListener(Event.ADDED_TO_STAGE, addedToStageEventHandler);
			_canvas.stage.addEventListener(ResizeEvent.RESIZE, resizeEventHandler);
			_canvas.addEventListener(Event.ENTER_FRAME, enterFrameEventHandler);
		};
		
		private function resizeEventHandler(pEvent:ResizeEvent):void {
			relocate();
		};
		
		private function enterFrameEventHandler(pEvent:Event):void {
			sortAll();
		};
		
		public function get geometry():IsometricGeometry {
			return _geometry;
		};
		
		public function get canvas():Sprite {
			return _canvas;
		};
		
		public function relocate():void {
			var centerX:int = Math.ceil(_canvas.stage.stageWidth / 2);
			var centerY:int = Math.ceil((_canvas.stage.stageHeight - _canvas.height) / 2);
			
			_canvas.x = centerX;
			_canvas.y = centerY;
		};
		
		public function getLayerByID(pID:int):IsometricLayer {
			return _layers[pID] as IsometricLayer;
		};
		
		public function addLayer(pLayer:IsometricLayer):void {
			pLayer.setWorld(this);
			
			_layers[pLayer.id] = pLayer;
			
			_canvas.addChild(pLayer.canvas);
		};
		
		public function removeLayer(pLayer:IsometricLayer):void {
			delete _layers[pLayer.id];
			
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
		
		private function sortAll():void {
			for each (var layer:IsometricLayer in _layers) {
				if (layer.sortingType == IsometricLayerSortingType.ALWAYS) {
					layer.sort();	
				}
			}
		};
	};
}