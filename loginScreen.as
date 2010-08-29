package {
	
	
	import SWFAddress;
	import SWFAddressEvent;
	import flash.external.ExternalInterface;
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.net.*;
	import flash.text.*;
	import loginCheck;
	import ApplicationScreen;
	//import BarItem;
		
	public class loginScreen extends MovieClip {
		
		
		public var lc:loginCheck = new loginCheck();
		//public var barButton:BarItem;
		public var referenceTarget:ScreenBox; // the screenbox we need to kick back to on a successful login
			
		function loginScreen()
		{
			ExternalInterface.call("console.log", "creating Login Screen");
			lc.owner = this;
			login.addEventListener(MouseEvent.CLICK,loginClick); // add button controls
			register.addEventListener(MouseEvent.CLICK,registerClick); // add button controls
			
			ExternalInterface.call("console.log", "added events");
			//lc.logged = 0;
			loginFail.visible = false;
			loginAccepted.visible = false;
			registerAccepted.visible = false;
			
			// apply styles
			var tf:TextFormat = new TextFormat();
			tf.font = "Myriad Pro,Verdana,Arial";
			tf.color = 0xbbbbbb;

			first.setStyle("textFormat", tf);
			last.setStyle("textFormat", tf);
			email_reg.setStyle("textFormat", tf);
			password_reg.setStyle("textFormat", tf);
			company.setStyle("textFormat", tf);
			
			
			first.textField.addEventListener(FocusEvent.FOCUS_IN,eliminatePlaceholder);
			last.textField.addEventListener(FocusEvent.FOCUS_IN,eliminatePlaceholder);
			email_reg.textField.addEventListener(FocusEvent.FOCUS_IN,eliminatePlaceholder);
			password_reg.textField.addEventListener(FocusEvent.FOCUS_IN,eliminatePlaceholder);
			company.textField.addEventListener(FocusEvent.FOCUS_IN,eliminatePlaceholder);
			
			email.setStyle("textFormat", tf);
			password.setStyle("textFormat", tf);
			
			email.textField.addEventListener(FocusEvent.FOCUS_IN,eliminatePlaceholder);
			password.textField.addEventListener(FocusEvent.FOCUS_IN,eliminatePlaceholder);
		
			ExternalInterface.call("console.log", "created Login Screen");
		}	
		function eliminatePlaceholder(e:Event)
		{
			e.target.text = "";
			e.target.textColor = 0x000000;
			if(e.target == password.textField)
			{
				e.target.displayAsPassword = true;
			}
			e.target.removeEventListener(FocusEvent.FOCUS_IN,eliminatePlaceholder);
		}
		
		function loginClick(e:MouseEvent):void
		{
			
			trace("parent "+this.parent.name+" "+this.name+" "+this.parent.parent.name);
			ExternalInterface.call("console.log", "login clicked!");
			ExternalInterface.call("console.log", "login state is: " + lc.logged);
			lc.doLogin(email.text,password.text);
		}
		
		function registerClick(e:MouseEvent):void
		{
			lc.doRegister(first.text, last.text, company.text, email_reg.text, password_reg.text);
		}
		
		function loginReturn(val:Number):void
		{
			ExternalInterface.call("console.log", "login has returned with code " + val + "!");
			if(val >= 1)
			{
				lc.logged = 1;
				if(this.parent.parent is jujuDocument)
				{
					this.parent.parent.logged = lc.logged;
				}
				for(var i=0;i<this.numChildren;i++)
				{
					this.getChildAt(i).visible = false;
				}
				loginAccepted.visible = true;
				loginFail.visible = false;
				//barButton.setCaption("Logout");
				SWFAddress.back();
				return;
			}
			if(val < 0) // log out
			{
				lc.logged = 0;
				if(this.parent.parent is jujuDocument)
				{
					this.parent.parent.logged = lc.logged;
				}
				for(var d=0;d<this.numChildren;d++)
				{
					this.getChildAt(d).visible = false;
				}
				loginAccepted.visible = false;
				//logout.visible = false;
				//barButton.setCaption("Login");
				SWFAddress.back();
				return;
			}
			else
			{
				loginFail.visible = true;
				//barButton.setCaption("Login");
				return;
			}
		}
		
		function registerReturn(val:Number):void
		{
			if(val == 1)
			{
				for(var i=0;i<this.numChildren;i++)
				{
					this.getChildAt(i).visible = false;
				}
				registerAccepted.visible = true;
			}
		}
	}	
	
	
}