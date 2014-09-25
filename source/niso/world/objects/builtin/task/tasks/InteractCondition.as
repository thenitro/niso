package niso.world.objects.builtin.task.tasks {
    import niso.world.objects.builtin.task.TaskCondition;

    public class InteractCondition extends TaskCondition {

        public function InteractCondition() {
            super(TYPE_CONDITION);
        };

        override public function get reflection():Class {
            return InteractCondition;
        };

        override public function check():Boolean {
            return true;
        };
    }
}
