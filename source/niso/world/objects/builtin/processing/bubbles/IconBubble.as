package niso.world.objects.builtin.processing.bubbles {
    import niso.world.objects.builtin.processing.*;

    import starling.display.Image;
    import starling.textures.Texture;

    public class IconBubble extends AbstractBubble {

        public function IconBubble() {
            super();
        };

        override public function get reflection():Class {
            return IconBubble;
        };

        override public function update(pState:ProcessingState):void {
            removeChildren(0, -1, true);

            x = 0;
            y = 0;

            var texture:Texture = _library.getByID(pState.bubbleIconID).content as Texture;

            var icon:Image = new Image(texture);
                icon.pivotX = texture.width  / 2;

            addChild(icon);

            x =  0;
            y = -((parent.pivotY + parent.height / 2) + texture.height * 2);
        };

        override public function dispose():void {
            removeChildren(0, -1, true);
            super.dispose();
        };

        override public function poolPrepare():void {
            removeChildren(0, -1, true);
        };
    };
}
