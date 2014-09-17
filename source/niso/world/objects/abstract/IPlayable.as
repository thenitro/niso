package niso.world.objects.abstract {
    import starling.display.DisplayObjectContainer;

    public interface IPlayable {
        function get view():DisplayObjectContainer;
        function gotoAndPlay(pSequenceID:String, pFlip:Boolean = false):void;
    }
}
