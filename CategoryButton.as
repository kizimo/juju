package {
	
	
	import SWFAddress;
	import SWFAddressEvent;
	import flash.external.ExternalInterface;
	import BarItem;
	import flash.net.*;
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import ApplicationScreen;
	
	public class CategoryButton extends flash.display.MovieClip
	{
		//
		// global variables
		//
		
		var caption:String;
		var myNode:XML;
		var myHTML:TextField;
		var actiontype:Number;
		var myLocation:String;
		
		function CategoryButton()
		{
			// listeners
			this.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver); // listen for move over
			this.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut); // listen for move over
			this.addEventListener(MouseEvent.CLICK,onMouseClick); // listen for move over
			actiontype = 0;
		}
		
		function setCaption(s:String):void
		{
			highlight.visible = false;
			trace("Caption set to " + s);
			caption = s;
			c_Caption.text = s;
			var newFormat:TextFormat = new TextFormat();
			c_Caption.x = 0;
			newFormat.align = TextFormatAlign.LEFT;
			c_Caption.setTextFormat(newFormat);
		}
		
		function onMouseOver(e:MouseEvent):void
		{
			// show each sub item
			highlight.visible = true;	
			c_Caption.textColor = 0xFFFFFF;
		}
		
		function onMouseOut(e:MouseEvent):void
		{
			highlight.visible = false;
			c_Caption.textColor = 0x666666;
		}
		
		function onMouseClick(e:MouseEvent):void
		{
			trace("Mouse CLicked " + caption);
			if(actiontype == 0)
			{
				parent.setSectionTitle(caption);
				if(myHTML is TextField && myNode.toXMLString() != myHTML.text)
				{
					var node:XML = new XML(myNode.toXMLString());
					
					if(this.parent.parent is ApplicationScreen)
					{
						ExternalInterface.call("console.log", "parent x2" );
						if(this.parent.parent.logged < 1 && node.child("secret") != null)
						{
							delete node.secret;
						}
					}
					if(this.parent.parent.parent is ApplicationScreen)
					{
						ExternalInterface.call("console.log", "parent x3");
						if(this.parent.parent.parent.logged < 1 && node.child("secret") != null)
						{
							delete node.secret;
						}
					}
					myHTML.text = node.toXMLString();
				}
				else
				{
					trace("myHTML is undefined");
				}
				parent.htmlText.visible = true;
				parent.scrollbar.update();
				parent.scrollbar.visible = parent.scrollbar.enabled;
				parent.slideShow.visible = false;
			}
			if(actiontype == 1) // gallery
			{
				parent.setSectionTitle(caption);
				parent.slideShow.visible = true;
				parent.htmlText.visible = false;
				parent.scrollbar.visible = false;
				
				parent.slideShow.xmlFilePath = myLocation;
			}
		}
	}
}