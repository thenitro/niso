package niso.files {
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.events.Event;
    import flash.utils.ByteArray;

    import ngine.files.TFile;

    import npooling.IReusable;

    import starling.events.EventDispatcher;
    import starling.textures.Texture;
    import starling.textures.TextureAtlas;

    public class NIOFormat extends EventDispatcher implements IReusable {
        public static const PARSING_COMPLETED:String = 'parsing_completed';


        private static const EMPTY_BITMAP:BitmapData = new BitmapData(2, 2, true, 0x00000000);
        private static const EMPTY_TEXTURE:Texture   = Texture.fromBitmapData(EMPTY_BITMAP);

        private var _disposed:Boolean;

        private var _offsetX:Number;
        private var _offsetY:Number;

        private var _texture:Texture;
        private var _bitmapData:BitmapData;

        private var _isAtlas:Boolean;
        private var _atlas:TextureAtlas;

        private var _description:XML;

        private var _file:TFile;

        public function NIOFormat(pOffsetX:Number = 0, pOffsetY:Number = 0,
                                  pTexture:Texture = null) {
            super();

            _offsetX = pOffsetX;
            _offsetY = pOffsetY;

            _texture    = pTexture || EMPTY_TEXTURE;
            _bitmapData = EMPTY_BITMAP;
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

        public function get isAtlas():Boolean {
            return _isAtlas;
        };

        public function get texture():Texture {
            return _texture;
        };

        public function get atlas():TextureAtlas {
            return _atlas;
        };

        public function get bitmapData():BitmapData {
            return _bitmapData;
        };

        public function load(pFile:TFile):void {
            if (pFile.content is NIOFormat) {
                dispatchEventWith(PARSING_COMPLETED);
                return;
            }

            _file = pFile;

            var content:ByteArray = _file.content as ByteArray;
                content.position = 0;

            _offsetX = content.readInt();
            _offsetY = content.readInt();

            var size:int = content.readInt();

            var ba:ByteArray = new ByteArray();
                ba.writeBytes(content, content.position, size);

            content.position += size;

            _isAtlas = content.readBoolean();

            if (_isAtlas) {
                _description = new XML(content.readUTF());
            }

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

            var bitmap:Bitmap = loaderInfo.content as Bitmap;

            _texture    = Texture.fromBitmap(bitmap, false);
            _bitmapData = bitmap.bitmapData;

            if (_isAtlas) {
                _atlas = new TextureAtlas(_texture, _description);
            }

            _file.setContent(this, loaderInfo.bytesLoaded);

            dispatchEventWith(PARSING_COMPLETED);
        };
    };

}