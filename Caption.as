package  {
	public class Caption {
		public static var ALIGN_LEFT:String = "left";
		public static var ALIGN_CENTER:String = "center";
		public static var ALIGN_RIGHT:String = "right";
	
		// Location
		public static var LOCATION_TOP_LEFT:String = "TL";
		public static var LOCATION_TOP_CENTRE:String = "T";
		public static var LOCATION_TOP_RIGHT:String = "TR";
		public static var LOCATION_MIDDLE_LEFT:String = "L";
		public static var LOCATION_MIDDLE_CENTRE:String = "C";
		public static var LOCATION_MIDDLE_RIGHT:String = "R";
		public static var LOCATION_BOTTOM_LEFT:String = "BL";
		public static var LOCATION_BOTTOM_CENTRE:String = "B";
		public static var LOCATION_BOTTOM_RIGHT:String = "BR";
		
		private var begin:Number;
		private var end:Number;
		private var speaker:String;
		private var location:String;
		private var textAlign:String;
		private var text:String;
		private var emotions_array:Array;
		
		/*
		 * Sets location and alignment of captions; sets the begin, end, speaker, text attributes and emotions array. 
		 *
		 * @param captionparams			Object
		 * @param emotions_array		Array
		 */
		public function Caption(captionParams:Object, emotions_array:Array) {
			this.begin = captionParams.begin;
			this.end = captionParams.end;
			this.speaker = captionParams.speaker;
			
			// Sets location of captions
			switch (captionParams.location.toUpperCase ()) 
			{
				case LOCATION_TOP_LEFT :
				case "7" :
					this.location = LOCATION_TOP_LEFT;
					break;
				case LOCATION_TOP_CENTRE :
				case "8" :
					this.location = LOCATION_TOP_CENTRE;
					break;
				case LOCATION_TOP_RIGHT :
				case "9" :
					this.location = LOCATION_TOP_RIGHT;
					break;
				case LOCATION_MIDDLE_LEFT :
				case "4" :
					this.location = LOCATION_MIDDLE_LEFT;
					break;
				case LOCATION_MIDDLE_CENTRE :
				case "5" :
					this.location = LOCATION_MIDDLE_CENTRE;
					break;
				case LOCATION_MIDDLE_RIGHT :
				case "6" :
					this.location = LOCATION_MIDDLE_RIGHT;
					break;
				case LOCATION_BOTTOM_LEFT :
				case "1" :
					this.location = LOCATION_BOTTOM_LEFT;
					break;
				case LOCATION_BOTTOM_CENTRE :
				case "2" :
					this.location = LOCATION_BOTTOM_CENTRE;
					break;
				case LOCATION_BOTTOM_RIGHT :
				case "3" :
					this.location = LOCATION_BOTTOM_RIGHT;
					break;
				default :
					this.location = LOCATION_BOTTOM_CENTRE;
			} // LOCATION SWITCH
			
			// Sets text alignment of captions
			switch (captionParams.align.toLowerCase ()) 
			{
				case ALIGN_LEFT :
				case "0" :
					this.textAlign = ALIGN_LEFT;
					break;
				case ALIGN_RIGHT :
				case "2" :
					this.textAlign = ALIGN_RIGHT;
					break;
				case ALIGN_CENTER :
				case "1" :
					this.textAlign = ALIGN_CENTER;
					break;
				default :
					this.textAlign = ALIGN_CENTER;
			} // TEXT ALIGNMENT SWITCH
			this.text = captionParams.text;
			this.emotions_array = emotions_array;
		} // CONSTRUCTOR
		
		//*********************************************
		
		/*
		 * Returns the begin time of the caption.
		 * @return begin								Number
		 */
		public function getBegin ():Number {
			return this.begin;
		}
		
		/*
		 * Returns the end time of the caption.
		 * @return end									Number
		 */
		public function getEnd ():Number {
			return this.end;
		}
		/*
		 * Returns the display duration the caption.
		 * @return duration								Number
		 */
		public function getDur ():Number {
			return this.end - this.begin;
		}
		/*
		 * Returns the speaker's name.
		 * @return speaker								String
		 */
		public function getSpeaker ():String {
			return this.speaker;
		}
		/*
		 * Returns the location of the caption.
		 * @return location								String
		 */
		public function getLocation ():String {
			return this.location;
		}
		/*
		 * Returns the text alignment of the caption.
		 * @return textAlign							String
		 */
		public function getTextAlign ():String {
			return this.textAlign;
		}
		/*
		 * Returns the caption text.
		 * @return text									String
		 */
		public function getText ():String {
			return this.text;
		}
		/*
		 * Returns a number associated with an emotion
		 * @return emotions_array[index]				Emotion
		 */
		public function getEmotion (index:Number):Emotion {
			return this.emotions_array[index];
		}
		/*
		 * Returns length of the caption.
		 * @return emotions_array.length				Number
		 */
		public function length ():Number {
			return this.emotions_array.length;
		}
	} // CAPTION CLASS
} // PACKAGE
