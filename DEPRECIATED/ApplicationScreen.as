package {
	
	import SWFAddress;
	import SWFAddressEvent;
	import flash.external.ExternalInterface;
	import Navigation;
	import flash.net.*;
	import flash.display.*;
	import flash.events.*;
	//import SubBarItem;
	//import BarItem;
	import PageEngine;
	
	public class ApplicationScreen extends Sprite
	{
		// loader objects
		public var contentXMLURL:URLRequest;
		public var contentXMLLoader:URLLoader;
		private var nav:Navigation;
		public var pages:PageEngine;
		public var logged:Number = 0;
		//private var i:Number = 0;
		
		// client URL
		public var menuURL:String = "menuFeed.xml"; //"http://www.juju.com/menuFeed.xml"
		
		public function ApplicationScreen()
		{
			// as the script starts, load the XML files we need
			contentXMLURL = new URLRequest(menuURL);
			contentXMLLoader = new URLLoader(contentXMLURL);
			contentXMLLoader.addEventListener(Event.COMPLETE, menuLoaded);
			contentXMLLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, scError);
			contentXMLLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			contentXMLLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		
		protected function menuLoaded(event:flash.events.Event):void
		{
			pages = new PageEngine();
			pages.name = "pageContainer";
			pages.generatePages(new XML(event.target.data));

			nav = new Navigation();	
			nav.name = "navContainer";
			nav.buildNav(new XML(event.target.data))
			nav.x = 20;
			nav.y = 0;
			this.addChild(pages)
			this.addChild(nav);
			
			trace("SWFAddress.getValue(): "+SWFAddress.getValue());
			
			// all tabs are ready, so load up the SWF page
			if(SWFAddress.getValue().replace(/^\/.*?\//g,"") == "")
			{
				//SWFAddress.setValue(SWFAddress.getValue());
				pages.showHide(SWFAddress.getValue()+"_screen",true);
			}
			else
			{
				SWFAddress.setValue(SWFAddress.getValue().replace(/^\/.*?\//g,"/"));
				pages.showHide(SWFAddress.getValue().replace(/^\/.*?\//g,"/")+"_screen",true);
			}
		}
		
	
		// xml file could not load
		protected function scError(event:flash.events.SecurityErrorEvent):void 
		{
			trace("securityErrorHandler: " + event);
		}
		
		protected function httpStatusHandler (e:HTTPStatusEvent):void {
			trace("httpStatusHandler:" + e +" -->status: " + e.status);
		}
			
		protected function ioErrorHandler(e:IOErrorEvent):void {
			trace("ioErrorHandler: " + e);
		}
		
	}
}