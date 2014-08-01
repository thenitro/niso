package niso.world.controllers {
    import flash.geom.Point;

    import niso.world.IsometricWorld;

    import nmath.vectors.Vector2D;

    import npooling.Pool;

    import starling.events.EventDispatcher;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;

    public class WorldTouchController extends EventDispatcher {
        public static const TOUCH_EVENT:String = 'touch_event';
        public static const MOVE_EVENT:String  = 'move_event';

        private static var _pool:Pool = Pool.getInstance();

        private var _world:IsometricWorld;
        private var _start:Vector2D;

        public function WorldTouchController() {
            _start  = Vector2D.ZERO;

            super();
        };

        public function init(pWorld:IsometricWorld):void {
            _world = pWorld;
            _world.canvas.addEventListener(TouchEvent.TOUCH,
                                           layerTouchEventHandler);
        };

        public function deactivate():void {
            _world.canvas.removeEventListener(TouchEvent.TOUCH,
                                              layerTouchEventHandler);
        };

        private function layerTouchEventHandler(pEvent:TouchEvent):void {
            var touch:Touch = pEvent.getTouch(_world.canvas);

            if (!touch) {
                _start.zero();

                return;
            }

            var location:Point = touch.getLocation(_world.canvas);

            if (touch.phase == TouchPhase.BEGAN) {
                _start.fromPoint(location);
            }

            var end:Vector2D    = Vector2D.fromPoint(location);
            var offset:Vector2D = end.substract(_start, true);
                offset.divideScalar(2);
                offset.inverse();

            if (touch.phase == TouchPhase.MOVED) {
                dispatchEventWith(MOVE_EVENT, false, offset);

                _start.x = end.x;
                _start.y = end.y;
            }

            if (touch.phase == TouchPhase.ENDED) {
                if (!offset.lengthSquared()) {
                    dispatchEventWith(TOUCH_EVENT, false, _start);
                }
            }

            _pool.put(end);
            _pool.put(offset);
        };
    };
}
