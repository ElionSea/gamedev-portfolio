/**
 * Created by Sith on 01.08.14.
 */
package screens
{
import custom.CustomEvent;
import data.DataController;
import data.LevelData;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.utils.Timer;
import sound.SoundManager;
import utils.ShiftingTextField;

public class GameOverScreen
{
    private var _view:ScrGameOverMc;
    private var _mainScreen:Sprite;

    // BUTTONS
    private var _btnGuild:SimpleButton;
    private var _btnMainMenu:SimpleButton;
    private var _btnReplay:SimpleButton;
    private var _btnNextLevel:SimpleButton;

    private var _statEvent:CustomEvent;
    private var _textFields:Vector.<ShiftingTextField>;
    private var _values:Array;

    private var _attentionClip:McAtention;

    /*CONSTRUCTOR*/
    public function GameOverScreen(view:ScrGameOverMc, e:CustomEvent, mainScreen:Sprite)
    {
        _view = view;
        _view.scaleX = _view.scaleY = Platformer.SCALE_FACTOR;
        _statEvent = e;
        _mainScreen = mainScreen;

        _view.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    /* ON ADDED TO STAGE*/
    private function onAddedToStage(e:Event):void
    {
        _view.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

        initButtons();

        initValues();

        animateScreen();
        //updateStat();

        if(_statEvent.obj.isLevelCompleted)
        {

        }
        else
        {
            SoundManager.playSound(SoundManager.LEVEL_FAILED, 0.8);
        }
    }

    /* INIT BUTTONS */
    private function initButtons():void
    {
        _btnGuild = _view["btnGuild"];
        _btnMainMenu = _view["btnMainMenu"];
        _btnReplay = _view["btnReplay"];
        _btnNextLevel = _view["btnNextLevel"];

        _btnGuild.addEventListener(MouseEvent.CLICK, goToGuild);
        _btnMainMenu.addEventListener(MouseEvent.CLICK, goToMainMenu);
        _btnReplay.addEventListener(MouseEvent.CLICK, replay);
        _btnNextLevel.addEventListener(MouseEvent.CLICK, loadNextLevel);

        _btnGuild.visible = false;
        _btnMainMenu.visible = false;
        _btnReplay.visible = false;
        _btnNextLevel.visible = false;

        _attentionClip = new McAtention();
        _attentionClip.x = _btnGuild.width + _btnGuild.x;
        _attentionClip.y = _btnGuild.y;
        _view.addChild(_attentionClip);
        _attentionClip.visible = false;
    }

    /* INIT VALUES */
    private function initValues():void
    {
        _textFields = new Vector.<ShiftingTextField>();
        _textFields.push
                (
                        new ShiftingTextField(_view.tfAccuracy),
                        new ShiftingTextField(_view.tfBonusFactor,true, true),
                        new ShiftingTextField(_view.tfCoinsScored),
                        new ShiftingTextField(_view.tfCoinsBonus),
                        new ShiftingTextField(_view.tfCoinsTotal),
                        new ShiftingTextField(_view.tfGamePointsScored),
                        new ShiftingTextField(_view.tfGamePointsBonus),
                        new ShiftingTextField(_view.tfGamePointsTotal)
                );

        _values = [];
        _values.push
                (
                        _statEvent.obj.accuracy,
                        _statEvent.obj.bonusFactor,
                        _statEvent.obj.coinsScored,
                        _statEvent.obj.coinsBonus,
                        _statEvent.obj.coinsTotal,
                        _statEvent.obj.gamePoints,
                        _statEvent.obj.gamePointsBonus,
                        _statEvent.obj.totalGamePoints
                );

        if(_statEvent.obj.isLevelCompleted)     _view.cap.gotoAndStop(1);
        else                                    _view.cap.gotoAndStop(2);
    }

    /* ANIMATE SCREEN */
    private var _animateTimer:Timer;
    private var _counter:int = 0;
    private function animateScreen():void
    {
        _view.addEventListener(MouseEvent.CLICK, updateStat);
        _animateTimer = new Timer(1000, _textFields.length);
        _animateTimer.addEventListener(TimerEvent.TIMER, timerTick);
        _animateTimer.start();
    }

    /* TIMER TICK */
    private function timerTick(e:TimerEvent):void
    {
        SoundManager.playSound(SoundManager.COUNT_POINTS);
       _textFields[_counter].tweenNumbers(_values[_counter], 10);
        if(_counter == _textFields.length-1)
        {
            clearAnimateTimer();
            updateStat();
        }
        _counter++;
    }

    /* CLEAR ANIMATE TIMER */
    private function clearAnimateTimer():void
    {
         if(_animateTimer)
         {
             _animateTimer.stop();
             _animateTimer.removeEventListener(TimerEvent.TIMER, timerTick);
             _animateTimer = null;
         }
    }

    /* UPDATE STAT */
    private function updateStat(e:MouseEvent=null):void
    {
        clearAnimateTimer();
        if(_view.hasEventListener(MouseEvent.CLICK)) _view.removeEventListener(MouseEvent.CLICK, updateStat);
        if(_statEvent.obj.isLevelCompleted)
        {
            _btnNextLevel.visible = true;
            _btnReplay.visible = false;
            _view.tfGamePointsScored.text = _statEvent.obj.gamePoints.toString();
            _view.tfGamePointsBonus.text = _statEvent.obj.gamePointsBonus.toString();
            _view.tfGamePointsTotal.text = _statEvent.obj.totalGamePoints.toString();
            LevelData.currentLevel++;
            DataController.gameData.updateMarket(LevelData.currentLevel);
        }
        else
        {
            _btnNextLevel.visible = false;
            _btnReplay.visible = true;
            _view.cap.gotoAndStop(2);
        }
        _view.tfAccuracy.text = _statEvent.obj.accuracy.toString();
        _view.tfBonusFactor.text = _statEvent.obj.bonusFactor.toString();
        _view.tfCoinsScored.text = _statEvent.obj.coinsScored.toString();
        _view.tfCoinsBonus.text = _statEvent.obj.coinsBonus.toString();
        _view.tfCoinsTotal.text = _statEvent.obj.coinsTotal.toString();

        _btnGuild.visible = true;
        _btnMainMenu.visible = true;

        updateAttention();
    }

    /* UPDATE ATTENTION */
    private function updateAttention():void
    {
        var canBuy:Boolean = DataController.gameData.isCanBuySomething();
        var canUpdate:Boolean = (DataController.playerData.isCanUpdateSomeMagicSkill() || DataController.playerData.isCanUpdateSomeSkill());
//        trace("isCanBuySomething : " + canBuy);
//        trace("isCanUpdateSomeMagicSkill : " + DataController.playerData.isCanUpdateSomeMagicSkill());
//        trace("isCanUpdateSomeSkill : " + DataController.playerData.isCanUpdateSomeSkill());
        _attentionClip.visible = (canBuy || canUpdate);
    }



    /* LOAD NEXT LEVEL */
    private function loadNextLevel(e:MouseEvent):void
    {
            ScreenManager.show(ScreenManager.LEVEL_SCREEN);
    }

    /* GO TO GUILD */
    private function goToGuild(e:MouseEvent):void   { ScreenManager.show(ScreenManager.GUILD_SCREEN); }

    /* GO TO MAIN MENU */
    private function goToMainMenu(e:MouseEvent):void    { ScreenManager.show(ScreenManager.MAIN_MENU); }

    /* REPLAY */
    private function replay(e:MouseEvent):void  { ScreenManager.show(ScreenManager.LEVEL_SCREEN); }

    /* DEACTIVATE */
    public function deactivate():void
    {
        _btnGuild.removeEventListener(MouseEvent.CLICK, goToGuild);
        _btnMainMenu.removeEventListener(MouseEvent.CLICK, goToMainMenu);
        _btnReplay.removeEventListener(MouseEvent.CLICK, replay);
        _btnNextLevel.removeEventListener(MouseEvent.CLICK, loadNextLevel);
    }

    public function get view():ScrGameOverMc {return _view;}
}
}
