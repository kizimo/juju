package {

	import SWFAddress;
	import SWFAddressEvent;

	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.geom.*;
	
	public class Navigation extends Sprite {
		
		private var subWidth:Number=106;
		private var subOffset:Number=9;
		private var navWidth:Number=123;
		private var navHeight:Number=23;
		private var isFirst:Boolean=true;
		private var isSubFirst:Boolean=true;
		private var posIncrease:Number=7;
		private var posHolder:Number=1;
		private var i:Number=0;
		private var navX:Number=370;
		private var navY:Number=73;
		private var subNavY:Number=99;
		private var lastSeen:Array= new Array();

		public function Navigation() {}
		public function buildNav(list:XMLList) 
		{
			for each (var opt:XML in list)
			{
				addToMain(opt.attribute("title"),((i * navWidth) + navX), navY,opt.attribute("link").length());
				if (opt.option.length()>0)
				{
					listB = createSubItem(opt.attribute("title"),opt.attribute("title"),(opt.option as XMLList),((i * navWidth) + navX),0,1);
					createSubNavBG(opt.attribute("title"),opt.option.length(),((i * navWidth) + navX),navY);
		
				}
				i++;
			}
		}

		public function addToMain(item:String, xpos:Number, ypos:Number, len:Number):void {
			var bmpBG:Bitmap=createBG();
			var navItem:Sprite=createContainer(item,item,item,xpos,ypos,0);
			navItem.addEventListener(MouseEvent.MOUSE_OVER,onMainMouseOver);
			navItem.addEventListener(MouseEvent.MOUSE_OUT,onMainMouseOut);
			navItem.addEventListener(MouseEvent.CLICK,onMainMouseClick);
			
			navItem.addChild(bmpBG);

			var myName:TextField=createText(item);
			navItem.addChild(myName);
			//navItem.addChild(myName);
			//this.addChild(myName);
			this.addChild(navItem);
			//trace("adding item: "+item+" xpos:"+xpos);
		}

		public function addToSub(parentItem:String, parentName:String, item:String, xpos:Number, ypos:Number, level:Number, count:Number):Number {
			var returnVal:Number = new Number();
			if (ypos >0)
			{
				returnVal = ypos+(navHeight*count);
			}
			else
			{
				returnVal = subNavY+(navHeight*count);
			}
			
			var navItem:Sprite = createContainer(parentItem,parentName,item,xpos,returnVal,level,true);
			
			navItem.addEventListener(MouseEvent.MOUSE_OVER,onLev1MouseOver);
			navItem.addEventListener(MouseEvent.MOUSE_OUT,onLev1MouseOut);
			navItem.addEventListener(MouseEvent.CLICK,onLev1MouseClick);
			//navItem.addChild(bmpBG);

			var myName:TextField=createSubText(item);
			navItem.addChild(myName);
			//navItem.addChild(myName); 
			//this.addChild(myName);
			this.addChild(navItem);
			navItem.visible = false;
			trace("adding item: "+item+"_sub count:"+count+" level:"+level+" subNavY:"+subNavY+" navHeight:"+navHeight+" xpos:"+xpos+"->"+this.name+" "+(subNavY+(navHeight*count)));
			return returnVal;
		}

		private function cleanUpNav(e:Sprite):void
		{
			if (lastSeen.length > 0)
			{
				for(var l:Number=0; l<(e.parent).numChildren-1; l++)
				{
					for each (var na:String in lastSeen)
					{
						if ((e.parent).getChildAt(l).name == na)
						{
							(e.parent).getChildAt(l).visible = false;
							if (((e.parent).getChildAt(l)).getChildByName("subSprite") != null)
							{
								((e.parent).getChildAt(l)).removeChild(((e.parent).getChildAt(l)).getChildByName("subSprite"));
							}
						}
					}
				}
				lastSeen = new Array();
			}
		}
		
		private function onMainMouseOver(e:MouseEvent):void 
		{
			cleanUpNav(e.target);
			var newFormat:TextFormat = new TextFormat();
				newFormat.color=0x666666;
				e.target.getChildByName("textBox").setTextFormat(newFormat);
			(e.target.getChildByName("background")).visible = true;
			for(var i:Number=0; i<(e.target.parent).numChildren-1; i++)
			{
				if ((e.target.parent).getChildAt(i).name == (e.target.name+"_sub"))
				{
					(e.target.parent).getChildAt(i).visible = true;
					lastSeen.push(e.target.name+"_sub");
				}
			}
		}
		
		private function onMainMouseClick(e:MouseEvent):void {
			trace("mouseclick: "+e.target.name+" parent"+e.target.parent.name);
			cleanUpNav(e.target);
			for(var i:Number=0; i<(e.target.parent).parent.numChildren-1; i++)
			{
				if ((e.target.parent).parent.getChildAt(i).name == "pageContainer") {
					e.target.parent.parent.getChildAt(i).showHide("Login_screen");
					e.target.parent.parent.getChildAt(i).showHide(e.target.name+"_screen",true);
					SWFAddress.setValue("/" + e.target.name + "/");
					SWFAddress.setTitle("JuJu | " + e.target.name);
				}
			}
			if (e.target.name == "Home")
			{
				SWFAddress.setValue("/" + e.target.name + "/");
				SWFAddress.setTitle("JuJu | " + e.target.name);
			}
		}

		private function onMainMouseOut(e:MouseEvent):void {
			var newFormat:TextFormat = new TextFormat();
			newFormat.color=0xA8A9A0;
			e.target.getChildByName("textBox").setTextFormat(newFormat);
			(e.target.getChildByName("background")).visible = false;
		}

		private function onLev1MouseOver(e:MouseEvent):void {
			e.target.addChildAt(createRollo("0xbbbbbb"),1);
			var newFormat:TextFormat = new TextFormat();
			newFormat.color=0xFFFFFF;
			e.target.getChildByName("textBox").setTextFormat(newFormat);
			e.target.setChildIndex(e.target.getChildByName("textBox"),1);
			for(var i:Number=0; i<(e.target.parent).numChildren-1; i++)
			{
				if ((e.target.parent).getChildAt(i).name == (e.target.getChildByName("textBox").text+"_sub"))
				{
					(e.target.parent).getChildAt(i).visible = true;
					if (e.target.getChildByName("subSprite") == null)
					{
						e.target.addChildAt(createSubSprite("0xeeeeee"),0);
						e.target.setChildIndex(e.target.getChildByName("textBox"),2);
					}
					else
					{
						e.target.setChildIndex(e.target.getChildByName("textBox"),2);
					}
				}
				/*else
				//{
				//	var parentHolder:String = new String();
					if (((e.target.parent).getChildAt(i)).getChildByName("textBox").text == String(e.target.name).replace('/_sub/','')){
						parentHolder = ((e.target.parent).getChildAt(i)).name;
					}
						
					if (lastSeen.length > 0)
					{
						for each (var na:String in lastSeen)
						{
							if (((e.target.parent).getChildAt(i).name == na) && ((e.target.parent).getChildAt(i).name != parentHolder))
							{
								trace("disabled:"+(e.target.parent).getChildAt(i).name+"" +e.target.name);
								((e.target.parent).getChildAt(i)).visible = false;
							}
						}	
					}
				}*/
				lastSeen.push(e.target.getChildByName("textBox").text+"_sub");

			}
		}

		private function onBGMouseOver(e:MouseEvent):void {
			for(var i:Number=0; i<(e.target.parent).numChildren-1; i++)
			{
				trace(e.target.parent.name);
				trace(e.target.name);
				trace(e.currentTarget.name);
				if ((e.target.parent).getChildAt(i).name == (e.target.name))
				{
					(e.target.parent).getChildAt(i).visible = false;
				}
			}
		}
		
		private function onLev1MouseOut(e:MouseEvent):void {
			e.target.removeChild(e.target.getChildByName("rollOverSprite"));
			var newFormat:TextFormat = new TextFormat();
			newFormat.color=0xA8A9A0;
			e.target.getChildByName("textBox").setTextFormat(newFormat);
			//(e.target.getChildByName("background")).visible = false;
		}

		private function onLev1MouseClick(e:MouseEvent):void {
			cleanUpNav(e.target);
			e.target.parent.parent.getChildByName("pageContainer").showHide(e.target.getChildByName("textBox").text+"_screen",true);
			SWFAddress.setValue("/" + e.target.getChildByName("textBox").text + "/");
			SWFAddress.setTitle("JuJu | " + e.target.getChildByName("textBox").text);
		}

		private function createRollo(color:String):Sprite {
			var rollOverBG:Sprite = new Sprite();
			rollOverBG.buttonMode=true;
			rollOverBG.useHandCursor=true;
			rollOverBG.mouseChildren=false;
			rollOverBG.name="rollOverSprite";
			rollOverBG.graphics.beginFill(color);
			rollOverBG.graphics.drawRect(subOffset, 0, subWidth, navHeight);
			return rollOverBG;
		}
		
		private function createSubNavBG(parentTitle:String,count:Number,xpos:Number,ypos:Number):Sprite {
			var rollOverBG:Sprite = new Sprite();
			rollOverBG.buttonMode=false;
			rollOverBG.useHandCursor=false;
			rollOverBG.mouseChildren=true;
			rollOverBG.name=parentTitle+"_sub";
			rollOverBG.graphics.beginFill(0x000000);
			rollOverBG.alpha = .001;
			rollOverBG.graphics.drawRect(xpos, subNavY, subWidth, navHeight*count);
			rollOverBG.addEventListener(MouseEvent.MOUSE_OUT, onBGMouseOver);
			this.addChild(rollOverBG);
		}
		
		private function createSubSprite(color:String):Sprite {
			var rollOverBG:Sprite = new Sprite();
			rollOverBG.buttonMode=true;
			rollOverBG.useHandCursor=true;
			rollOverBG.mouseChildren=false;
			rollOverBG.name="subSprite";
			rollOverBG.graphics.beginFill(color);
			rollOverBG.graphics.drawRect(subOffset, 0, subWidth, navHeight);
			return rollOverBG;
		}
		
		private function createBG(vis:Boolean=false):Bitmap {
			var bmp:Bitmap = new Bitmap();
			bmp.bitmapData=new highlightSidesImg(134.4,36);
			var scaledBitmapData:BitmapData=new BitmapData(134.4,navHeight,true,0xFFFFFFFF);
			var scaleMatrix:Matrix = new Matrix();
			scaleMatrix.scale(1.2,.6472222222);
			scaleMatrix.tx=-10;
			scaledBitmapData.draw(bmp.bitmapData,scaleMatrix);
			bmp.bitmapData=scaledBitmapData;
			bmp.height=navHeight;
			bmp.smoothing=true;
			bmp.x=0;
			bmp.name="background";
			if (vis) {
				bmp.visible=true;
			} else {
				bmp.visible=false;
			}
			return bmp;
		}

		private function createText(item:String):TextField {
			var myName:TextField = new TextField();
			myName.x=0;
			//myName.y = 0;
			myName.text=item;
			myName.name="textBox";
			myName.background=false;
			//myName.autoSize = TextFieldAutoSize.RIGHT;
			myName.width=navWidth;
			myName.height=navHeight;
			myName.border=false;
			//myName.addEventListener(MouseEvent.MOUSE_OVER,onMainMouseOver);

			var newFormat:TextFormat = new TextFormat();
			newFormat.align=TextFormatAlign.LEFT;
			newFormat.blockIndent=10;
			newFormat.size=16;
			newFormat.bold=false;
			newFormat.color=0xA8A9A0;
			newFormat.font="Myriad Pro";
			newFormat.indent=2;
			newFormat.leading=0;
			newFormat.leftMargin=0;
			newFormat.letterSpacing=0;
			newFormat.rightMargin=0;
			myName.setTextFormat(newFormat);
			return myName;
		}

		private function createSubText(item:String):TextField {
			var myName:TextField = new TextField();
			myName.x = 0;
			myName.y = 2;
			myName.text=item;
			myName.name="textBox";
			myName.background=false;
			//myName.autoSize = TextFieldAutoSize.RIGHT;
			myName.width=subWidth;
			myName.height=navHeight;
			myName.border=false;
			//myName.addEventListener(MouseEvent.MOUSE_OVER,onMainMouseOver);

			var newFormat:TextFormat = new TextFormat();
			newFormat.align=TextFormatAlign.LEFT;
			newFormat.blockIndent=10;
			newFormat.size=14;
			newFormat.bold=false;
			newFormat.color=0xA8A9A0;
			newFormat.font="Myriad Pro";
			newFormat.indent=2;
			newFormat.leading=0;
			newFormat.leftMargin=0;
			newFormat.letterSpacing=0;
			newFormat.rightMargin=0;
			myName.setTextFormat(newFormat);
			return myName;
		}

		private function createContainer(parentItem:String, parentName:String,Item:String, xpos:Number, ypos:Number, subPos:Number, addFill:Boolean=false):Sprite 
		{
			var navItem:Sprite = new Sprite();
			navItem.buttonMode=true;
			navItem.useHandCursor=true;
			navItem.mouseChildren=false;
			if (parentName != Item)
			{
				Item = parentName+"_sub";
			}
			navItem.name=Item;

			if (addFill) {
				navItem.graphics.beginFill(0xffffff);
			}
			if (subPos>0) {
				navItem.graphics.drawRect(subOffset, 0, subWidth, navHeight);
				navItem.width=subWidth;
			} else {
				navItem.graphics.drawRect(0, 0, navWidth, navHeight);
				navItem.width=navWidth;
			}
			navItem.height=navHeight;
			//navItem.x = xpos;
			//navItem.y = ypos;
			if (isFirst) {
				navItem.x=xpos;
				isFirst=false;
			} else if (subPos == 1) {
				navItem.x = (this.getChildByName(parentItem)).x;
				//isSubFirst = false;
			} else if (subPos > 1) {
				navItem.x = (this.getChildByName(parentItem)).x + (subWidth *(subPos-1));
			} else {
				navItem.x=xpos-posIncrease;
				posIncrease+=7;
			}
			navItem.y=ypos;
			return navItem;
		}

		private function createSubItem(par:String,alt:String,listB:XMLList,xpos:Number,ypos:Number,c:Number):XMLList {
			var count:Number=c;
			var itemCount:Number=0;
			for each (var opts:XML in listB) {
				var subNavItemY:String=addToSub(par,alt,opts.attribute("title"),xpos,ypos,c,itemCount);
				if (opts.option.length()>0)
				{
					listB = createSubItem(par,opts.attribute("title"),(opts.option as XMLList),xpos,subNavItemY,(count+1));
				} 
				itemCount++;
			}
			return null;
		}
	}
}