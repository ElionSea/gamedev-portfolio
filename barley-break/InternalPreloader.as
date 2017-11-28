package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.text.TextField;

	public class InternalPreloader extends MovieClip
	{
			public var mc_preloader:MovieClip;
			private var percent:Number;
			
			public function InternalPreloader():void
			{
				
				stop();
			
				
				
				loaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
				loaderInfo.addEventListener(Event.COMPLETE, onComplete);
			}
			
			function onProgress(e:ProgressEvent):void
			{
				percent = (e.bytesLoaded/e.bytesTotal)*100;
				//update text field with the current progress
				mc_preloader.txt_loading.text = 
					String(Math.round((e.bytesLoaded/e.bytesTotal)*100));
				mc_preloader.barMask.scaleX = percent / 100;
			}
			
			function onComplete(e:Event):void
			{
				trace("Fully loaded, starting the movie.");
				
				//removing unnecessary listeners
				loaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
				loaderInfo.removeEventListener(Event.COMPLETE, onComplete);
				//go to the second frame. 
				//You can also add nextFrame or just play() 
				//if you have more than one frame to show (full animation)
				gotoAndStop(2);
			}
		
		
	}
}