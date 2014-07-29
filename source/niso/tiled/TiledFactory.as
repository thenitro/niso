package niso.tiled {
    import flash.utils.getDefinitionByName;

    import niso.world.objects.IsometricBehavior;
    import niso.world.objects.IsometricSprite;

    import npooling.Pool;

    public class TiledFactory {
        protected static var _pool:Pool = Pool.getInstance();

        public function TiledFactory() {

        };

        public function createTile(pTileAbstract:Object,
                                   pLoader:TiledLoader):IsometricSprite {
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

            if (String(pObjectAbstract.@type).length) {
                var currentClass:Class         = getDefinitionByName(pObjectAbstract.@type) as Class;
                var instance:IsometricBehavior = _pool.get(currentClass) as IsometricBehavior;

                if (!instance) {
                    instance = new currentClass();
                    _pool.allocate(currentClass, 1);
                }

                object.setBehavior(instance);
            }

            return object;
        };
    };
}
