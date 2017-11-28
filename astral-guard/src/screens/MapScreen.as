/**
 * Created by ElionSea on 06.03.15.
 */
package screens
{
import data.DataController;
import data.LevelData;

import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.Event;
import flash.events.MouseEvent;

import sound.SoundManager;

import xmlParsingTiledLevel.Level;

/* screen map - класс, представляющий скрин карты и обновлящий вид на основе данных LevelData */
public class MapScreen extends AScreen
{
    private const GOTO_GUILD:String = "btnGotoGuild";
    private const GOTO_BATTLE:String = "btnGotoBattle";
    private const GOTO_ACHIEVEMENTS:String = "btnGotoAchievements";

    private var _gotoGuildBtn:SimpleButton;
    private var _gotoBattleBtn:SimpleButton;
    private var _gotoAchievements:SimpleButton;

    private var _currentLevelIndicator:McCurrentLevelIndicator;

    private var _attentionClip:McAtention;

    private var _viewZones:Array;
    private var _levelIndicators:Array;

    /*CONSTRUCTOR*/
    public function MapScreen(screenName:String, view:MovieClip, isShowingMouseCursor:Boolean)
    {
        super(screenName, view, null, isShowingMouseCursor);

        _viewZones = [_view[LevelData.CASTLE], _view[LevelData.SWAMP], _view[LevelData.DESERT], _view[LevelData.INNER], _view[LevelData.ICEWORLD], _view[LevelData.VOLCANO]];

        _currentLevelIndicator = new McCurrentLevelIndicator();

        _attentionClip = new McAtention();

        _levelIndicators = [];
        for(var i:int = 1; i <= 20; i++)
        {
            var curLevelIndicator:MovieClip = _view["level_"+i];

            _levelIndicators.push(curLevelIndicator);
            curLevelIndicator.gotoAndStop(2);
            curLevelIndicator.visible = false;
        }

//        trace("_levelIndicators length : "  + _levelIndicators.length);
        _view.addEventListener(Event.ADDED_TO_STAGE, initScreen);
    }

    /* INIT */
    private function initScreen(e:Event):void
    {
//        _view.removeEventListener(Event.ADDED_TO_STAGE, init);

        _gotoGuildBtn = _view[GOTO_GUILD];
        _gotoBattleBtn = _view[GOTO_BATTLE];
        _gotoAchievements = _view[GOTO_ACHIEVEMENTS];
        _gotoGuildBtn.addEventListener(MouseEvent.CLICK, gotoGuild);
        _gotoBattleBtn.addEventListener(MouseEvent.CLICK, gotoBattle);
        _gotoAchievements.addEventListener(MouseEvent.CLICK, gotoAchievements);


        _attentionClip.x = _gotoGuildBtn.x + _gotoGuildBtn.width;
        _attentionClip.y = _gotoGuildBtn.y;
        _view.addChild(_attentionClip);
        _attentionClip.visible = false;

        updateView();

        SoundManager.playSound(SoundManager.MUSIC_MAP_SCREEN, 0.5, 0, 3);
    }

    private function gotoAchievements(e:MouseEvent):void
    {
        ScreenManager.show(ScreenManager.ACHIEVEMENTS_SCREEN);
    }

    /* GO TO BATTLE */
    private function gotoBattle(e:MouseEvent):void
    {
        ScreenManager.show(ScreenManager.LEVEL_SCREEN);
    }

    /* GO TO GUILD */
    private function gotoGuild(e:MouseEvent):void
    {
        ScreenManager.show(ScreenManager.GUILD_SCREEN);
    }

    /* UPDATE VIEW */
    private function updateView():void
    {
        var curLevel:Level = LevelData.getLevel(LevelData.currentLevel);
        var zones:Array = [LevelData.CASTLE, LevelData.SWAMP, LevelData.DESERT, LevelData.INNER, LevelData.ICEWORLD, LevelData.VOLCANO];

        if(LevelData.currentLevel != 21) // if game not ended
        {
            // update zones view
            for(var i:int=0; i < zones.length; i++)
            {
                var curZone:String = zones[i];
                _viewZones[i].alpha = 1;
                if(curLevel.levelName != curZone && i > zones.indexOf(curLevel.levelName)) _viewZones[i].alpha = 0.08;
            }

            // update level indicators
            for(var j:int = 1; j <= 20; j++)
            {
                var curIndicator:MovieClip = _levelIndicators[j-1];

                if(j > curLevel.levelNumber)
                {
                    curIndicator.visible = false;
                }
                else if(j == curLevel.levelNumber)
                {
                    curIndicator.visible = true;
                    curIndicator.gotoAndStop(1);

                    // add current level indicator
                    _currentLevelIndicator.x = curIndicator.x;
                    _currentLevelIndicator.y = curIndicator.y;
                    _view.addChild(_currentLevelIndicator);
                }
                else
                {
                    curIndicator.visible = true;
                    curIndicator.gotoAndStop(2);
                }
            }

            var canBuy:Boolean = DataController.gameData.isCanBuySomething();
            var canUpdate:Boolean = (DataController.playerData.isCanUpdateSomeMagicSkill() || DataController.playerData.isCanUpdateSomeSkill());
            _attentionClip.visible = (canBuy || canUpdate);
        }
        else // game is ended
        {
            for(var k:int=0; k < zones.length; k++)
            {
                _viewZones[k].alpha = 1;
            }

            for(var l:int = 1; l <= 20; l++)
            {
                var curIndicator2:MovieClip = _levelIndicators[l-1];
                curIndicator2.visible = true;
                curIndicator2.gotoAndStop(2);
            }

            _gotoBattleBtn.visible = false;
            _gotoGuildBtn.visible = false;
            _attentionClip.visible = false;
            _currentLevelIndicator.visible = false;
        }
    }

    /* DEACTIVATE */
    public override function deactivate():void
    {
        SoundManager.fadeSound(SoundManager.MUSIC_MAP_SCREEN, 0, 0.5);
        _gotoGuildBtn.removeEventListener(MouseEvent.CLICK, gotoGuild);
        _gotoBattleBtn.removeEventListener(MouseEvent.CLICK, gotoBattle);
        _gotoAchievements.removeEventListener(MouseEvent.CLICK, gotoAchievements);
    }
}
}
