package niso.world.objects.builtin.task.tasks {
    import niso.world.objects.builtin.task.TaskCondition;

    public class WalkCondition extends TaskCondition {

        public function WalkCondition() {
            super(TYPE_CONDITION);
        };

        override public function get reflection():Class {
            return WalkCondition;
        };

        override public function check():Boolean {
            var currentTask:WalkTask = task as WalkTask;

            if (task.behavior.object.x == currentTask.destination.indexX &&
                task.behavior.object.z == currentTask.destination.indexY) {
                return false;
            }

            if (currentTask.path == null || currentTask.path.length == 0) {
                return false
            }

            return true;
        };
    }
}
