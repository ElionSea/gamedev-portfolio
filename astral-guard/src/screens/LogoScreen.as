/**
 * Created by ElionSea on 10.04.15.
 */
package screens
{
import flash.display.MovieClip;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.Timer;

public class LogoScreen extends AScreen
{
    private var _durationShow:int;
    private var _timer:Timer;

    /*CONSTRUCTOR*/
    public function LogoScreen(screenName:String, view:MovieClip, nextScreen:IScreen, isShowingMouseCursor:Boolean, durationShow:int)
    {
        super(screenName, view, nextScreen, isShowingMouseCursor);
        _durationShow = durationShow;
    }

    protected override function addedToStageHandler(e:Event):void
    {
        super.addedToStageHandler(e);
        _timer = new Timer(_durationShow*1000, 1);
        _timer.addEventListener(TimerEvent.TIMER_COMPLETE, completeTimer);
        _timer.start();
    }

    private function completeTimer(e:TimerEvent):void
    {
        _timer.removeEventListener(TimerEvent.TIMER_COMPLETE, completeTimer);
        _timer = null;

        ScreenManager.show(_nextScreen.screenName);
    }

    protected override function exitFrameListener(e:Event=null):void
    {

    }
}
}
