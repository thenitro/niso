package niso.world.layers {
	
	public class IsometricLayerSortingType {
		public static const ON_DEMAND:uint = 0;
		public static const ON_CHANGE:uint = 1;
		public static const ALWAYS:uint    = 2;
		
		public function IsometricLayerSortingType() {
			throw new Error("IsometricLayerSortingType: class is static!");
		};
	};
}