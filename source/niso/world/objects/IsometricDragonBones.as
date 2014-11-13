package niso.world.objects {
    import dragonBones.Armature;
    import dragonBones.animation.WorldClock;
    import dragonBones.events.AnimationEvent;
    import dragonBones.factorys.StarlingFactory;

    import flash.display.BitmapData;

    import flash.geom.Point;
    import flash.geom.Rectangle;

    import niso.world.objects.abstract.IPlayable;

    import starling.display.DisplayObjectContainer;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Touch;
    import starling.textures.SubTexture;

    public class IsometricDragonBones extends IsometricDisplayObject implements IPlayable {
        private var _view:Sprite;

        private var _animation:String;
        private var _flip:Boolean;

        private var _armature:Armature;
        private var _sprite:Sprite;

        private var _factory:StarlingFactory;

        public function IsometricDragonBones() {
            super();
        };

        override public function get reflection():Class {
            return IsometricDragonBones;
        };

        override public function hitTest(pTouch:Touch):Boolean {
            if (!super.hitTest(pTouch)) {
                return false;
            }

            var bitmap:BitmapData = _factory.getTextureAtlas(_factory.currentTextureAtlasName).bitmapData;

            for (var i:int = 0; i < _sprite.numChildren; i++) {
                var image:Image = _sprite.getChildAt(i) as Image;
                if (!image) {
                    continue;
                }

                var texture:SubTexture = image.texture as SubTexture;
                if (!texture) {
                    continue;
                }

                var clip:Rectangle = texture.clipping;

                var point:Point = pTouch.getLocation(image);

                    point.x += bitmap.width  * clip.x;
                    point.y += bitmap.height * clip.y;

                var pixel:uint = bitmap.getPixel32(point.x, point.y);
                var alpha:int  = (pixel >> 24) & 0xFF;

                if (!alpha) {
                    continue;
                }

                return true;
            }

            return false;
        };

        override public function set visible(pValue:Boolean):void {
            super.visible = pValue;

            if (pValue) {
                WorldClock.clock.add(_armature);
            } else {
                WorldClock.clock.remove(_armature);
            }
        };

        override public function poolPrepare():void {
            removeBehavoir();
            clean();

            super.poolPrepare();
        };

        public function buildArmature(pArmatureID:String,
                                      pFactory:StarlingFactory):void {
            clean();

            _factory = pFactory;

            _armature = pFactory.buildArmature(pArmatureID);
            _sprite   = _armature.display as Sprite;

            _view.addChild(_sprite);

            WorldClock.clock.add(_armature);
        };

        public function gotoAndPlay(pAnimation:String, pFlip:Boolean = false):void {
            if (_animation == pAnimation && _flip == pFlip) {
                return;
            }

            _animation = pAnimation;
            _flip      = pFlip;

            _armature.addEventListener(AnimationEvent.LOOP_COMPLETE, animationEventCompleteEventHandler);
            _armature.animation.gotoAndPlay(pAnimation);

            _sprite.scaleX = pFlip ? -1 : 1;
        };

        override protected function init():DisplayObjectContainer {
            _view = new Sprite();

            return _view;
        };

        private function clean():void {
            _view.removeChildren(0, -1, true);

            _animation = null;

            if (_armature) {
                _armature.removeEventListener(AnimationEvent.COMPLETE, animationEventCompleteEventHandler);
                _armature = null;
            }

            _sprite  = null;
            _factory = null;
        };

        private function animationEventCompleteEventHandler(pEvent:AnimationEvent):void {
            if (!_armature) {
                return;
            }

            _armature.removeEventListener(AnimationEvent.COMPLETE, animationEventCompleteEventHandler);

            dispatchEventWith(PlayableEvents.COMPLETE);
        };
    };
}
