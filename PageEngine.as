package {
	import flash.external.ExternalInterface;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.text.*;
	import ScreenBox;
	
	
	public class PageEngine extends Sprite
	{

		private var ScreenBoxY:Number = 175;
		private var ScreenBoxX:Number = 150;
		//private var myScreen:ScreenBox = new ScreenBox();
		private var pageName:String = new String();
		
		public function PageEngine(){}
		
		public function generatePages(list:XMLList)
		{
			for each (var opt:XML in list)
			{
				if(opt.attribute("type") != null && opt.attribute("type") == "gallery")
				{
					createPageFromGallery(opt.attribute("title"),opt.attribute("gallerylink"),opt.attribute("link"));
				}
				else
				{
					if (opt.attribute("link").length() > 0){
						createPageFromLink(opt.attribute("title"),opt.attribute("link"));
					}
				}
				if(opt.option.length() > 0)
				{
					listB = createSubItem( opt.attribute("title"),(opt.option as XMLList),1);
				}
			}
		}
		
		private function createSubItem(par:String, listB:XMLList,c:Number):XMLList
		{
			var count:Number = c;
			var itemCount:Number = 0;
			for each (var opt:XML in listB)
			{
				if(opt.attribute("type") != null && opt.attribute("type") == "gallery")
				{
					createPageFromGallery(opt.attribute("title"),opt.attribute("gallerylink"),opt.attribute("link"));
				}
				else
				{
					if (opt.attribute("link").length() > 0)
					{
						createPageFromLink(opt.attribute("title"),opt.attribute("link"));
					}
				}
				try
				{
					count++
					listB = createSubItem(opt.attribute("title"),(opt.option as XMLList),count);
				} 
				catch(e:Error)
				{
					//return null;
				}
				itemCount++;
			}
			return null
		} 
		
		private function generatePage():ScreenBox
		{
			var myScreen:ScreenBox = new ScreenBox();
				myScreen.x = ScreenBoxX;
				myScreen.y = ScreenBoxY;
				myScreen.visible = false;
				this.addChild(myScreen);
				myScreen.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownDrag);
				myScreen.addEventListener(MouseEvent.MOUSE_UP, onMouseUpDrag);
			return myScreen
		}
		
		public function createPageFromGallery(ti:String,l:String,link:String):void
		{
			var generated:ScreenBox = generatePage();
			generated.name = ti+"_screen";
			target = l;

			generated.convertToGallery(l);
			
			
			//if(SWFAddress.getValue().replace(/\//g,"") == caption) // if my tab is set and I just loaded my screen
			//{
			//	// all tabs are ready, so load up the SWF page
			//	ExternalInterface.call("console.log", "resetting to " + SWFAddress.getValue());
			//	showScreen();
			//}
		}
		
		public function createPageFromLink(ti:String,link:String):void
		{
			var generated:ScreenBox = generatePage();
			generated.name = ti+"_screen";
				if(ti == "Login") // is a login
				{
					generated.convertToLogin(); // make the login screen
					//generated.visible = false
					//generated.loginbox.barButton = this; // offer reverse reference, so the loginscreen can change the button's title
				
				}
				else if(ti == "Contact Us") // is a login
				{
					generated.convertToContact(); // make the contact
				}
				else
				{
				// try to load the page
				var pageXMLLoader:URLRequest = new URLRequest(link);
				var pageURLLoader:URLLoader = new URLLoader(pageXMLLoader);
					pageURLLoader.addEventListener(Event.COMPLETE,targetLoaded);
					pageURLLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
					pageURLLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
					pageURLLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				}
		}
		
		private function onMouseDownDrag(event:MouseEvent):void{
			this.startDrag();
			trace("login: "+this.name+" : "+this.parent.name);
		}
		
		private function onMouseUpDrag(event:MouseEvent):void{
			this.stopDrag();
		}
		
		protected function httpStatusHandler (e:HTTPStatusEvent):void {
			//trace("httpStatusHandler:" + e +" -->status: " + e.status);
		}
			
		protected function securityErrorHandler (e:SecurityErrorEvent):void {
			//trace("securityErrorHandler:" + e);
		}
			
		protected function ioErrorHandler(e:IOErrorEvent):void {
			//trace("ioErrorHandler: " + e);
		}
		
		public function targetLoaded(e:Event):void
		{
			var getFirstText:Boolean = true;
			var XMLFile:XML = new XML();
				XMLFile.ignoreWhitespace = true;
				XMLFile = new XML(e.target.data);

			if (XMLFile.attribute("title").length()>0)
			{
				var myScreen:ScreenBox = this.getChildByName(XMLFile.attribute("title")+"_screen");
				if(XMLFile.attribute("type") == "categories") // for a list of categories
				{
						if(XMLFile.pageText != null)
						{
							myScreen.htmlText.htmlText = XMLFile.pageText.toString();
							if(XMLFile.pageText.attribute("title").length()>0)
							{
								myScreen.setSectionTitle(XMLFile.pageText.attribute("title"));
							}
							getFirstText = false;
						}
						
						// get all the bar items into a list
						var list:XMLList = XMLFile.category;
						myScreen.convertToCats();

						for each (var opt:XML in list)
						{
							if(getFirstText)
							{
								myScreen.htmlText.htmlText = opt.toString();
								myScreen.setSectionTitle(opt.attribute("name"))
								getFirstText = false;
							}
							var categoryTitle:String = new String();
							if(opt.attribute("type") == "page")
							{
								myScreen.addCategory(opt.attribute("name"),opt);
							}
							if(opt.attribute("type") == "gallery")
							{
								if(opt.attribute("subheader").length()>0)
								{
									myScreen.setSubTitle(opt.attribute("subheader"));
									myScreen.hasSubTitle = true;
								}
								myScreen.addGalleryCategory(opt.attribute("name"),opt.attribute("location"));
							}
						}
					}
					else if (XMLFile.attribute("type") == "about")
					{
						myScreen.convertToAbout(XMLFile.attribute("location"));
						//myScreen.secretText = XMLFile.toXMLString();
						if(XMLFile.secret != null)
						{
							delete XMLFile.secret;
						}
						myScreen.htmlText.htmlText = XMLFile.toXMLString();
						// set it up as a page
					}
					else if (XMLFile.attribute("type") == "page")
					{
						myScreen.convertToPage();
						myScreen.secretText = XMLFile.toXMLString();
						if(XMLFile.child("secret") != null)
						{
							delete XMLFile.secret;
						}
						myScreen.htmlText.htmlText = XMLFile.toXMLString();
						myScreen.htmlText.x = 0;
						//myScreen.htmlText.x = 30; // set x pos
						myScreen.htmlText.width = 630; // increase width
						
					}
					//if(SWFAddress.getValue().replace(/\//g,"") == caption) // if my tab is set and I just loaded my screen
					//{
					//	// all tabs are ready, so load up the SWF page
					//	ExternalInterface.call("console.log", "resetting to " + SWFAddress.getValue());
					showHide(myScreen);
					//}
			}
		}
		
		
		
		public function onMouseOver(e:flash.events.MouseEvent):void
		{
			if(this.subItems == null)
			{
				this.subItems = new Array();
			}
			// show each sub item
			highlight.visible = true;
			c_CaptionB.visible = true;
			c_Caption.visible = false;
			for(var i=0; i<this.subItems.length; i++)
			{
				if(subItems[i] is SubBarItem)
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
			c_Caption.visible = true;
			c_CaptionB.visible = false;
			for(var i=0; i<this.subItems.length; i++)
			{
				if(subItems[i] is SubBarItem)
				{
					subItems[i].easeOut();
				}
			}
			//ExternalInterface.call("console.log", "Hid " + this.subItems.length + " items and " + this.numChildren + " children");	
		}
		
		public var easeFrames:Number = 10.0;
		
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
				e.target.y = 25;
				e.target.removeEventListener(Event.ENTER_FRAME, easeInAnimation);
			}
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
				e.target.y = 15;
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
			// if this is a logout, just log them out, don't show anything else
			if(caption == "Logout")
			{
				this.myScreen.loginbox.lc.logout(); // that's all
			}
			else
			{
				// fade Juju butterfly
				SWFAddress.setValue("/" + caption + "/");
				showScreen();
			}
		}
		
		private function cleanScreen():void
		{
			for(var d:Number=0; d<this.numChildren-1; d++)
			{
				if((this.getChildAt(d) is ScreenBox)||
				   (this.getChildAt(d).name=="Contact Us_screen"))
				{
					if(this.getChildAt(d).visible == true)
					{
						trace("out with: "+this.getChildAt(d).name);
						this.getChildAt(d).addEventListener(Event.ENTER_FRAME, fadeOutAnimation);
					}
				}
			}

		}
		
		public function showHide(which:String,vis:Boolean=false):void
		{
			
			cleanScreen()
			try
			{
				this.getChildByName(which);
			}
			catch(e)
			{
				vis = false;
			}
			
			if (vis)
			{
				
				if(this.parent is jujuDocument)
				{
					this.parent.fadeOutSumptuous();
				}
				if (this.getChildByName(which))
				{
					
					this.getChildByName(which).visible = true;
					this.getChildByName(which).removeEventListener(Event.ENTER_FRAME, fadeOutAnimation);
					this.getChildByName(which).addEventListener(Event.ENTER_FRAME, fadeInAnimation);
					ExternalInterface.call("setSEO", this.getChildByName(which).htmlText.htmlText);
			
					//this.getChildByName(which).scrollbar.scrollTarget=this.getChildByName(which).htmlText;
					//this.getChildByName(which).scrollbar.update();
					//this.getChildByName(which).activateFirstCategory();
				}
			}
			else
			{
				if (this.parent != null)
				{
					try
					{
						this.getChildByName(which).visible = false;
					} catch(e){}
					this.parent.fadeInHome();
					if(this.parent.logged > 0)
					{
						this.getChildByName(which).htmlText.htmlText = this.getChildByName(which).secretText;
					}
				}
			}
		}
		

	}
}