package niso.world.objects.builtin {
	import niso.world.objects.IsometricBehavior;
	import niso.world.objects.IsometricDisplayObject;
	
	import ngine.pathfinding.Pathfinder;
	
	public class Obstacle extends IsometricBehavior {
		private static var _pathfinder:Pathfinder = Pathfinder.getInstance();
		
		public function Obstacle() {
			super();
		};
		
		override public function get reflection():Class {
			return Obstacle;
		};
		
		override public function setObject(pObject:IsometricDisplayObject):void {
			super.setObject(pObject);
			
			_pathfinder.setUnWalkable(pObject.indexX, pObject.indexZ);
		};
	};
}