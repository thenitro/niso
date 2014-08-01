package niso.tiled {
    import flash.utils.getDefinitionByName;

    import niso.world.IsometricWorld;

    import niso.world.objects.IsometricBehavior;
    import niso.world.objects.IsometricSprite;

    import npooling.Pool;

    public class TiledFactory {
        protected static var _pool:Pool = Pool.getInstance();

        protected var _world:IsometricWorld;

        public function TiledFactory() {

        };

        public function setWorld(pWorld:IsometricWorld):void {
            _world = pWorld;
        };

        public function initMap(pSizeX:int, pSizeY:int):void {

        };

        public function createTile(pTileAbstract:Object):IsometricSprite {
            var object:IsometricSprite = _pool.get(IsometricSprite) as IsometricSprite;

            if (!object) {
                object = new IsometricSprite();
                _pool.allocate(IsometricSprite, 1);
            }

            return object;
        };

        public function createObject(pObjectAbstract:XML):IsometricSprite {
            var object:IsometricSprite = _pool.get(IsometricSprite) as IsometricSprite;

            if (!object) {
                object = new IsometricSprite();
                _pool.allocate(IsometricSprite, 1);
            }

            return object;
        };

        public function createBehaviour(pObjectAbstract:XML,
                                        pObject:IsometricSprite):IsometricBehavior {
            if (!String(pObjectAbstract.@type).length) {
                return null;
            }

            var currentClass:Class         = getDefinitionByName(pObjectAbstract.@type) as Class;
            var instance:IsometricBehavior = _pool.get(currentClass) as IsometricBehavior;

            if (!instance) {
                instance = new currentClass();
                _pool.allocate(currentClass, 1);
            }

            pObject.setBehavior(instance);

            return instance;
        };
    };
}
