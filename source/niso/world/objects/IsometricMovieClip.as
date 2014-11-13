package niso.world.objects {
    import flash.geom.Point;
    import flash.geom.Rectangle;

    import niso.files.NIOFormat;
    import niso.world.objects.abstract.IPlayable;

    import starling.core.Starling;
    import starling.display.DisplayObjectContainer;
    import starling.display.MovieClip;
    import starling.display.Sprite;
    import starling.events.Touch;
    import starling.textures.SubTexture;
    import starling.textures.TextureAtlas;
    import starling.textures.TextureSmoothing;

    public class IsometricMovieClip extends IsometricDisplayObject implements IPlayable {
        private var _view:Sprite;

        private var _pivotX:Number;
        private var _pivotY:Number;

        private var _frameRate:int;

        private var _animation:String;
        private var _flip:Boolean;

        private var _atlas:TextureAtlas;
        private var _movie:MovieClip;

        private var _nio:NIOFormat;

        public function IsometricMovieClip() {
            super();
        };

        override public function get reflection():Class {
            return IsometricMovieClip;
        };


        override public function hitTest(pTouch:Touch):Boolean {
            if (!super.hitTest(pTouch)) {
                return false;
            }

            var texture:SubTexture = _movie.texture as SubTexture;
            if (!texture) {
                return false;
            }

            var clip:Rectangle = texture.clipping;

            var point:Point = pTouch.getLocation(_movie);
                point.x += _nio.bitmapData.width  * clip.x;
                point.y += _nio.bitmapData.height * clip.y;

            var pixel:uint = _nio.bitmapData.getPixel32(point.x, point.y);
            var alpha:int  = (pixel >> 24) & 0xFF;

            if (!alpha) {
                return false;
            }

            return true;
        };

        override public function set visible(pValue:Boolean):void {
            super.visible = pValue;

            if (pValue) {
                Starling.juggler.add(_movie);
            } else {
                Starling.juggler.remove(_movie);
            }
        };

        override public function poolPrepare():void {
            clean();
            super.poolPrepare();
        };

        public function setAtlas(pNIO:NIOFormat,
                                 pFrameRate:int,
                                 pAnimation:String = null):void {
            _nio = pNIO;

            _atlas = pNIO.atlas;

            _pivotX = pNIO.offsetX;
            _pivotY = pNIO.offsetY;

            _frameRate = pFrameRate;

            if (pAnimation) {
                gotoAndPlay(pAnimation);
            }
        };

        public function gotoAndPlay(pAnimation:String, pFlip:Boolean = false):void {
            if (_animation == pAnimation && _flip == pFlip) {
                return;
            }

            _animation = pAnimation;
            _flip      = pFlip;

            clean();

            _movie = new MovieClip(_atlas.getTextures(_animation),
                                                _frameRate);

            _movie.pivotX    = _pivotX;
            _movie.pivotY    = _pivotY;

            _movie.scaleX = pFlip ? -1 : 1;

            _movie.smoothing = TextureSmoothing.NONE;

            _movie.play();

            _view.addChild(_movie);

            Starling.juggler.add(_movie);
        };

        override protected function init():DisplayObjectContainer {
            _view = new Sprite();

            return _view;
        };

        private function clean():void {
            Starling.juggler.remove(_movie);

            _view.removeChildren(0, -1, true);

            _movie = null;
            _atlas = null;

            _animation = null;

            _nio = null;
        };
    };
}
