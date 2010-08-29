package {
	
	import SWFAddress;
	import SWFAddressEvent;
	import flash.external.ExternalInterface;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.text.*;
	import ScreenBox;
	import ApplicationScreen;
	import BarItem;
	
	public class SubBarItem extends flash.display.MovieClip
	{
		//
		// global variables
		//
		public var ScreenBoxY:Number = 190;
		public var ScreenBoxX:Number = 150;
		
		public var caption:String;
		public var target:String; 
		
		public var subItems:Array;
		
		public var myScreen:ScreenBox;
		private var isNotGallery:Boolean = true;
		public var parentName:String = new String();
		
		public function SubBarItem()
		{
			init();
		}
		// listeners
		public function init()
		{
			// initialize

			// instatiate listeners
			this.addEventListener(MouseEvent.MOUSE_OVER,	onMouseOver); 	// listen for move over
			this.addEventListener(MouseEvent.MOUSE_OUT,		onMouseOut); 	// listen for move over
			highlight.addEventListener(MouseEvent.CLICK,	onMouseClick); 	// listen for move over
			c_Caption.addEventListener(MouseEvent.CLICK,	onMouseClick); 	// listen for move over
			bottom2.visible = false;
			
		}
		
		public function setCaption(s:String):void
		{
			highlight.visible = false;
			caption = s;
			c_Caption.text = s;
		}
		
		public function setupGallery(l:String,s:String):void
		{
			target = l;
			myScreen = new ScreenBox();
			if(this.parent is ApplicationScreen)
			{
				this.parent.addChild(myScreen);
			}
			else if(this.parent.parent is ApplicationScreen)
			{
				this.parent.parent.addChild(myScreen);
			}
			myScreen.x = ScreenBoxX;
			myScreen.y = ScreenBoxY;
			myScreen.alpha = 0.0;
			myScreen.visible = false;
			isNotGallery = false;
			myScreen.convertToGallery(l);
			
			if(target.length >= 1) // not empty
			{
				// try to load the page
				var pageXMLLoader:URLRequest = new URLRequest(s);
				var pageURLLoader:URLLoader = new URLLoader(pageXMLLoader);
				pageURLLoader.addEventListener(Event.COMPLETE,targetLoaded);
				pageURLLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
				pageURLLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				pageURLLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			}
			
			if(SWFAddress.getValue().replace(/\//g,"") == caption) // if my tab is set and I just loaded my screen
			{
				// all tabs are ready, so load up the SWF page
				ExternalInterface.call("console.log", "resetting to " + SWFAddress.getValue());
				showScreen();
			}
		}
		
		public function setLink(s:String):void
		{
			target = s;
			if(target != null && target.length >= 1 && target == "login") // is a login
			{
				myScreen = new ScreenBox();
				if(this.parent is ApplicationScreen)
				{
					this.parent.addChild(myScreen);
				}
				else if(this.parent.parent is ApplicationScreen)
				{
					this.parent.parent.addChild(myScreen);
				}
				myScreen.x = ScreenBoxX;
				myScreen.y = ScreenBoxY;
				myScreen.alpha = 0.0;
				myScreen.visible = false;
				myScreen.convertToLogin(); // make the login screen
				
			}
			else if(target.length >= 1) // not empty
			{
				// try to load the page
				var pageXMLLoader:URLRequest = new URLRequest(target);
				var pageURLLoader:URLLoader = new URLLoader(pageXMLLoader);
				pageURLLoader.addEventListener(Event.COMPLETE,targetLoaded);
				pageURLLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
				pageURLLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				pageURLLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			}
		}
		
		protected function httpStatusHandler (e:HTTPStatusEvent):void {
			//Just fail already!
			ExternalInterface.call("console.log", "httpStatusHandler:" + e +" -->status: " + e.status);
		}
			
		protected function securityErrorHandler (e:SecurityErrorEvent):void {
			//Just fail already!
			ExternalInterface.call("console.log", "securityErrorHandler:" + e);
		}
			
		protected function ioErrorHandler(e:IOErrorEvent):void {
			//Just fail already!
			ExternalInterface.call("console.log", "ioErrorHandler: " + e);
		}
		
		public function targetLoaded(e:flash.events.Event):void
		{
			if(isNotGallery){
				myScreen = new ScreenBox();
			}
			
			if(this.parent is ApplicationScreen)
			{
				this.parent.addChild(myScreen);
			}
			else if(this.parent.parent is ApplicationScreen)
			{
				this.parent.parent.addChild(myScreen);
			}
			myScreen.x = ScreenBoxX;
			myScreen.y = ScreenBoxY;
			myScreen.alpha = 0.0;
			myScreen.visible = false;
			//ExternalInterface.call("console.log", (myScreen);
			
			// load the XML file
			try{
				   
				// load the XML
				var XMLFile:XML = new XML();
				XMLFile = new XML(e.target.data);
	
				if(XMLFile.@type == "categories") // for a list of categories
				{
					// get all the bar items into a list
					var list:XMLList = XMLFile.child("category");
					if(isNotGallery){
						myScreen.convertToCats();
					}
					
					// for each option in the list
					for(var i=0; i<list.length(); i++){
						var categoryTitle:String = new String();
						if(list[i].@type == "page")
						{
							var htmlpage:XML = list[i];
							myScreen.addCategory(list[i].@name, htmlpage);
						}
						if(list[i].@type == "gallery")
						{
							myScreen.setSectionTitle(list[i].@name);
							if("@subheader" in list[i])
							{
								myScreen.setSubTitle(list[i].@subheader);
								myScreen.hasSubTitle = true;
							}
							myScreen.addGalleryCategory(list[i].@name, list[i].@location);
						}
					}
				}
				else if (XMLFile.@type == "page")
				{
					myScreen.convertToPage();
					myScreen.secretText = XMLFile.toXMLString();
					if(XMLFile.child("secret") != null)
					{
						delete XMLFile.secret;
					}
					myScreen.htmlText.htmlText = XMLFile.toXMLString();
					// set it up as a page
					myScreen.htmlText.x = 30; // set x pos
					myScreen.htmlText.width = 660; // increase width
				}
				
				if(SWFAddress.getValue().replace(/\//g,"") == caption) // if my tab is set and I just loaded my screen
				{
					// all tabs are ready, so load up the SWF page
					ExternalInterface.call("console.log", "resetting to " + SWFAddress.getValue());
					showScreen();
				}
				
				
			} catch (e:TypeError){
				//Could not convert the data, probavlu because
				//because is not formated correctly
				ExternalInterface.call("console.log", "ScreenBox could not parse the XML");
				ExternalInterface.call("console.log", e.message);
			};
			//ExternalInterface.call("console.log", (myScreen);
		}
		
		// add a sub item to this bar
		public function addSubBarItem(item:BarItem):void
		{
			if(this.subItems == null)
			{
				this.subItems = new Array();
			}
			this.addChild(item); // add to this clip
			var i:Number = subItems.length;
			item.x = i*99;
			item.y = 19;
			item.alpha = 0.0;
			item.visible = false;
			this.subItems.push(item); // add as a sub menu
			//ExternalInterface.call("console.log", (myScreen);
			
		}
		
		public function onMouseOver(e:flash.events.MouseEvent):void
		{
			if(this.subItems == null)
			{
				this.subItems = new Array();
			}
			// show each sub item
			highlight.visible = true;
			for(var i=0; i<this.subItems.length; i++)
			{
				if(subItems[i] is BarItem)
				{
					subItems[i].easeIn();
				}
			}
			//ExternalInterface.call("console.log", "Showed " + this.subItems.length + " items and " + this.numChildren + " children");			   
		}
		
		public function onMouseOut(e:flash.events.MouseEvent):void
		{
			//ExternalInterface.call("console.log", "MouseOut");
			if(this.subItems == null)
			{
				this.subItems = new Array();
			}
			highlight.visible = false;
			for(var i=0; i<this.subItems.length; i++)
			{
				if(subItems[i] is BarItem)
				{
					subItems[i].easeOut();
				}
			}
			//ExternalInterface.call("console.log", "Hid " + this.subItems.length + " items and " + this.numChildren + " children");	
		}
		
		public var easeFrames:Number = 14.0;
		
		public function easeIn()
		{
			this.visible = true;
			this.removeEventListener(Event.ENTER_FRAME,easeOutAnimation);
			this.addEventListener(Event.ENTER_FRAME,easeInAnimation);
		}
		
		public function easeInAnimation(e:Event)
		{
			e.target.alpha += (1.0 / easeFrames);
			e.target.y += 1;
		 
			if (e.target.alpha >= 1.0) 
			{
				e.target.alpha = 1.0;
				e.target.y = 33;
				e.target.removeEventListener(Event.ENTER_FRAME, easeInAnimation);
			}
		}
		
		public function zeroitem()
		{
			bottom.visible = false;
			bottom2.visible = true;
		}
		
		public function fadeInAnimation(e:Event)
		{
			e.target.alpha += (1.0 / easeFrames);
		 
			if (e.target.alpha >= 1.0) 
			{
				e.target.alpha = 1.0;
				e.target.removeEventListener(Event.ENTER_FRAME, fadeInAnimation);
			}
		}
		
		public function easeOut()
		{
			this.visible = true;
			this.removeEventListener(Event.ENTER_FRAME,easeInAnimation);
			this.addEventListener(Event.ENTER_FRAME,easeOutAnimation);
		}
		
		public function easeOutAnimation(e:Event)
		{
			e.target.alpha -= (1.0 / easeFrames);
			e.target.y -= 1;
			if(e.target.alpha <= 0.0)
			{
				e.target.alpha = 0.0;
				e.target.y = 19;
				e.target.visible = false;
				e.target.removeEventListener(Event.ENTER_FRAME,easeOutAnimation);
			}
		}
		public function fadeOutAnimation(e:Event)
		{
			e.target.alpha -= (1.0 / easeFrames);
			if(e.target.alpha <= 0.0)
			{
				e.target.alpha = 0.0;
				e.target.visible = false;
				e.target.removeEventListener(Event.ENTER_FRAME,fadeOutAnimation);
			}
		}
		
		public function onMouseClick(e:flash.events.MouseEvent):void
		{
			// fade Juju butterfly
			if (parentName)
			{
				SWFAddress.setValue("/" + parentName + "/" + caption + "/");
			}
			else
			{
				SWFAddress.setValue("/" + caption + "/");
			}
			showScreen();
		}
		
		public function showScreen()
		{
			ExternalInterface.call("console.log", myScreen + " for " + caption);
			ExternalInterface.call("console.log", "this.parent " + parentName);
			ExternalInterface.call("console.log", "resetting to " + SWFAddress.getValue());
			ExternalInterface.call("console.log", "setting SWFAddress");
			
			var ar:ApplicationScreen;
			
			if(this.parent is ApplicationScreen)
			{
				ar = this.parent;
			}
			else
			{
				ar = this.parent.parent;
			}
			for( var i=0; i < ar.numChildren; i++)
			{
				if(ar.getChildAt(i) is ScreenBox)
				{
					if(ar.getChildAt(i).visible == true)
					{
						ar.getChildAt(i).addEventListener(Event.ENTER_FRAME, fadeOutAnimation);
					}
				}
			}
			if(myScreen != null)
			{
				if(this.parent.parent.parent is jujuDocument)
				{
					this.parent.parent.parent.fadeOutSumptuous();
				}
				myScreen.parent.setChildIndex(myScreen,0);
			
				myScreen.visible = true;
				myScreen.removeEventListener(Event.ENTER_FRAME, fadeOutAnimation);
				myScreen.addEventListener(Event.ENTER_FRAME, fadeInAnimation);
				myScreen.activateFirstCategory();
				return true;
			}
			else
			{
				ExternalInterface.call("console.log", "gohome");
				this.parent.parent.parent.fadeInHome();
				ExternalInterface.call("console.log", "gohome B");
				return false;
			}
		}
	}
}