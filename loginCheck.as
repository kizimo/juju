package {
	
	
	
	import SWFAddress;
	import SWFAddressEvent;
	import flash.external.ExternalInterface;
	import BarItem;
	import flash.net.*;
	import flash.display.*;
	import flash.events.*;

	public class loginCheck extends Object {
		
		// 1 if logged in, 0 otherwise
		public var logged:Number = 0;
		public var contentXMLURL:URLRequest;
		public var contentXMLLoader:URLLoader;
		public var owner:loginScreen;
		
		public var loaderURL:String = "./pages/login.php?";
		
		
		public function doLogin(name:String, pass:String)
		{
			ExternalInterface.call("console.log", "sending login data: " + name + " / " + pass);
			logged = 0;
			var log:String = loaderURL + "email=" + name + "&pass=" + pass + "&nocache=" + Math.round(Math.random()*1000000);
			while(log.indexOf(" ") != -1)
			{ 
				log = log.replace(" ","%20");
			}
			ExternalInterface.call("console.log", "call to address: " + log);
			contentXMLURL = new URLRequest(log);
			contentXMLLoader = new URLLoader(contentXMLURL);
			contentXMLLoader.addEventListener(Event.COMPLETE, returnLogin);
		}
		
		public function logout()
		{
			logged = 0;
			owner.loginReturn(Number(-1));
		}
		
		public function returnLogin(event:flash.events.Event):void
		{
			ExternalInterface.call("console.log", "login check returned!");
			try{
				   
				// load the XML
				var XMLFile:XML = new XML();
				XMLFile = new XML(event.target.data);
				ExternalInterface.call("console.log", XMLFile);
				
				ExternalInterface.call("console.log", "Status of the login is: "  + XMLFile.@result);
				owner.loginReturn(Number(XMLFile.@result));
				
			} catch (e:TypeError){
		        //Could not convert the data, probavlu because
		        //because is not formated correctly
		        ExternalInterface.call("console.log", "Could not parse the XML");
		        trace(e.message);
		    };
		}
		
		public function doRegister(first:String, last:String, company:String, email:String, pass:String)
		{
			ExternalInterface.call("console.log", "sending login data: " + name + " / " + pass);
			logged = 0;
			var log:String = loaderURL + "action=register&first=" + first + "&last=" + last + "&company=" + company + "&email=" + email + "&pass=" + pass + "&nocache=" + Math.round(Math.random()*1000000);
			while(log.indexOf(" ") != -1)
			{ 
				log = log.replace(" ","%20");
			}
			
			ExternalInterface.call("console.log", "call to address: " + log);
			contentXMLURL = new URLRequest(log);
			contentXMLLoader = new URLLoader(contentXMLURL);
			contentXMLLoader.addEventListener(Event.COMPLETE, returnLogin);
		}
		
		public function returnRegister(event:flash.events.Event):void
		{
			try{
				   
				// load the XML
				var XMLFile:XML = new XML();
				XMLFile = new XML(event.target.data);
				ExternalInterface.call("console.log", XMLFile);
				
				ExternalInterface.call("console.log", "Status of the login is: "  + XMLFile.@result);
				owner.loginRegister(Number(XMLFile.@result));
				
			} catch (e:TypeError){
		        //Could not convert the data, probavlu because
		        //because is not formated correctly
		        ExternalInterface.call("console.log", "Could not parse the XML");
		        trace(e.message);
		    };
		}
		
	}
}
	