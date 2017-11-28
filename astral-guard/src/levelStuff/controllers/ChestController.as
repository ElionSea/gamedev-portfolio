/**
 * Created by Sith on 15.08.14.
 */
package levelStuff.controllers
{
import compositepPattern.ISubController;

import custom.ClipLabel;
import custom.CustomEvent;

import data.AchievementsData;

import data.DataController;

import data.GameData;
import data.LevelData;

import flash.display.Sprite;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.utils.Timer;
import flash.utils.setTimeout;

import levelStuff.Chest;
import levelStuff.enemies.IEnemy;
import levelStuff.treasures.TList;

import popup.PopupController;

public class ChestController implements ISubController
{
    private var _mainScreen:Sprite;
    private var _isBonus:Boolean;
    private var _endGameCallback:Function;
    private var _chestAmount:int = 5;

    private var _timer:Timer;

    private static var s_chestDeathCounter:int = 0;

    private var _chests:Vector.<IEnemy> = new Vector.<IEnemy>();

    /*CONSTRUCTOR*/
    public function ChestController(mainScreen:Sprite, isBonus:Boolean, endGameCallback:Function)
    {
        _mainScreen = mainScreen;
        _isBonus = isBonus;
        _endGameCallback = endGameCallback;

        startLevel();
    }

    /* START LEVEL */
    private function startLevel():void
    {
//        _timer = new Timer(1000, _chestAmount);
        if(_isBonus)
        {
            _timer = new Timer(1000, 20);
            _timer.addEventListener(TimerEvent.TIMER, addChest);
            _timer.addEventListener(TimerEvent.TIMER_COMPLETE, endBonusLevel);
            _timer.start();
        }
        else
        {
            _timer = new Timer(10000, _chestAmount);
            _timer.addEventListener(TimerEvent.TIMER, addChest);
            _timer.start();
        }

        _mainScreen.addEventListener(CustomEvent.STOP_GENERATE, stopGenerate, true);
    }

    /* END BONUS LEVEL */
    private function endBonusLevel(e:TimerEvent):void
    {
        _timer.stop();
        _timer.removeEventListener(TimerEvent.TIMER, addChest);
        _timer.removeEventListener(TimerEvent.TIMER_COMPLETE, endBonusLevel);
        _timer = null;
        setTimeout(levelCompleted, 5000);
    }

    /* LEVEL COMPLETED */
    private function levelCompleted():void
    {
        _endGameCallback(true);
    }

    /* STOP GENERATE */
    private function stopGenerate(e:CustomEvent=null):void
    {
        _mainScreen.removeEventListener(CustomEvent.STOP_GENERATE, stopGenerate);
        removeTimer();
    }

    /* ADD CHEST */
    private function addChest(e:TimerEvent):void
    {
        var randomY:Number = (Math.random()*(((Platformer.HEIGHT/Platformer.SCALE_FACTOR))-40))+40;
        var endPoint:Point = new Point(_mainScreen.width-30, randomY);
//        trace("end point : " + endPoint);
        // пока что в сундуках будет лежать только банки с маной и здоровьем
        var randomTreasure:Array = TList.getRandomTreasure(LevelData.currentLevel);
        var newChest:Chest = new Chest(30, randomY, endPoint, randomTreasure);
        _mainScreen.addChild(newChest.view);
        newChest.playState(ClipLabel.WALK);
        addWarning(newChest);
    }

    /* ADD WARNING */
    private var _warningTimer:Timer;
    private function addWarning(newChest:Chest):void
    {
        if(newChest.warningTimer == null)
        {
            newChest.warningTimer = new Timer(1500, 1);
            newChest.warningTimer.addEventListener(TimerEvent.TIMER_COMPLETE, pushChest)
        }
        newChest.warning.x = 85;
        newChest.warning.y = newChest.view.y;
        _mainScreen.addChild(newChest.warning);
        newChest.warningTimer.start();
        function pushChest(e:TimerEvent):void
        {
            newChest.warningTimer.stop();
            newChest.warningTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, pushChest);
            newChest.warningTimer = null;

            _chests.push(newChest);
            _mainScreen.removeChild(newChest.warning);
        }

        if(DataController.playerData.isNeedToShowChestTutPopupOnLevel && LevelData.currentLevel == 1)
        {
            DataController.playerData.isNeedToShowChestTutPopupOnLevel = false;
            PopupController.showPopup(PopupController.CHEST_POPUP);
        }
    }

    /* CHEST CONTROLLER LOOP */
    public function loop():void
    {
        for each(var chest:Chest in _chests)
        {
            checkForOutOfScreen(chest);
            checkForDeath(chest);
            if(chest)    chest.move();
//            trace(chest.view.x, chest.view.y);
        }
    }

    /* DEACTIVATE */
    public function deactivate():void
    {
        stopGenerate();
        for each(var chest:Chest in _chests)
        {
            chest.deactivate();
            destroyChest(chest);
        }
    }

    /* CHECK FOR OUT OF SCREEN */
    private function checkForOutOfScreen(chest:Chest):void
    {
        if(chest.view.x >= _mainScreen.width-30)
        {
//            trace("DESTROY CHEST");
            destroyChest(chest);
        }
    }

    /* CHECK FOR DEATH */
    private function checkForDeath(chest:Chest):void
    {
        if(chest.health <= 0)
        {
            if(!chest.isDeath)
            {
                chestDeathCounter(1);
                chest.isDeath = true;
                chest.view.dispatchEvent(new CustomEvent(CustomEvent.TREASURE_FROM_DIED, IEnemy, true, false,
                        {
                            x:chest.view.x,
                            y:chest.view.y,
                            treasure:chest.treasure
                        }));
                destroyChest(chest);
            }
        }
    }

    /* DESTROY CHEST */
    private function destroyChest(chest:Chest):void
    {
        _mainScreen.removeChild(chest.view);
        _chests.splice(_chests.indexOf(chest), 1);
        chest.deactivate();
        chest = null;
    }

    /* PAUSE */
    public function pause():void
    {
        if(_timer) _timer.stop();
        if(_warningTimer) _warningTimer.stop();
        for each(var chest:Chest in _chests)
        {
            chest.pause();
        }
    }

    /* RESUME */
    public function resume():void
    {
        if(_timer) _timer.start();
        if(_warningTimer) _warningTimer.start();
        for each(var chest:Chest in _chests)
        {
            chest.resume();
        }
    }

     /* TIMER COMPLETE */
    private function removeTimer(e:TimerEvent=null):void
    {
        if(_timer)
        {
            _timer.stop();
            _timer.removeEventListener(TimerEvent.TIMER, addChest);
            _timer = null;
        }
    }

    public function get chests():Vector.<IEnemy> {return _chests;}

    public function chestDeathCounter(value:int):void {
        ChestController.s_chestDeathCounter += value;
        if(ChestController.s_chestDeathCounter == 20) DataController.achievementsData.updateAchievement(AchievementsData.CHEST_HUNTER_NOVICE);
        if(ChestController.s_chestDeathCounter == 40) DataController.achievementsData.updateAchievement(AchievementsData.CHEST_HUNTER_SKILLED);
        if(ChestController.s_chestDeathCounter == 60) DataController.achievementsData.updateAchievement(AchievementsData.CHEST_HUNTER_EXPERT);
    }
}
}
