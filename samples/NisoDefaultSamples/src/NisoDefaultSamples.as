package {
	import com.thenitro.ngine.display.DocumentClass;
	import com.thenitro.niso.samples.LuftUsageSample;
	import com.thenitro.niso.samples.ObjectsCreationSample;
	import com.thenitro.niso.samples.TiledEditorDemo;
	
	import flash.display.Sprite;
	
	[SWF(frameRate="60")]
	public class NisoDefaultSamples extends DocumentClass {
		
		public function NisoDefaultSamples() {
			super(ObjectsCreationSample, true);
			//super(LuftUsageSample, true);
			//super(TiledEditorDemo, true);
		};
	};
}