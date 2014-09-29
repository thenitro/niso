package niso.tiled {
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequest;

    import niso.world.IsometricWorld;
    import niso.world.layers.IsometricLayer;
    import niso.world.layers.IsometricLayerSortingType;
    import niso.world.objects.IsometricDisplayObject;
    import niso.world.objects.IsometricSprite;

    import nmath.TQuad;
    import nmath.vectors.Vector2D;

    import npooling.Pool;

    import starling.events.Event;
    import starling.events.EventDispatcher;
    import starling.textures.Texture;

    public final class TiledLoader extends EventDispatcher {
        public static const LOADING_COMPLETED:String = 'loading_completed';

        private var _world:IsometricWorld;
        private var _factory:TiledFactory;

        private var _index:Vector2D;

        private var _sizeX:int;
        private var _sizeZ:int;

        private var _tileWidth:Number;
        private var _tileHeight:Number;

		private var _url:String;
        private var _loaded:Boolean;

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

        public function get world():IsometricWorld {
            return _world;
        };

        public function get sizeX():int {
            return _sizeX
        };

        public function get sizeZ():int {
            return _sizeZ;
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
		
		public function buildLevel(pWorld:IsometricWorld,
                                   pFactory:TiledFactory):void {
            _world   = pWorld;

            _sizeX = _data.@width;
            _sizeZ = _data.@height;

            _factory = pFactory;
            _factory.setWorld(_world);
            _factory.initMap(_sizeX, _sizeZ);

            _index = Vector2D.ZERO;

            _tileWidth  = _data.@tilewidth;
            _tileHeight = _data.@tileheight;

            _world.geometry.setTileSize(_tileWidth, _tileHeight);

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
			
			_world.center();

            Pool.getInstance().put(_index);
		};

        public function getTexture(pID:int):Texture {
            for (var i:uint = 0; i < _tilesets.length; i++) {
                if (pID >= _tilesets[i].maxID && _tilesets[i].firstID < pID) {
                    continue;
                }

                return _tilesets[i].getItem(pID);
            }

            return null;
        };
		
		private function parseLayer(pData:XML, pLayerID:uint):void {
            _index.zero();

			var layer:IsometricLayer = IsometricLayer.NEW;
				layer.init(pLayerID, false, IsometricLayerSortingType.ON_DEMAND);
			
			_world.addLayer(layer);
			
			for each (var tileAbstract:XML in pData..tile) {
				if (tileAbstract.@gid != 0) {
                    var texture:Texture = getTexture(tileAbstract.@gid);

                    var tile:IsometricSprite = _factory.createTile(tileAbstract);

                        tile.x = _index.x;
                        tile.z = _index.y;

                        tile.setTexture(texture, texture.width / 2, texture.height / 2);

                    _world.addObject(pLayerID, tile);
				}

				_index.x++;
				
				if (_index.x >= pData.@width) {
					_index.x = 0;
					_index.y++;
				}
			}
			
			layer.sort();
            layer.canvas.flatten();
        };
		
		private function parseObjectGroup(pData:XML, pLayerID:uint):void {
			var layer:IsometricLayer = IsometricLayer.NEW;
				layer.init(pLayerID, false, IsometricLayerSortingType.ALWAYS);
			
			_world.addLayer(layer);

            for each (var objectAbstract:XML in pData..object) {
                var halfWidth:int  = Math.ceil(Math.round(objectAbstract.@width  / _tileHeight) / 2) - 1;
                var halfHeight:int = Math.ceil(Math.round(objectAbstract.@height / _tileHeight) / 2) - 1;

                _index.x = Math.round(objectAbstract.@x / _tileHeight) + halfWidth;
                _index.y = Math.round(objectAbstract.@y / _tileHeight) + halfHeight;

                var object:IsometricDisplayObject = _factory.createObject(objectAbstract);

                    object.x = _index.x;
                    object.z = _index.y;

				_world.addObject(pLayerID, object);

                _factory.createBehaviour(objectAbstract, object);
			}
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