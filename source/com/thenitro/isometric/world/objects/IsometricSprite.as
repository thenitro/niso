package com.thenitro.isometric.world.objects {
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;

	public final class IsometricSprite extends IsometricDisplayObject {
		private var _view:Sprite;
		
		public function IsometricSprite() {
			super();
		};
		
		public function setTexture(pTexture:Texture):void {
			if (!pTexture) {
				throw new Error("IsometricSprite.setTexure: texture is null!");
				return null;
			}
			
			_view.removeChildren(0, -1, true);
			
			var image:Image = new Image(pTexture);
				
				image.pivotX = image.width / 2;
				image.pivotY = image.height / 2;
				
			_view.addChild(image);
		};
		
		override protected function init():DisplayObject {
			_view = new Sprite();
			
			return _view;
		};
	};
}