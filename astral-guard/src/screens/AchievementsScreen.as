/**
 * Created by ElionSea on 24.03.15.
 */
package screens
{
import data.DataController;

import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.Event;
import flash.events.MouseEvent;

import locale.InfoNode;
import locale.Locale;

import sound.SoundManager;

public class AchievementsScreen extends AScreen
{
    private const BTN_BACK_TO_MAP:String = "btn_backToMap";

    private var _backToMapBtn:SimpleButton;

    private var _achievementsIcons:Array;

    /*CONSTRUCTOR*/
    public function AchievementsScreen(screenName:String, view:MovieClip, isShowingMouseCursor:Boolean)
    {
        super(screenName, view, null, isShowingMouseCursor);

        _achievementsIcons = [];
        for each(var key:String in DataController.achievementsData.keys)
        {
            var achievementIcon:MovieClip = _view["icon_"+key];
            _achievementsIcons.push(achievementIcon);
        }

        _view.addEventListener(Event.ADDED_TO_STAGE, initScreen);
    }

    /* INIT SCREEN */
    private function initScreen(e:Event):void
    {
        _backToMapBtn = _view[BTN_BACK_TO_MAP];
        _backToMapBtn.addEventListener(MouseEvent.CLICK, backToMap);

        _view.addEventListener(MouseEvent.MOUSE_OVER, showAchievementInfo);

        initIcons();

        SoundManager.playSound(SoundManager.MUSIC_ACHIEVEMENT_SCREEN, 0.5, 0, 3);
    }

    /* SHOW ACHIEVEMENT INFO */
    private function showAchievementInfo(e:MouseEvent):void
    {
        if(e.target is MovieClip)
        {
            if(e.target.name.indexOf("icon_") == 0)
            {
                var iconName:String = e.target.name.substr(5);
                var infoNode:InfoNode = Locale.getAchievementsScreenInfo(["icons", (iconName)]);
                _view.tfCaption.text = infoNode.caption;
                _view.tfDesc.text = infoNode.description;
            }
            else
            {
                _view.tfCaption.text = "";
                _view.tfDesc.text = "";
            }
        }
    }

    /* INIT ICONS */
    private function initIcons():void
    {
        for(var i:int=0; i<20; i++)
        {
            if(DataController.achievementsData.achievements[DataController.achievementsData.keys[i]].opened)
            {
                _achievementsIcons[i].gotoAndStop(i+2);
            }
            else
            {
                _achievementsIcons[i].gotoAndStop(1);
            }
        }
    }

    /* BACK TO MAP */
    private function backToMap(e:MouseEvent):void
    {
        ScreenManager.show(ScreenManager.MAP_SCREEN);
    }

    /* DEACTIVATE */
    public override function deactivate():void
    {
        SoundManager.fadeSound(SoundManager.MUSIC_ACHIEVEMENT_SCREEN, 0.5, 0);
        _backToMapBtn.removeEventListener(MouseEvent.CLICK, backToMap);
        _view.removeEventListener(MouseEvent.MOUSE_OVER, showAchievementInfo);
    }
}
}
