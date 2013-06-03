package  
{
	import  fl.video.*;
	import flash.external.ExternalInterface;
	import flash.display.StageScaleMode;

	/*
	 * A version of the engine meant to interface with an external editor
	 */
	public class EditorEngine extends Engine
	{
		protected const EDITOR_MIN_WIDTH:Number = 480;
		protected const EDITOR_MIN_HEIGHT:Number = 360;

		public function EditorEngine() 
		{
			super(); //Call super before everything else
			
			//Make methods callable through an external program
			ExternalInterface.addCallback("isPlaying", external_isPlaying);
			ExternalInterface.addCallback("getPlayheadTime", external_getPlayheadTime);
			ExternalInterface.addCallback("setPlayheadTime", external_setPlayheadTime);
			ExternalInterface.addCallback("play", external_play);
			ExternalInterface.addCallback("pause", external_pause);
			ExternalInterface.addCallback("togglePlay", external_togglePlay);
			ExternalInterface.addCallback("videoLength", external_videoLength);
		}

		function external_play ():void
		{
			player.play();
		}
		
		function external_pause():void
		{
			player.stop();
		}

		function external_togglePlay():void
		{
			if(player.playing)
				player.stop();
			else
				player.play();
		}
		
		function external_isPlaying():Boolean
		{
			return player.playing;
		}
		
		function external_videoLength():Number
		{
			return player.totalTime;
		}
		
		function external_getPlayheadTime():Number
		{
			return player.playheadTime;
		}
		
		function external_setPlayheadTime(time:Number):void
		{
			player.playheadTime = time;
		}

		/*
		 * Sets up video controls: volume, source, frame rate. Initializes the effects for emotions, and the cue points.
		 * 
		 * @see Effects [class]
		 * @see addCuePooints [method]
		 * @see readyHandler [method]
		 * @see cuePointHandler [method]
		 */
		override function loadVideo():void
		{
			player.addEventListener ("ready", readyHandler);
			player.addEventListener ("cuePoint", cuePointHandler);
			
			// Playback
			player.autoPlay = false;
			player.autoRewind = settings.getAutoRewind ();
			
			///*// Skin
			player.skin = "SkinOverPlayMute.swf";
			player.skinAutoHide = settings.getSkinAutoHide();
			player.skinBackgroundAlpha = settings.getSkinBackgroundAlpha();
			player.skinBackgroundColor = settings.getSkinBackgroundColour();
			player.skinFadeTime = settings.getSkinFadeTime();
			//*/
			//player.volume = settings.getVolume (); 						// volume range 0-1
			player.volume = 0;
			player.playheadUpdateInterval = Math.floor (1000 / 48); 	// FPS = 48
			
			player.source = settings.getContentVideo ();
			
			if (settings.getShowCaptions ()) {
				addCuePoints ();
//				effects = new Effects (settings.getHappyParams (), settings.getSadParams (), settings.getFearParams (), settings.getAngerParams ());
				happy = new Happy(settings.getHappyParams ());
				sad = new Sad(settings.getSadParams ());
				fear = new Fear(settings.getFearParams ());
				anger = new Anger(settings.getAngerParams ());
			}
		}
		
		/*
		 * Displays the FLVPlayer and plays the video. 
		 * 
		 * @param eventObject						Object
		 */
		override function readyHandler (eventObject:Object):void {
			/*Set player and stage not to scale. It is necessary to do this
			before the decision statement below otherwise the player will not
			be the native height of the movie*/
			player.scaleMode = VideoScaleMode.MAINTAIN_ASPECT_RATIO;
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			
			trace("Before Resize");
			trace("Player Width " + player.width);
			trace("Player Height " + player.height);

			//Set player dimensions to stage dimentions
			//While maintaining aspect ratios
			player.width = 1280;
			player.height = 720;

			//Anchor the player to the Center of the stage
			player.align = VideoAlign.CENTER;
			//Anchor the stage to the Center corner
			stage.align = VideoAlign.CENTER;
	
			trace("After Resize");
			trace("Player Width " + player.width);
			trace("Player Height " + player.height);
			
			
			// Seek & Play
			if (settings.getSeek () > 0)
				player.seek (settings.getSeek ());
			//if (settings.getAutoPlay ())
			//	player.play ()
		
			player.visible = true;
			
			//Inform the container that the swf is done loading.
			ExternalInterface.call("Done Loading");
		}
	}//Class
	
}//Package
