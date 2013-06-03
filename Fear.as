package  {
	import flash.display.DisplayObject;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import com.greensock.*;
	import com.greensock.easing.*;
	
	public class Fear extends Effects{
		private var fearFPS:Array;
		private var fearDur:Array;
		private var fearScaleBegin:Array;
		private var fearScaleFinish:Array;
		private var fearVibrateX:Array;
		private var fearVibrateY:Array;
		
		private var frames:Number;
		
		/*
		 * Sets all values from given object.
		 *
		 * @param fearParams							Object
		 */
		public function Fear(fearParams:Object) {
			super();
			
			this.fearFPS = fearParams.fps;
			this.fearDur = fearParams.dur;
			this.fearScaleBegin = fearParams.scaleBegin;
			this.fearScaleFinish = fearParams.scaleFinish;
			this.fearVibrateX = fearParams.vibrateX;
			this.fearVibrateY = fearParams.vibrateY;
		}
		
		/*
		 * Sets parameters and frame values.
		 *
		 * @param intensity								Number
		 */
		public function setFrames(intensity:Number):void {
			super.setParams(fearFPS,fearDur,fearScaleBegin,fearScaleFinish,intensity);
			frames = 48 * super.getDuration() * 0.25;
		}

		/*
		 * Creates all tweens needed for fear emotion.
		 *
		 * @param caption_txt 						DisplayObject
		 * @param intensity							Number
		 * @see scaleTween [method]
		 * @see vibrateTween [method]
		 */
		public function startTween(caption_txt:DisplayObject,intensity:Number):void {
			var unitX:Number = super.getIntensity(fearVibrateX, intensity);
			var unitY:Number = super.getIntensity(fearVibrateY, intensity);
			var vibrateBeginX:Number = caption_txt.x - unitX;
			var vibrateBeginY:Number = caption_txt.y - unitY;
			var xFin:Number = vibrateBeginX + (Math.random () * unitX * 3);
			var yFin:Number = vibrateBeginY + (Math.random () * unitY * 3);
			
			var scale:TweenLite = new TweenLite(caption_txt,1,{scaleY:super.getScaleBegin(),useFrames:true,onComplete:reverseTween, onReverseComplete:restartTween,overwrite:0});
			var vibrate:TweenLite = new TweenLite(caption_txt,1,{x:xFin,y:yFin,onComplete:reverseTween, onReverseComplete:restartTween,overwrite:0,useFrames:true});
			function reverseTween():void {
				scale.reverse();
				vibrate.reverse();
			}
			function restartTween():void {
				scale.restart();
					
				xFin = vibrateBeginX + Math.random () * unitX * 3;
				yFin = vibrateBeginY + Math.random () * unitY * 3;
				vibrate = TweenLite.from(caption_txt,1,{x:xFin,y:yFin,useFrames:true,overwrite:0});
			}
		}
	}
}