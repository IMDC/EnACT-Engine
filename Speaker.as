package  {
	import flash.text.TextFormat;
	
	public class Speaker {
		public static var BACKGROUND_ALPHA_MIN:Number = 0; ;// Transparent
		public static var BACKGROUND_ALPHA_MAX:Number = 100; ;// Opaque
		
		public static var FONT_SIZE_MIN:Number = 9;
		public static var FONT_SIZE_MAX:Number = 48;
		
		private var speaker:String;
		
		private var backgroundVisibility:Boolean;
		private var backgroundAlpha:Number;
		private var backgroundColour:Number;
		
		private var caption_fmt:TextFormat;
		
		/*
		 * Sets speaker properties (font, background, name, alpha)
		 * 
		 * @param speakerName						String
		 * @param backgroundParams					Object
		 * @param fontParams						Object
		 */
		public function Speaker(speakerName:String, backgroundParams:Object, fontParams:Object) {
			this.speaker = speakerName;
			
			// Background
			this.backgroundVisibility = Settings.stringToBoolean (backgroundParams.visible);
	
			backgroundParams.alpha = Math.max (backgroundParams.alpha, BACKGROUND_ALPHA_MIN);
			backgroundParams.alpha = Math.min (backgroundParams.alpha, BACKGROUND_ALPHA_MAX);
			this.backgroundAlpha = backgroundParams.alpha;
			
			this.backgroundColour = parseInt (backgroundParams.colour, 16);
			
			// Font
			this.caption_fmt = new TextFormat ();
			this.caption_fmt.font = fontParams.name;
	
			// Font Size
			var fontSize:Number = Number (fontParams.size);
			fontSize = Math.max (fontSize, FONT_SIZE_MIN);
			fontSize = Math.min (fontSize, FONT_SIZE_MAX);
	
			// Sets font properties
			this.caption_fmt.size = fontSize;
			this.caption_fmt.color = Number (fontParams.colour);
			this.caption_fmt.bold = Settings.stringToBoolean (fontParams.bold);
		}
		
		//*************************************************
		
		/*
		 * Returns speaker name (of caption)
		 * @return speaker								String
		 */
		public function getSpeaker ():String {
			return this.speaker;
		}
		/*
		 * Returns background visibility boolean value
		 * @return backgroundVisibility					Boolean
		 */
		public function getBackgroundVisibility ():Boolean {
			return this.backgroundVisibility;
		}
		/*
		 * Returns alpha numeric value
		 * @return backgroundAlpha						Number
		 */
		public function getBackgroundAlpha ():Number {
			return this.backgroundAlpha;
		}
		/*
		 * Returns background colour
		 * @return backgroundColour						Number
		 */
		public function getBackgroundColour ():Number {
			return this.backgroundColour;
		}
		/*
		 * Returns text format (font size, font type, font colour)
		 * @return caption_fmt							TextFormat
		 */
		public function getTextFormat ():TextFormat {
			return this.caption_fmt;
		}
		
	} // SPEAKER CLASS
} // PACKAGE
