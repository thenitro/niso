package niso.world.objects.builtin.task.tasks {
    import flash.events.TimerEvent;
    import flash.utils.Timer;

    import niso.world.objects.builtin.Character;
    import niso.world.objects.builtin.task.Task;

    import starling.events.Event;

    public class IdleTask extends Task {
        public static const STATE_ID:int = 1;

        public var maxIdleTime:int;

        private var _timer:Timer;

        public function IdleTask() {
            super(STATE_ID);
        };

        override public function get reflection():Class {
            return IdleTask;
        };

        override public function init(pBehavior:Character):void {
            super.init(pBehavior);

            _condition = new IdleCondition();
            _condition.init(this);
        };

        override public function execute():void {
            startTimer();
        };

        override public function cancel():void {
            stopTimer();
            canceled();
        };

        private function startTimer():void {
            _timer = new Timer(Math.random() * maxIdleTime);
            _timer.addEventListener(TimerEvent.TIMER_COMPLETE,
                                    timerCompleteEventHandler);
            _timer.start();
        };

        private function stopTimer():void {
            if (!_timer) {
                return;
            }

            _timer.stop();
            _timer = null;
        };

        private function timerCompleteEventHandler(pEvent:Event):void {
            stopTimer();
            executed();
        };
    }
}
