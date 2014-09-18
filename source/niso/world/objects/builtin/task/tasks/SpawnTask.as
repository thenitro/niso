package niso.world.objects.builtin.task.tasks {
    import niso.world.objects.builtin.Character;
    import niso.world.objects.builtin.task.Task;

    import nmath.Random;

    import npathfinding.base.Node;

    import npathfinding.base.Pathfinder;

    public class SpawnTask extends Task {
        public static const STATE_ID:int = 0;

        private static var _pathfinder:Pathfinder = Pathfinder.getInstance();

        public function SpawnTask() {
            super(STATE_ID);
        };

        override public function get reflection():Class {
            return SpawnTask;
        };

        override public function init(pBehavior:Character):void {
            super.init(pBehavior);

            _condition = new SpawnCondition();
            _condition.init(this);
        };

        override public function execute():void {
            var free:Array     = _pathfinder.freeNodes.list;
            var spawnNode:Node = Random.arrayElement(free);

            behavior.object.x = spawnNode.indexX;
            behavior.object.z = spawnNode.indexY;

            behavior.object.updateScreenPosition();

            executed();
        };
    };
}
