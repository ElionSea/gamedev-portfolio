/**
 * Created by Sith on 28.01.14.
 */
package screens
{
import custom.CustomCursor;
import data.DataController;
import data.GameData;
import data.InputData;
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.ui.Mouse;

import sound.SoundManager;

public class MainMenuScreen extends AScreen
{
    public static const BTN_NEW_GAME:String = "btn_newGame";
    public static const BTN_RESUME:String = "btn_resumeGame";
    public static const BTN_OPTIONS:String = "btn_options";
    public static const BTN_ACHIEVEMENTS:String = "btn_achivments";
    public static const BTN_CREDITS:String = "btn_credits";
    public static const BTN_MORE_GAMES:String = "btn_moreGames";

    private var _isAlreadyStart:Boolean;

    /* CONSTRUCTOR */
    public function MainMenuScreen(screenName:String, view:MovieClip, isShowingMouseCursor:Boolean)
    {
        super(screenName, view, null, isShowingMouseCursor);
        _screenName = screenName;
        _isShowingMouseCursor = isShowingMouseCursor;
        _view.addEventListener(Event.ADDED_TO_STAGE, init);
        _view.addEventListener(MouseEvent.MOUSE_MOVE, updateMouseCursor);
    }

    /* INIT */
    private function init(e:Event):void
    {
        trace("MAIN : init");

//        _view.removeEventListener(Event.ADDED_TO_STAGE, init);

        updateView();

        _view.addEventListener(MouseEvent.CLICK, onClick);

        SoundManager.playSound(SoundManager.MUSIC_MAIN_MENU, 0.15, 0, 3);
    }

    /* UDPATE VIEW */
    private function updateView():void
    {
        // если это первый запуск игры
        if(DataController.gameData.firstLaunch)
        {
            // не первый запуск но игра уже пройдена
            if(!DataController.gameData.gameEnded)
            {
                updateResumeNewBtns(true);
            }
            else
            {
                updateResumeNewBtns(false);
            }
        }
        // во всех остальных случаях
        else
        {
            updateResumeNewBtns(false);
        }
    }

    /* UPDATE RESUME & NEW BUTTONS */
    private function updateResumeNewBtns(showNew:Boolean):void
    {
        if(showNew)
        {
            _view[BTN_NEW_GAME].visible = true;
            _view[BTN_RESUME].visible = false;
        }
        else
        {
            _view[BTN_NEW_GAME].visible = false;
            _view[BTN_RESUME].visible = true;
        }
    }

    private function updateMouseCursor(e:MouseEvent):void
    {
        if(e.target is SimpleButton)
        {
            if(Mouse.cursor != CustomCursor.HAND_CURSOR)
            {
                CustomCursor.changeCursor(CustomCursor.HAND_CURSOR);
            }
        }
        else
        {
            if(Mouse.cursor != CustomCursor.ARROW_CURSOR)
            {
                CustomCursor.changeCursor(CustomCursor.ARROW_CURSOR);
            }
        }
    }

    /* ON CLICK */
    private function onClick(e:MouseEvent):void
    {
        if(e.target is SimpleButton)
        {
            SoundManager.playSound(SoundManager.START_LEVEL);
            switch(DisplayObject(e.target).name)
            {
                case BTN_NEW_GAME:
                        DataController.gameData.firstLaunch = false;
                       ScreenManager.show(ScreenManager.VIDEO_SCREEN);
//                         ScreenManager.show(ScreenManager.GUILD_SCREEN);
//                         ScreenManager.show(ScreenManager.ACHIEVEMENTS_SCREEN);
//                         ScreenManager.show(ScreenManager.LEVEL_SCREEN);
                    break;
                case BTN_RESUME:
//                       ScreenManager.show(ScreenManager.VIDEO_SCREEN);
                         ScreenManager.show(ScreenManager.GUILD_SCREEN);

                    break;
                case BTN_CREDITS:
                        ScreenManager.show(ScreenManager.CREDITS_SCREEN);
                    break;
            }
        }

    }

    /* DEACTIVATE */
    public override function deactivate():void
    {
        SoundManager.fadeSound(SoundManager.MUSIC_MAIN_MENU, 0, 0.5);
        _view.removeEventListener(MouseEvent.CLICK, onClick);
        _view.removeEventListener(MouseEvent.MOUSE_MOVE, updateMouseCursor);
    }
}
}
