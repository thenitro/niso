package niso.world.objects.abstract {
    import npathfinding.base.Node;

    public interface IInteractable {
        function interact():void;
        function getInteractionPoints():Vector.<Node>;
    }
}
