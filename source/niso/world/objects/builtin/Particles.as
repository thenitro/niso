package niso.world.objects.builtin {
    import com.thenitro.ngine.particles.abstract.emitters.ParticlesEmitter;
    import com.thenitro.ngine.particles.abstract.emitters.position.ParticlesPosition;
    import com.thenitro.ngine.particles.abstract.emitters.position.PointParticles;
    import com.thenitro.ngine.particles.abstract.emitters.position.RectangleParticles;
    import com.thenitro.ngine.particles.abstract.loader.EmitterParametersLoader;
    import com.thenitro.ngine.particles.abstract.particles.ImageParticle;

    import flash.display.BitmapData;

    import flash.utils.ByteArray;

    import ngine.files.Library;
    import ngine.files.TFile;

    import niso.world.objects.IsometricBehavior;
    import niso.world.objects.IsometricDisplayObject;

    import nmath.vectors.Vector2D;

    import starling.core.Starling;
    import starling.display.BlendMode;
    import starling.display.Sprite;
    import starling.events.EnterFrameEvent;
    import starling.events.Event;
    import starling.textures.Texture;

    public class Particles extends IsometricBehavior {
        private static var _library:Library = Library.getInstance();

        public var particleFile:String;
        public var particleTexture:String;

        private var _emitter:ParticlesEmitter;

        public function Particles() {
            super();
        };

        public function init(pFileID:String, pTextureID:String):void {

        };

        override public function setObject(pObject:IsometricDisplayObject):void {
            super.setObject(pObject);

            var file:TFile = _library.getByID(particleFile);

            if (!file) {
                return;
            }

            _emitter = new ParticlesEmitter();

            _emitter.ParticleClass = ImageParticle;
            _emitter.particleData  = _library.getByID(particleTexture).content as Texture;

            var particlePosition:RectangleParticles = new RectangleParticles();
                particlePosition.init(_emitter, new Vector2D(20, 20));

            _emitter.particlesPosition = particlePosition;

            (pObject.view as Sprite).addChild(_emitter.canvas);

            var ba:ByteArray = new ByteArray();
                ba.writeBytes(file.content as ByteArray);

            var loader:EmitterParametersLoader = new EmitterParametersLoader();
                loader.loadBytes(ba, _emitter);

            _emitter.blendMode = BlendMode.MULTIPLY;

            ba.clear();

            pObject.view.addEventListener(Event.ENTER_FRAME, enterFrameEventHandler);
        };

        private function enterFrameEventHandler(pEvent:EnterFrameEvent):void {
            _emitter.update(pEvent.passedTime);
        };
    };
}
