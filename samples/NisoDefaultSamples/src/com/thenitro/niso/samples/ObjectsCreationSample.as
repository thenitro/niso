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
	
	public final class ObjectsCreationSample extends Sprite {
		[Embed(source="iso-64x64-outside.png", mimeType="image/png")]
		private static const DefaultSpriteSheet:Class;
		
		private static const TILE_SIZE:uint = 32;
		
		public function ObjectsCreationSample() {
			super();
			addEventListener(Event.ADDED_TO_STAGE, addedToStageEventHandler);
		};
		
		private function addedToStageEventHandler(pEvent:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageEventHandler);
			
			//Lets take some material to work with
			var sprites:SpriteSheetCutter = new SpriteSheetCutter( 
				(new DefaultSpriteSheet() as Bitmap).bitmapData, 64, 64);
			
			//Create an geometry and set tile size of tile (height)
			var geom:IsometricGeometry = new IsometricGeometry();
				geom.setTileSize(TILE_SIZE);
				
			/** Create layer: and set sort type 
			 *				ON_DEMAND - manualy sort when you need it	
			 *				ON_CHANGE - sort when you add or remove element to layer
			 *				ALWAY     - sort on enterframe
			 */
			var layer:IsometricLayer = new IsometricLayer();
				layer.init(0, false, IsometricLayerSortingType.ON_DEMAND);
				
			//Create world and set geometry and add layer for it	
			var world:IsometricWorld = new IsometricWorld();
				world.setGeometry(geom);
				world.addLayer(layer);
			
			addChild(world.canvas);
				
			var i:int;
			var j:int;
			
			var object:IsometricSprite;
			
			//Creating objects
			for (i = 0; i < 10; i++) {
				for (j = 0; j < 10; j++) {
					object = new IsometricSprite();
					
					object.x = i * geom.tileSize;
					object.z = j * geom.tileSize;
					//Take textures from sprite sheet from 0 to 3 in horizontal and vertical
					object.setTexture(sprites.getByIndex(int(Math.random() * 3), 
														 int(Math.random() * 3)));
						
					world.addObject(0, object);
				}
			}
			
			//And sort layer after adding items to it
			layer.sort();
			
			//Nice to have few layers: one for terrain and one for objects, lets create it with sorting type on change
			var layer2:IsometricLayer = new IsometricLayer();
				layer2.init(1, false, IsometricLayerSortingType.ON_CHANGE);
				
			world.addLayer(layer2);
			
			//Create some mountains randomly
			for (i = 0; i < 5; i++) {
				for (j = 0; j < 5; j++) {
					object = new IsometricSprite();
					
					object.x = i * geom.tileSize;
					object.z = j * geom.tileSize;
					
					object.setTexture(sprites.getByIndex(5, int(Math.random() * 9)));
					
					world.addObject(1, object)
				}
			}
			
			//Place world in center of screen
			world.relocate();
		};
	};
}