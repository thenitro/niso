package niso.world.objects.builtin {
    import com.thenitro.ngine.particles.abstract.emitters.ParticlesEmitter;
    import com.thenitro.ngine.particles.abstract.emitters.position.RectangleParticles;
    import com.thenitro.ngine.particles.abstract.loader.EmitterParametersLoader;
    import com.thenitro.ngine.particles.abstract.particles.ImageParticle;

    import flash.utils.ByteArray;

    import ngine.files.Library;
    import ngine.files.TFile;

    import niso.world.objects.IsometricBehavior;
    import niso.world.objects.IsometricDisplayObject;

    import nmath.vectors.Vector2D;

    import starling.display.Sprite;
    import starling.events.EnterFrameEvent;
    import starling.events.Event;
    import starling.textures.Texture;

    public class IsometricParticles extends IsometricBehavior {
        private static var _library:Library = Library.getInstance();
        private static var _loader:EmitterParametersLoader = new EmitterParametersLoader();

        public var particleFile:String;
        public var particleTexture:String;

        private var _emitter:ParticlesEmitter;

        public function IsometricParticles() {
            super();
        };

        override public function get reflection():Class {
            return IsometricParticles;
        };

        override public function set visible(pValue:Boolean):void {
            super.visible = pValue;

            if (pValue) {
                object.view.addEventListener(Event.ENTER_FRAME, enterFrameEventHandler);
            } else {
                object.view.removeEventListener(Event.ENTER_FRAME, enterFrameEventHandler);
            }
        };

        override public function setObject(pObject:IsometricDisplayObject):void {
            super.setObject(pObject);

            var file:TFile = _library.get(particleFile);

            if (!file) {
                throw new ArgumentError('Illegal particle file!');
                return;
            }

            _emitter = ParticlesEmitter.NEW;

            _emitter.ParticleClass = ImageParticle;
            _emitter.particleData  = _library.get(particleTexture).content as Texture;

            var particlePosition:RectangleParticles = RectangleParticles.NEW;
                particlePosition.init(_emitter, new Vector2D(0, 0));

            _emitter.particlesPosition = particlePosition;

            (pObject.view as Sprite).addChild(_emitter.canvas);

            var ba:ByteArray = new ByteArray();
                ba.writeBytes(file.content as ByteArray);

            _loader.loadBytes(ba, _emitter);

            ba.clear();
        };

        override public function poolPrepare():void {
            object.view.removeEventListener(Event.ENTER_FRAME, enterFrameEventHandler);

            particleFile    = null;
            particleTexture = null;

            _pool.put(_emitter);

            super.poolPrepare();
        };

        private function enterFrameEventHandler(pEvent:EnterFrameEvent):void {
            _emitter.update(pEvent.passedTime);
        };
    };
}
