package niso.world.controllers {
    import flash.geom.Point;

    import niso.world.IsometricWorld;
    import niso.world.layers.IsometricLayer;
    import niso.world.objects.IsometricDisplayObject;

    import nthread.Threader;

    import starling.display.Stage;

    public class IsometricCulling {
        private var _world:IsometricWorld;
        private var _stage:Stage;
        private var _cullingOffset:Number;

        private var _threader:Threader;

        public function IsometricCulling(pWorld:IsometricWorld, pStage:Stage,
                                         pCullingOffset:Number) {
            _world         = pWorld;
            _stage         = pStage;
            _cullingOffset = pCullingOffset;

            _threader = new Threader();
            _threader.init(100, 10000);
        };

        public function update():void {
            _threader.purge();

            var layer:IsometricLayer = _world.getLayerByID(1);

            for each (var object:IsometricDisplayObject in layer.objects) {
                _threader.addThread(checkVisibility, [ object ] );
            }
        };

        private function checkVisibility(pObject:IsometricDisplayObject):void {
            if (isInViewport(pObject)) {
                pObject.visible = true;
            } else {
                pObject.visible = false;
            }
        };

        private function isInViewport(pObject:IsometricDisplayObject):Boolean {
            if (!pObject.view) {
                return false;
            }

            if (leftPointOnScreen(pObject) || rightPointOnScreen(pObject)) {
                return true;
            }

            return false;
        };

        private function leftPointOnScreen(pObject:IsometricDisplayObject):Boolean {
            var point:Point = pObject.view.localToGlobal(new Point(-pObject.view.width / 2, -pObject.view.height / 2));

            if (isPointOnScreen(point)) {
                return true;
            }

            return false;
        };

        private function rightPointOnScreen(pObject:IsometricDisplayObject):Boolean {
            var point:Point  = new Point(pObject.view.width / 2, pObject.view.height / 2);
            var result:Point = pObject.view.localToGlobal(point);

            if (isPointOnScreen(result)) {
                return true;
            }

            return false;
        };

        private function isPointOnScreen(pPoint:Point):Boolean {
            if (!pPoint) {
                return false;
            }

            if ((pPoint.x > -_cullingOffset && pPoint.y > -_cullingOffset) &&
                    (pPoint.x < _stage.stageWidth + _cullingOffset &&
                            pPoint.y < _stage.stageHeight + _cullingOffset)) {
                return true;
            }

            return false;
        };
    }
}
