package com.thenitro.isometric.tiled {
	import com.thenitro.ngine.textures.SpriteSheetCutter;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.textures.Texture;
	
	public final class TilesetLoader extends EventDispatcher {
		private var _firstID:uint;
		
		private var _tileWidth:uint;
		private var _tileHeight:uint;
		
		private var _sourceURL:String;
		
		private var _cutter:SpriteSheetCutter;
		
		public function TilesetLoader(pFirstID:uint, 
									  pTileWidth:uint, pTileHeight:uint,
									  pSourceURL:String) {
			super();
			
			_firstID = pFirstID;
			
			_tileWidth  = pTileWidth;
			_tileHeight = pTileHeight;
			
			_sourceURL = pSourceURL;
		};
		
		public function get firstID():uint {
			return _firstID;
		};
		
		public function get maxID():uint {
			return _firstID + _cutter.maxID;
		};
		
		public function getItem(pIndex:uint):Texture {
			return _cutter.getByID(pIndex - _firstID);
		};
		
		public function load():void {
			var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE,
														  loaderCompleteEventHandler);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,
														  loaderErrorEventHandler);
				loader.load(new URLRequest(_sourceURL));
		};
		
		private function loaderCompleteEventHandler(pEvent:flash.events.Event):void {
			var loaderInfo:LoaderInfo = pEvent.currentTarget as LoaderInfo;
				loaderInfo.removeEventListener(flash.events.Event.COMPLETE, 
											   loaderCompleteEventHandler);
				loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,
											   loaderErrorEventHandler);
			
			var bitmap:BitmapData = (loaderInfo.loader.content as Bitmap).bitmapData;
			
			_cutter = new SpriteSheetCutter(bitmap, _tileWidth, _tileHeight);
			
			dispatchEventWith(starling.events.Event.COMPLETE);
		};
		
		private function loaderErrorEventHandler(pEvent:IOErrorEvent):void {
			throw new Error("TilesetLoader.loaderErrorEventHandler(pEvent):" + 
							"cannot find sprite sheet with url " + _sourceURL);
		};
	};
}