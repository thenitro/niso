package niso.world.objects.builtin {
    import niso.world.objects.IsometricBehavior;
    import niso.world.objects.IsometricDisplayObject;

    import npathfinding.base.Pathfinder;

    public class Obstacle extends IsometricBehavior {
		protected static var _pathfinder:Pathfinder = Pathfinder.getInstance();

        private var _sizeX:int;
        private var _sizeZ:int;

		public function Obstacle() {
			super();
		};
		
		override public function get reflection():Class {
			return Obstacle;
		};

        public function get sizeX():int {
            return _sizeX;
        };

        public function get sizeZ():int {
            return _sizeZ;
        };

        override public function poolPrepare():void {
            setState(_pathfinder.setWalkable);

            super.poolPrepare();
        };

        override public function dispose():void {
            setState(_pathfinder.setWalkable);
            super.dispose();
        };

		override public function setObject(pObject:IsometricDisplayObject):void {
			super.setObject(pObject);
            setState(_pathfinder.setUnWalkable);
		};

        public function setSize(pSizeX:int, pSizeZ:int):void {
            _sizeX = pSizeX;
            _sizeZ = pSizeZ;
        };

        private function setState(pState:Function):void {
            if (_sizeX == 0 && _sizeZ == 0) {
                return;
            }

            if (_sizeX == 1 && _sizeZ == 1) {
                pState(object.x, object.z);
            } else {
                var offsetX:int = object.x - int(_sizeX / 2);
                var offsetZ:int = object.z - int(_sizeZ / 2);

                for (var i:int = offsetX; i < offsetX + _sizeX; i++) {
                    for (var j:int = offsetZ; j < offsetZ + _sizeZ; j++) {
                        pState(i, j);
                    }
                }
            }
        };
	};
}