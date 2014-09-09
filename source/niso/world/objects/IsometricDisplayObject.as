package niso.world.objects {
    import niso.world.layers.IsometricLayer;

    import nmath.vectors.TVector3D;
    import nmath.vectors.Vector2D;

    import npooling.IReusable;
    import npooling.Pool;

    import starling.display.DisplayObject;
    import starling.events.Event;

    public class IsometricDisplayObject implements IReusable {
		private static var _pool:Pool = Pool.getInstance();

        private var _disposed:Boolean;

		private var _screenPosition:Vector2D;
		private var _isometricPosition:TVector3D;
		
		private var _id:uint;
		
		private var _layer:IsometricLayer;
		
		private var _view:DisplayObject;

		private var _behavior:IsometricBehavior;

		private var _alpha:Number;

		public function IsometricDisplayObject() {
			_alpha = 1.0;
			
			_screenPosition    = Vector2D.ZERO;
			_isometricPosition = TVector3D.ZERO;
			
			_view = init();
            _view.addEventListener(Event.ADDED_TO_STAGE,
                                   viewAddedToStageEventHandler);
		};
		
		public function get reflection():Class {
			return IsometricDisplayObject;
		};

        public function get disposed():Boolean {
            return _disposed;
        };
		
		public function get id():uint {
			return _id;
		};
		
		public function get layer():IsometricLayer {
			return _layer;
		};
		
		public function get view():DisplayObject {
			return _view;
		};
		
		public function set x(pValue:Number):void {
			_isometricPosition.x = pValue;
		};
		
		public function get x():Number {
			return _isometricPosition.x;
		};
		
		public function set y(pValue:Number):void {
			_isometricPosition.y = pValue;
		};
		
		public function get y():Number {
			return _isometricPosition.y;
		};
		
		public function set z(pValue:Number):void {
			_isometricPosition.z = pValue;
		};
		
		public function get z():Number {
			return _isometricPosition.z;
		};
		
		public function set alpha(pValue:Number):void {
			_alpha = pValue;
			
			if (_view) {
				_view.alpha = _alpha;
			}
		};
		
		public function get alpha():Number {
			return _alpha;
		};
		
		public function get depth():Number {
			return _screenPosition.depth;
		};
		
		public function get isometricPosition():TVector3D {
			return _isometricPosition;
		};

        public function get screenPosition():Vector2D {
            return _screenPosition;
        };

        public function get visible():Boolean {
            return _view.visible;
        };

        public function set visible(pValue:Boolean):void {
            _view.visible = pValue;

            if (_behavior) {
                _behavior.visible = pValue;
            }
        };

        public function get behavior():IsometricBehavior {
            return _behavior;
        };

		public function setLayer(pLayer:IsometricLayer):void {
			_layer = pLayer;
		};
		
		public function setBehavior(pBehavior:IsometricBehavior):void {
			_behavior = pBehavior;
			_behavior.setObject(this);
		};
		
		public function updateScreenPosition():void {
			if (!_layer || !_layer.world || !_layer.world.geometry) {
				return;
			}
			
			_layer.world.geometry.isometricToScreen(_isometricPosition, _screenPosition);
			
			_view.x = _screenPosition.x;
			_view.y = _screenPosition.y;
			
			_view.alpha = _alpha;
		};

		public function poolPrepare():void {
            visible = true;

			_alpha = 1.0;

            _screenPosition.zero();
            _isometricPosition.zero();

            _pool.put(_behavior);
            _behavior = null;

            _layer = null;
		};
		
		public function dispose():void {
            poolPrepare();

			_pool.put(_screenPosition);
			_pool.put(_isometricPosition);
			
			_screenPosition    = null;
			_isometricPosition = null;

			_view.dispose();
			_view = null;

            _disposed = true;
		};
		
		protected function init():DisplayObject {
			return null;
		};

        private function viewAddedToStageEventHandler(pEvent:Event):void {
            var target:DisplayObject = pEvent.target as DisplayObject;
                target.removeEventListener(Event.ADDED_TO_STAGE,
                                           viewAddedToStageEventHandler);
        };
	}
}