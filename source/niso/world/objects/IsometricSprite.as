package niso.world.objects {
    import flash.geom.Point;
    import flash.geom.Rectangle;

    import niso.files.NIOFormat;

    import starling.display.DisplayObjectContainer;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Touch;
    import starling.textures.TextureSmoothing;

    public final class IsometricSprite extends IsometricDisplayObject {
		private var _view:Sprite;
        private var _nio:NIOFormat;
		
		public function IsometricSprite() {
			super();
		};
		
		override public function get reflection():Class {
			return IsometricSprite;
		};

        override public function hitTest(pTouch:Touch):Boolean {
            if (!super.hitTest(pTouch)) {
                return false;
            }

            var point:Point = pTouch.getLocation(view);

            var bdX:Number = point.x + _nio.offsetX;
            var bdY:Number = point.y + _nio.offsetY;

            var pixel:uint = _nio.bitmapData.getPixel32(bdX, bdY);
            var alpha:int  = (pixel >> 24) & 0xFF;
            if (!alpha) {
                return false;
            }

            return true;
        };

        override public function poolPrepare():void {
            _view.removeChildren(0, -1, true);
            _nio = null;

            super.poolPrepare();
        };
		
		public function setTexture(pNIO:NIOFormat):void {
            _nio = pNIO;

			_view.removeChildren(0, -1, true);
			
			var image:Image = new Image(pNIO.texture);
				
				image.pivotX    = pNIO.offsetX;
				image.pivotY    = pNIO.offsetY;

				image.smoothing = TextureSmoothing.NONE;

			_view.addChild(image);
		};
		
		override protected function init():DisplayObjectContainer {
			_view = new Sprite();
			
			return _view;
		};
	};
}