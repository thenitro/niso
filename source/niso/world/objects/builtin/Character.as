package niso.world.objects.builtin {
    import niso.geom.Direction;
    import niso.geom.Directions;
    import niso.world.objects.IsometricBehavior;
    import niso.world.objects.IsometricDisplayObject;
    import niso.world.objects.IsometricMovieClip;

    import nmath.vectors.TVector3D;

    import npathfinding.base.Heuristic;
    import npathfinding.base.Node;
    import npathfinding.base.Pathfinder;

    import starling.animation.Tween;
    import starling.core.Starling;

    public class Character extends IsometricBehavior {
		public static const MOVE_COMPLETE:String = 'move_complete_event';

		public var moveHeuristric:Function = Heuristic.euclidean;
		public var moveSpeed:Number = 1;

        private static var _directions:Directions = Directions.getInstance();
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
			
			if (object.x == pDestinationX &&
				object.z == pDestinationZ) {
				dispatchEventWith(MOVE_COMPLETE, false, object);
				return;
			}

            _route = _pathfinder.findPath(object.x, object.z,
                                          pDestinationX, pDestinationZ,
                                          moveHeuristric);
			
			if (!_route || _route.length == 0) {
				dispatchEventWith(MOVE_COMPLETE, false, object);
				return;
			}

            _route.shift();
			
			_destinationX = pDestinationX;
			_destinationZ = pDestinationZ;

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

					destination.x = node.indexX;
					destination.z = node.indexY;

				var distance:Number = object.isometricPosition.distanceTo(destination);

                var direction:Direction = _directions.getDirection(object.isometricPosition, destination);

                (object as IsometricMovieClip).setTextures(direction.id + '_walk', direction.flip);

				var tween:Tween = new Tween(object, distance / moveSpeed);
				
					tween.animate('x', destination.x);
					tween.animate('z', destination.z);
					
					tween.onComplete = nextPoint;
					tween.onUpdate   = object.updateScreenPosition;
					
				Starling.juggler.add(tween);

				_pool.put(destination);
			} else {
				_moving = false;
				_route  = null;

                (object as IsometricMovieClip).setTextures('idle');
				
				dispatchEventWith(MOVE_COMPLETE, false, object);
			}
		};
	};
}