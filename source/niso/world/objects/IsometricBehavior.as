package niso.world.objects {
	import npooling.IReusable;
	import npooling.Pool;
	
	import starling.events.EventDispatcher;
	
	public class IsometricBehavior extends EventDispatcher implements IReusable {
		protected static var _pool:Pool = Pool.getInstance();

        public var id:String;

        private var _disposed:Boolean;
		private var _object:IsometricDisplayObject;

        private var _visible:Boolean;

        private var _depth:Number = 0;
		
		public function IsometricBehavior() {
			super();
		};
		
		public function get reflection():Class {
			return IsometricBehavior;
		};

        public function get disposed():Boolean {
            return _disposed;
        };
		
		public function get object():IsometricDisplayObject {
			return _object;
		};

        public function get visible():Boolean {
            return _visible;
        };

        public function set visible(pValue:Boolean):void {
            _visible = pValue;
        };

        public function set depth(pValue:Number):void {
            if (_object) {
                _object.y = pValue;
                _object.updateScreenPosition();
            }

            _depth = isNaN(pValue) ? 0 : pValue;
        };
		
		public function setObject(pObject:IsometricDisplayObject):void {
			_object = pObject;
            _object.y = _depth;
            _object.updateScreenPosition();
		};

        public function removeFromPosition():void {

        };

        public function setPosition():void {

        };
		
		public function poolPrepare():void {
			removeEventListeners();

            _object = null;
		};
		
		public function dispose():void {
			removeEventListeners();

            _disposed = true;
		};
	};
}