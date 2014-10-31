package niso.world.objects.builtin.task.tasks {
    import niso.world.objects.PlayableEvents;
    import niso.world.objects.abstract.IInteractable;
    import niso.world.objects.abstract.IPlayable;
    import niso.world.objects.builtin.Character;
    import niso.world.objects.builtin.task.Task;

    import starling.events.Event;

    public class InteractTask extends Task {
        public static const STATE_ID:int = 3;

        public var target:IInteractable;

        private var _object:IPlayable;

        public function InteractTask() {
            super(STATE_ID);
        };

        override public function get reflection():Class {
            return InteractTask;
        };

        override public function poolPrepare():void {
            super.poolPrepare();

            _object.removeEventListener(PlayableEvents.COMPLETE, playableCompleteEventHandler);
            _object = null;
        };

        override public function dispose():void {
            super.dispose();

            _object.removeEventListener(PlayableEvents.COMPLETE, playableCompleteEventHandler);
            _object = null;
        };

        override public function init(pBehavior:Character):void {
            super.init(pBehavior);

            _condition = _pool.get(InteractCondition) as InteractCondition;
            _condition.init(this);

            _object = pBehavior.object as IPlayable;
        };

        override public function execute():void {
            _object.addEventListener(PlayableEvents.COMPLETE, playableCompleteEventHandler);
            _object.gotoAndPlay('interact');
        };

        override public function cancel():void {
            canceled();
        };

        private function playableCompleteEventHandler(pEvent:Event):void {
            _object.removeEventListener(PlayableEvents.COMPLETE, playableCompleteEventHandler);

            target.interact();

            executed();
        };
    }
}
