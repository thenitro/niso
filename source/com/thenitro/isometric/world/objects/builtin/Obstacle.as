package com.thenitro.isometric.world.objects.builtin {
	import com.thenitro.ngine.pathfinding.Pathfinder;
	import com.thenitro.isometric.world.objects.IsometricBehavior;
	import com.thenitro.isometric.world.objects.IsometricDisplayObject;
	
	public class Obstacle extends IsometricBehavior {
		private static var _pathfinder:Pathfinder = Pathfinder.getInstance();
		
		public function Obstacle() {
			super();
		};
		
		override public function setObject(pObject:IsometricDisplayObject):void {
			var indexX:uint = pObject.x / pObject.layer.world.geometry.tileSize;
			var indexZ:uint = pObject.z / pObject.layer.world.geometry.tileSize;
			
			trace("Obstacle.setObject(pObject)", indexX, indexZ);
			
			_pathfinder.setUnWalkable(indexX, indexZ);
		};
	};
}