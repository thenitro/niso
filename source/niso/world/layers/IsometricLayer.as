package niso.world.layers {
    import flash.utils.Dictionary;

    import ncollections.MatrixMxN;

    import niso.world.IsometricWorld;
    import niso.world.objects.IsometricDisplayObject;

    import nmath.vectors.TVector3D;
    import nmath.vectors.Vector2D;

    import npooling.IReusable;
    import npooling.Pool;

    import starling.display.DisplayObject;
    import starling.display.Sprite;

    public class IsometricLayer implements IReusable {
		private static var _pool:Pool = Pool.getInstance();

        private var _disposed:Boolean;

		private var _canvas:Sprite;

		private var _objects:Dictionary;
		private var _id:uint;
		
		private var _world:IsometricWorld;
		
		private var _useLuft:Boolean;
		
		private var _sortingType:uint;
        private var _objectsNum:int;
		
		public function IsometricLayer() {
			_canvas  = new Sprite();
			_objects = new Dictionary();

            _objectsNum = 0;
		};

        public static function get NEW():IsometricLayer {
            var result:IsometricLayer = _pool.get(IsometricLayer) as IsometricLayer;

            if (!result) {
                result = new IsometricLayer();
                _pool.allocate(IsometricLayer, 1);
            }

            return result;
        };
		
		public function get reflection():Class {
			return IsometricLayer;
		};

        public function get disposed():Boolean {
            return _disposed;
        };
		
		public function get canvas():Sprite {
			return _canvas;
		};
		
		public function get id():uint {
			return _id;
		};
		
		public function get world():IsometricWorld {
			return _world;
		};
		
		public function get sortingType():uint {
			return _sortingType;
		};
		
		public function get objects():Dictionary {
			return _objects;
		};

        public function get objectsNum():int {
            return _objectsNum;
        };
		
		/**
		 * 
		 * @param pID          - id of layer, better use ordered layer id's
		 * @param pUseLuft     - luft for creating mountains and stuff
		 * @param pSortingType - IsometricLayerSortingType.ON_DEMAND - manualy sort when you need it	
		 *						 IsometricLayerSortingType.ON_CHANGE - sort when you add or remove element to layer
		 *					     IsometricLayerSortingType.IsometricLayerSortingType.ALWAY - sort on enterframe
		 * 
		 */		
		public function init(pID:uint, pUseLuft:Boolean, pSortingType:uint):void {
			_id          = pID;
			_useLuft     = pUseLuft;
			_sortingType = pSortingType;
		};
		
		public function setWorld(pWorld:IsometricWorld):void {
			_world = pWorld;
			
			if (_useLuft) {
				var offset3D:TVector3D = TVector3D.ZERO;
				
                    offset3D.x -= 1;
                    offset3D.y  = 0;
                    offset3D.z -= 1;
				
				var offset:Vector2D = _world.geometry.isometricToScreen(offset3D);
				
				_canvas.x = offset.x;
				_canvas.y = offset.y;
			}
		};
		
		public function add(pObject:IsometricDisplayObject):void {
			_objects[pObject.view] = pObject;
			
			pObject.setLayer(this);
			pObject.updateScreenPosition();
			
			_canvas.addChild(pObject.view);

            _objectsNum++;
			
			if (_sortingType == IsometricLayerSortingType.ON_CHANGE) {
				sort();
			}
		};
		
		public function remove(pObject:IsometricDisplayObject):void {
			delete _objects[pObject.view];
			
			_canvas.removeChild(pObject.view);

            _objectsNum--;
			
			if (_sortingType == IsometricLayerSortingType.ON_CHANGE) {
				sort();
			}
		};
		
		public function sort():void {
			_canvas.sortChildren(sortObjects);
		};
		
		public function clean():void {
			_canvas.removeChildren();
			
			for each (var object:IsometricDisplayObject in _objects) {
				_pool.put(object);
			}

            for each (var objectID:Object in _objects) {
                delete _objects[objectID];
            }

            _objectsNum = 0;

            _canvas.unflatten();
		};
		
		public function poolPrepare():void {
			clean();
		};
		
		public function dispose():void {
			clean();	
			
			_canvas.dispose();
			_canvas = null;
			
			_objects = null;

            _disposed = true;
		};
		
		private function sortObjects(pA:DisplayObject, 
									 pB:DisplayObject):int {
			var a:IsometricDisplayObject = _objects[pA] as IsometricDisplayObject;
			var b:IsometricDisplayObject = _objects[pB] as IsometricDisplayObject;
			
			if (a.depth < b.depth) {
				return -1;
			}
			
			return 1;
		};
	}
}