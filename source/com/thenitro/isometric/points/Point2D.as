package com.thenitro.isometric.points {
	import com.thenitro.ngine.pool.IReusable;
	import com.thenitro.ngine.pool.Pool;

	public class Point2D implements IReusable {
		private static var _pool:Pool = Pool.getInstance();
		
		public var x:Number;
		public var y:Number;
		
		public var depth:Number;
		
		public function Point2D() {
			x = 0;
			y = 0;
			
			depth = NaN;
		};
		
		public function get reflection():Class {
			return Point2D;
		};
		
		public function clone():Point2D {
			var result:Point2D = _pool.get(Point2D) as Point2D;
				
			if (!result) {
				_pool.allocate(Point2D, 1);
				result = new Point2D();
			}
			
				result.x = x;
				result.y = y;
				
				result.depth = depth;
				
			return result;
		};
		
		public function poolPrepare():void {
			x = 0;
			y = 0;
			
			depth = 0;
		};
		
		public function dispose():void {
			
		};
		
		public function toString():String {
			return '[ Point2D ( x: ' + x + ', y:' + y + ' depth ' + depth + ' ) ]';
		};
	};
}