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

        };
    }
}
