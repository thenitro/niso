package niso.world.objects.builtin.task.tasks {
    import dragonBones.Bone;

    import niso.geom.Direction;
    import niso.geom.Directions;
    import niso.world.objects.abstract.IPlayable;
    import niso.world.objects.builtin.Character;
    import niso.world.objects.builtin.task.Task;

    import nmath.vectors.TVector3D;

    import npathfinding.base.Node;

    import npooling.Pool;

    import starling.animation.Tween;
    import starling.core.Starling;

    public class WalkTask extends Task {
        private static var _pool:Pool             = Pool.getInstance();
        private static var _directions:Directions = Directions.getInstance();

        public static const STATE_ID:int = 2;

        public var path:Vector.<Node>;
        public var destination:Node;

        private var _currentTween:Tween;
        private var _object:IPlayable;

        private var _next:Node;

        private var _canceled:Boolean;

        public function WalkTask() {
            super(STATE_ID);
        };

        override public function get reflection():Class {
            return WalkTask;
        };

        override public function poolPrepare():void {
            super.poolPrepare();
            removeTween();
        };

        override public function dispose():void {
            super.dispose();
            removeTween();
        };

        override public function init(pBehavior:Character):void {
            super.init(pBehavior);

            _condition = new WalkCondition();
            _condition.init(this);

            _object = pBehavior.object as IPlayable;
        };

        override public function execute():void {
            path.shift();
            nextPoint();
        };

        override public function cancel():void {
            _canceled = true;

            path.length = 0;
        };

        private function nextPoint():void {
            _next = path.shift();

            if (_next) {
                removeTween();

                var destination:TVector3D = TVector3D.ZERO;

                    destination.x = _next.indexX;
                    destination.z = _next.indexY;

                var position:TVector3D = behavior.object.isometricPosition;

                if (!position) {
                    cancel();
                    nextPoint();
                    return;
                }

                var distance:Number     =  position.distanceTo(destination);
                var direction:Direction = _directions.getDirection(position, destination);

                if (direction) {
                    _object.gotoAndPlay(direction.id + '_walk', direction.flip);
                } else {
                    behavior.object.alpha = 0.5;
                }

                _currentTween = new Tween(behavior.object, distance / behavior.moveSpeed);

                _currentTween.animate('x', destination.x);
                _currentTween.animate('z', destination.z);

                _currentTween.onComplete = nextPoint;
                _currentTween.onUpdate   = behavior.object.updateScreenPosition;

                Starling.juggler.add(_currentTween);

                _pool.put(destination);
            } else {
                if (_canceled) {
                    canceled();
                } else {
                    executed();
                }

                path = null;
                destination = null;

                _next = null;
            }
        };

        private function removeTween():void {
            if (!_currentTween) {
                return;
            }

            Starling.juggler.remove(_currentTween);

            _currentTween.removeEventListeners();
            _currentTween = null;
        };
    }
}
