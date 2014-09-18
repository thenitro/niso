package niso.world.objects.builtin.processing.bubbles {
    import ngine.files.Library;

    import niso.world.objects.builtin.processing.ProcessingState;

    import npooling.IReusable;
    import npooling.Pool;

    import starling.display.Sprite;

    public class AbstractBubble extends Sprite implements IReusable {
        protected static var _pool:Pool       = Pool.getInstance();
        protected static var _library:Library = Library.getInstance();

        private var _disposed:Boolean;

        public function AbstractBubble() {
            super();
        };

        public function get reflection():Class {
            return AbstractBubble;
        };

        public function get disposed():Boolean {
            return _disposed;
        };

        override public function dispose():void {
            super.dispose();

            _disposed = true;
        };

        public function update(pState:ProcessingState):void {

        };

        public function poolPrepare():void {
        };
    }
}
