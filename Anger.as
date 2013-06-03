package  {
	import flash.display.DisplayObject;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	import com.greensock.*;
	import com.greensock.easing.*;
	
	public class Anger extends Effects{
		private var angerFPS:Array;
		private var angerDur:Array;
		private var angerScaleBegin:Array;
		private var angerScaleFinish:Array;
		private var angerVibrateX:Array;
		private var angerVibrateY:Array;
		
		private var frames:Number;
		
		/*
		 * Sets all values from given object.
		 *
		 * @param intensity							Number
		 */
		public function Anger(angerParams:Object) {
			super();
			
			this.angerFPS = angerParams.fps;
			this.angerDur = angerParams.dur;
			this.angerScaleBegin = angerParams.scaleBegin;
			this.angerScaleFinish = angerParams.scaleFinish;
			this.angerVibrateX = angerParams.vibrateX;
			this.angerVibrateY = angerParams.vibrateY;
		}

		/*
		 * Sets parameters and frame values.
		 *
		 * @param intensity							Number
		 */
		public function setFrames(intensity:Number):void {
			super.setParams(angerFPS,angerDur,angerScaleBegin,angerScaleFinish,intensity);
			frames = super.getFPS() * super.getDuration() * 0.25;
		}
		
		/*
		 * Creates all tweens needed for anger emotion.
		 *
		 * @param caption_txt 						DisplayObject
		 * @param intensity 						number
		 * @see scaleTween [method]
		 */
		public function startTween(caption_txt:DisplayObject, intensity:Number):void {
			var unitX:Number = super.getIntensity(angerVibrateX, intensity);
			var unitY:Number = super.getIntensity(angerVibrateY, intensity);
			var vibrateBeginX:Number = caption_txt.x - unitX;
			var vibrateBeginY:Number = caption_txt.y - unitY;
			
			var xFin:Number = caption_txt.x + super.resize (caption_txt.height, (1 - super.getScaleFinish()) * 50);
			var yFin:Number = caption_txt.y + super.resize (caption_txt.height, (1 - super.getScaleFinish()) * 50);
			
			var vibrate:TweenLite = TweenLite.to(caption_txt,frames * 0.5,{x:xFin,y:yFin,scaleX:super.getScaleFinish(),scaleY:super.getScaleFinish(),onComplete:restartTween,useFrames:true,overwrite:0});

			function restartTween():void {
				xFin = vibrateBeginX - Math.random () * unitX * 3;
				yFin = vibrateBeginY - Math.random () * unitY * 3;
				vibrate = TweenLite.from(caption_txt,1,{x:xFin,y:yFin,useFrames:true,onComplete:restartTween,onReverseComplete:reverseTween,overwrite:0});
			}
			function reverseTween():void {
				vibrate.restart();
			}
			
		}
	} // EFFECTS
} // PACKAGE