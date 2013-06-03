package  {
	import fl.transitions.Tween;

	public class Effects {		
		private var fps:Number;
		private var dur:Number;
		private var scaleBegin:Number;
		private var scaleFinish:Number;
		
		public function Effects(){
			// Empty Constructor
		}
		
		/*
		 * Sets tweening values from given input values.
		 *
		 * @param emotionFPS					Array
		 * @param emotionDur					Array
		 * @param emotionScaleBegin				Array
		 * @param emotionScaleFinish			Array
		 * @param intensity						Number
		 */
		public function setParams(emotionFPS:Array, emotionDur:Array, emotionScaleBegin:Array, emotionScaleFinish:Array, intensity:Number):void
		{
			fps = this.getIntensity(emotionFPS,intensity);
			dur = this.getIntensity(emotionDur,intensity);
			scaleBegin = this.getIntensity(emotionScaleBegin,intensity);
			scaleFinish = this.getIntensity(emotionScaleFinish,intensity);
		}
		
		/*
		 * Returns frames per second
		 *
		 * @return fps							Number
		 */
		public function getFPS():Number {
			return fps;
		}
		
		/*
		 * Returns duration of the caption
		 *
		 * @return dur							Number
		 */
		public function getDuration():Number {
			return dur;
		}
		/*
		 * Returns the initial scale value
		 *
		 * @return scaleBegin					Number
		 */
		public function getScaleBegin():Number {
			return scaleBegin;
		}
		/*
		 * Returns the scale value on finish
		 *
		 * @return scaleFinish					Number
		 */
		public function getScaleFinish():Number {
			return scaleFinish;
		}
		/*
		 * Retrieves duration of a caption
		 *
		 * @param begin 						Object
		 * @param finish		 				Object
		 * @param speed							Number
		 * @return duration						Number
		 */
		public function duration (begin:Number, finish:Number, speed:Number):Number {
			return Math.abs (finish - begin) * speed;
		}
		
		/*
		 * Resizes given input values.
		 *
		 * @param value 				Number
		 * @param scale					Number
		 * @return scaledValue			Number
		 */
		public function resize (value:Number, scale:Number):Number {
			return (value * scale * 0.01);
		}
		
		/*
		 * Retrieves intensity of a given word
		 *
		 * @param intensity_array 				Object
		 * @param intensity		 				Object
		 * @return intensity_array[index]		Numbers
		 */
		public function getIntensity (intensity_array:Array, intensity:Number):Number {
			var index:Number = intensity - 1;
	
			if (index < 0)
				return 0;
	
			if (index > intensity_array.length)
				index = intensity_array.length - 1;
	
			return Number (intensity_array[index]);
		}
	}
}
