package niso.world.controllers {
    import com.junkbyte.console.Cc;

    import flash.geom.Point;
    import flash.utils.Dictionary;

    import niso.world.IsometricWorld;
    import niso.world.objects.IsometricDisplayObject;

    import nmath.vectors.Vector2D;

    import npooling.Pool;

    import starling.display.DisplayObject;
    import starling.events.EventDispatcher;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;

    public class WorldTouchController extends EventDispatcher {
        public static const INTERACT:String = 'interact';

        public static const TOUCH_EVENT:String = 'touch_event';
        public static const MOVE_EVENT:String  = 'move_event';
        public static const ZOOM_EVENT:String  = 'zoom_event';
        public static const COMPLETED:String   = 'completed';

        public static const TYPE_COORDS:String  = 'coords';
        public static const TYPE_OBJECTS:String = 'objects';

        public static const TYPE_BOTH:String = 'both';

        private static var _pool:Pool = Pool.getInstance();

        private var _world:IsometricWorld;
        private var _start:Vector2D;
        private var _calc:Vector2D;

        private var _fingerA:Vector2D;
        private var _fingerB:Vector2D;

        private var _distance:Number = 0;

        private var _type:String;

        public function WorldTouchController() {
            _start = Vector2D.ZERO;
            _calc  = Vector2D.ZERO;

            super();
        };

        public function setInteractionType(pType:String):void {
            _type = pType;
        };

        public function init(pWorld:IsometricWorld):void {
            _world = pWorld;
            _world.canvas.addEventListener(TouchEvent.TOUCH, layerTouchEventHandler);
        };

        public function deactivate():void {
            _world.canvas.removeEventListener(TouchEvent.TOUCH, layerTouchEventHandler);
        };

        private function layerTouchEventHandler(pEvent:TouchEvent):void {
            if (!_type) {
                CONFIG::DEBUG {
                    Cc.log('WorldTouchController.layerTouchEventHandler: ' +
                            '_type is not set! Use ' +
                            'WorldTouchController.setInteractionType(pType:String)');
                }
                return;
            }

            if (_type == TYPE_OBJECTS || _type == TYPE_BOTH) {
                var object:IsometricDisplayObject = processObjects(pEvent);
                if (object) {
                    return;
                }
            }

            if (pEvent.touches.length == 1) {
                processTapOrPan(pEvent.getTouch(_world.canvas));
                return;
            }

            if (pEvent.touches.length == 2) {
                processZoom(pEvent);
                return;
            }
        };

        private function processObjects(pEvent:TouchEvent):IsometricDisplayObject {
            var objects:Dictionary = _world.getLayerByID(2).objects;

            for (var object:DisplayObject in objects) {
                var touch:Touch = pEvent.getTouch(object);
                if (!touch) {
                    continue;
                }

                var isometric:IsometricDisplayObject =
                        objects[object] as IsometricDisplayObject;
                if (!isometric) {
                    continue;
                }

                if (touch.phase == TouchPhase.ENDED) {
                    if (_calc.lengthSquared() < 10) {
                        dispatchEventWith(INTERACT, false, isometric);
                        return isometric;
                    }
                }
            }

            return null;
        };

        private function processTapOrPan(pTouch:Touch):void {
            if (!pTouch) {
                _start.zero();

                return;
            }

            var location:Point = pTouch.getLocation(_world.canvas);

            if (pTouch.phase == TouchPhase.BEGAN) {
                _start.fromPoint(location);
                _calc.zero();

                return;
            }

            if (pTouch.phase == TouchPhase.MOVED) {
                var end:Vector2D    = Vector2D.fromPoint(location);

                var offset:Vector2D = end.substract(_start, true);
                    offset.inverse();
                    offset.multiplyScalar(_world.canvas.scaleX);

                _calc.add(offset);

                dispatchEventWith(MOVE_EVENT, false, offset);

                _pool.put(end);
                _pool.put(offset);
            }

            if (pTouch.phase == TouchPhase.ENDED) {
                if (_calc.lengthSquared() < 10) {
                    if (_type == TYPE_COORDS || _type == TYPE_BOTH) {
                        dispatchEventWith(TOUCH_EVENT, false, _start);
                    }
                } else {
                    dispatchEventWith(COMPLETED, false, offset);
                }
            }
        };

        private function processZoom(pEvent:TouchEvent):void {
            if (pEvent.touches[0].phase == TouchPhase.BEGAN ||
                    pEvent.touches[1].phase == TouchPhase.BEGAN) {
                _fingerA = Vector2D.fromPoint(pEvent.touches[0].getLocation(_world.canvas));
                _fingerB = Vector2D.fromPoint(pEvent.touches[1].getLocation(_world.canvas));

                _distance = _fingerA.distanceTo(_fingerB);

                return;
            }

            if (pEvent.touches[0].phase == TouchPhase.MOVED ||
                    pEvent.touches[1].phase == TouchPhase.MOVED) {

                _fingerA = Vector2D.fromPoint(pEvent.touches[0].getLocation(_world.canvas));
                _fingerB = Vector2D.fromPoint(pEvent.touches[1].getLocation(_world.canvas));

                var newDistance:Number = _fingerA.distanceTo(_fingerB);
                var scale:Number = _distance / newDistance;

                _distance = newDistance;

                dispatchEventWith(ZOOM_EVENT, false, scale);

                return;
            }

            if (pEvent.touches[0].phase == TouchPhase.ENDED ||
                    pEvent.touches[1].phase == TouchPhase.ENDED) {
                dispatchEventWith(COMPLETED);
                return;
            }
        };
    };
}
