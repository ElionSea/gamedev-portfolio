/**
 * Created by ElionSea on 03.12.14.
 */
package levels
{
import custom.ClipLabel;
import custom.CustomMovieClip;

import data.LevelData;

import flash.display.Sprite;
import flash.events.TimerEvent;
import flash.utils.Timer;

import compositepPattern.ISubController;

import player.MovableModel;

import player.PlayerController;

/* Класс контролирующий поведение всех объектов на сцене */
public class LevelObjectsController implements ISubController
{
    private var _gameScreen:Sprite;
    private var _player:PlayerController;

    private var _showSloughTimer:Timer;
    private var _hideSloughTimer:Timer;

    private var _slough:CustomMovieClip;
    private const SHOW_PERIOD:int = 5000;
    private const HIDE_PERIOD:int = 7000;

    /*CONSTRUCTOR*/
    public function LevelObjectsController(player:PlayerController, gameScreen:Sprite)
    {
        _player = player;
        _gameScreen = gameScreen;

    }

    /* START LEVEL */
    public function startLevel():void
    {
        var curLvlName:String = LevelData.getLevel(LevelData.currentLevel).levelName;
        switch (curLvlName)
        {
            case LevelData.DESERT :
                _showSloughTimer = new Timer(HIDE_PERIOD, 1);
                _showSloughTimer.addEventListener(TimerEvent.TIMER_COMPLETE, showSlough);
                _showSloughTimer.start();
                break;
        }
    }

    /* SHOW SLOUGH */
    private function showSlough(e:TimerEvent):void
    {
        var randomX:Number = 100 + (Math.random()*150);
        if(_slough == null)
        {
            _slough = new CustomMovieClip(LevelObjectsController, new MovableModel(), new McSlough());
            _slough.clipLabels = new Vector.<ClipLabel>();
            _slough.clipLabels.push(new ClipLabel(ClipLabel.WALK, 5, 0.2));
            _slough.clipLabels.push(new ClipLabel(ClipLabel.SHOW, 3, 0.1));
            _slough.clipLabels.push(new ClipLabel(ClipLabel.HIDE, 3, 0.1));
        }

//        _slough.view.x = 100;
        _slough.view.x = randomX;
        _slough.view.y = Platformer.HEIGHT-20;
        _gameScreen.addChildAt(_slough.view, _gameScreen.getChildIndex(_player.view)-1);
        _slough.playState(ClipLabel.SHOW, null, ClipLabel.WALK);

        _showSloughTimer.stop();
        _showSloughTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, showSlough);
        _showSloughTimer = null;

        _hideSloughTimer = new Timer(SHOW_PERIOD, 1);
        _hideSloughTimer.addEventListener(TimerEvent.TIMER_COMPLETE, hideSlough);
        _hideSloughTimer.start();
    }

    /* HIDE SLOUGH */
    private function hideSlough(e:TimerEvent):void
    {
        _gameScreen.removeChild(_slough.view);

        _hideSloughTimer.stop();
        _hideSloughTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, hideSlough);
        _hideSloughTimer = null;

        _showSloughTimer = new Timer(SHOW_PERIOD, 1);
        _showSloughTimer.addEventListener(TimerEvent.TIMER_COMPLETE, showSlough);
        _showSloughTimer.start();
    }

    /* DEACTIVATE */
    public function deactivate():void
    {
//        hideSlough();
        if(_slough)
        {
            if(_gameScreen.contains(_slough.view)) _gameScreen.removeChild(_slough.view);
            _slough = null;

        }

        if(_showSloughTimer)
        {
            _showSloughTimer.stop();
            _showSloughTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, hideSlough);
            _showSloughTimer = null;
        }

        if(_hideSloughTimer)
        {
            _hideSloughTimer.stop();
            _hideSloughTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, showSlough);
            _hideSloughTimer = null;
        }
    }

    /* LOOP */
    public function loop():void
    {
        if(_slough)
        {
            if(_gameScreen.contains(_slough.view))
            {
                if(_player.hitBox.hitTestObject(_slough.hitBox))
                {
                    _player.movingMode = PlayerController.SLOUGH;
                }
                else
                {
                    _player.movingMode = PlayerController.NORMAL;
                }
            }
            else
            {
                _player.movingMode = PlayerController.NORMAL;
            }
        }
    }
}
}
