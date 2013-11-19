package com.thenitro.isometric.world.objects {
	import com.thenitro.isometric.world.layers.IsometricLayer;
	
	import ngine.math.vectors.TVector3D;
	import ngine.math.vectors.Vector2D;
	
	import npooling.IReusable;
	import npooling.Pool;
	
	import starling.display.DisplayObject;
	
	public class IsometricDisplayObject implements IReusable {
		private static var _pool:Pool = Pool.getInstance();
		
		private var _screenPosition:Vector2D;
		private var _isometricPosition:TVector3D;
		
		private var _id:uint;
		
		private var _layer:IsometricLayer;
		
		private var _view:DisplayObject;
		private var _behavior:IsometricBehavior;
		
		private var _alpha:Number;
		
		private var _indexX:int;
		private var _indexZ:int;
		
		public function IsometricDisplayObject() {
			_alpha = 1.0;
			
			_screenPosition    = Vector2D.ZERO;
			_isometricPosition = TVector3D.ZERO;
			
			_view = init();
		};
		
		public function get reflection():Class {
			return IsometricDisplayObject;
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
		
		public function get indexX():int {
			return _indexX;
		};
		
		public function get indexZ():int {
			return _indexZ;
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
			
			_indexX = _isometricPosition.x / _layer.world.geometry.tileSize;
			_indexZ = _isometricPosition.z / _layer.world.geometry.tileSize;
		};
		
		public function poolPrepare():void {
			_alpha = 1.0;
		};
		
		public function dispose():void {
			_pool.put(_screenPosition);
			_pool.put(_isometricPosition);
			
			_screenPosition    = null;
			_isometricPosition = null;
			
			_layer = null;
			
			_view.dispose();
			_view = null;
		};
		
		protected function init():DisplayObject {
			return null;
		};
	}
}