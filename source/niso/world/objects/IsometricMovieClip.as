package niso.world.objects {
    import starling.core.Starling;
    import starling.display.DisplayObject;
    import starling.display.MovieClip;
    import starling.display.Sprite;
    import starling.textures.TextureAtlas;
    import starling.textures.TextureSmoothing;

    public class IsometricMovieClip extends IsometricDisplayObject {
        private var _view:Sprite;

        private var _atlas:TextureAtlas;

        private var _pivotX:Number;
        private var _pivotY:Number;

        private var _frameRate:int;

        private var _animation:String;
        private var _flip:Boolean;

        public function IsometricMovieClip() {
            super();
        };

        override public function get reflection():Class {
            return IsometricMovieClip;
        };

        public function setAtlas(pAtlas:TextureAtlas,
                                 pPivotX:Number, pPivotY:Number,
                                 pFrameRate:int,
                                 pAnimation:String):void {
            _atlas = pAtlas;

            _pivotX = pPivotX;
            _pivotY = pPivotY;

            _frameRate = pFrameRate;

            setTextures(pAnimation);
        };

        public function setTextures(pAnimation:String, pFlip:Boolean = false):void {
            if (_animation == pAnimation && _flip == pFlip) {
                return;
            }

            _animation = pAnimation;
            _flip      = pFlip;

            _view.removeChildren(0, -1, true);

            var movie:MovieClip = new MovieClip(_atlas.getTextures(_animation),
                                                _frameRate);

                movie.pivotX    = _pivotX;
                movie.pivotY    = _pivotY;

                movie.scaleX = pFlip ? -1 : 1;

                movie.smoothing = TextureSmoothing.NONE;

                movie.play();

            _view.addChild(movie);

            Starling.juggler.add(movie);
        };

        override protected function init():DisplayObject {
            _view = new Sprite();

            return _view;
        };
    };
}
