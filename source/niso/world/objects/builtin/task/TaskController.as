package niso.world.objects.builtin.task {
    import npooling.IReusable;
    import npooling.Pool;

    import nthread.Threader;

    import starling.core.Starling;
    import starling.events.Event;

    public class TaskController implements IReusable {
		public static const NO:int = -1;

        private static var _pool:Pool         = Pool.getInstance();
		private static var _threader:Threader = createThreader();

        private var _disposed:Boolean;

        private var _state:int;
        private var _currentTask:Task;

		private var _schedule:Vector.<Task>;
		
		public function TaskController() {
			_schedule = new Vector.<Task>();
            _state    = NO;
		};

        public static function get NEW():TaskController {
            var result:TaskController = _pool.get(TaskController) as TaskController;

            if (!result) {
                result = new TaskController();
                _pool.allocate(TaskController, 1);
            }

            return result;
        };

        private static function createThreader():Threader {
            _threader = new Threader();
            _threader.init(1, 2);

            Starling.current.stage.addEventListener(Event.ENTER_FRAME,
                                                    enterFrameEventHandler);

            return _threader;
        };

        private static function enterFrameEventHandler(pEvent:Event):void {
            _threader.update();
        };

        public function get reflection():Class {
            return TaskController;
        };

		public function get disposed():Boolean {
			return _disposed;
		};

        public function get state():int {
            return _state;
        };

		public function addTask(pTask:Task):void {
            if (pTask.condition.type == TaskCondition.TYPE_INTERRUPT) {
                if (pTask.condition.check()) {
                    purge();

                    _schedule.push(pTask);
                    return;
                }
            }

            _schedule.push(pTask);

            if (!_currentTask) {
               startNextTask();
            }
		};

        public function purge():void {
            for each (var task:Task in _schedule) {
                _pool.put(task);
            }

            _schedule.length = 0;

            if (_currentTask) {
                _threader.removeThread(_currentTask.execute);

                _currentTask.removeEventListener(Event.COMPLETE, taskCompleteEventHandler);
                _currentTask.cancel();
            }
        };

        public function poolPrepare():void {
            poolCurrentTask();
            purge();
        };

        public function dispose():void {
            poolCurrentTask();
            purge();

            _schedule = null;
        };

        private function startTask(pTask:Task):void {
            if (!pTask) {
                return;
            }

            _state = pTask.state;

            _currentTask = pTask;
            _currentTask.addEventListener(Event.COMPLETE, taskCompleteEventHandler);
            _currentTask.addEventListener(Event.CANCEL,   taskCanceledEventHandler);
            _currentTask.addEventListener(Event.REMOVED,  taskRemovedEventHandler);

            //_currentTask.execute();

            _threader.addThread(_currentTask.execute);
        };

        private function startNextTask():void {
            var task:Task = _schedule.shift();

            if (task && task.condition.check()) {
                startTask(task);
            }
        };

        private function poolCurrentTask():void {
            _pool.put(_currentTask);
            _currentTask = null;
        };

        private function taskCompleteEventHandler(pEvent:Event):void {
            _currentTask.removeEventListener(Event.COMPLETE, taskCompleteEventHandler);
            _currentTask.removeEventListener(Event.CANCEL,   taskCanceledEventHandler);
            _currentTask = null;

            startNextTask();
        };

        private function taskCanceledEventHandler(pEvent:Event):void {
            _currentTask.removeEventListener(Event.COMPLETE, taskCompleteEventHandler);
            _currentTask.removeEventListener(Event.CANCEL,   taskCanceledEventHandler);
            _currentTask = null;

            startNextTask();
        };

        private function taskRemovedEventHandler(pEvent:Event):void {
            _pool.put(pEvent.target as Task);
        };
	};
}