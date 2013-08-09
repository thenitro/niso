package com.thenitro.isometric.world.objects {
	import com.thenitro.isometric.points.Point2D;
	import com.thenitro.isometric.points.Point3D;
	import com.thenitro.isometric.world.layers.IsometricLayer;
	import com.thenitro.ngine.pool.IReusable;
	import com.thenitro.ngine.pool.Pool;
	
	import starling.display.DisplayObject;
	
	public class IsometricDisplayObject implements IReusable {
		private static var _pool:Pool = Pool.getInstance();
		
		private var _screenPosition:Point2D;
		private var _isometricPosition:Point3D;
		
		private var _id:uint;
		
		private var _layer:IsometricLayer;
		
		private var _view:DisplayObject;
		
		public function IsometricDisplayObject() {
			_screenPosition = _pool.get(Point2D) as Point2D;
			
			if (!_screenPosition) {
				_screenPosition = new Point2D();
				_pool.allocate(Point2D, 1);
			}
			
			_isometricPosition = _pool.get(Point3D) as Point3D;
			
			if (!_isometricPosition) {
				_isometricPosition = new Point3D();
				_pool.allocate(Point3D, 1);
			}
			
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
		
		public function get depth():Number {
			return _screenPosition.depth;
		};
		
		public function setLayer(pLayer:IsometricLayer):void {
			_layer = pLayer;
		};
		
		public function updateScreenPosition():void {
			if (!_layer || !_layer.world || !_layer.world.geometry) {
				return;
			}
			
			_layer.world.geometry.isometricToScreen(_isometricPosition, _screenPosition);
			
			_view.x = _screenPosition.x;
			_view.y = _screenPosition.y;
		};
		
		public function poolPrepare():void {
			
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