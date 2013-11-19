package com.thenitro.isometric.geom {
	import ngine.math.vectors.TVector3D;
	import ngine.math.vectors.Vector2D;
	
	import npooling.Pool;
	
	public final class IsometricGeometry {
		public static const RATIO:Number = Math.sin(Math.PI / 6);
		
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
		
		public function isometricToScreen(pPosition:TVector3D, 
										  pOutput:Vector2D = null):Vector2D {
			pOutput = pOutput ? pOutput : Vector2D.ZERO;
			
			pOutput.x =  pPosition.x - pPosition.z;
			pOutput.y = (pPosition.x + pPosition.z) * RATIO;
			
			pOutput.depth = (pPosition.x + pPosition.z) * 0.866 - pPosition.y * 0.707;
			
			return pOutput;
		};
		
		public function screenToIsometric(pPosition:Vector2D, 
										  pOutput:TVector3D = null):TVector3D {
			pOutput = pOutput ? pOutput : TVector3D.ZERO;
			
			pOutput.x =  pPosition.x * RATIO + pPosition.y;
			pOutput.y =  0.0;
			pOutput.z = -pPosition.x * RATIO + pPosition.y;
			
			return pOutput;
		};
		
		public function distance(pCurrentPoint:TVector3D, 
								 pDestinationPoint:TVector3D):Number {
			if (!pCurrentPoint || !pDestinationPoint) {
				return 0;
			}
			
			var dx:Number = pDestinationPoint.x - pCurrentPoint.x;
			var dz:Number = pDestinationPoint.z - pCurrentPoint.z;
			
			return Math.sqrt(dx * dx + dz * dz);
		};
	};
}