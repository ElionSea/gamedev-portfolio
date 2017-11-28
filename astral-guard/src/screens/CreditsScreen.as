/**
 * Created by ElionSea on 22.03.15.
 */
package screens {
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.Event;
import flash.events.MouseEvent;

public class CreditsScreen extends AScreen
{

    private const BTN_CREDITS_BACK:String = "btn_CreditsBack";

    private var _backBtn:SimpleButton;

    /*CONSTRUCTOR*/
    public function CreditsScreen(screenName:String, view:MovieClip, isShowingMouseCursor:Boolean)
    {
        super(screenName, view, null, isShowingMouseCursor);

        _view.addEventListener(Event.ADDED_TO_STAGE, initScreen);
    }

    private function initScreen(e:Event):void
    {
        _backBtn = _view[BTN_CREDITS_BACK];
        _backBtn.addEventListener(MouseEvent.CLICK, gotoMainMenu);
    }

    private function gotoMainMenu(e:MouseEvent):void
    {
        ScreenManager.show(ScreenManager.MAIN_MENU);
    }

    /* DEACTIVATE */
    public override function deactivate():void
    {
        _backBtn.removeEventListener(MouseEvent.CLICK, gotoMainMenu);
    }
}
}
