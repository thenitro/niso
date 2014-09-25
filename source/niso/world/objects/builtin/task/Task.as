package niso.world.objects.builtin.task {
    import niso.world.objects.builtin.Character;

    import npooling.IReusable;

    import starling.events.Event;
    import starling.events.EventDispatcher;

    public class Task extends EventDispatcher implements IReusable {
        private var _disposed:Boolean;

        protected var _condition:TaskCondition;

        private var _state:int;
        private var _behavior:Character;

		public function Task(pState:int) {
            _state = pState;

			super();
		};

        public function get reflection():Class {
            return Task;
        };

        public function get disposed():Boolean {
            return _disposed;
        };

        public function get state():int {
            return _state;
        };

        public function get behavior():Character {
            return _behavior;
        };

        public function get condition():TaskCondition {
            return _condition;
        };

        public function get controller():TaskController {
            return _behavior.tasks;
        };

        public function init(pBehavior:Character):void {
            _behavior = pBehavior;
        };

        public function cancel():void {
            canceled();
        };
		
		public function execute():void {
            executed();
		};

        protected function canceled():void {
            dispatchEventWith(Event.CANCEL);
        };

        protected function executed():void {
            dispatchEventWith(Event.COMPLETE);
        };

        public function poolPrepare():void {
            removeEventListeners();
            cancel();

            _behavior = null;
        };

        public function dispose():void {
            removeEventListeners();
            cancel();

            _behavior = null;
        };
	};
}