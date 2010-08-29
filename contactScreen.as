package {
	
	import flash.external.ExternalInterface;
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.net.*;
	import flash.text.*;
		
	public class contactScreen extends MovieClip {
			
		public var contentXMLURL:URLRequest;
		public var contentXMLLoader:URLLoader;
		function contactScreen()
		{
			email.textField.addEventListener(FocusEvent.FOCUS_IN,eliminatePlaceholder);
			subject.textField.addEventListener(FocusEvent.FOCUS_IN,eliminatePlaceholder);
			content.textField.addEventListener(FocusEvent.FOCUS_IN,eliminatePlaceholder);
			
			sendButton.addEventListener(MouseEvent.CLICK,sendClick);
			var tf:TextFormat = new TextFormat();
			tf.font = "Myriad Pro,Verdana,Arial";
			tf.color = 0xbbbbbb;
			
			email.setStyle("textFormat", tf);
			subject.setStyle("textFormat", tf);
			content.setStyle("textFormat", tf);   
		}	
		
		function eliminatePlaceholder(e:Event)
		{
			e.target.text = "";
			e.target.textColor = 0x000000;
			e.target.removeEventListener(FocusEvent.FOCUS_IN,eliminatePlaceholder);
		}
		
		function sendClick(e:MouseEvent):void
		{
			email.enabled = false;
			subject.enabled = false;
			content.enabled = false;
			sendButton.enabled = false;
			ExternalInterface.call("console.log", "send clicked!");
			sendMessage(email.textField.text,subject.textField.text,content.textField.text);
		}
		
		function sendMessage(emailAddress:String, subjectLine:String, bodyContent:String):void
		{
			ExternalInterface.call("console.log", "now sending " + emailAddress + " and " + subjectLine + " and " + bodyContent);
			var emailURL:String = "jujumail.php?email=" + escape(emailAddress) + "&subject=" + escape(subjectLine) + "&body=" + escape(bodyContent);
			contentXMLURL = new URLRequest(emailURL);
			contentXMLLoader = new URLLoader(contentXMLURL);
			contentXMLLoader.addEventListener(Event.COMPLETE, sendReturn);
			contentXMLLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, scError);
		}
		
		function sendReturn(e:Event):void
		{
			loginAccepted.text = "Thanks for your comment!";
			email.visible = false;
			subject.visible = false;
			content.visible = false;
			sendButton.visible = false;
			ExternalInterface.call("console.log", "Mail sent");
		}
		
		function scError(e:Event):void
		{
			ExternalInterface.call("console.log", "Security Error sending mail");
		}
	}	
	
	
}