package  {
	import flash.display.MovieClip;
	import fl.video.FLVPlayback;
	import fl.video.MetadataEvent;
	import fl.video.*;
	import flash.display.DisplayObject;
	import flash.text.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.StageScaleMode;
	import flash.media.Video;
	
	public class Engine extends MovieClip {
		protected const MIN_WIDTH:Number = 480;
		protected const MIN_HEIGHT:Number = 360;
		
		protected var player:FLVPlayback;
		protected var settings:Settings;
		protected var speakers:Speakers;
		protected var captions:Captions;
		
		// Emotions
		protected var happy:Happy;
		protected var sad:Sad;
		protected var fear:Fear;
		protected var anger:Anger;
		
		// Dimensions
		var CAPTION_TOP:Number;
		var CAPTION_LEFT:Number;
		var CAPTION_BOTTOM:Number;
		var CAPTION_RIGHT:Number;
				
		var CAPTION_WIDTH:Number;
		var CAPTION_HEIGHT:Number;
				
		// Position
		var CAPTION_X:Number;
		var CAPTION_Y:Number;
		var CAPTION_MIN_X:Number;
		var CAPTION_MIN_Y:Number;
		var CAPTION_MAX_X:Number;
		var CAPTION_MAX_Y:Number;
		
		public function Engine() {
			player = new FLVPlayback();
			
			player.visible = false;
			player.x = 0;
			player.y = 0;
			addChildAt(player,0);
			
			settings = new Settings ("Settings.xml", loadSpeakers);
		}
		
		
		/*
		 * Reads and parses Speakers file; upon completion, calls on loadCaption method.
		 *
		 * @see Speakers [class]
		 * @see loadCaptions [method]
		 */
		function loadSpeakers ():void {
			speakers = new Speakers (settings.getContentSpeakers (), loadCaptions);
		}
		
		/*
		 * Reads and parses Captions file; upon completion, calls on loadVideo method.
		 *
		 * @see Captions [class]
		 * @see loadVideo [method]
		 */
		function loadCaptions ():void {
			captions = new Captions (settings.getContentCaptions (), loadVideo);
		}
		
		/*
		 * Sets up video controls: volume, source, frame rate. Initializes the effects for emotions, and the cue points.
		 * 
		 * @see Effects [class]
		 * @see addCuePooints [method]
		 * @see readyHandler [method]
		 * @see cuePointHandler [method]
		 */
		function loadVideo():void {
			player.addEventListener ("ready", readyHandler);
			player.addEventListener ("cuePoint", cuePointHandler);
			
			// Playback
			player.autoPlay = false;
			player.autoRewind = settings.getAutoRewind ();
			
			// Skin
			player.skin = "SkinOverPlayFullScreen.swf";
			player.skinAutoHide = settings.getSkinAutoHide();
			player.skinBackgroundAlpha = settings.getSkinBackgroundAlpha();
			player.skinBackgroundColor = settings.getSkinBackgroundColour();
			player.skinFadeTime = settings.getSkinFadeTime();
			
			player.volume = settings.getVolume (); 						// volume range 0-1
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
		function readyHandler (eventObject:Object):void {
			/*Set player and stage not to scale. It is necessary to do this
			before the decision statement below otherwise the player will not
			be the native height of the movie*/
			player.scaleMode = VideoScaleMode.NO_SCALE;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			trace("Before Resize");
			trace("Player Width " + player.width);
			trace("Player Height " + player.height);

			//If either the video's width or height is too small
			if(player.width < MIN_WIDTH || player.height < MIN_HEIGHT)
			{
				trace("The player has been resized");
				//Set Dimensions so that the smallest dimension is replaced
				//by the larger dimension
				player.width = Math.max(player.width,MIN_WIDTH);
				player.height = Math.max(player.height,MIN_HEIGHT);
				
				//Prevent weird video stretching by maintaining aspect
				player.scaleMode = VideoScaleMode.MAINTAIN_ASPECT_RATIO;
			}

			//Anchor the player to the top left corner of the stage
			player.align = VideoAlign.TOP_LEFT;
			//Anchor the stage to the top left corner
			stage.align = VideoAlign.TOP_LEFT;
	
			trace("After Resize");
			trace("Player Width " + player.width);
			trace("Player Height " + player.height);
			
			
			// Seek & Play
			if (settings.getSeek () > 0)
				player.seek (settings.getSeek ());
			if (settings.getAutoPlay ())
				player.play ();
		
			player.visible = true;
		}
		
		/*
		 * Calls on respective methods to deal with cue points.
		 * 
		 * @see createCaption [method]
		 * @see removeCaption [method]
		 * @see startEmotion [method]
		 * @param eventObject							Object
		 */
		function cuePointHandler (eventObject:Object):void {
			var EnACT_ID:String = eventObject.info.parameters.value;
				
			var caption_index:Number = getCaptionIndex (EnACT_ID);
			var emotion_index:Number = getEmotionIndex (EnACT_ID);
					
			switch (eventObject.info.name) {
				case "BEGIN":
					createCaption (caption_index);
					break;
				case "END":
					removeCaption (caption_index);
					break;
				case "START":
					startEmotion (EnACT_ID, caption_index, emotion_index);
					break;
//				case "CLEAR":
//					removeAllCaptions ();			
			}
		}
		
		/*
		 * Returns a numeric value which is associated with an particular emotion.
		 * 
		 * @param EnACT_ID			EnACT_ID String
		 * @return emotionIndex		Number
		 */
		function getEmotionIndex (EnACT_ID:String):Number {
			return (Number (EnACT_ID) % 1000);
		}
		
		/*
		 * Returns a numeric value which is associated with an particular caption.
		 * 
		 * @param EnACT_ID			EnACT_ID String
		 * @return captionIndex		Number
		 */
		function getCaptionIndex (EnACT_ID:String):Number {
			return Math.floor (Number (EnACT_ID) / 1000) - 1;
		}
		
		/*
		 * Calls on addEnActCuePoint method to add cue points.
		 * BEGIN - specifies when the caption begins
		 * END - when the caption ends
		 * START - when animated captions (emotions) should start
		 * 
		 * @see addEnACTCuePoint [method]
		 */
		function addCuePoints ():void {
			var caption:Caption;
			var emotion:Emotion;
			
//			addEnACTCuePoint (0, 0, "CLEAR", 0);
				
			// Caption
			for (var i:Number = 0; i < captions.length (); i++) {
				caption = captions.getCaption (i);
				
				if( caption.getBegin() > 0)
					addEnACTCuePoint (i, 0, "BEGIN", caption.getBegin ());
			}
					
			for (var i:Number = 0; i < captions.length (); i++) {
				caption = captions.getCaption (i);
				
				if( caption.getEnd() > 0)
					addEnACTCuePoint (i, 0, "END", caption.getEnd ());
			}
				
			// Emotion
			for (var i:Number = 0; i < captions.length (); i++) {
				caption = captions.getCaption (i);
						
				for (var j:Number = 0; j < caption.length (); j++) {
					emotion = caption.getEmotion (j);
							
					if (emotion.getType () != Emotion.EMOTION_NONE) {
						if( emotion.getBegin () > 0)
							addEnACTCuePoint (i, j, "START", emotion.getBegin ());
					}
						
				}
			}
//			addEnACTCuePoint (0, 0, "CLEAR", 0);
		}
		
		/*
		 * Adds cue points to the FLVPlayer.
		 * 
		 * @param caption_index											Number
		 * @param emotion_index											Number
		 * @param name (specifies what type of cue point)				String
		 * @param time (duration at which cue point should occur) 		Number
		 */
		function addEnACTCuePoint (caption_index:Number, emotion_index:Number, name:String, time:Number):void {
			var EnACT_ID:String = createEnACT_ID (caption_index, emotion_index);
			
			player.addASCuePoint (time, name, {value: EnACT_ID});
		}
		
		/*
		 * Creates an EnACT identifier from caption index and emotion index
		 * 
		 * @param caption_index		Caption Number
		 * @param emotion_index		Emotion Number
		 * @return EnACT_ID			String
		 */
		function createEnACT_ID (caption_index:Number, emotion_index:Number):String {
			return String (((caption_index + 1) * 1000) + emotion_index);
		}
		
		/*
		 * Creates captions for display on the stage.
		 * 
		 * @see setCaptionLocation 		[method]
		 * @see setCaptionAlignmentY 	[method]
		 * @see stringReplace 			[method]
		 * @see setCaptionAlignmentX 	[method]
		 * @see removeTrailingNewLine 	[method]
		 * @see createEnACT_ID 			[method]
		 * @see createEmotion 			[method]
		 * @see isLastWordOfLine		[method]
		 * @param caption_index			Number
		 */
		function createCaption (caption_index:Number):void {
			var caption:Caption = captions.getCaption (caption_index);
			var speaker:Speaker = speakers.getSpeakerName(caption.getSpeaker ());
				
			// Sets caption location
			setCaptionLocation(caption_index,caption.getLocation());
			
			// Search all strings and replaces the end of line with a new line character
			var captionText:String = caption.getText ();
			captionText = stringReplace (captionText, " \\n", "\n");
			captionText = stringReplace (captionText, "\\n ", "\n");
			captionText = stringReplace (captionText, "\\n", "\n");
			
			// Metrics used for spacing 
			var captionMetrics:TextField = new TextField();
			captionMetrics.defaultTextFormat = speaker.getTextFormat();
			captionMetrics.text = captionText;
					
			var spaceMetrics:TextField = new TextField();
			spaceMetrics.defaultTextFormat = speaker.getTextFormat();
			spaceMetrics.text = " ";
			
			// Sets vertical alignment
			setCaptionAlignmentY (caption.getLocation (), captionMetrics.textHeight);
			
			// Display Caption
			var startIndex:Number = 0;
			var currentText:String = "";
			var currentMetrics:TextField = new TextField();
			currentMetrics.defaultTextFormat = speaker.getTextFormat();
			
			var printCaption:Function = function (endIndex:Number) 
			{
				currentMetrics.text = currentText;
				
				// Sets horizontal alignment
				setCaptionAlignmentX (caption.getTextAlign (), currentMetrics.textWidth);
				
				/* 
				 * Tracking used to add more background space for animations;
				 * Only applicable for anger and fear emotions.
				 */
				var tracking:Number;
				var EnACT_ID:String;
				var emotion:Emotion;
				var emotionText:String;
				var emotionMetrics:TextField = new TextField();
				emotionMetrics.defaultTextFormat = speaker.getTextFormat();
				
				for (var i:Number = startIndex; i < endIndex; i++) 
				{
					emotion = caption.getEmotion (i);
					emotionText = removeTrailingNewLine (emotion.getText ());
					emotionMetrics.text = emotionText;
					
					switch (emotion.getType ()) 
					{
						case Emotion.EMOTION_FEAR :
							tracking = emotion.getIntensity () * 0.0625;
							break;
						case Emotion.EMOTION_ANGER :
							tracking = emotion.getIntensity () * 0.25;
							break;
						case Emotion.EMOTION_HAPPY :
						case Emotion.EMOTION_SAD :
						case Emotion.EMOTION_NONE :
						default:
							tracking = 0;
							break;
					} // switch
					
					if (i != startIndex)
						CAPTION_X += spaceMetrics.textWidth * tracking;
					EnACT_ID = createEnACT_ID (caption_index, i);
					
					// Creates captions and adds them to the stage
					createEmotion(EnACT_ID,speaker,emotionText,CAPTION_X,CAPTION_Y,emotionMetrics.textWidth,emotionMetrics.textHeight);
					
					// Caption Window Width
					CAPTION_MAX_X = Math.max (CAPTION_MAX_X, CAPTION_X + emotionMetrics.textWidth);
					CAPTION_X += emotionMetrics.textWidth + spaceMetrics.textWidth;
							
					// Tracking
					if (i != endIndex - 1)
						CAPTION_X += spaceMetrics.textWidth * tracking;
				} // for
				
				CAPTION_Y += currentMetrics.textHeight;
				
				startIndex = endIndex;
				currentText = "";
			}; // print function
			
			var emotionText:String;
			var emotionMetrics:TextField = new TextField();
			emotionMetrics.defaultTextFormat = speaker.getTextFormat();
				
			for (var i:Number = 0; i < caption.length (); i++) {
				emotionText = caption.getEmotion (i).getText ();
				
				emotionMetrics.text = emotionText;
				currentMetrics.text = currentText;
					
				if (isLastWordOfLine (emotionText) == true) {
					emotionText = removeTrailingNewLine (emotionText);
					currentText += emotionText;
					printCaption (i + 1);
				}
				else 
				{			
					if (currentMetrics.textWidth + emotionMetrics.textWidth > CAPTION_WIDTH)
						printCaption (i);
			
					currentText += emotionText + " ";
				}
			}
			
			currentText = removeTrailingSpace (currentText);
			printCaption (caption.length ());
					
			CAPTION_MAX_Y = CAPTION_Y + 4;// - (currentMetrics.height + currentMetrics.textHeight);
				
			// Space Border for Background
			CAPTION_MIN_X -= spaceMetrics.textWidth;
			CAPTION_MAX_X += spaceMetrics.textWidth * 2;

			createBackground(caption_index, speaker, CAPTION_MIN_X, CAPTION_MIN_Y, CAPTION_MAX_X - CAPTION_MIN_X, CAPTION_MAX_Y - CAPTION_MIN_Y);
		}
		
		/*
		 * Creates background for captions to be displayed on.
		 * 
		 * @see createTextField [method]
		 * @param caption_index						Number
		 * @param speaker 							Speaker
		 * @param x (x-position of background)		Nummber
		 * @param y (y-position of background)		Number
		 * @param width (width of background)		Number
		 * @param height (height of background)		Number
		 */
		function createBackground (caption_index:Number, speaker:Speaker,x:Number, y:Number, width:Number, height:Number):void {
			var background_txt:TextField = new TextField();
			var background_txt:TextField = this.createTextField(createBackground_ID(caption_index),x,y,width,height);
					
			background_txt.embedFonts = true;
			background_txt.selectable = false;
					
			background_txt.alpha = speaker.getBackgroundAlpha ();
			background_txt.background = speaker.getBackgroundVisibility ();
			background_txt.backgroundColor = speaker.getBackgroundColour ();
			addChildAt(background_txt,2);
		}
		
		/*
		 * Creates a background identifier from given caption index.
		 * 
		 * @param caption_index		Caption Number
		 * @return backgroundID		String
		 */
		function createBackground_ID (caption_index:Number):String {
			return ("BACKGROUND" + caption_index);
		}
		
		/*
		 * Sets border dimensions for displaying captions at desired location
		 * 
		 * @param caption_index													Number
		 * @param location (specifies where the caption should be displayed) 	String
		 */
		function setCaptionLocation (caption_index:Number, location:String):void {			
/*			// Location Allocation
			var location_index:Number = getLocationIndex (location) - 1;
		
			if (LOCATION_ALLOCATION[location_index] != undefined)
				removeCaption (LOCATION_ALLOCATION[location_index]);
		
			LOCATION_ALLOCATION[location_index] = caption_index;
*/		
			// Caption Top and Bottom
			switch (location) {
				// Top
				case Caption.LOCATION_TOP_LEFT:
				case Caption.LOCATION_TOP_CENTRE:
				case Caption.LOCATION_TOP_RIGHT:
					CAPTION_TOP = player.height * 0.10; //Caption.MARGIN_TOP;
					CAPTION_BOTTOM = player.height * 0.35;
					break;
				// Middle
				case Caption.LOCATION_MIDDLE_LEFT:
				case Caption.LOCATION_MIDDLE_CENTRE:
				case Caption.LOCATION_MIDDLE_RIGHT:
					CAPTION_TOP = player.height * 0.35;
					CAPTION_BOTTOM = player.height * 0.65;
					break;
				// Bottom
				case Caption.LOCATION_BOTTOM_LEFT:
				case Caption.LOCATION_BOTTOM_CENTRE:
				case Caption.LOCATION_BOTTOM_RIGHT:
					CAPTION_TOP = player.height * 0.65;
					CAPTION_BOTTOM = player.height * 0.90; //FLVPlayer.height - Caption.MARGIN_BOTTOM;
					break;
			}
					
			// Caption Left and Right
			switch (location) {
				// Left
				case Caption.LOCATION_TOP_LEFT:
				case Caption.LOCATION_MIDDLE_LEFT:
				case Caption.LOCATION_BOTTOM_LEFT:
					CAPTION_LEFT = player.width * 0.05; //Caption.MARGIN_LEFT;
					CAPTION_RIGHT = player.width * 0.50;
					break;
				// Centre
				case Caption.LOCATION_TOP_CENTRE:
				case Caption.LOCATION_MIDDLE_CENTRE:
				case Caption.LOCATION_BOTTOM_CENTRE:
					CAPTION_LEFT = player.width * 0.10;
					CAPTION_RIGHT = player.width * 0.90;
					break;
				// Right
				case Caption.LOCATION_TOP_RIGHT:
				case Caption.LOCATION_MIDDLE_RIGHT:
				case Caption.LOCATION_BOTTOM_RIGHT:
					CAPTION_LEFT = player.width * 0.50;
					CAPTION_RIGHT = player.width * 0.95; //FLVPlayer.width - Caption.MARGIN_RIGHT;
					break;
			}
				
			// Dimensions
			CAPTION_WIDTH = CAPTION_RIGHT - CAPTION_LEFT;
			CAPTION_HEIGHT = CAPTION_BOTTOM - CAPTION_TOP;
		
			// Boundaries
			CAPTION_MIN_X = CAPTION_RIGHT;
			CAPTION_MIN_Y = CAPTION_BOTTOM;
			CAPTION_MAX_X = CAPTION_LEFT;
			CAPTION_MAX_Y = CAPTION_TOP;
		}
		
		/*
		 * Sets y-position border dimensions for displaying captions.
		 * 
		 * @param location									String
		 * @param textHeight (height of the caption) 		Number
		 */
		function setCaptionAlignmentY (location:String, textHeight:Number):void {
			switch (location) {
				// Top
				case Caption.LOCATION_TOP_LEFT:
				case Caption.LOCATION_TOP_CENTRE:
				case Caption.LOCATION_TOP_RIGHT:
					CAPTION_Y = CAPTION_TOP;
					break;
				// Middle
				case Caption.LOCATION_MIDDLE_LEFT:
				case Caption.LOCATION_MIDDLE_CENTRE:
				case Caption.LOCATION_MIDDLE_RIGHT:
					CAPTION_Y = CAPTION_TOP + (CAPTION_HEIGHT - textHeight) * 0.5;
					break;
				// Bottom
				case Caption.LOCATION_BOTTOM_LEFT:
				case Caption.LOCATION_BOTTOM_CENTRE:
				case Caption.LOCATION_BOTTOM_RIGHT:
					CAPTION_Y = CAPTION_BOTTOM - textHeight;
					break;
			}
			CAPTION_MIN_Y = Math.min (CAPTION_MIN_Y, CAPTION_Y);
		}
		
		/*
		 * Sets x-position border dimensions for displaying captions.
		 * 
		 * @param align									String
		 * @param textWidth (width of the caption) 		Number
		 */
		function setCaptionAlignmentX (align:String, textWidth:Number):void {
			switch (align) {
				case Caption.ALIGN_LEFT:
					CAPTION_X = CAPTION_LEFT;
					break;
				case Caption.ALIGN_CENTER:
					CAPTION_X = CAPTION_LEFT + (CAPTION_WIDTH - textWidth) * 0.5;
					break;
				case Caption.ALIGN_RIGHT:
					CAPTION_X = CAPTION_RIGHT - textWidth;
					
					if (CAPTION_X < CAPTION_LEFT)
						CAPTION_X = CAPTION_LEFT;
					break;
			}
			CAPTION_MIN_X = Math.min (CAPTION_MIN_X, CAPTION_X);
		}
		
		/*
		 * Replaces a string with new string.
		 * 
		 * @param str (string to check)											String
		 * @param search (word to be replaced)									String
		 * @param replace (word that will be replacing the previous word)		String
		 * @return caption_arr (array of strings with the newly replaced word)	Array
		 */
		function stringReplace (str:String, search:String, replace:String):String {
			var caption_arr:Array = str.split (search);
			return caption_arr.join (replace);
		}
		
		/*
		 * Removes new line characters at the end of the line if they exist.
		 * 
		 * @see isLastWordOfLine [method]
		 * @param emotionText											String
		 * @return emotionText (word without new line character)		String
		 */
		function removeTrailingNewLine (emotionText:String):String {
			if (isLastWordOfLine (emotionText))
				return emotionText.slice (0, -2);
			return emotionText;
		}
		
		/*
		 * Removes white space if existing. 
		 * 
		 * @param emotionText									String
		 * @return emotionText (word without white spaces)		String
		 */
		function removeTrailingSpace (emotionText:String):String {
			if (emotionText.slice (-1) == " ")
				return emotionText.slice (0, -1);
			return emotionText;
		}
		
		/*
		 * Checks to see if the given string is the last word on the line.
		 * 
		 * @param emotionText										String
		 * @return true if it is the last word on the line
		 * @return false if it is not the last word on the line	
		 */
		function isLastWordOfLine (emotionText:String):Boolean {
			return (emotionText.slice (-2) == "\\n");
		}
		
		/*
		 * Creates the caption which will be associated with an emotion.
		 *
		 * @see createTextField [method]
		 * @param EnACT_ID 								String 
		 * @param speaker 								Speaker
		 * @param emotionText (caption)					String
		 * @param x (x-position of textfield)			Number
		 * @param y (y-position of textfield)			Number
		 * @param width (width of textfield)			Number
		 * @param height (height of textfield)			Number
		 */
		function createEmotion (EnACT_ID:String, speaker:Speaker, emotionText:String,x:Number, y:Number,width:Number, height:Number):void {
			var caption_txt:TextField = this.createTextField(EnACT_ID,x,y,width+4,height+4);
			caption_txt.defaultTextFormat = speaker.getTextFormat();
			caption_txt.text = emotionText;
					
			caption_txt.embedFonts = true;
			caption_txt.selectable = false;
				
			caption_txt.autoSize = TextFieldAutoSize.CENTER;
			caption_txt.antiAliasType = AntiAliasType.ADVANCED; 
			caption_txt.gridFitType = GridFitType.SUBPIXEL;
			addChild(caption_txt);
		}
		
		/*
		 * Creates a new textfield with desired attributes.
		 * 
		 * @param name (name of the textfield)						String
		 * @param x (x position)									Number
		 * @param y (x position)									Number
		 * @param width												Number
		 * @param height 											Number
		 * @return txt_field (textfield with assigned attributes)	TextField
		 */
		function createTextField (name:String, x:Number, y:Number, width:Number, height:Number):TextField {
			var txt_field:TextField = new TextField();
			txt_field.name = name;
			txt_field.x = x;
			txt_field.y = y;
			txt_field.width = width;
			txt_field.height = height;
			
			return txt_field;
		}
		
		/*
		 * Removes captions and backgrounds from the stage.
		 * 
		 * @param caption_index						Number
		 */
		function removeCaption (caption_index:Number):void {
			var caption:Caption = captions.getCaption (caption_index);
					
			var EnACT_ID:String;
			var caption_txt:DisplayObject;
					
			for (var j:Number = 0; j < caption.length (); j++) {
				EnACT_ID = createEnACT_ID (caption_index, j);
				
				caption_txt = getChildByName(EnACT_ID);
						
				if (caption_txt != null)
					removeChild(caption_txt); 
			}
					
			var background_txt:DisplayObject = getChildByName(createBackground_ID (caption_index));
			if (background_txt != null)
				removeChild(background_txt);
				
/*			// Location Allocation
			var location_index:Number = getLocationIndex (caption.getLocation ()) - 1;
			
			LOCATION_ALLOCATION[location_index] = null;
*/
		}
		
		/*
		 * Starts animating the captions.
		 * 
		 * @param EnACT_ID							String
		 * @param caption_index						Number
		 * @param emotion_index						Number
		 */
		function startEmotion (EnACT_ID:String, caption_index:Number, emotion_index:Number):void {
			var caption:Caption = captions.getCaption (caption_index);
			var emotion:Emotion = caption.getEmotion (emotion_index);
				
			var caption_txt:DisplayObject = getChildByName (EnACT_ID);
					
			var displayDuration:Number = caption.getEnd () - emotion.getBegin ();
					
			switch (emotion.getType ()) 
			{ 
				case Emotion.EMOTION_HAPPY:
				case "1":
					happy.setFrames(emotion.getIntensity ());
					happy.startTween(caption_txt, emotion.getIntensity ());
					break;
				case Emotion.EMOTION_SAD:
				case "2":
					sad.setFrames(emotion.getIntensity ());
					sad.startTween(caption_txt,emotion.getIntensity ());
					break;
				case Emotion.EMOTION_FEAR:
				case "3":
					fear.setFrames(emotion.getIntensity ());
					fear.startTween(caption_txt,emotion.getIntensity());
					break;
				case Emotion.EMOTION_ANGER:
				case "4":
					anger.setFrames(emotion.getIntensity());
					anger.startTween(caption_txt,emotion.getIntensity());
					break;
				case Emotion.EMOTION_NONE:
				case "0":
				default:
					break;
			}
		}
	} // Class
} // Package
