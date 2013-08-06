package source.com.thenitro.isometric.tiled {
	import starling.events.EventDispatcher;
	
	public final class TilesetLoader extends EventDispatcher {
		private var _firstID:uint;
		
		private var _tileWidth:uint;
		private var _tileHeight:uint;
		
		private var _sourceURL:String;
		
		public function TilesetLoader(pFirstID:uint, 
									  pTileWidth:uint, pTileHeight:uint,
									  pSourceURL:String) {
			super();
			
			_firstID = pFirstID;
			
			_tileWidth  = pTileWidth;
			_tileHeight = pTileHeight;
			
			_sourceURL = pSourceURL;
		};
		
		public function load():void {
			
		};
	};
}