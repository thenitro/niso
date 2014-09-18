package niso.world.objects.builtin {
    import niso.world.objects.IsometricDisplayObject;
    import niso.world.objects.abstract.IPlayable;
    import niso.world.objects.builtin.processing.*;
    import niso.world.objects.builtin.processing.bubbles.AbstractBubble;

    import starling.events.Event;

    public class Building extends Obstacle {
        private var _object:IPlayable;
        private var _bubble:AbstractBubble;

        private var _states:Vector.<ProcessingState>;
        private var _currentState:ProcessingState;

        public function Building() {
            super();
        };

        override public function get reflection():Class {
            return Obstacle;
        };

        override public function setObject(pObject:IsometricDisplayObject):void {
            _object = pObject as IPlayable;

            if (!_object) {
                throw new ArgumentError('Building.setObject: object must be IPlayable, but not ' + pObject);
            }

            super.setObject(pObject);

            //TODO: remove stub
            startState(_states[0]);
        };

        override public function poolPrepare():void {
            clean();
            super.poolPrepare();
        };

        override public function dispose():void {
            clean();
            super.dispose();
        };

        public function setStates(pStates:Vector.<ProcessingState>):void {
            _states = pStates;
        };

        public function startState(pState:ProcessingState):void {
            _currentState = pState;
            _currentState.addEventListener(ProcessingState.START,
                                           buildingStateStartEventHandler);
            _currentState.addEventListener(ProcessingState.STOP,
                                           buildingStateStopEventHandler);
            _currentState.start();
        };

        public function interact():void {
            if (_currentState.time == -1) {
                _currentState.stop();

                startState(_states[_currentState.nextState]);
            }
        };

        private function applyState(pState:ProcessingState):void {
            _bubble = _object.view.addChild(pState.createBubble()) as AbstractBubble;
            _bubble.update(pState);

            _object.gotoAndPlay(pState.sequenceID);
        };

        private function clean():void {
            _object = null;
            _currentState = null;

            for each (var state:ProcessingState in _states) {
                _pool.put(state);
            }

            _states = null;

            removeBubble();
        };

        private function removeBubble():void {
            _object.view.removeChild(_bubble);
            _pool.put(_bubble);

            _bubble = null;
        };

        private function buildingStateStartEventHandler(pEvent:Event):void {
            var state:ProcessingState = pEvent.target as ProcessingState;
                state.removeEventListener(ProcessingState.START,
                                          buildingStateStartEventHandler);

            applyState(pEvent.target as ProcessingState);
        };

        private function buildingStateStopEventHandler(pEvent:Event):void {
            var state:ProcessingState = pEvent.target as ProcessingState;
                state.removeEventListener(ProcessingState.STOP,
                                          buildingStateStopEventHandler);

            removeBubble();

            trace('Building.buildingStateStopEventHandler:', _bubble, _object.view.numChildren, _object.view.height);

            startState(_states[state.nextState]);

            trace('Building.buildingStateStopEventHandler:', _bubble);
        };
    };
}
