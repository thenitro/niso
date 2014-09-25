package niso.world.objects.builtin.task.tasks {
    import flash.events.TimerEvent;
    import flash.utils.Timer;

    import niso.world.objects.abstract.IPlayable;
    import niso.world.objects.builtin.Character;
    import niso.world.objects.builtin.task.Task;

    import nmath.Random;

    import npathfinding.base.Node;
    import npathfinding.base.Pathfinder;

    public class IdleTask extends Task {
        public static const STATE_ID:int = 1;

        private static var _pathfinder:Pathfinder = Pathfinder.getInstance();

        private var _timer:Timer;
        private var _object:IPlayable;

        public function IdleTask() {
            super(STATE_ID);
        };

        override public function get reflection():Class {
            return IdleTask;
        };

        override public function poolPrepare():void {
            super.poolPrepare();
            stopTimer();

            _object = null;
        };

        override public function dispose():void {
            super.dispose();
            stopTimer();

            _object = null;
        };

        override public function init(pBehavior:Character):void {
            super.init(pBehavior);

            _condition = _pool.get(IdleCondition) as IdleCondition;
            _condition.init(this);

            _object = pBehavior.object as IPlayable;
        };

        override public function execute():void {
            startTimer();

            _object.gotoAndPlay('idle');
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
            findPath();
            executed();
        };

        private function findPath():void {
            var destination:Node = Random.arrayElement(_pathfinder.freeNodes.list);

            var path:Vector.<Node> = _pathfinder.findPath(behavior.object.x,
                                                          behavior.object.z,
                                                          destination.indexX,
                                                          destination.indexY,
                                                          behavior.heuristic);

            var walkTask:WalkTask = _pool.get(WalkTask) as WalkTask;
                walkTask.path        = path;
                walkTask.destination = destination;
                walkTask.init(behavior);

            behavior.tasks.addTask(walkTask);

            var idleTask:IdleTask = _pool.get(IdleTask) as IdleTask;
                idleTask.init(behavior);

            behavior.tasks.addTask(idleTask);
        };
    }
}
