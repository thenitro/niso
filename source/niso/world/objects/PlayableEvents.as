package niso.world.objects {
    public class PlayableEvents {
        public static const COMPLETE:String = 'playable_event_complete';

        public function PlayableEvents() {
            throw new Error('PlayableEvents is static!');
        };
    }
}
