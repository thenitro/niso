package niso.world.objects.builtin.task.tasks {
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

        public function WalkTask() {
            super(STATE_ID);
        };

        override public function get reflection():Class {
            return WalkTask;
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
            path = null;
            destination = null;

            _next = null;

            removeTween();
            canceled();
        };

        private function nextPoint():void {
            _next = path.shift();

            if (_next) {
                removeTween();

                var destination:TVector3D = TVector3D.ZERO;

                    destination.x = _next.indexX;
                    destination.z = _next.indexY;

                var distance:Number     = behavior.object.isometricPosition.distanceTo(destination);
                var direction:Direction = _directions.getDirection(behavior.object.isometricPosition, destination);

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
                path = null;

                _next = null;

                executed();
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
