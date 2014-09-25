package niso.world.objects.abstract {
    import starling.display.DisplayObjectContainer;

    public interface IPlayable {
        function addEventListener(type:String,listener:Function):void;
        function removeEventListener(type:String,listener:Function):void;

        function get view():DisplayObjectContainer;
        function gotoAndPlay(pSequenceID:String, pFlip:Boolean = false):void;
    }
}
