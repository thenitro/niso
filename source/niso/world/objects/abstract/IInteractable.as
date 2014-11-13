package niso.world.objects.abstract {
    import nmath.vectors.Vector2D;

    import npathfinding.base.Node;

    public interface IInteractable {
        function interact():void;
        function getInteractionPoints():Vector.<Node>;
    }
}
