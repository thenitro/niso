package niso.world.objects.builtin.task {
    import npooling.IReusable;

    public class TaskCondition implements IReusable {
		public static const TYPE_INTERRUPT:int = 0;
		public static const TYPE_CONDITION:int = 1;

        private var _disposed:Boolean;

        private var _type:uint;
        private var _task:Task;

		public function TaskCondition(pType:uint) {
			_type  = pType;
		};

        public function get reflection():Class {
            return TaskCondition;
        };

        public function get disposed():Boolean {
            return _disposed;
        };

		public function get type():int {
			return _type;
		};

        public function get task():Task {
            return _task;
        };

        public function init(pTask:Task):void {
            _task = pTask;
        };
		
		public function check():Boolean {
			return false;
		};

        public function poolPrepare():void {

        };

		public function dispose():void {
			_disposed = true;
		};
	};
}