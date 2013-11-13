package {
	import com.thenitro.niso.samples.LuftUsageSample;
	import com.thenitro.niso.samples.ObjectsCreationSample;
	import com.thenitro.niso.samples.TiledEditorDemo;
	
	import ngine.display.DocumentClass;
	
	[SWF(frameRate="60", backgroundColor="#FFFFFF")]
	public class NisoDefaultSamples extends DocumentClass {
		
		public function NisoDefaultSamples() {
			//super(ObjectsCreationSample, true);
			//super(LuftUsageSample, true);
			  super(TiledEditorDemo, true);
		};
	};
}