package  {
	import flash.xml.XMLNode;
	import flash.xml.XMLDocument;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class Speakers {
		
		public static var NODE_SPEAKERS:String = "speakers";
		public static var NODE_SPEAKER:String = "speaker";
		public static var NODE_BACKGROUND:String = "background";
		public static var NODE_FONT:String = "font";
		//public static var DEFAULT_SPEAKER:String = "default";
		
		private var speakers_array:Array; 
		
		/*
		 * Parses children nodes (speaker nodes) from Speakers.xml file.
		 *
		 * @see parseAllSpeakersNode		[method]
		 * @param fileName					String
		 * @param dependentFunction			Function
		 */
		public function Speakers(fileName:String, dependentFunction:Function) 
		{
			var thisClass:Speakers = this;
			this.speakers_array = new Array ();
			
			var xmlString:URLRequest = new URLRequest(fileName);
			var xmlLoader:URLLoader = new URLLoader(xmlString);
			xmlLoader.addEventListener(Event.COMPLETE, LoadXML);
			
			// Read in the XML file
			function LoadXML(e:Event):void 
			{
				var speakers_doc:XMLDocument = new XMLDocument();
				var speakers_xml:XML = XML(e.target.data);
				speakers_doc.parseXML(speakers_xml.toXMLString());
				
				for (var child_node:XMLNode = speakers_doc.firstChild; child_node != null; child_node = child_node.nextSibling) {
					switch (child_node.nodeName) 
					{
						case NODE_SPEAKERS:
							if (thisClass.parseAllSpeakersNode (child_node)) {
								//addDefaultSpeaker ();
								dependentFunction ();
							}
							break;
					}
				}
			}
		}

		/*
		 * Parses children nodes (speaker nodes)
		 *
		 * @see parseOneSpeakerNode		[method]
		 * @param root_node				XMLNode
		 * @return true
		 */
		private function parseAllSpeakersNode (root_node:XMLNode):Boolean {
			for (var child_node:XMLNode = root_node.firstChild; child_node != null; child_node = child_node.nextSibling) {
				switch (child_node.nodeName) {
					case NODE_SPEAKER:
						parseOneSpeakerNode (child_node);
						break;
				}
			}
			return true;
		}
		
		/*
		 * Extracts background & font properties from an individual speaker nodes
		 *
		 * @see addSpeaker 				[method]
		 * @param root_node				XMLNode
		 */
		private function parseOneSpeakerNode (root_node:XMLNode):void {
			var background_node:XMLNode;
			var font_node:XMLNode;
			
			for (var child_node:XMLNode = root_node.firstChild; child_node != null; child_node = child_node.nextSibling) {
				switch (child_node.nodeName) {
					case NODE_BACKGROUND:
						background_node = child_node;
						break;
					case NODE_FONT:
						font_node = child_node;
						break;
				}
			}
			addSpeaker (root_node.attributes.name, background_node, font_node);
		}
		
		/*
		 * Adds speaker object to the array.
		 *
		 * @param speakerName					String
		 * @param background_node				XMLNode
		 * @param font_node						XMLNode
		 */
		private function addSpeaker (speakerName:String, background_node:XMLNode, font_node:XMLNode):void {
			// Background
			var backgroundParams:Object = {
				visible: background_node.attributes.visible,
				alpha: background_node.attributes.alpha,
				colour: background_node.attributes.colour
			};

			// Font
			var fontParams:Object = {
				name: font_node.attributes.name,
				size: font_node.attributes.size,
				colour: font_node.attributes.colour,
				bold: font_node.attributes.bold
			};
			this.speakers_array.push (new Speaker (speakerName, backgroundParams, fontParams));
		}
		
	/*
		private function addDefaultSpeaker ():void {
			// Background
			var backgroundParams:Object = {
				visible: "true",
				alpha: "0",
				colour: "0x000000"
			};

			// Font
			var fontParams:Object = {
				name: "Trebuchet MS",
				size: "14",
				colour: "0xFFFFFF",
				bold: "true"
			};
			this.speakers_array.push (new Speaker (DEFAULT_SPEAKER, backgroundParams, fontParams));
		}
	*/
	
		//******************************************************************************
		
		/*
		 * Returns speaker names.
		 *
		 * @param speakerName					String
		 * @return speakers						Speaker
		 */
		public function getSpeakerName (speakerName:String):Speaker {			
			var speaker:Speaker;
	
			for (var i:Number = 0; i < this.speakers_array.length; i++) {
				speaker = this.speakers_array[i];

				if ((speakerName.slice(-8,speakerName.length)).match("(CONT'D)"))
					speakerName = speakerName.slice(0,(speakerName.length-9));
				else if (speaker.getSpeaker().match(speakerName))
					break;
			}
			return speaker;
		}
		/*
		 * Returns number of speakers.
		 *
		 * @return speakers_array.length		Number
		 */
		public function length ():Number {
			return this.speakers_array.length;
		}
		
	} // SPEAKERS CLASS
} // PACKAGE
