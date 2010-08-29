package {
	
	
	import SWFAddress;
	import SWFAddressEvent;
	import flash.external.ExternalInterface;
	//import BarItem;
	import flash.net.*;
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.text.TextField;
	import flash.text.StyleSheet;
	import CategoryButton;
	import flash.display.loader;
	
	public class ScreenBox extends flash.display.MovieClip
	{
		public var categoryList:Array;
		public var imageList:Array;
		public var secretText:String; // secret text
	
		public var styles:StyleSheet;
		public var styleLoader:URLLoader;
		
		public var mainImage:MovieClip;
		public var hasSubTitle:Boolean = false;
		
		public function ScreenBox()
		{
			styles = new StyleSheet();
			styleLoader = new URLLoader();
			styleLoader.addEventListener(Event.COMPLETE,styleLoaded);
			styleLoader.load(new URLRequest("jujustyle.css"));
		}
		public function styleLoaded(e:Event)
		{
			styles.parseCSS(e.target.data);
			htmlText.styleSheet = styles;
			htmlText.multiline = true;
			htmlText.condenseWhite = true;
			//htmlText.html = true;
			htmlText.htmlText = htmlText.htmlText;
			
			
		}
		
		// add categories to this screen
		public function addCategory(cName:String,htmlpage:XML):void
		{
			//trace("Adding category " + cName + " with HTML Content: " + htmlpage);
			if(categoryList == null)
			{
				categoryList = new Array();
			}
			
			// create the category button
			var cb:CategoryButton = new CategoryButton;
			// add it to the category list
			categoryList.push(cb);
			// add it to the view
			this.addChild(cb);
			cb.y = (categoryList.length -1 ) * 30 + 60;
			cb.x = 40;
			
			// create the html area
			cb.setCaption(cName);
			cb.myNode = htmlpage;
			// add it to the view
			
			// give the category list a soft link
			cb.myHTML = htmlText;
			// make it hidden
			
		}
		
		public function activateFirstCategory()
		{
			if(categoryList != null && categoryList.length > 0)
			{
				categoryList[0].onMouseClick(null);
			}
			else
			{
				if(this.parent.parent.parent.logged > 0)
				{
					htmlText.htmlText = secretText;
				}
			}
		}
		
		// add categories to this screen
		public function addGalleryCategory(cName:String,location:String):void
		{
			if(categoryList == null)
			{
				categoryList = new Array();
			}
			
			// create the category button
			var cb:CategoryButton = new CategoryButton;
			// add it to the category list
			categoryList.push(cb);
			// add it to the view
			this.addChild(cb);
			cb.y = (categoryList.length -1 ) * 30 + 60;
			cb.x = 40;
			
			// create the html area
			cb.setCaption(cName);
			cb.myLocation = location;
			// add it to the view
			
			cb.actiontype = 1; // open gallery on click
			strokeBox.visible = true;
			
		}
		
		public function setSectionTitle(s:String):void
		{
			var newFormat:TextFormat = new TextFormat();
			headlines.header.text = s.toUpperCase();
			newFormat.bold = true;
			headlines.header.setTextFormat(newFormat);

		}
		
		public function setSubTitle(s:String):void
		{
			headlines.subheader.text = s;
			//trace("headlines.subheader.text: "+s);
		}
		
		public function convertToPage():void
		{
			strokeBox.visible = false;
			headlines.visible = false;
			htmlText.visible = true;
			scrollbar.visible = true;
			loginbox.visible = false;
			slideShow.visible = false;
			contact.visible = false;
			slideShow2.visible = false;
			htmlText.x = 20;
			htmlText.y = 20;
		}
		
		public function convertToCats():void
		{
			headlines.visible = true;
			headlines.subheader.visible = false;
			htmlText.visible = true;
			scrollbar.visible = true;
			loginbox.visible = false;
			slideShow.visible = false;
			contact.visible = false;
			slideShow2.visible = false;
			slideShow.x = 180;
			slideShow.y = 70;
			slideShow.width = 468;
			slideShow.height = 300;
			htmlText.x = 198;
			strokeBox.visible = false;
			strokeBox.x = slideShow.x - 1;
			strokeBox.y = slideShow.y - 1;
			strokeBox.width = slideShow.width + 2;
			strokeBox.height = slideShow.height + 2;
		}

		public function convertToAbout(s:String):void
		{
			strokeBox.visible = false;
			headlines.visible = true;
			htmlText.visible = true;
			scrollbar.visible = true;
			loginbox.visible = false;
			slideShow.visible = false;
			slideShow2.visible = true;
			contact.visible = false;

			headlines.categories.visible = false;
			headlines.subheader.visible = false;
			headlines.header.x = 268;
			headlines.header.text = "ABOUT US";
			headlines.underlined.x = 268;
			headlines.underlined.width = 346;
			
			var newFormat:TextFormat = new TextFormat();
			newFormat.bold = true;
			headlines.header.setTextFormat(newFormat);
			
			slideShow2.xmlFilePath = s;
			slideShow2.x = 40;
			slideShow2.y = 20;
			slideShow2.width = 242;
			slideShow2.height = 384;
			
			htmlText.x = 292;
			htmlText.y = 60;
			htmlText.width = 326;
			htmlText.height = 344;
		}
		
		/*function showLoaded(e:Event):void
		{
			ExternalInterface.call("console.log", "Monoslideshow Loaded");
			
			monoslideshow = event.target.content;
			monoslideshow.setViewport(new Rectangle(50, 50, 480, 360));
			monoslideshow.loadDataFile("monoslideshow.xml");
			aboutHolder.addChild(e.target);
		}*/
		
		public function convertToLogin():void
		{
			strokeBox.visible = false;
			loginbox.visible = true;
			headlines.visible = false;
			htmlText.visible = false;
			scrollbar.visible = false;
			slideShow.visible = false;
			contact.visible = false;
			slideShow2.visible = false;
		}
		
		public function convertToContact():void
		{
			strokeBox.visible = false;
			loginbox.visible = false;
			headlines.visible = false;
			htmlText.visible = false;
			scrollbar.visible = false;
			slideShow.visible = false;
			contact.visible = true;
			slideShow2.visible = false;
		}
		
		public function convertToGallery(s:String):void
		{
			
			slideShow.visible = true;
			headlines.visible = true;
			headlines.underlined.visible = false;
			if (headlines.subheader.text == "")
			{
				headlines.subheader.visible = false;
				headlines.categories.visible = false;
				slideShow.x = 90 //180;
				slideShow.y = 70;
				slideShow.width = 536; // 468;
				slideShow.height = 300;
			}
			else
			{
				headlines.subheader.visible = true;
				headlines.categories.visible = false;
				slideShow.x = 90 //180;
				slideShow.y = 80;
				slideShow.width = 536 //468;
				slideShow.height = 290;
			}
			strokeBox.visible = true;
			strokeBox.x = slideShow.x - 1;
			strokeBox.y = slideShow.y - 1;
			strokeBox.width = slideShow.width + 2;
			strokeBox.height = slideShow.height + 2;
			loginbox.visible = false;
			htmlText.visible = true;
			scrollbar.visible = false;
			contact.visible = false;
			slideShow2.visible = false;
			slideShow.xmlFilePath = s;
		}
		
	}
}