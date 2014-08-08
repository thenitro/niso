package niso.world.objects {
    import niso.world.objects.abstract.IPlayable;

    import starling.core.Starling;
    import starling.display.DisplayObject;
    import starling.display.MovieClip;
    import starling.display.Sprite;
    import starling.textures.TextureAtlas;
    import starling.textures.TextureSmoothing;

    public class IsometricMovieClip extends IsometricDisplayObject implements IPlayable {
        private var _view:Sprite;

        private var _atlas:TextureAtlas;

        private var _pivotX:Number;
        private var _pivotY:Number;

        private var _frameRate:int;

        private var _animation:String;
        private var _flip:Boolean;

        private var _movie:MovieClip;

        public function IsometricMovieClip() {
            super();
        };

        override public function get reflection():Class {
            return IsometricMovieClip;
        };

        override public function set visible(pValue:Boolean):void {
            super.visible = pValue;

            if (pValue) {
                Starling.juggler.add(_movie);
            } else {
                Starling.juggler.remove(_movie);
            }
        };

        public function setAtlas(pAtlas:TextureAtlas,
                                 pPivotX:Number, pPivotY:Number,
                                 pFrameRate:int,
                                 pAnimation:String):void {
            _atlas = pAtlas;

            _pivotX = pPivotX;
            _pivotY = pPivotY;

            _frameRate = pFrameRate;

            gotoAndPlay(pAnimation);
        };

        public function gotoAndPlay(pAnimation:String, pFlip:Boolean = false):void {
            if (_animation == pAnimation && _flip == pFlip) {
                return;
            }

            _animation = pAnimation;
            _flip      = pFlip;

            _view.removeChildren(0, -1, true);

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

        override protected function init():DisplayObject {
            _view = new Sprite();

            return _view;
        };
    };
}
