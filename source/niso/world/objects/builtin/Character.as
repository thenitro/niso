package niso.world.objects.builtin {
    import niso.world.objects.IsometricBehavior;
    import niso.world.objects.IsometricDisplayObject;
    import niso.world.objects.builtin.task.TaskController;

    import npathfinding.base.Heuristic;

    public class Character extends IsometricBehavior {
		public static const MOVE_COMPLETE:String = 'move_complete_event';

        public var moveSpeed:Number   = 2.0;
        public var heuristic:Function = Heuristic.manhattan;

        public var maxIdleTime:int = 10000;

        private var _tasks:TaskController;
		
		public function Character() {
			super();
		};
		
		override public function get reflection():Class {
			return Character;
		};

        public function get tasks():TaskController {
            return _tasks;
        };

        override public function poolPrepare():void {
            _pool.put(_tasks);
            _tasks = null;

            super.poolPrepare();
        };

        override public function dispose():void {
            _pool.put(_tasks);
            _tasks = null;

            super.dispose();
        };

		override public function setObject(pObject:IsometricDisplayObject):void {
			super.setObject(pObject);

            _tasks = new TaskController();
		};
	};
}