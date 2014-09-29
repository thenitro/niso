package niso.world.objects.builtin.processing.bubbles {
    import flash.geom.Rectangle;

    import niso.world.objects.builtin.processing.ProcessingState;

    import starling.display.Image;
    import starling.display.Sprite;

    import starling.events.Event;
    import starling.textures.Texture;

    public class ProgressbarBubble extends AbstractBubble {
        private var _background:Image;
        private var _foreground:Sprite;

        public function ProgressbarBubble() {
            super();
            addEventListener(Event.ADDED_TO_STAGE, addedToStageEventHandler);
        };

        override public function get reflection():Class {
            return ProgressbarBubble;
        };

        override public function update(pState:ProcessingState):void {
            x = 0;
            y = 0;

            pState.addEventListener(ProcessingState.PROGRESS,
                                    stateProgressEventHandler);
            pState.addEventListener(ProcessingState.STOP,
                                    buildingStateStopEventHandler);

            pivotX = _background.width / 2;

            x =  0;
            y = -((parent.pivotY + parent.height / 2) + _background.height * 2);
        };

        override public function dispose():void {
            removeChild(_background, true);
            removeChild(_foreground, true);

            _background = null;
            _foreground = null;
        };

        override public function poolPrepare():void {

        };

        private function addedToStageEventHandler(pEvent:Event):void {
            removeEventListener(Event.ADDED_TO_STAGE, addedToStageEventHandler);

            var backgroundTexture:Texture = _library.get('super_timer_back').content as Texture;
            var foregroundTexture:Texture = _library.get('super_timer').content as Texture;

            _background = addChild(new Image(backgroundTexture)) as Image;

            _foreground = addChild(new Sprite()) as Sprite;
            _foreground.addChild(new Image(foregroundTexture)) as Image;
        };

        private function stateProgressEventHandler(pEvent:Event):void {
            _foreground.clipRect = new Rectangle(0, 0,
                                                 _background.width * (pEvent.data as Number),
                                                 _background.height );
        };

        private function buildingStateStopEventHandler(pEvent:Event):void {
            var state:ProcessingState = pEvent.target as ProcessingState;
                state.removeEventListener(ProcessingState.PROGRESS,
                                          stateProgressEventHandler);
                state.removeEventListener(ProcessingState.STOP,
                                          buildingStateStopEventHandler);
        };
    }
}
