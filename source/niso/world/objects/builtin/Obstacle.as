package niso.world.objects.builtin {
    import niso.world.objects.IsometricBehavior;
    import niso.world.objects.IsometricDisplayObject;

    import npathfinding.base.Pathfinder;

    public class Obstacle extends IsometricBehavior {
		protected static var _pathfinder:Pathfinder = Pathfinder.getInstance();

        public var width:Number;
        public var height:Number;

		public function Obstacle() {
			super();
		};
		
		override public function get reflection():Class {
			return Obstacle;
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

        private function setState(pState:Function):void {
            if (width == 0 && height == 0) {
                return;
            }

            if (width == 1 && height == 1) {
                pState(object.x, object.z);
            } else {
                var offsetX:int = object.x - int(width  / 2);
                var offsetZ:int = object.z - int(height / 2);

                for (var i:int = offsetX; i < offsetX + width; i++) {
                    for (var j:int = offsetZ; j < offsetZ + height; j++) {
                        pState(i, j);
                    }
                }
            }
        };
	};
}