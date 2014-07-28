package niso.tiled {
	import niso.geom.IsometricGeometry;
	import niso.world.IsometricWorld;
	import niso.world.layers.IsometricLayer;
	import niso.world.layers.IsometricLayerSortingType;
	import niso.world.objects.IsometricBehavior;
	import niso.world.objects.IsometricSprite;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getDefinitionByName;
	
	import npooling.Pool;
	
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.textures.Texture;
	
	public final class TiledLoader extends EventDispatcher {
        public static const LOADING_COMPLETED:String = 'loading_completed';

		private static var _pool:Pool = Pool.getInstance();
		
		private var _url:String;
        private var _loaded:Boolean;

		private var _world:IsometricWorld;
		
		private var _data:XML;

		private var _loaders:Vector.<TilesetLoader>;
		private var _tilesets:Vector.<TilesetLoader>;		
		
		public function TiledLoader(pURL:String) {
			super();
			
			_url    = pURL;
            _loaded = false;
			
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
		
		public function buildLevel(pWorld:IsometricWorld):void {
            _world = pWorld;

            if (!_loaded) {
                return;
            }

			var layerID:uint = 0;
			
			for each (var child:XML in _data.children()) {
				if (child.name() == 'layer') {
					parseLayer(child, layerID);
				} else if (child.name() == 'objectgroup') {
					parseObjectGroup(child, layerID);
				} else {
					continue;
				}
				
				layerID++;
			}
			
			_world.relocate();
		};
		
		private function parseLayer(pData:XML, pLayerID:uint):void {
			var indexX:uint = 0;
			var indexZ:uint = 0;
			
			var layer:IsometricLayer = new IsometricLayer();
				layer.init(pLayerID, false, IsometricLayerSortingType.ON_DEMAND);
			
			_world.addLayer(layer);
			
			for each (var tileAbstract:XML in pData..tile) {
				if (tileAbstract.@gid != 0) {
					var object:IsometricSprite = _pool.get(IsometricSprite) as IsometricSprite;
					
					if (!object) {
						object = new IsometricSprite();
						_pool.allocate(IsometricSprite, 1);
					}
					
						object.setTexture(getTexture(tileAbstract.@gid));
						object.x = indexX * _world.geometry.tileSize;
						object.z = indexZ * _world.geometry.tileSize;
					
					_world.addObject(pLayerID, object);
				}
				
				indexX++;
				
				if (indexX >= pData.@width) {
					indexX = 0;
					indexZ++;
				}
			}
			
			layer.sort();
		};
		
		private function parseObjectGroup(pData:XML, pLayerID:uint):void {
			var layer:IsometricLayer = new IsometricLayer();
				layer.init(pLayerID, false, IsometricLayerSortingType.ALWAYS);
			
			_world.addLayer(layer);
			
			for each (var objectAbstract:XML in pData..object) {				
				var object:IsometricSprite = _pool.get(IsometricSprite) as IsometricSprite;
				
				if (!object) {
					object = new IsometricSprite();
					_pool.allocate(IsometricSprite, 1);
				}
				
					object.setTexture(getTexture(objectAbstract.@gid));
					object.x = objectAbstract.@x - _world.geometry.tileSize;
					object.z = objectAbstract.@y - _world.geometry.tileSize;
					
				if (String(objectAbstract.@type).length) {					
					var currentClass:Class         = getDefinitionByName(objectAbstract.@type) as Class;
					var instance:IsometricBehavior = _pool.get(currentClass) as IsometricBehavior; 
					
					if (!instance) {
						instance = new currentClass();
						_pool.allocate(currentClass, 1);
					}
					
					
					object.setBehavior(instance);
				}
				
				_world.addObject(pLayerID, object);
			}
		};
		
		private function getTexture(pID:int):Texture {
			for (var i:uint = 0; i < _tilesets.length; i++) {
				if (pID >= _tilesets[i].maxID && _tilesets[i].firstID < pID) {
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
                _loaded = true;
				
				dispatchEventWith(LOADING_COMPLETED);
			}
		};
	};
}