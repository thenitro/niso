package source.com.thenitro.isometric.tiled {
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import source.com.thenitro.isometric.world.IsometricWorld;
	
	import starling.events.EventDispatcher;
	
	public final class TiledLoader extends EventDispatcher {
		private var _url:String;
		private var _world:IsometricWorld;
		
		public function TiledLoader(pURL:String, pWorld:IsometricWorld) {
			super();
			
			_url   = pURL;
			_world = pWorld;
		};
		
		public function load():void {
			var loader:URLLoader = new URLLoader();
				loader.addEventListener(Event.COMPLETE, completeEventHandler);
				loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorEventHandler);
				loader.load(new URLRequest(_url));
		};
		
		private function completeEventHandler(pEvent:Event):void {
			var target:URLLoader = pEvent.target as URLLoader;
				target.removeEventListener(Event.COMPLETE, completeEventHandler);
				
			var data:XML = new XML(target.data);
			
			trace("TiledLoader.completeEventHandler(pEvent): " + data);
			
			for each (var tileset:XML in data..tileset) {
				trace("TiledLoader.completeEventHandler(pEvent): " + tileset);
			}
		};
		
		private function ioErrorEventHandler(pEvent:IOErrorEvent):void {
			trace("TiledLoader.ioErrorEventHandler(pEvent)" + pEvent.errorID);
		};
	};
}