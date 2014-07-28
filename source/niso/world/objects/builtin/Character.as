package niso.world.objects.builtin {
    import niso.world.objects.IsometricBehavior;
    import niso.world.objects.IsometricDisplayObject;

    import starling.animation.Tween;
    import starling.core.Starling;

    public class Character extends IsometricBehavior {
		public static const MOVE_COMPLETE:String = 'move_complete_event';
		
		public var moveHeuristric:Function = AStar.euclidian;
		
		public var moveSpeed:Number = 1;
		
		private static var _pathfinder:Pathfinder = Pathfinder.getInstance();
		
		private var _moving:Boolean;
		private var _route:Vector.<Node>;
		
		private var _destinationX:int;
		private var _destinationZ:int;
		
		public function Character() {
			super();
		};
		
		override public function get reflection():Class {
			return Character;
		};
		
		public function get moving():Boolean {
			return _moving;
		};
		
		override public function setObject(pObject:IsometricDisplayObject):void {
			super.setObject(pObject);
		};
		
		public function moveTo(pDestinationX:int, pDestinationZ:int):void {
			if (_moving) {
				return;
			}
			
			if (object.indexX == pDestinationX && 
				object.indexZ == pDestinationZ) {
				dispatchEventWith(MOVE_COMPLETE, false, object);
				return;
			}
			
			var route:Vector.<Node> = _pathfinder.findPath(object.indexX, 
														   object.indexZ,
														   pDestinationX,
														   pDestinationZ,
														   moveHeuristric);
			
			if (route.length == 0) {
				dispatchEventWith(MOVE_COMPLETE, false, object);
				return;
			}
			
			_destinationX = pDestinationX;
			_destinationZ = pDestinationZ;
			
			_route = _pathfinder.reducePath(route);
			 route = null;
			
			startMoving();
		};
		
		private function startMoving():void {
			_moving = true;
			
			nextPoint();
		};
		
		private function nextPoint():void {
			var node:Node = _route.shift();
			
			if (node) {
				var destination:TVector3D = TVector3D.ZERO;
					destination.x = _destinationX * object.layer.world.geometry.tileSize;
					destination.z = _destinationZ * object.layer.world.geometry.tileSize;
					
				var distance:Number = object.isometricPosition.distanceTo(destination);
				
				var tween:Tween = new Tween(object, distance * moveSpeed);
				
					tween.animate('x', destination.x);
					tween.animate('z', destination.z);
					
					tween.onComplete = nextPoint;
					tween.onUpdate   = object.updateScreenPosition;
					
				Starling.juggler.add(tween);
				
				_pool.put(destination);
			} else {
				_moving = false;
				_route  = null;
				
				dispatchEventWith(MOVE_COMPLETE, false, object);
			}
		};
	};
}