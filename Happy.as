package  {
	import flash.display.DisplayObject;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import com.greensock.*;
	import com.greensock.easing.*;
	
	public class Happy extends Effects{
		private var happyFPS:Array;
		private var happyDur:Array;
		private var happyAlphaBegin:Array;
		private var happyAlphaFinish:Array;
		private var happyScaleBegin:Array;
		private var happyScaleFinish:Array;
		private var happyYFinish:Array;
		private var frames:Number;
		
		private var alphaTween:Tween;
		/*
		 * Sets all values from given object.
		 *
		 * @param happyParams							Object
		 */
		public function Happy(happyParams:Object) {
			super();
			
			this.happyFPS = happyParams.fps;
			this.happyDur = happyParams.dur;
			this.happyAlphaBegin = happyParams.alphaBegin;
			this.happyAlphaFinish = happyParams.alphaFinish;
			this.happyScaleBegin = happyParams.scaleBegin;
			this.happyScaleFinish = happyParams.scaleFinish;
			this.happyYFinish = happyParams.yFinish;
		}
		
		/*
		 * Sets parameters and frame values.
		 *
		 * @param intensity							Number
		 */
		public function setFrames(intensity:Number):void {
			super.setParams(happyFPS,happyDur,happyScaleBegin,happyScaleFinish,intensity);
			frames = super.getFPS() * super.getDuration() * 0.25;
		}
		/*
		 * Sets parameters and creates tweens.
		 *
		 * @param caption_txt						DisplayObject
		 * @param intensity							Number
		 */
		public function startTween(caption_txt:DisplayObject,intensity:Number):void {
			// Sets values for tweening
			var alphaBegin = super.getIntensity(happyAlphaBegin, intensity);
			var alphaFinish = super.getIntensity(happyAlphaFinish, intensity);
			
			alphaTween = new Tween(caption_txt, "alpha", None.easeNone, alphaBegin, alphaFinish, frames);

			var xBegin:Number = caption_txt.x;
			var xFinish:Number = caption_txt.x + super.resize (caption_txt.width, (1 - super.getScaleFinish()) * 50);
			var yBegin:Number = caption_txt.y + super.resize (caption_txt.height, 1 - super.getScaleBegin());
			var yFinish:Number = yBegin - super.resize (caption_txt.height, super.getIntensity (happyYFinish, intensity));
			var yFinish2:Number = caption_txt.y;
			
			caption_txt.y = yBegin;
			TweenLite.to(caption_txt,frames,{x:xFinish,y:yFinish,scaleX:super.getScaleFinish(),scaleY:super.getScaleFinish(),useFrames:true,onComplete:tweenToEnd});
			
			function tweenToEnd():void {
				TweenLite.to(caption_txt,frames,{x:xBegin,y:yFinish2,scaleX:1,scaleY:1,useFrames:true});
			}
		}
	}
}
