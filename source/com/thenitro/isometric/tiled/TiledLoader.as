package com.thenitro.isometric.tiled {
	import com.thenitro.isometric.geom.IsometricGeometry;
	import com.thenitro.isometric.world.IsometricWorld;
	import com.thenitro.isometric.world.layers.IsometricLayer;
	import com.thenitro.isometric.world.objects.IsometricSprite;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.textures.Texture;
	
	public final class TiledLoader extends EventDispatcher {
		private var _url:String;
		private var _world:IsometricWorld;
		
		private var _data:XML;

		private var _loaders:Vector.<TilesetLoader>;
		private var _tilesets:Vector.<TilesetLoader>;
		
		public function TiledLoader(pURL:String, pWorld:IsometricWorld) {
			super();
			
			_url   = pURL;
			_world = pWorld;
			
			_loaders  = new Vector.<TilesetLoader>();
			_tilesets = new Vector.<TilesetLoader>();
		};
		
		public function load():void {
			_loaders.length = 0;
			
			var loader:URLLoader = new URLLoader();
				loader.addEventListener(flash.events.Event.COMPLETE, 
										completeEventHandler);
				loader.addEventListener(IOErrorEvent.IO_ERROR, 
										ioErrorEventHandler);
				loader.load(new URLRequest(_url));
		};
		
		private function buildLevel():void {
			var layerID:uint = 0;
			
			for each (var layerAbstact:XML in _data..layer) {
				var indexX:uint = 0;
				var indexZ:uint = 0;
				
				var layer:IsometricLayer = new IsometricLayer();
					layer.init(layerID, false);
					
				_world.addLayer(layer);
				
				trace("TiledLoader.buildLevel()", layerAbstact.@name);
				
				for each (var tileAbstract:XML in layerAbstact.data..tile) {
					if (tileAbstract.@gid != 0) {
						var object:IsometricSprite = new IsometricSprite();
							object.setTexture(getTexture(tileAbstract.@gid));
							object.x = indexX * _world.geometry.tileSize;
							object.z = indexZ * _world.geometry.tileSize;
						
						_world.addObject(layerID, object);
					}
					
					indexX++;
					
					if (indexX >= layerAbstact.@width) {
						indexX = 0;
						indexZ++;
					}
				}
				
				layerID++;
			}
			
			_world.relocate();
		};
		
		private function getTexture(pID:int):Texture {
			for (var i:uint = 0; i < _tilesets.length; i++) {
				trace("TiledLoader.getTexture(pID)", _tilesets[i].maxID, _tilesets[i].firstID, pID);
				
				if (pID > _tilesets[i].maxID && _tilesets[i].firstID < pID) {
					continue;
				}
				
				return _tilesets[i].getItem(pID);
			}
			
			return null;
		};
		
		private function sortTilesetLoaders(pA:TilesetLoader, pB:TilesetLoader):int {
			if (pA.firstID > pB.firstID) {
				return 1;
			}
			
			return -1;
		};
		
		private function completeEventHandler(pEvent:flash.events.Event):void {
			var target:URLLoader = pEvent.target as URLLoader;
				target.removeEventListener(flash.events.Event.COMPLETE, 
										   completeEventHandler);
				target.removeEventListener(IOErrorEvent.IO_ERROR,
										   ioErrorEventHandler);
				
			var loader:TilesetLoader;
			
			_data = new XML(target.data);
			
			var geometry:IsometricGeometry = new IsometricGeometry();
				geometry.setTileSize(_data.@tileheight);
				
			_world.setGeometry(geometry);
			
			for each (var abstract:XML in _data..tileset) {
				loader = new TilesetLoader(abstract.@firstgid, 
										   abstract.@tilewidth, 
										   abstract.@tileheight, 
										   abstract.image.@source);
				loader.addEventListener(starling.events.Event.COMPLETE, 
										loaderCompletedEventHandler);
				loader.load();
				
				_loaders.push(loader);
			}
		};
		
		private function ioErrorEventHandler(pEvent:IOErrorEvent):void {
			throw new Error("TiledLoader.ioErrorEventHandler(pEvent): " +
							"no file in url " + _url);
		};
		
		private function loaderCompletedEventHandler(pEvent:starling.events.Event):void {
			var loader:TilesetLoader = pEvent.currentTarget as TilesetLoader;
				loader.removeEventListener(starling.events.Event.COMPLETE, 
										   loaderCompletedEventHandler);
				
			_loaders.splice(_loaders.indexOf(loader), 1);
			_tilesets.push(loader);
			
			if (!_loaders.length) {
				_tilesets.sort(sortTilesetLoaders);
				
				buildLevel();
			}
		};
	};
}