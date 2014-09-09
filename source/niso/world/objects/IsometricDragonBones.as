package niso.world.objects {
    import dragonBones.Armature;
    import dragonBones.animation.WorldClock;
    import dragonBones.factorys.StarlingFactory;

    import niso.world.objects.abstract.IPlayable;

    import starling.display.DisplayObject;
    import starling.display.Sprite;

    public class IsometricDragonBones extends IsometricDisplayObject implements IPlayable {
        private var _view:Sprite;

        private var _animation:String;
        private var _flip:Boolean;

        private var _armature:Armature;
        private var _sprite:Sprite;

        public function IsometricDragonBones() {
            super();
        };

        override public function get reflection():Class {
            return IsometricDragonBones;
        };

        override public function set visible(pValue:Boolean):void {
            super.visible = pValue;

            if (pValue) {
                WorldClock.clock.add(_armature);
            } else {
                WorldClock.clock.remove(_armature);
            }
        };

        public function buildArmature(pArmatureID:String,
                                      pFactory:StarlingFactory):void {
            _view.removeChildren(0, -1, true);

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

            _armature.animation.gotoAndPlay(pAnimation);
            _sprite.scaleX = pFlip ? -1 : 1;
        };

        override protected function init():DisplayObject {
            _view = new Sprite();

            return _view;
        };
    };
}
