package  {
	import flash.xml.XMLNode;
	import flash.xml.XMLDocument;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class Captions {
		public static var NODE_CAPTIONS:String = "captions";
		public static var NODE_CAPTION:String = "caption";
		public static var NODE_EMOTION:String = "emotion";
		public static var NODE_TEXT:String = "text";
	
		public static var CAPTION_MAX_SECONDS:Number = 15;
		
		private var captions_array:Array;

		/*
		 * Parses the given caption file and calls on appropriate method to handle children nodes.
		 * Upon completion, the dependentFunction is executed.
		 *
		 * @see parsecaptionsNode 		[method]
		 * @param fileName				String
		 * @param dependentFunction		Function
		 */
		public function Captions(fileName:String, dependentFunction:Function) {
			var thisClass:Captions = this;
			this.captions_array = new Array ();
			
			var xmlString:URLRequest = new URLRequest(fileName);
			var xmlLoader:URLLoader = new URLLoader(xmlString);
			xmlLoader.addEventListener(Event.COMPLETE, LoadXML);
			
			function LoadXML(e:Event):void {
				var captions_doc:XMLDocument = new XMLDocument();
				var captions_xml:XML = XML(e.target.data);
				captions_doc.parseXML(captions_xml.toXMLString());
				
				for (var child_node:XMLNode = captions_doc.firstChild; child_node != null; child_node = child_node.nextSibling) 
				{
					switch (child_node.nodeName) {
						case NODE_CAPTIONS :
							if (thisClass.parseCaptionsNode (child_node))
								dependentFunction ();
							break;
					}
				}
			}; //LOADXML
		}
		
		/*
		 * Parses given information, retrieves dialogue.
		 *
		 * @see addCaption								[method]
		 * @param root_node	(child node of file)		XMLNode
		 * @return true when method is done executing.
		 */
		private function parseCaptionsNode (root_node:XMLNode):Boolean {
			for (var child_node:XMLNode = root_node.firstChild; child_node != null; child_node = child_node.nextSibling) {
				switch (child_node.nodeName) {
					case NODE_CAPTION :
						addCaption (child_node);
						break;
				}
			}
			return true;
		}
		
		/*
		 * Parsed captions get added to the caption array. 
		 *
		 * @see timeToSeconds								[method]
		 * @see Caption										[class]
		 * @param caption_node	(child node of file)		XMLNode
		 */
		private function addCaption (caption_node:XMLNode):void 
		{
			var captionBegin:Number = Settings.timeToSeconds (caption_node.attributes.begin);
			var captionEnd:Number;
			
			if (caption_node.attributes.end != null) 
				captionEnd = Settings.timeToSeconds (caption_node.attributes.end);
			else if (caption_node.attributes.dur != null)
				captionEnd = captionBegin + Settings.timeToSeconds (caption_node.attributes.dur);
			else 
				captionEnd = captionBegin + CAPTION_MAX_SECONDS;
			
			var captionDuration:Number = captionEnd - captionBegin;

			var captionText:String = "";
			for (var emotion_node:XMLNode = caption_node.firstChild; emotion_node != null; emotion_node = emotion_node.nextSibling) 
			{
				if (emotion_node.nodeName == NODE_EMOTION)
					captionText += emotion_node.firstChild.nodeValue + " ";
			}
			var caption_array:Array = captionText.split (" ");
			captionText = captionText.slice (0, -1);
			var charactersTotal:Number = captionText.length - caption_array.length;
			
			// Caption Object 
			var captionParams:Object = {
				begin: captionBegin, 
				end: captionEnd, 
				speaker: caption_node.attributes.speaker, 
				location: caption_node.attributes.location, 
				align: caption_node.attributes.align, 
				text: captionText
			};
			
			var emotions_array:Array = new Array ();
			var charactersCount:Number = 0;
			var text_array:Array;
			var emotionText:String;
			var begin:Number;
			
			for (var emotion_node:XMLNode = caption_node.firstChild; emotion_node != null; emotion_node = emotion_node.nextSibling) 
			{
				if (emotion_node.nodeName == NODE_EMOTION) 
				{
					emotionText = emotion_node.firstChild.nodeValue;
					text_array = emotionText.split (" ");
					
					for (var index:Number = 0; index < text_array.length; index++) 
					{
						begin = (charactersCount / charactersTotal) * (captionDuration * 0.5);
						emotions_array.push (new Emotion (emotion_node.attributes.type, Number (emotion_node.attributes.intensity), captionBegin + begin, text_array[index]));
						charactersCount += text_array[index].length - index;
					}
				}
			}
			this.captions_array.push (new Caption (captionParams, emotions_array));
		}
		
		//***************************************************
		
		/*
		 * Returns caption at the given index.
		 * 
		 * @param index								Number
		 * @return captions_array[index]			Caption
		 */
		public function getCaption (index:Number):Caption {
			return this.captions_array[index];
		}
		/*
		 * Returns number of captions (lines).
		 * 
		 * @return captions_array.length			Number
		 */
		public function length ():Number {
			return this.captions_array.length;
		}
	} // CAPTIONS CLASS
} // PACKAGE
