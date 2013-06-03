package  {
	public class Emotion {
		public static var EMOTION_NONE:String = "none";
		public static var EMOTION_HAPPY:String = "happy";
		public static var EMOTION_SAD:String = "sad";
		public static var EMOTION_FEAR:String = "fear";
		public static var EMOTION_ANGER:String = "anger";
	
		public static var INTENSITY_NONE:Number = 0;
		public static var INTENSITY_LOW:Number = 1;
		public static var INTENSITY_MEDIUM:Number = 2;
		public static var INTENSITY_HIGH:Number = 3;
		
		private var type:String;
		private var intensity:Number;
		private var text:String;
		private var begin:Number;
		
		/*
		 * Sets emotion type, intensity, start time and caption text. 
		 *
		 * @param type (emotion type)							String
		 * @param intensity (emotion intensity)					Number
		 * @param begin (begin time of animating emotion)		Number
		 * @param text (caption text)							String
		 */
		public function Emotion(type:String, intensity:Number, begin:Number, text:String) {
			// Determines the corresponding emotion 
			switch (type.toLowerCase ()) 
			{
				case Emotion.EMOTION_HAPPY :
				case "1" :
					this.type = Emotion.EMOTION_HAPPY;
					break;
				case Emotion.EMOTION_SAD :
				case "2" :
					this.type = Emotion.EMOTION_SAD;
					break;
				case Emotion.EMOTION_FEAR :
				case "3" :
					this.type = Emotion.EMOTION_FEAR;
					break;
				case Emotion.EMOTION_ANGER :
				case "4" :
					this.type = Emotion.EMOTION_ANGER;
					break;
				case Emotion.EMOTION_NONE :
				case "0" :
					this.type = Emotion.EMOTION_NONE;
					break;
				default :
					this.type = Emotion.EMOTION_NONE;
			} // TYPE SWITCH
			
			// Sets intensity of the word, the text effected, and the beginning time of the caption.
			this.intensity = intensity;
			this.text = text;
			this.begin = begin;
		}
		
		//***************************************
		/*
		 * Returns emotion type (happy, mad, sad, fear, none)
		 * @return type 						String
		 */
		public function getType ():String {
			return this.type;
		}
		/*
		 * Returns emotion intensity
		 * @return intensity					Number
		 */
		public function getIntensity ():Number {
			return this.intensity;
		}
		/*
		 * Returns caption text
		 * @return text							String
		 */
		public function getText ():String {
			return this.text;
		}
		/*
		 * Returns start time of emotion
		 * @return begin						Number
		 */
		public function getBegin ():Number {
			return this.begin;
		}
		
	} // EMOTION CLASS
} // PACKAGE
