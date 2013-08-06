package source.com.thenitro.isometric.points {
	import com.thenitro.ngine.pool.IReusable;
	import com.thenitro.ngine.pool.Pool;
	
	public final class Point3D implements IReusable {
		public var x:Number;
		public var y:Number;
		public var z:Number;
		
		public var depth:Number;
		
		private static var _pool:Pool = Pool.getInstance();
		
		public function Point3D() {
			super();
			
			x = 0;
			y = 0;
			z = 0;
			
			depth = NaN;
		};
		
		public function get reflection():Class {
			return Point3D;
		};
		
		public function equals(pTarget:Point3D):Boolean {
			if (!pTarget) {
				return false;
			}
			
			return x == pTarget.x && y == pTarget.y && z == pTarget.z;
		};
		
		public function clone():Point3D {
			var result:Point3D = _pool.get(Point3D) as Point3D;
			
			if (!result) {
				result = new Point3D();
				_pool.allocate(Point3D, 1);
			}
			
			result.x = x;
			result.y = y;
			result.z = z;
			
			return result;
		};
		
		public function toString():String {
			return '[ Point3D ( x: ' + x + ', y:' + y + ', z: ' + z + ' ) ]';
		};
		
		public function poolPrepare():void {
			x = 0;
			y = 0;
			
			z = 0;
			
			depth = 0;
		};
		
		public function dispose():void {
			
		};
	}
}