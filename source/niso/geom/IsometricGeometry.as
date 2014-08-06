package niso.geom {
    import nmath.vectors.TVector3D;
    import nmath.vectors.Vector2D;

    public final class IsometricGeometry {
		private var _tileWidth:Number;
		private var _tileHeight:Number;

		private var _tileWidthHalf:Number;
		private var _tileHeightHalf:Number;

		public function IsometricGeometry() {
		};
		
		public function get tileWidth():Number {
			return _tileWidth;
		};

		public function get tileHeight():Number {
			return _tileHeight;
		};

		public function setTileSize(pTileWidth:Number, pTileHeight:Number):void {
			_tileWidth  = pTileWidth;
			_tileHeight = pTileHeight;

            _tileWidthHalf  = pTileWidth  / 2;
            _tileHeightHalf = pTileHeight / 2;
		};

		public function isometricToScreen(pPosition:TVector3D,
										  pOutput:Vector2D = null):Vector2D {
			pOutput = pOutput ? pOutput : Vector2D.ZERO;

            pOutput.x = (pPosition.x - pPosition.z) * _tileWidthHalf;
            pOutput.y = (pPosition.x + pPosition.z) * _tileHeightHalf;

			pOutput.depth = (pPosition.x + pPosition.z) * 0.866 - pPosition.y * 0.707;
			
			return pOutput;
		};
		
		public function screenToIsometric(pPosition:Vector2D, 
										  pOutput:TVector3D = null, pRoundCoords:Boolean = true):TVector3D {
			pOutput = pOutput ? pOutput : TVector3D.ZERO;

            pOutput.x = (pPosition.x / _tileWidthHalf  +  pPosition.y / _tileHeightHalf) / 2;
            pOutput.z = (pPosition.y / _tileHeightHalf - (pPosition.x / _tileWidthHalf)) / 2;

            if (pRoundCoords) {
                pOutput.round();
            }

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