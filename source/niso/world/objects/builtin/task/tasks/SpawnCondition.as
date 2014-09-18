package niso.world.objects.builtin.task.tasks {
    import niso.world.objects.builtin.task.TaskCondition;
    import niso.world.objects.builtin.task.TaskController;

    public class SpawnCondition extends TaskCondition {

        public function SpawnCondition() {
            super(TYPE_CONDITION);
        };

        override public function get reflection():Class {
            return SpawnCondition;
        };

        override public function check():Boolean {
            if (task.controller.state == TaskController.NO) {
                return true;
            }

            return false;
        };
    };
}
