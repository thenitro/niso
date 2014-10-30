package niso.world.objects.builtin {
    import niso.world.objects.abstract.IInteractable;

    import npathfinding.base.Node;

    public class Interactable extends Obstacle implements IInteractable {

        public function Interactable() {
            super();
        };

        public function interact():void {

        };

        public function getInteractionPoints():Vector.<Node> {
            var result:Vector.<Node> = new Vector.<Node>();

            var offsetX:int = object.x - int(width / 2);
            var offsetZ:int = object.z - int(height / 2);

            for (var i:int = offsetX - 1; i < offsetX + width + 1; i++) {
                for (var j:int = offsetZ - 1; j < offsetZ + height + 1; j++) {
                    if (_pathfinder.isWalkable(i, j)) {
                        result.push(_pathfinder.takeNode(i, j));
                    }
                }
            }

            return result;
        };
    }
}
