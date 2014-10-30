package niso.world.objects.builtin {
    import niso.world.objects.IsometricDisplayObject;
    import niso.world.objects.abstract.IInteractable;
    import niso.world.objects.abstract.IPlayable;
    import niso.world.objects.builtin.processing.*;
    import niso.world.objects.builtin.processing.bubbles.AbstractBubble;

    import starling.events.Event;

    public class Building extends Interactable implements IInteractable {
        private var _object:IPlayable;
        private var _bubble:AbstractBubble;

        private var _states:Object;
        private var _currentState:ProcessingState;

        private var _startingStateID:String;
        private var _stateTimeLeft:Number;

        private var _getTime:Function;

        public function Building() {
            super();
        };

        override public function get reflection():Class {
            return Building;
        };

        public function get currentState():ProcessingState {
            return _currentState;
        };

        override public function setObject(pObject:IsometricDisplayObject):void {
            _object = pObject as IPlayable;

            if (!_object) {
                throw new ArgumentError('Building.setObject: object must be IPlayable, but not ' + pObject);
            }

            super.setObject(pObject);
            startState(_startingStateID, _stateTimeLeft);
        };

        override public function poolPrepare():void {
            clean();
            super.poolPrepare();
        };

        override public function dispose():void {
            clean();
            super.dispose();
        };

        public function setStates(pStates:Object, pStartingStateID:String,
                                  pGetTime:Function, pStateTimeLeft:Number = -1):void {
            _states          = pStates;
            _startingStateID = pStartingStateID;
            _getTime         = pGetTime;
            _stateTimeLeft   = pStateTimeLeft;
        };

        public function startState(pStateID:String, pStateStartTime:Number):void {
            _currentState = _states[pStateID] as ProcessingState;
            _currentState.addEventListener(ProcessingState.START,
                                           buildingStateStartEventHandler);
            _currentState.addEventListener(ProcessingState.STOP,
                                           buildingStateStopEventHandler);
            _currentState.start(pStateStartTime, _getTime);
        };

        public function forceStopState():void {
            if (!_currentState) {
                return;
            }

            removeBubble();

            _currentState.removeEventListener(ProcessingState.START,
                                              buildingStateStartEventHandler);
            _currentState.removeEventListener(ProcessingState.STOP,
                                              buildingStateStopEventHandler);
            _currentState.stop();
            _currentState = null;
        };

        override public function interact():void {
            if (_currentState.time == -1) {
                _currentState.stop();
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
            if (!_object || !_bubble) {
                return;
            }

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
            startState(state.nextState, -1);
        };
    };
}
