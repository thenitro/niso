package com.thenitro.isometric.world.objects {
	import npooling.IReusable;
	import npooling.Pool;
	
	import starling.events.EventDispatcher;
	
	public class IsometricBehavior extends EventDispatcher implements IReusable {
		protected static var _pool:Pool = Pool.getInstance();
		
		private var _object:IsometricDisplayObject;
		
		public function IsometricBehavior() {
			super();
		};
		
		public function get reflection():Class {
			return IsometricBehavior;
		};
		
		public function get object():IsometricDisplayObject {
			return _object;
		};
		
		public function setObject(pObject:IsometricDisplayObject):void {
			_object = pObject;
		};
		
		public function poolPrepare():void {
			removeEventListeners();
		};
		
		public function dispose():void {
			removeEventListeners();
		};
	};
}