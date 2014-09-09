package niso.world.controllers {
    import niso.world.IsometricWorld;

    import starling.events.Event;
    import starling.events.EventDispatcher;

    public class IsometricCamera extends EventDispatcher {
        private var _world:IsometricWorld;
        private var _culling:IsometricCulling;

        public function IsometricCamera() {
            super();
        };

        public function init(pWorld:IsometricWorld, pCulling:IsometricCulling):void {
            _culling = pCulling;

            _world = pWorld;
            _world.addEventListener(IsometricWorld.POSITION_UPDATE,
                                    worldPositionUpdateEventHandler);
        };

        public function start():void {
            _culling.start();
        };

        public function stop():void {
            _culling.stop();
        };

        private function worldPositionUpdateEventHandler(pEvent:Event):void {
            _culling.update();
        };
    };
}
