package source.com.thenitro.isometric.world {
	import com.thenitro.ngine.pool.Pool;
	
	import flash.utils.Dictionary;
	
	import source.com.thenitro.isometric.geom.IsometricGeometry;
	import source.com.thenitro.isometric.world.layers.IsometricLayer;
	import source.com.thenitro.isometric.world.objects.IsometricDisplayObject;
	
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
		};
		
		private function addedToStageEventHandler(pEvent:Event):void {
			_canvas.removeEventListener(Event.ADDED_TO_STAGE, addedToStageEventHandler);
			_canvas.stage.addEventListener(ResizeEvent.RESIZE, resizeEventHandler);
		};
		
		private function resizeEventHandler(pEvent:ResizeEvent):void {
			relocate();
		};
		
		public function get geometry():IsometricGeometry {
			return _geometry;
		};
		
		public function get canvas():Sprite {
			return _canvas;
		};
		
		public function setGeometry(pGeometry:IsometricGeometry):void {
			_geometry = pGeometry;
		};
		
		public function relocate():void {
			var centerX:Number =  _canvas.stage.stageWidth / 2;
			var centerY:Number = (_canvas.stage.stageHeight - _canvas.height) / 2;
			
			_canvas.x = centerX;
			_canvas.y = centerY;
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
			var layer:IsometricLayer = _layers[pLayerID] as IsometricLayer;
				layer.add(pObject);
		};
		
		public function removeObject(pLayerID:uint,
									 pObject:IsometricDisplayObject):void {
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
	};
}