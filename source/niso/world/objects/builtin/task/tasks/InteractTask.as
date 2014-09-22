package niso.world.objects.builtin.task.tasks {
    import niso.world.objects.builtin.task.*;
    import niso.world.objects.builtin.task.tasks.*;
    import flash.events.TimerEvent;
    import flash.utils.Timer;

    import niso.world.objects.abstract.IPlayable;
    import niso.world.objects.builtin.Character;
    import niso.world.objects.builtin.task.Task;

    import nmath.Random;

    import npathfinding.base.Node;
    import npathfinding.base.Pathfinder;

    public class InteractTask extends Task {
        public static const STATE_ID:int = 3;

        private static var _pathfinder:Pathfinder = Pathfinder.getInstance();

        private var _timer:Timer;
        private var _object:IPlayable;

        public function InteractTask() {
            super(STATE_ID);
        };

        override public function get reflection():Class {
            return InteractTask;
        };

        override public function init(pBehavior:Character):void {
            super.init(pBehavior);

            _condition = new IdleCondition();
            _condition.init(this);

            _object = pBehavior.object as IPlayable;
        };

        override public function execute():void {
            startTimer();

            _object.gotoAndPlay('interact');
        };

        override public function cancel():void {
            stopTimer();
            canceled();
        };

        private function startTimer():void {
            _timer = new Timer(Random.range(behavior.maxIdleTime / 10, behavior.maxIdleTime), 1);
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

        private function timerCompleteEventHandler(pEvent:TimerEvent):void {
            stopTimer();
            executed();
        };
    }
}
