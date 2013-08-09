package com.thenitro.isometric.geom {
	import com.thenitro.isometric.points.Point2D;
	import com.thenitro.isometric.points.Point3D;
	import com.thenitro.ngine.pool.Pool;
	
	public final class IsometricGeometry {
		public static const RATIO:Number = Math.sin(Math.PI / 6);
		
		private static var _pool:Pool = Pool.getInstance();
		
		private var _tileSize:Number;
		
		public function IsometricGeometry() {
			_tileSize = 0;
		};
		
		public function get tileSize():Number {
			return _tileSize;
		};
		
		public function setTileSize(pTileSize:Number):void {
			_tileSize = pTileSize;
		};
		
		public function isometricToScreen(pPosition:Point3D, 
										  pOutput:Point2D = null):Point2D {
			if (!pOutput) {
				pOutput = _pool.get(Point2D) as Point2D;
				
				if (!pOutput) {
					pOutput = new Point2D();
					_pool.allocate(Point2D, 1);
				}	
			}
			
			pOutput.x =  pPosition.x - pPosition.z;
			pOutput.y = (pPosition.x + pPosition.z) * RATIO;
			
			pOutput.depth = (pPosition.x + pPosition.z) * 0.866 - pPosition.y * 0.707;
			
			return pOutput;
		};
		
		public function screenToIsometric(pPosition:Point2D, pOutput:Point3D = null):Point3D {
			if (!pOutput) {
				pOutput = _pool.get(Point3D) as Point3D;
				
				if (!pOutput) {
					pOutput = new Point3D();
					_pool.allocate(Point3D, 1);
				}
			}
			
			pOutput.x =  pPosition.x * RATIO + pPosition.y;
			pOutput.y =  0.0;
			pOutput.z = -pPosition.x * RATIO + pPosition.y;
			
			return pOutput;
		};
		
		public function distance(pCurrentPoint:Point3D, 
								 pDestinationPoint:Point3D):Number {
			if (!pCurrentPoint || !pDestinationPoint) {
				return 0;
			}
			
			var dx:Number = pDestinationPoint.x - pCurrentPoint.x;
			var dz:Number = pDestinationPoint.z - pCurrentPoint.z;
			
			return Math.sqrt(dx * dx + dz * dz);
		};
	};
}