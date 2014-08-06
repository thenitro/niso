package niso.world.objects.builtin {
    import niso.world.objects.IsometricBehavior;
    import niso.world.objects.IsometricDisplayObject;

    import npathfinding.base.Pathfinder;

    public class Obstacle extends IsometricBehavior {
		private static var _pathfinder:Pathfinder = Pathfinder.getInstance();

        private var _sizeX:int;
        private var _sizeZ:int;

		public function Obstacle() {
			super();
		};
		
		override public function get reflection():Class {
			return Obstacle;
		};

        public function init(pSizeX:int, pSizeZ:int):void {
            _sizeX = pSizeX;
            _sizeZ = pSizeZ;
        };

		override public function setObject(pObject:IsometricDisplayObject):void {
			super.setObject(pObject);

            if (_sizeX == 0 && _sizeZ == 0) {
                return;
            }

            if (_sizeX == 1 && _sizeZ == 1) {
                _pathfinder.setUnWalkable(pObject.x, pObject.z);
            } else {
                var offsetX:int = pObject.x - int(_sizeX / 2);
                var offsetZ:int = pObject.z - int(_sizeZ / 2);

                for (var i:int = offsetX; i < offsetX + _sizeX; i++) {
                    for (var j:int = offsetZ; j < offsetZ + _sizeZ; j++) {
                        _pathfinder.setUnWalkable(i, j);
                    }
                }
            }
		};
	};
}