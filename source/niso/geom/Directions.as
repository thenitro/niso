package niso.geom {
    import flash.errors.IllegalOperationError;
    import flash.utils.Dictionary;

    import nmath.vectors.TVector3D;
    import nmath.vectors.Vector2D;

    import npooling.Pool;

    public class Directions {
        private static var _pool:Pool = Pool.getInstance();

        private static var _instance:Directions;
        private static var _allowInstance:Boolean;

        private var _directions:Dictionary;
        private var _geometry:IsometricGeometry;

        public function Directions() {
            if (!_allowInstance) {
                throw new IllegalOperationError('Directions is Singleton!');
            }
        };

        public static function getInstance():Directions {
            if (!_instance) {
                _allowInstance = true;
                _instance      = new Directions();
                _allowInstance = false;
            }

            return _instance;
        };

        public function init(pGeometry:IsometricGeometry):void {
            _geometry   = pGeometry;
            _directions = new Dictionary();

            var current:TVector3D = TVector3D.ZERO;
                current.x = 1;
                current.z = 1;

            var next:TVector3D = TVector3D.ZERO;
                next.x = 2;
                next.z = 2;

            var angle:Number = getAngle(current, next);
            var direction:Direction = Direction.NEW;
                direction.init('forward');

            _directions[angle] = direction.clone();

            next.x = 0;
            next.z = 0;

            angle = getAngle(current, next);
            direction.init('backward');

            _directions[angle] = direction.clone();

            next.x = 0;
            next.z = 2;

            angle = getAngle(current, next);
            direction.init('side', true);

            _directions[angle] = direction.clone();

            next.x = 2;
            next.z = 0;

            angle = getAngle(current, next);
            direction.init('side');

            _directions[angle] = direction.clone();

            next.x = 1;
            next.z = 0;

            angle = getAngle(current, next);
            direction.init('backward_side');

            _directions[angle] = direction.clone();

            next.x = 0;
            next.z = 1;

            angle = getAngle(current, next);
            direction.init('backward_side', true);

            _directions[angle] = direction.clone();

            next.x = 2;
            next.z = 1;

            angle = getAngle(current, next);
            direction.init('forward_side');

            _directions[angle] = direction.clone();

            next.x = 1;
            next.z = 2;

            angle = getAngle(current, next);
            direction.init('forward_side', true);

            _directions[angle] = direction;

            _pool.put(current);
            _pool.put(next);
        };

        public function getDirection(pStart:TVector3D,
                                     pDestination:TVector3D):Direction {
            var angle:Number = getAngle(pStart, pDestination);

            return _directions[angle];
        };

        private function getAngle(pVectorA:TVector3D,
                                  pVectorB:TVector3D):Number {
            var vectorA2D:Vector2D = _geometry.isometricToScreen(pVectorA);
            var vectorB2D:Vector2D = _geometry.isometricToScreen(pVectorB);

            var result:Number = vectorB2D.angleTo(vectorA2D);

            _pool.put(vectorA2D);
            _pool.put(vectorB2D);

            return result;
        };
    };
}
