package source.com.thenitro.isometric.world.layers {
	import com.thenitro.ngine.pool.IReusable;
	import com.thenitro.ngine.pool.Pool;
	
	import source.com.thenitro.isometric.points.Point2D;
	import source.com.thenitro.isometric.points.Point3D;
	import source.com.thenitro.isometric.world.IsometricWorld;
	import source.com.thenitro.isometric.world.objects.IsometricDisplayObject;
	
	import starling.display.Sprite;
	
	public class IsometricLayer implements IReusable {
		private static var _pool:Pool = Pool.getInstance();
		
		private var _canvas:Sprite;
		
		private var _array:Array;
		private var _id:uint;
		
		private var _world:IsometricWorld;
		
		private var _useLuft:Boolean;
		
		public function IsometricLayer() {
			_canvas = new Sprite();
			_array  = [];
		};
		
		public function get reflection():Class {
			return IsometricLayer;
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
		
		public function init(pID:uint, pUseLuft:Boolean):void {
			_id      = pID;
			_useLuft = pUseLuft;
		};
		
		public function setWorld(pWorld:IsometricWorld):void {
			_world = pWorld;
			
			if (_useLuft) {
				var offset3D:Point3D = _pool.get(Point3D) as Point3D;
				
				if (!offset3D) {
					offset3D = new Point3D();
					_pool.allocate(Point3D, 1);
				}
				
				offset3D.x = _id * -_world.geometry.tileSize;
				offset3D.y = 0;
				offset3D.z = _id * -_world.geometry.tileSize;
				
				var offset:Point2D = _world.geometry.isometricToScreen(offset3D);
				
				_canvas.x = offset.x;
				_canvas.y = offset.y;
			}
		};
		
		public function add(pObject:IsometricDisplayObject):void {
			_array.push(pObject);
			
			pObject.setLayer(this);
			pObject.updateScreenPosition();
			
			_canvas.addChild(pObject.view);
		};
		
		public function remove(pObject:IsometricDisplayObject):void {
			_array.splice(_array.indexOf(pObject), 1);
			
			_canvas.removeChild(pObject.view);
		};
		
		public function sort():void {
			_array.sortOn('depth', Array.NUMERIC);
			
			for (var i:uint = 0; i < _array.length; i++) {
				var object:IsometricDisplayObject = _array[i] as IsometricDisplayObject;
				
				_canvas.setChildIndex(object.view, i);
			}
		};
		
		public function clean():void {
			_canvas.removeChildren();
			
			for each (var object:IsometricDisplayObject in _array) {
				remove(object);
				
				_pool.put(object);
			}
			
			_array.length = 0;
		};
		
		public function poolPrepare():void {
			clean();
		};
		
		public function dispose():void {
			clean();	
			
			_canvas.dispose();
			_canvas = null;
			
			_array = null;
		};
	}
}