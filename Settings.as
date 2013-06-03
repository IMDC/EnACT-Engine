package {
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.xml.XMLNode;
	import flash.xml.XMLDocument;
	
	public class Settings {
		
		public static var NODE_SETTINGS:String = "settings";
		public static var NODE_META:String = "meta";
		public static var NODE_PLAYBACK:String = "playback";
		public static var NODE_SKIN:String = "skin";
		public static var NODE_CONTENT:String = "content";
		public static var NODE_SPEAKERS:String = "speakers";
		public static var NODE_CAPTIONS:String = "captions";
		public static var NODE_VIDEO:String = "video";
	
		public static var NODE_EMOTIONS:String = "emotions";
		public static var NODE_HAPPY:String = "happy";
		public static var NODE_SAD:String = "sad";
		public static var NODE_FEAR:String = "fear";
		public static var NODE_ANGER:String = "anger";
		public static var NODE_PARAM:String = "param";
		
		private var metaBase:String = "";
		//private var metaWordSpacing:Number = 1.5;
		//private var metaSeparateEmotion:String = "1";
		
		private var happyParams:Object;
		private var sadParams:Object;
		private var fearParams:Object;
		private var angerParams:Object;
		
		private var autoPlay:Boolean;
		private var autoRewind:Boolean;
		//private var autoSize:Boolean;
		private var seek:Number;
		//private var width:Number;
		//private var height:Number;
		private var scale:Number;
		private var volume:Number;
		private var showCaptions:Boolean;
		
		private var skin:String;
		private var skinAutoHide:Boolean;
		private var skinFadeTime:Number;
		private var skinBackgroundAlpha:Number;
		private var skinBackgroundColour:Number;
	
		
		private var contentSpeakers:String;
		private var contentCaptions:String;
		private var contentVideo:String;
		
		public static var TIME_VALUES:Array = [1, 60, 3600];
		
		/*
		 * Parses the given settings file and calls on appropriate method to handle children nodes.
		 * Upon completion, the dependentFunction is executed.
		 *
		 * @see parseSettingsNode [method]
		 * @param fileName 									String
		 * @param dependentFunction 						Function
		 */
		public function Settings(fileName:String, dependentFunction:Function) 
		{
			var thisClass:Settings = this;
			
			var xmlString:URLRequest = new URLRequest(fileName);
			var xmlLoader:URLLoader = new URLLoader(xmlString);
			xmlLoader.addEventListener(Event.COMPLETE, LoadXML);
			
			// Loads XML file for parsing
			function LoadXML(e:Event):void 
			{
				var settings_doc:XMLDocument = new XMLDocument();
				var settings_xml:XML = XML(e.target.data);
				settings_doc.parseXML(settings_xml.toXMLString());
				
				for (var child_node:XMLNode = settings_doc.firstChild; child_node != null; child_node = child_node.nextSibling) {
					switch (child_node.nodeName) {
						case NODE_SETTINGS :
							if (thisClass.parseSettingsNode (child_node))
								dependentFunction ();
							break;
					}
				}
			}// LOADXML
		}
		
		/*
		 * Takes given time and return the equivalent value in seconds. 
		 *
		 * @param time_str 									String
		 * @return seconds									Number
		 */
		public static function timeToSeconds (time_str:String):Number 
		{
			var seconds:Number = 0;
			var value_index:Number;
	
			var time_array:Array = time_str.split (":");
			
			if (time_array.length == 1) 
			{
				var unit:String = time_str.slice (-1);
				switch (unit) 
				{
					case "h" : // hours
						value_index = 2;
						seconds = Number (time_str.slice (0, -1));
						break;
					case "m" : // minutes
						value_index = 1;
						seconds = Number (time_str.slice (0, -1));
						break;
					case "s" : // seconds
						value_index = 0;
						seconds = Number (time_str.slice (0, -1));
						break;
					default :
						value_index = 0;
						seconds = Number (time_str);
						break;
				}
				seconds *= TIME_VALUES[value_index];
			} // IF
			else {
				// Time Format
				for (var i:Number = 0; i < time_array.length; i++) {
					value_index = time_array.length - 1 - i;
					seconds += Number (time_array[i]) * TIME_VALUES[value_index];
				}
			}
			return seconds;
		}
		
		/*
		 * Converts a given string into a boolean value
		 *
		 * @param boolean 								String
		 * @return true when value is "1" or "true"
		 * @return false when value is "0" or "false"
		 */
		public static function stringToBoolean (boolean:String):Boolean {
			return (boolean == "1" || boolean.toLowerCase () == "true");
		}
		
		/*
		 * Parses given node, and calls on respective methods to retrieve the information. 
		 *
		 * @see addMetaNode [method]
		 * @see addPlaybackNode [method]
		 * @see addContentNode [method]
		 * @see addEmotionsNode [method]
		 * @param root_node 								XMLNode
		 * @return true upon completion
		 */
		private function parseSettingsNode (root_node:XMLNode):Boolean 
		{
			for (var child_node:XMLNode = root_node.firstChild; child_node != null; child_node = child_node.nextSibling) {
				switch (child_node.nodeName) 
				{
					case NODE_META :
						addMetaNode (child_node);
						break;
					case NODE_PLAYBACK :
						addPlaybackNode (child_node);
						break;
					case NODE_SKIN :
						addSkinNode (child_node);
						break;
					case NODE_CONTENT :
						addContentNode (child_node);
						break;
					case NODE_EMOTIONS :
						addEmotionsNode (child_node);
						break;
				}
			}
			return true;
		}
		
		/*
		 * Stores the node information to a variable
		 *
		 * @param meta_node 								XMLNode
		 */
		private function addMetaNode(meta_node:XMLNode) {
			switch (meta_node.attributes.name) {
				case "base" :
					this.metaBase = meta_node.attributes.content;
					break;
			}
		}
		
		/*
		 * Sets playback properties
		 *
		 * @param playback_node 					XMLNode
		 */
		private function addPlaybackNode (playback_node:XMLNode) {
			this.autoPlay = stringToBoolean (playback_node.attributes.autoPlay);
			this.autoRewind = stringToBoolean (playback_node.attributes.autoRewind);
			this.seek = timeToSeconds (playback_node.attributes.seek);
			
		/* Attributes not used.
			this.autoSize = stringToBoolean (playback_node.attributes.autoSize);
			this.width = Number (playback_node.attributes.width);
			this.height = Number (playback_node.attributes.height);
		*/
			this.scale = Number (playback_node.attributes.scale);
			this.volume = Number (playback_node.attributes.volume);
			this.showCaptions = stringToBoolean (playback_node.attributes.showCaptions);
		}
		
		/*
		 * Sets skin properties
		 *
		 * @param skin_node 						XMLNode
		 */
		private function addSkinNode (skin_node:XMLNode) {
			this.skin = skin_node.attributes.src;
			this.skinAutoHide = stringToBoolean (skin_node.attributes.skinAutoHide);
			this.skinFadeTime = Number (skin_node.attributes.skinFadeTime);
			this.skinBackgroundAlpha = Number (skin_node.attributes.skinBackgroundAlpha);
			this.skinBackgroundColour = parseInt (skin_node.attributes.skinBackgroundColour, 16);
		}
		
		/*
		 * Retrieves dialogue, speaker & video sources from file. 
		 *
		 * @param content_node 						XMLNode
		 */
		private function addContentNode (content_node:XMLNode) {
			for (var child_node:XMLNode = content_node.firstChild; child_node != null; child_node = child_node.nextSibling) {
				switch (child_node.nodeName) {
					case NODE_SPEAKERS :
						this.contentSpeakers = child_node.attributes.src;
						break;
					case NODE_CAPTIONS :
						this.contentCaptions = child_node.attributes.src;
						break;
					case NODE_VIDEO :
						this.contentVideo = child_node.attributes.src;
						break;
				}
			}
		}
		
		/*
		 * Retrieves dialogue, speaker & video sources from file. 
		 *
		 * @param content_node 						XMLNode
		 */
		private function addEmotionsNode (emotion_node:XMLNode) {
			for (var child_node:XMLNode = emotion_node.firstChild; child_node != null; child_node = child_node.nextSibling) {
				switch (child_node.nodeName) {
					case NODE_HAPPY :
						this.happyParams = getParams (child_node);
						break;
					case NODE_SAD :
						this.sadParams = getParams (child_node);
						break;
					case NODE_FEAR :
						this.fearParams = getParams (child_node);
						break;
					case NODE_ANGER :
						this.angerParams = getParams (child_node);
						break;
				}
			}
		}
		
		/*
		 * Retrieves values for each emotion and stores it in an Object container. 
		 *
		 * @param root_node 													XMLNode
		 * @return params (object containing the values for tween animations)	Object
		 */
		private function getParams (root_node:XMLNode):Object {
			var params:Object = new Object ();
	
			var intensity_str:String;
			var intensity_array:Array;
			
			var count:Number = 0;
	
			for (var child_node:XMLNode = root_node.firstChild; child_node != null; child_node = child_node.nextSibling) {
				if (child_node.nodeName == NODE_PARAM) {
					intensity_str = child_node.attributes.value;
					intensity_array = intensity_str.split (",");
					params[child_node.attributes.name] = intensity_array;
				}
			}
			return params;
		}
		
		//***********************************************************************
		// GET METHODS
		// Playback
		
		/*
		 * Returns autoplay property
		 * @return seek				Boolean
		 */
		public function getAutoPlay():Boolean {
			return this.autoPlay;
		}
		
		/*
		 * Returns autorewind property
		 * @return autoRewind		Boolean
		 */
		public function getAutoRewind():Boolean {
			return this.autoRewind;
		}
		
	/*	Not used.
		public function getAutoSize ():Boolean {
			return this.autoSize;
		}
		public function getWidth ():Number {
			return this.width;
		}
		public function getHeight ():Number {
			return this.height;
		}
		public function getScale ():Number {
			return this.scale;
		}
	*/
		
		/*
		 * Returns seek value
		 * @return seek		Number
		 */
		public function getSeek():Number {
			return this.seek;
		}
		
		/*
		 * Returns volume value 
		 * @return volume		Number
		 */
		public function getVolume():Number {
			return this.volume;
		}
		/*
		 * Returns boolean value to indicate if captions should be displayed 
		 * @return true	to display captions
		 * @return false for no caption display
		 */
		public function getShowCaptions():Boolean {
			return this.showCaptions;
		}
		
//	 Skin attributes not used
	
		public function getSkin ():String {
			if (this.skin == "")
				return "";
				
			return this.metaBase + this.skin;
		}
		public function getSkinAutoHide ():Boolean {
			return this.skinAutoHide;
		}
		public function getSkinFadeTime ():Number {
			return this.skinFadeTime;
		}
		public function getSkinBackgroundAlpha ():Number {
			return this.skinBackgroundAlpha;
		}
		public function getSkinBackgroundColour ():Number {
			return this.skinBackgroundColour;
		}
	
		
		// Content
		/*
		 * Returns the path of the speakers file.
		 * @return contentSpeakers		String
		 */
		public function getContentSpeakers():String {
			return this.contentSpeakers;
		}
		/*
		 * Returns the path of the captions (dialogues) file.
		 * @return contentCaptions		String
		 */
		public function getContentCaptions():String {
			return this.contentCaptions;
		}
		/*
		 * Returns the path of the video file.
		 * @return contentVideo			String
		 */
		public function getContentVideo():String {
			return this.contentVideo;
		}
		
		// Emotions
		/*
		 * Returns happy parameters 
		 * @return happyParams			Object
		 */
		public function getHappyParams ():Object {
			return this.happyParams;
		}
		/*
		 * Returns sad parameters 
		 * @return sadParams			Object
		 */
		public function getSadParams ():Object {
			return this.sadParams;
		}
		
		/*
		 * Returns fear parameters 
		 * @return fearParams			Object
		 */
		public function getFearParams ():Object {
			return this.fearParams;
		}
		
		/*
		 * Returns anger parameters 
		 * @return angerParams			Object
		 */
		public function getAngerParams ():Object {
			return this.angerParams;
		}
	} // SETTINGS CLASS
} // PACKAGE
