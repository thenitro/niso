package niso.world.objects.builtin.task.tasks {
    import niso.world.objects.builtin.task.TaskCondition;

    public class IdleCondition extends TaskCondition {

        public function IdleCondition() {
            super(TYPE_CONDITION);
        };

        override public function get reflection():Class {
            return IdleCondition;
        };

        override public function check():Boolean {
            return true;
        };
    }
}
