package niso.files {
    import flash.display.Bitmap;
    import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.events.Event;
    import flash.utils.ByteArray;
    import flash.utils.ByteArray;

    import ngine.files.TFile;

    import npooling.IReusable;

    import starling.events.EventDispatcher;
    import starling.textures.Texture;

    public class NIOFormat extends EventDispatcher implements IReusable {
        public static const PARSING_COMPLETED:String = 'parsing_completed';

        private var _disposed:Boolean;

        private var _offsetX:Number;
        private var _offsetY:Number;

        private var _texture:Texture;

        private var _file:TFile;

        public function NIOFormat() {
            super();
        };

        public function get reflection():Class {
            return NIOFormat;
        };

        public function get disposed():Boolean {
            return _disposed;
        };

        public function get offsetX():Number {
            return _offsetX;
        };

        public function get offsetY():Number {
            return _offsetY;
        };

        public function get texture():Texture {
            return _texture;
        };

        public function load(pFile:TFile):void {
            _file = pFile;

            var content:ByteArray = pFile.content as ByteArray;

            _offsetX = content.readInt();
            _offsetY = content.readInt();

            var size:int = content.readInt();

            var ba:ByteArray = new ByteArray();
                ba.writeBytes(content, content.position, size);

            content.position += size;

            var loader:Loader = new Loader();
                loader.contentLoaderInfo.addEventListener(Event.COMPLETE,
                                                          loaderCompletedEventHandler);
                loader.loadBytes(ba);
        };

        public function poolPrepare():void {
            _texture = null
        };

        public function dispose():void {
            poolPrepare();

            _disposed = true;
        };

        private function loaderCompletedEventHandler(pEvent:Event):void {
            var loaderInfo:LoaderInfo = pEvent.target as LoaderInfo;
                loaderInfo.removeEventListener(Event.COMPLETE,
                                               loaderCompletedEventHandler);

            _texture = Texture.fromBitmap(loaderInfo.content as Bitmap);

            _file.setContent(this, loaderInfo.bytesLoaded);

            dispatchEventWith(PARSING_COMPLETED);
        };
    };

}