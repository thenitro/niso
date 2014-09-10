package niso.files {
    import ngine.files.IProgressable;
    import ngine.files.TFile;

    import starling.events.Event;
    import starling.events.EventDispatcher;

    public class NIOFilesParser extends EventDispatcher implements IProgressable {
        public static const PROGRESS:String = 'nio_file_parser_progress';

        private var _files:Vector.<TFile>;
        private var _loading:Vector.<NIOFormat>;

        public function NIOFilesParser() {
            super();

            _files   = new Vector.<TFile>();
            _loading = new Vector.<NIOFormat>();
        };

        public function get description():String {
            return 'Parsing objects';
        };

        public function get progress():Number {
            return progressed / total;
        };

        public function get progressed():int {
            return total - _loading.length;
        };

        public function get total():int {
            return _files.length;
        };

        public function add(pFile:TFile):void {
            _files.push(pFile);
        };

        public function parse():void {
            for each (var file:TFile in _files) {
                var nio:NIOFormat = new NIOFormat();
                    nio.addEventListener(NIOFormat.PARSING_COMPLETED,
                                         parsingCompletedEventHandler);
                    nio.load(file);

                _loading.push(nio);
            }
        };

        private function parsingCompletedEventHandler(pEvent:Event):void {
            var target:NIOFormat = pEvent.target as NIOFormat;

            _loading.splice(_loading.indexOf(target), 1);

            dispatchEventWith(PROGRESS);

            if (!_loading.length) {
                _files.length = 0;

                dispatchEventWith(Event.COMPLETE);
            }
        };
    };
}
