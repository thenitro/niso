package niso.world.objects.builtin.processing {
    import flash.events.TimerEvent;
    import flash.utils.Timer;

    import niso.world.objects.builtin.processing.bubbles.AbstractBubble;
    import niso.world.objects.builtin.processing.bubbles.IconBubble;
    import niso.world.objects.builtin.processing.bubbles.ProgressbarBubble;

    import npooling.IReusable;
    import npooling.Pool;

    import starling.events.EventDispatcher;

    public class ProcessingState extends EventDispatcher implements IReusable {
        public static const START:String    = 'start_event';
        public static const STOP:String     = 'stop_event';
        public static const PROGRESS:String = 'progress_event';

        private static const BUBBLES:Object = {
            'icon': IconBubble,
            'progress': ProgressbarBubble
        };

        private static var _pool:Pool = Pool.getInstance();

        private var _disposed:Boolean;

        private var _sequenceID:String;

        private var _bubbleID:String;
        private var _bubbleIconID:String;

        private var _next:String;

        private var _timer:Timer;
        private var _getTime:Function;

        private var _startTime:Number;
        private var _time:Number;

        public function ProcessingState() {
        };

        public function get reflection():Class {
            return ProcessingState;
        };

        public function get disposed():Boolean {
            return _disposed;
        };

        public function get sequenceID():String {
            return _sequenceID;
        };

        public function get bubbleIconID():String {
            return _bubbleIconID;
        };

        public function get nextState():String {
            return _next;
        };

        public function get time():Number {
            return _time * 1000;
        };

        public function init(pSequenceID:String, pNextState:String,
                             pBubbleID:String = null,
                             pBubbleIconID:String = null, pTime:int = -1):void {
            _sequenceID = pSequenceID;

            _bubbleID     = pBubbleID;
            _bubbleIconID = pBubbleIconID;

            _next = pNextState;
            _time = pTime;
        };

        public function createBubble():AbstractBubble {
            var currentClass:Class = BUBBLES[_bubbleID] as Class;

            var bubble:AbstractBubble = _pool.get(currentClass) as AbstractBubble;

            if (!bubble) {
                bubble = new currentClass();
                _pool.allocate(currentClass, 1);
            }

            return bubble;
        };

        public function start(pStartTime:Number, pGetTime:Function):void {
            _startTime = pStartTime;
            _getTime   = pGetTime;

            dispatchEventWith(START);
            startTimer();
        };

        public function stop():void {
            dispatchEventWith(STOP);
        };

        public function poolPrepare():void {
            stopTimer();

            _sequenceID = null;

            _bubbleID = null;
            _bubbleIconID = null;
        };

        public function dispose():void {
            poolPrepare();

            _disposed = true;
        };

        private function startTimer():void {
            if (_time == -1) {
                return;
            }

            var timerTime:Number;

            if (_startTime == -1) {
                 timerTime = time;
                _startTime = _getTime();
            } else {
                timerTime = _getTime() - _startTime;
            }

            _timer = new Timer(1000, timerTime / 1000);
            _timer.addEventListener(TimerEvent.TIMER, timerEventHandler);
            _timer.addEventListener(TimerEvent.TIMER_COMPLETE,
                                    timerCompleteEventHandler);
            _timer.start();
        };

        private function stopTimer():void {
            if (!_timer) {
                return;
            }

            _timer.removeEventListener(TimerEvent.TIMER, timerEventHandler);
            _timer.removeEventListener(TimerEvent.TIMER_COMPLETE,
                                       timerCompleteEventHandler);
            _timer.stop();
            _timer = null;
        };

        private function timerEventHandler(pEvent:TimerEvent):void {
            trace('ProcessingState.timerEventHandler:', _getTime(), _startTime);
            trace('ProcessingState.timerEventHandler:', time, _getTime() - _startTime);
            trace('ProcessingState.timerEventHandler:', (_getTime() - _startTime) / time);

            dispatchEventWith(PROGRESS, false, (_getTime() - _startTime) / time);
        };

        private function timerCompleteEventHandler(pEvent:TimerEvent):void {
            stopTimer();
            stop();
        };
    }
}