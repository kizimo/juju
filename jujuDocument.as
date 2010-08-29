package {
	
	//import com.asual.swfaddress.SWFAddress;
	//import com.asual.swfaddress.SWFAddressEvent;
	import SWFAddress;
	import SWFAddressEvent;
	import flash.display.*;
	import flash.events.*
	import flash.net.*;
	import flash.text.*;
	import loginCheck;
	import Navigation;
	import PageEngine;
		
	public class jujuDocument extends MovieClip {
		
		private var treeLoader:Loader;
		private var butterflyLoader:Loader;
		private var cloudLoader:Loader;
		private var dandelionLoader:Loader;
		private var birdLoader:Loader;
		
		private var contentXMLLoader:URLLoader;
		private var nav:Navigation;
		private var pages:PageEngine;
		public var logged:Number = 0;
		private var pageHolderString = new String();
		//private var i:Number = 0;
		
		// client URL
		private var menuURL:String = "menuFeed.xml"; //"http://www.juju.com/menuFeed.xml"
		
		public function jujuDocument()
		{
			// setup
			startLoading();
		}
		
		private function startLoading()
		{
			// TREE LOADER
			treeLoader = new Loader();
			treeholder.addChild(treeLoader);
			treeholder.visible = false;
			treeholder.stop();
			treeLoader.addEventListener(Event.COMPLETE,treeLoaded);
			treeLoader.load(new URLRequest("tree.swf"));
			
			// BUTTERFLY LOADER
			butterflyLoader = new Loader();
			holder.addChild(butterflyLoader);
			holder.visible = false;
			holder.stop();
			butterflyLoader.addEventListener(Event.COMPLETE,butterflyLoaded);
			butterflyLoader.load(new URLRequest("butterfly.swf"));
			
			// CLOUD LOADER
			cloudLoader = new Loader();
			cloudholder.addChild(cloudLoader);
			cloudholder.visible = false;
			cloudholder.stop();
			cloudLoader.addEventListener(Event.COMPLETE,cloudLoaded);
			cloudLoader.load(new URLRequest("clouds.swf"));
			
			// BIRD LOADER
			birdLoader = new Loader();
			birdholder.addChild(birdLoader);
			birdholder.visible = false;
			birdholder.stop();
			birdLoader.addEventListener(Event.COMPLETE,birdLoaded);
			birdLoader.load(new URLRequest("birds.swf"));
			
			// DANDELION LOADER
			dandelionLoader = new Loader();
			dandelionholder.addChild(dandelionLoader);
			dandelionholder.visible = false;
			dandelionholder.stop();
			dandelionLoader.addEventListener(Event.COMPLETE,dandelionLoaded);
			dandelionLoader.load(new URLRequest("dandelions.swf"));

			contentXMLLoader = new URLLoader(new URLRequest(menuURL));
			contentXMLLoader.addEventListener(Event.COMPLETE, menuLoaded);
			contentXMLLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, scError);
			contentXMLLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			contentXMLLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		
		private function butterflyLoaded(e:Event):void
		{
			holder.addChild(e.target);
			butterflyLoader.stop();
		}

		private function treeLoaded(e:Event)
		{
			treeLoader.stop();
		}
		
		private function cloudLoaded(e:Event)
		{
			cloudLoader.stop();
		}
		
		private function dandelionLoaded(e:Event)
		{
			dandelionLoader.stop();
		}
		
		private function birdLoaded(e:Event)
		{
			birdLoader.stop();
		}
		
		private function showButterfly()
		{
			holder.visible = true;
			holder.gotoAndPlay(1);
		}
		
		private function showTree()
		{
			treeholder.visible = true;
			treeholder.alpha = 0.0;
			treeholder.addEventListener(Event.ENTER_FRAME, fadeInSlow);
			treeholder.gotoAndPlay(1);
		}
		
		private function showCloud()
		{
			cloudholder.visible = true;
			cloudholder.alpha = 0.0;
			cloudholder.addEventListener(Event.ENTER_FRAME, fadeInSlow);
			cloudholder.gotoAndPlay(1);
		}
		
		private function showDandelion()
		{
			dandelionholder.visible = true;
			dandelionholder.alpha = 0.0;
			dandelionholder.addEventListener(Event.ENTER_FRAME, fadeInSlow);
			dandelionholder.gotoAndPlay(1);
		}
		
		private function showBird()
		{
			birdholder.visible = true;
			birdholder.alpha = 0.0;
			birdholder.addEventListener(Event.ENTER_FRAME, fadeInSlow);
			birdholder.gotoAndPlay(1);
		}
			
		private function loadingProgress()
		{
			// check if loaded
			var loadedBytes = stage.loaderInfo.bytesLoaded + treeLoader.loaderInfo.bytesLoaded + butterflyLoader.loaderInfo.bytesLoaded + cloudLoader.loaderInfo.bytesLoaded + dandelionLoader.loaderInfo.bytesLoaded + birdLoader.loaderInfo.bytesLoaded + contentXMLLoader.bytesLoaded;
			var totalBytes = stage.loaderInfo.bytesTotal + treeLoader.contentLoaderInfo.bytesTotal + butterflyLoader.contentLoaderInfo.bytesTotal + cloudLoader.contentLoaderInfo.bytesTotal + dandelionLoader.contentLoaderInfo.bytesTotal + birdLoader.contentLoaderInfo.bytesTotal + contentXMLLoader.bytesTotal;
			var percentBytes = int(loadedBytes / (totalBytes / 100));
			if(percentBytes > 100)
			{
				percentBytes = 100;
			}
			
			// update butterfly
			preloader.updatePercent(percentBytes);
			
			// if loaded, proceed
			if(percentBytes == 100)
			{
				this.gotoAndPlay(2);
			}
			else
			{
				// else, return
				this.gotoAndPlay(1);
			}
		}
		
		private function loadComplete()
		{
			/*treeholder.visible = true;
			treeholder.alpha = 0.0;
			treeholder.gotoAndPlay(1);*/
		}
		
		private function fadeInSumptuous()
		{
			sumptuous.addEventListener(Event.ENTER_FRAME, fadeInSlow);
			this.addChild(pages);
			this.addChild(nav);
		}


		private function  fadeInSlow(e:Event):void  {
		
			e.target.alpha += (1.0 / 90.0);
		 
			if (e.target.alpha >= 1.0) 
			{
				e.target.alpha = 1.0;
				e.target.removeEventListener(Event.ENTER_FRAME, fadeInSlow);
			}
		}
		
		public function fadeOutSumptuous()
		{
			sumptuous.addEventListener(Event.ENTER_FRAME,fadeOutSlow);
			holder.addEventListener(Event.ENTER_FRAME,fadeOutSlow);
		}
		
		private function fadeOutSlow(e:Event)
		{
			e.target.alpha -= (1.0 / 90.0);
			if(e.target.alpha <= 0.0)
			{
				e.target.alpha = 0.0;
				e.target.removeEventListener(Event.ENTER_FRAME,fadeOutSlow);
			}
		}
		
		public function fadeInHome()
		{
			sumptuous.removeEventListener(Event.ENTER_FRAME, fadeOutSlow);
			holder.removeEventListener(Event.ENTER_FRAME, fadeOutSlow);
			sumptuous.addEventListener(Event.ENTER_FRAME,fadeInSlow);
			holder.addEventListener(Event.ENTER_FRAME,fadeInSlow);
		}
		
		
		private function registerSWF()
		{
			var link:String = SWFAddress.getValue();
			
			link.replace(/\//g,""); // actual caption that was clicked
			
			if(link == "") // go directly to home
			{
				SWFAddress.setValue("/Home/");
				return;
			}
			else // try to restore this page
			{
				pageHolder = link+"_screen";
			}
			
			SWFAddress.setTitle(formatTitle(link));
			
		}

		private function formatTitle(s:String)
		{
			var output:String = s.replace(/\//g,"");
			output = "JuJu | " + output;
			return output;
		}
		
		private function swfAddressHandler(e:SWFAddressEvent)
		{
			var link:String = SWFAddress.getValue();
			if (link.replace(/\//g,"") == "")
			{
			 	//try again. swfaddress is so lame.
				link = SWFAddress.getValue();
			}
			callSWFEvent(link);
		}
	
		private function callSWFEvent(link:String):void
		{
			var caption:String = link.replace(/\//g,""); // actual caption that was clicked
			
			if(link == "") // go directly to home
			{
				SWFAddress.setValue("/Home/");
				return;
			}
			else // try to restore this page
			{
				pages.showHide(link+"_screen",true);
			}
			SWFAddress.setTitle(formatTitle(link));
			
		}
		
		protected function menuLoaded(event:flash.events.Event):void
		{
			var menuXML:XML = new XML(event.target.data);
			registerSWF();
			pages = new PageEngine();
			pages.name = "pageContainer";
			pages.generatePages(menuXML.menu.option);

			nav = new Navigation();	
			nav.name = "navContainer";
			nav.buildNav(menuXML.menu.option)
			
			if (menuXML.config.attribute("xposition").length()> 0)
			{
				nav.x = menuXML.config.attribute("xposition");
			}
			else
			{
				nav.x = 20;
			}
			
			if (menuXML.config.attribute("yposition").length()> 0)
			{
				nav.y = menuXML.config.attribute("yposition");
			}
			else
			{
				nav.y = 0;
			}
			//this.addChild(pages)
			//this.addChild(nav);
			
			trace("SWFAddress.getValue(): "+SWFAddress.getValue());
			//pages.showHide(link+"_screen",true);
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