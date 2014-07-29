package niso.world.objects {
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;

	public final class IsometricSprite extends IsometricDisplayObject {
		private var _view:Sprite;
		
		public function IsometricSprite() {
			super();
		};
		
		override public function get reflection():Class {
			return IsometricSprite;
		};
		
		public function setTexture(pTexture:Texture,
                                   pPivotX:Number, pPivotY:Number):void {
			if (!pTexture) {
				throw new Error("IsometricSprite.setTexure: texture is null!");
				return;
			}
			
			_view.removeChildren(0, -1, true);
			
			var image:Image = new Image(pTexture);
				
				image.pivotX    = pPivotX;
				image.pivotY    = pPivotY;

				image.smoothing = TextureSmoothing.NONE;
				
			_view.addChild(image);
		};
		
		override protected function init():DisplayObject {
			_view = new Sprite();
			
			return _view;
		};
	};
}