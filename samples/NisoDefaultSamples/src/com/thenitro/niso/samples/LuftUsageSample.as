package com.thenitro.niso.samples {
	import com.thenitro.isometric.geom.IsometricGeometry;
	import com.thenitro.isometric.world.IsometricWorld;
	import com.thenitro.isometric.world.layers.IsometricLayer;
	import com.thenitro.isometric.world.layers.IsometricLayerSortingType;
	import com.thenitro.isometric.world.objects.IsometricSprite;
	import com.thenitro.ngine.textures.SpriteSheetCutter;
	
	import flash.display.Bitmap;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public final class LuftUsageSample extends Sprite {
		[Embed(source="iso-64x64-outside.png", mimeType="image/png")]
		private static const DefaultSpriteSheet:Class;
		
		private static const TILE_SIZE:uint = 32;
		
		public function LuftUsageSample() {
			super();
			addEventListener(Event.ADDED_TO_STAGE, addedToStageEventHandler);
		};
		
		private function addedToStageEventHandler(pEvent:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageEventHandler);
			
			var sprites:SpriteSheetCutter = new SpriteSheetCutter( 
				(new DefaultSpriteSheet() as Bitmap).bitmapData, 64, 64);
			
			var geom:IsometricGeometry = new IsometricGeometry();
				geom.setTileSize(TILE_SIZE);
				
			//When you want add some luft its important to save an order in id's numeration
			//each id is multiplier for offsets
			var layer:IsometricLayer = new IsometricLayer();
				layer.init(0, true, IsometricLayerSortingType.ALWAYS);
				
			var layer1:IsometricLayer = new IsometricLayer();
				layer1.init(1, true, IsometricLayerSortingType.ALWAYS);
				
			var layer2:IsometricLayer = new IsometricLayer();
				layer2.init(2, true, IsometricLayerSortingType.ALWAYS);
				
			var layer3:IsometricLayer = new IsometricLayer();
				layer3.init(3, true, IsometricLayerSortingType.ALWAYS);
				
			var world:IsometricWorld = new IsometricWorld();
				world.setGeometry(geom);
				
				//add all layers to world
				world.addLayer(layer);
				world.addLayer(layer1);
				world.addLayer(layer2);
				world.addLayer(layer3);
				
			addChild(world.canvas);
				
			var i:int;
			var j:int;
			
			var object:IsometricSprite;
			
			for (i = 0; i < 10; i++) {
				for (j = 0; j < 10; j++) {
					object = new IsometricSprite();
					
					object.x = i * geom.tileSize;
					object.z = j * geom.tileSize;
					
					object.setTexture(sprites.getByIndex(int(Math.random() * 3),
														 int(Math.random() * 3)));
					
					world.addObject(layer.id, object);
				}
			}
			
			//Create first object
			object = new IsometricSprite();
			
			//Set position to tile size luft offset's layers
			//lets place it in center
			object.x = geom.tileSize * 5;
			object.z = geom.tileSize * 5;
			
			object.setTexture(sprites.getByIndex(6, 0));
			
			world.addObject(layer1.id, object);
			
			//create second object
			object = new IsometricSprite();
			
			//With same position!
			object.x = geom.tileSize * 5;
			object.z = geom.tileSize * 5;
			
			object.setTexture(sprites.getByIndex(6, 0));
			
			//and add it to second layer
			world.addObject(layer2.id, object);
			
			//create third object
			object = new IsometricSprite();
			
			//With same position!
			object.x = geom.tileSize * 5;
			object.z = geom.tileSize * 5;
			
			//Lets change texture
			object.setTexture(sprites.getByIndex(6, 5));
			
			//and add it to third layer
			world.addObject(layer3.id, object);
			
			//amazing! =)
			
			world.relocate();
		};
	};
}