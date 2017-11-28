/**
 * @author Denis Kolyako
 * @url http://dev.etcs.ru/
 * @email etc [at] mail.ru
 */
package {
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	
	public class Preloader extends MovieClip 
	{
		// входной кадр
		public static const ENTRY_FRAME:Number = 3;
		// имя главного класса
		public static const DOCUMENT_CLASS:String = 'Main';
		
		public var progressBar:Sprite;
		public var txtPercentLoad:TextField;
		public var myPreloader:MovieClip;
		
		// CONSTRUCTOR
		public function Preloader() 
		{
			//super();
			stop();
			progressBar = getChildByName("progressBar") as MovieClip;
			txtPercentLoad = getChildByName("txtPercentLoad") as TextField;
			progressBar.scaleX = 0;
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			loaderInfo.addEventListener(Event.COMPLETE, completeHandler);
		}
		
		// progressHandler
		private function progressHandler(event:ProgressEvent):void {
			var loaded:uint = event.bytesLoaded;
			var total:uint = event.bytesTotal;
			progressBar.scaleX = loaded/total;
		}
		
		// completeHandler
		private function completeHandler(event:Event):void {
			play();
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		// enterFrameHandler
		private function enterFrameHandler(event:Event):void 
		{
			if (currentFrame >= Preloader.ENTRY_FRAME) 
			{
				removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
				stop();
				main();
			}
		}
		
		// main
		private function main():void 
		{
			var programClass:Class = 
				loaderInfo.applicationDomain.getDefinition(Preloader.DOCUMENT_CLASS) as Class;
			var program:Sprite = new programClass() as Sprite;
			addChild(program);
			/* // Logic, but not working code:
			var program:Program = new Program();
			addChild(program);
			*/
		}
	}
}





