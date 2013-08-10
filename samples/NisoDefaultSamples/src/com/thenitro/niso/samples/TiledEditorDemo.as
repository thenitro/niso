package com.thenitro.niso.samples {
	import com.thenitro.isometric.tiled.TiledLoader;
	import com.thenitro.isometric.world.IsometricWorld;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public final class TiledEditorDemo extends Sprite {
		public function TiledEditorDemo() {
			super();
			addEventListener(Event.ADDED_TO_STAGE, addedToStageEventHandler);
		};
		
		private function addedToStageEventHandler(pEvent:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageEventHandler);
			
			var world:IsometricWorld = new IsometricWorld();
			
			addChild(world.canvas);
			
			var tiledLoader:TiledLoader = new TiledLoader('sample_map_30x30.tmx', world);
				tiledLoader.addEventListener(Event.COMPLETE, completeEventHandler);
				tiledLoader.load();
		};
		
		private function completeEventHandler(pEvent:Event):void {
			trace("TiledEditorDemo.completeEventHandler(pEvent): do with your level whatever you want!");
		};
	}
}