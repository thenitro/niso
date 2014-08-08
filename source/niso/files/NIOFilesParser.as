package niso.files {
    import ngine.files.TFile;

    import starling.events.Event;
    import starling.events.EventDispatcher;

    public class NIOFilesParser extends EventDispatcher {
        private var _files:Vector.<TFile>;
        private var _loading:Vector.<NIOFormat>;

        public function NIOFilesParser() {
            super();

            _files = new Vector.<TFile>();
            _loading = new Vector.<NIOFormat>();
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

            _files.length = 0;
        };

        private function parsingCompletedEventHandler(pEvent:Event):void {
            var target:NIOFormat = pEvent.target as NIOFormat;

            _loading.splice(_loading.indexOf(target), 1);

            if (!_loading.length) {
                dispatchEventWith(Event.COMPLETE);
            }
        };
    };
}
