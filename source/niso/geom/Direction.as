package niso.geom {
    import npooling.IReusable;
    import npooling.Pool;

    public class Direction implements IReusable {
        private static var _pool:Pool = Pool.getInstance();

        private var _disposed:Boolean;

        private var _id:String;
        private var _flip:Boolean;

        public function Direction() {

        };

        public static function get NEW():Direction {
            var result:Direction = _pool.get(Direction) as Direction;

            if (!result) {
                _pool.allocate(Direction, 1);
                result = new Direction();
            }

            return result;
        };

        public function get reflection():Class {
            return Direction;
        };

        public function get disposed():Boolean {
            return _disposed;
        };

        public function get id():String {
            return _id;
        };

        public function get flip():Boolean {
            return _flip;
        };

        public function clone():Direction {
            var result:Direction = Direction.NEW;
                result.init(_id, _flip);

            return result;
        };

        public function poolPrepare():void {

        };

        public function dispose():void {
            _disposed = true;
        };

        internal function init(pID:String, pFlip:Boolean = false):void {
            _id   = pID;
            _flip = pFlip;
        };
    }
}
