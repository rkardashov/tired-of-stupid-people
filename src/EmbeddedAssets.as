package 
{
	import flash.text.Font;
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class EmbeddedAssets 
	{
		[Embed(source = "../assets/textures/atlas_0.png")]
		static public const atlas_0: Class;
		[Embed(source = "../assets/textures/atlas_0.xml", mimeType="application/octet-stream")]
		static public const atlas_0_xml: Class;
		
		[Embed(source = "../assets/textures/atlas_1.png")]
		static public const atlas_1: Class;
		[Embed(source = "../assets/textures/atlas_1.xml", mimeType="application/octet-stream")]
		static public const atlas_1_xml: Class;
		
		[Embed(source = "../assets/textures/atlas_2.png")]
		static public const atlas_2: Class;
		[Embed(source = "../assets/textures/atlas_2.xml", mimeType="application/octet-stream")]
		static public const atlas_2_xml: Class;
		
		/*[Embed(source = "../assets/libgdx atlas/atlas.png")]
		static public const atlas: Class;
		[Embed(source = "../assets/libgdx atlas/atlas.xml", mimeType="application/octet-stream")]
		static public const atlas_xml: Class;
		*/
		[Embed(source = "../assets/sounds/music_bg.mp3")]
		static public const music_bg: Class;
		
		[Embed(source = "../assets/sounds/music_bg_muffle.mp3")]
		static public const music_bg_muffle: Class;
		
		[Embed(source = "../assets/sounds/sound_toggle.mp3")]
		static public const sound_toggle: Class;
		
		[Embed(source = "../assets/sounds/start.mp3")]
		static public const start: Class;
		
		[Embed(source = "../assets/sounds/hit.mp3")]
		static public const hit: Class;
		
		[Embed(source = "../assets/sounds/litter.mp3")]
		static public const litter: Class;
		
		[Embed(source = "../assets/sounds/pick_trash.mp3")]
		static public const pick_trash: Class;
		
		[Embed(source = "../assets/sounds/pause_1.mp3")]
		static public const pause_1: Class;
		[Embed(source = "../assets/sounds/pause_2.mp3")]
		static public const pause_2: Class;
		[Embed(source = "../assets/sounds/pause_3.mp3")]
		static public const pause_3: Class;
		
		[Embed(source = "../assets/sounds/car_start.mp3")]
		static public const car_start: Class;
		[Embed(source = "../assets/sounds/car_arrive.mp3")]
		static public const car_arrive: Class;
		[Embed(source = "../assets/sounds/car_depart.mp3")]
		static public const car_depart: Class;
		[Embed(source = "../assets/sounds/car_wait.mp3")]
		static public const car_wait: Class;
		
		[Embed(source = "../assets/fonts/tired.otf",
			fontName = "animalmusic",
			mimeType = "application/x-font",
			advancedAntiAliasing = "true",
			embedAsCFF="false")]
		static public const tired: Class;
		static public var font_tired: Font;
		
		// Font
		//headerFont = new fontMergeBold;
		
		//labelBarText = new TextField(200, 30, "Start", headerFont.fontName, 30, 0xFFFFFF);
		
		public function EmbeddedAssets() 
		{
			
		}
	}
}