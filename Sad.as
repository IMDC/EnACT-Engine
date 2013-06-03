package  {
	import flash.display.DisplayObject;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import com.greensock.*;
	import com.greensock.easing.*;
	
	public class Sad extends Effects{
		private var sadFPS:Array;
		private var sadDur:Array;
		private var sadAlphaBegin:Array;
		private var sadAlphaFinish:Array;
		private var sadScaleBegin:Array;
		private var sadScaleFinish:Array;
		private var sadYFinish:Array;
		private var frames:Number;
		
		private var tweenAlpha:Tween;
		/*
		 * Sets all values from given object.
		 *
		 * @param sadParams							Object
		 */
		public function Sad(sadParams:Object) {
			super();
			
			this.sadFPS = sadParams.fps;
			this.sadDur = sadParams.dur;
			this.sadAlphaBegin = sadParams.alphaBegin;
			this.sadAlphaFinish = sadParams.alphaFinish;
			this.sadScaleBegin = sadParams.scaleBegin;
			this.sadScaleFinish = sadParams.scaleFinish;
			this.sadYFinish = sadParams.yFinish;
		}

		/*
		 * Sets parameters and frame values.
		 *
		 * @param intensity							Number
		 */
		public function setFrames(intensity:Number):void {
			super.setParams(sadFPS,sadDur,sadScaleBegin,sadScaleFinish,intensity);
			frames = super.getFPS() * super.getDuration();
		}
		
		/*
		 * Creates all tweens needed for sad emotion.
		 *
		 * @param intensity							Number
		 * @param caption_txt 						DisplayObject
		 */
		public function startTween(caption_txt:DisplayObject,intensity:Number):void {
			var alphaBegin:Number = super.getIntensity (sadAlphaBegin, intensity);
			var alphaFinish:Number = super.getIntensity (sadAlphaFinish, intensity); 
			
			tweenAlpha = new Tween (caption_txt, "alpha", Regular.easeOut, alphaBegin, alphaFinish, frames);
			
			// Values needed to tween in the y-direction
			var yFinish:Number = caption_txt.y + super.resize (caption_txt.height, 100 - (super.getScaleFinish()*100)) + super.resize (caption_txt.height, super.getIntensity (sadYFinish, intensity));
			
			TweenLite.to(caption_txt,frames,{y:yFinish,scaleY:super.getScaleFinish(),alpha:alphaFinish,useFrames:true});
		}
	}
}
