/**
 * Created by Sith on 11.06.14.
 */
package player
{
import custom.ClipLabel;
import custom.CustomEvent;
import custom.CustomMovieClip;

import cv.Orion;

import data.PlayerData;

import flash.display.MovieClip;

import flash.display.Scene;

import flash.display.Sprite;
import flash.display.Stage;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.utils.Timer;

import levelStuff.IHittableByBullet;

import levelStuff.controllers.AGravityObjectController;
import levelStuff.controllers.AMovableController;
import levelStuff.controllers.AObstacleController;
import levelStuff.IGravityAffected;
import levelStuff.IShootable;
import compositepPattern.ISubController;
import levelStuff.spell.Fist;

import sound.SoundManager;

import xmlParsingTiledLevel.LevelObject;

public class PlayerController extends CustomMovieClip implements IGravityAffected, IShootable, IHittableByBullet, ISubController
{
    private var _playerModel:MovableModel;
    private var _totalHealth:int;
    private var _mainScreen:Sprite;
    private var _levelObject:LevelObject;
    private var _crystall:Sprite;
    private var _stage:Stage;
    private var _contHalfWidth:Number;
    private var _contHalfHeight:Number;
    private var _obstacleController:AObstacleController;
    private var _gravityController:AGravityObjectController;
    private var _moveController:AMovableController;
    private var _isGravityAffected:Boolean;
    private var _isObstacledHited:Boolean;
    private var _isMovable:Boolean;


    private var _movingMode:String;               // режим передвижения
    public static const NORMAL:String = "normal"; // нормальный режим (бег)
    public static const SLOUGH:String = "slough"; // замедление
    public static const SLIDING:String = "sliding"; // скольжение
    public static const PARALIZED:String = "paralized"; // парализованный

    private var _playerData:PlayerData;

    private var _shootBox:Sprite;           // клип, являющийся координатами для новых выстрелов

    private var _isInvulnerable:Boolean;    // неуязвимый (период когда игрок повреждён, и какой-то период неуязвим для новых атак)
    private var _invulnerableDuration:int = 2; // продолжительность неуязвимости

    private var _fist:Fist;

    private var o:Orion;

    /* CONSTRUCTOR */
    public function PlayerController(
            model:MovableModel,
            mainScreen:Sprite,
            stage:Stage,
            startPoint:Point,
            levelObject:LevelObject,
            isObstacledHited:Boolean,
            isGravityAffected:Boolean,
            isMovable:Boolean,
            playerTempData:PlayerData,
            movingMode:String=NORMAL)
    {
        super(this, model, new FaceMc(), startPoint.x, startPoint.y);
        _playerModel = model;
        _stage = stage;
        _isGravityAffected = isGravityAffected;
        _isObstacledHited = isObstacledHited;
        _isMovable = isMovable;
        _playerData = playerTempData;
        initClipLabels();
        if(_isObstacledHited) _obstacleController = new AObstacleController(this, _playerModel);
        if(_isGravityAffected) _gravityController = new AGravityObjectController(this, _playerModel);
        if(_isMovable)          _moveController = new AMovableController(this, _playerModel);

        _movingMode = movingMode;

        _mainScreen = mainScreen;
        _levelObject = levelObject;

        initCrystall();
        initConteinerSides();
        setOrientation(CustomMovieClip.RIGHT_ORI);
        updateShootBox(CustomMovieClip.RIGHT_ORI);

        _stage.addEventListener(CustomEvent.JUMP, jump, false);
        _stage.addEventListener(MouseEvent.MOUSE_MOVE, checkScaleX);
    }

    /* INIT CRYSTALL */
    private function initCrystall():void
    {
        _crystall =  _view["crystall"];
    }

    /* INIT CLIP LABELS */
    private function initClipLabels():void
    {
        clipLabels = new Vector.<ClipLabel>();
        clipLabels.push(new ClipLabel(ClipLabel.STAND, 12, 3));
        clipLabels.push(new ClipLabel(ClipLabel.DEATH, 1, 3));
        clipLabels.push(new ClipLabel(ClipLabel.RUN, 13, 0.5));
        clipLabels.push(new ClipLabel(ClipLabel.FLY_UP, 5, 0.5));
        clipLabels.push(new ClipLabel(ClipLabel.FLY_DOWN, 5, 0.5));
    }

    /* INIT CONTEINER SIDES */
    private function initConteinerSides():void
    {
        _contHalfWidth = hitBox.width/2;
        _contHalfHeight = hitBox.height/2;
    }

    /* DAMAGED */
    public override function damaged(damage:int=0):void
    {
        if(health > 0)
        {
            health = (_playerData.currentHealth-damage);
            super.damaged();
        }
    }

    /* UPDATE SHOOT BOX */
    private function  updateShootBox(value:int):void
    {
        if(value == LEFT_ORI)   _shootBox = _view.shootbox_left;
        else                    _shootBox = _view.shootbox_right;
    }

    /* PLAYER LOOP */
    public function loop():void
    {
        if(_isObstacledHited)   _obstacleController.hitTestWithObstacles();
        if(_isGravityAffected)  _gravityController.gravity();

        if(_movingMode == NORMAL)
        {
            if(_isMovable)
            {
                _moveController.isSlough = false;
                _moveController.moving();
            }
            checkForControllState();
        }
        // застрял в трясине
        else if(_movingMode == SLOUGH)
        {
            if(_isMovable)
            {
                _moveController.isSlough = true;
                _moveController.slough();
            }
            checkForControllState();
        }
        else if(_movingMode == PARALIZED)
        {
            if(_isMovable)
            {
                _moveController.paralized();
            }
        }
        else if(_movingMode == SLIDING)
        {
            if(_isMovable)
            {
                _moveController.isSlough = false;
                _moveController.sliding();
            }
            checkForControllState();
        }

        manaRecovery();
        healthRecovery();
    }

    /* MANA RECOVERY */
    // восстановление маны
    private var _manaRecoveryTimer:Timer;
    private function manaRecovery():void
    {
        if(_manaRecoveryTimer == null)
        {
            _manaRecoveryTimer = new Timer(1000);
            _manaRecoveryTimer.addEventListener(TimerEvent.TIMER, increaseMana);
            _manaRecoveryTimer.start();
        }
    }

    /* HEALTH RECOVERY TIMER */
    private var _healthRecoveryTimer:Timer;
    private function healthRecovery():void
    {
        if(_healthRecoveryTimer == null)
        {
            _healthRecoveryTimer = new Timer(1000);
            _healthRecoveryTimer.addEventListener(TimerEvent.TIMER, increaseHealth);
            _healthRecoveryTimer.start();
        }
    }

    /* INCREASE HEALTH */
    private function increaseHealth(e:TimerEvent):void
    {
        _playerData.currentHealth += _playerData.healthRecovery;
    }

    /* INCREASE MANA */
    private function increaseMana(e:TimerEvent):void
    {
        _playerData.currentMana += _playerData.manaRecovery;
    }

    /* CHECK SCALE X */
    private function checkScaleX(e:MouseEvent):void
    {
        // привязка scaleX вида в зависимости от координат мыши
        if(e.localX < view.x)
        {
            setOrientation(CustomMovieClip.LEFT_ORI, true);
            updateShootBox(CustomMovieClip.LEFT_ORI);
        }
        else
        {
            setOrientation(CustomMovieClip.RIGHT_ORI, true);
            updateShootBox(CustomMovieClip.RIGHT_ORI);
        }
    }

    /* CHECK FOR BITMAP ORIENTATION */
    private function checkForControllState():void
    {
        if(_playerModel.isLeft)
        {
            _playerModel.speedX = Math.abs(_playerModel.speedX) * -1;
        }
        else
        {
            _playerModel.speedX = Math.abs(_playerModel.speedX);
        }

        if(_playerModel.isLeft || _playerModel.isRight)
        {
            if(_playerModel.isOnGround)
            {
                playState(ClipLabel.RUN);
                dust();
            }
            else
            {
                playState(ClipLabel.FLY_UP);
                deactivateDustTimer();
            }
        }
        else
        {
            if(_playerModel.isJump)
            {
                playState(ClipLabel.FLY_UP);
            }
            else if(_playerModel.isOnGround)
            {
                playState(ClipLabel.STAND);
            }
            deactivateDustTimer();
        }
    }

    /* DUST */
    private var _dustTimer:Timer;
    private var _isRunDust:Boolean;
    private function dust():void
    {
        if(!_isRunDust)
        {
//            SoundManager.playSound(SoundManager.GG_RUN, 0.6, 0, 0, true);
            _isRunDust = true;
            if(_dustTimer == null)
            {
                _dustTimer = new Timer(200);
                _dustTimer.addEventListener(TimerEvent.TIMER, dispatchDust);
                _dustTimer.start();
            }
            else
            {
                _dustTimer.reset();
                _dustTimer.start();
            }
        }
    }
    private function dispatchDust(e:TimerEvent):void
    {
        _view.dispatchEvent(new CustomEvent(CustomEvent.DUST, null, false, false, {bulletX:_view.x, bulletY:_view.y + _view.height/2}));
    }
    private function deactivateDustTimer():void
    {
        if(_dustTimer)
        {
//            SoundManager.fadeSound(SoundManager.GG_RUN);
            _dustTimer.stop();
            _isRunDust = false;
        }
    }

    /* PARALIZED */
    // парализование
    private var _paralizedTimer:Timer;
    public function paralized():void
    {
        _movingMode = PARALIZED;
        _mainScreen.dispatchEvent(new CustomEvent(CustomEvent.SHOW_PARALIZED, PlayerController, false, false, {x:_view.x, y:_view.y}));
        if(_stage.hasEventListener(MouseEvent.MOUSE_MOVE)) _stage.removeEventListener(MouseEvent.MOUSE_MOVE, checkScaleX);
        pause();
        _paralizedTimer = new Timer(1500, 1);
        _paralizedTimer.addEventListener(TimerEvent.TIMER_COMPLETE, unparalized);
        _paralizedTimer.start();
    }

    private function unparalized(e:TimerEvent):void
    {
        if(!_stage.hasEventListener(MouseEvent.MOUSE_MOVE)) _stage.addEventListener(MouseEvent.MOUSE_MOVE, checkScaleX);
        resume();
        _paralizedTimer.stop();
        _paralizedTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, unparalized);
        _paralizedTimer = null;
        _movingMode = NORMAL;
    }

    /* PAUSE */
    public override function pause():void
    {
        super.pause();
        if(_dustTimer) _dustTimer.stop();
        if(_manaRecoveryTimer) _manaRecoveryTimer.stop();
        if(_healthRecoveryTimer) _healthRecoveryTimer.stop();
    }

    /* RESUME */
    public override function resume():void
    {
        super.resume();
        if(_dustTimer) _dustTimer.start();
        if(_manaRecoveryTimer) _manaRecoveryTimer.start();
        if(_healthRecoveryTimer) _healthRecoveryTimer.start();
    }

    /* JUMP */
    private function jump(e:CustomEvent):void
    {
        if(_playerModel.jumpAmount == 0 && _playerModel.hitDown)
        {
            _playerModel.isOnGround = false;
            _playerModel.isUp = false;
            _playerModel.jumpAmount++;
            _playerModel.isJump = true;
//            _view.dispatchEvent(new CustomEvent(CustomEvent.JUMP));
        }
    }

    /* DEACTIVATE */
    public override function deactivate():void
    {
        super.deactivate();
        removeHitBox();
        if(_dustTimer)
        {
            _dustTimer.stop();
            _dustTimer.removeEventListener(TimerEvent.TIMER, dispatchDust);
            _dustTimer = null;
        }
        if(_manaRecoveryTimer)
        {
            _manaRecoveryTimer.stop();
            _manaRecoveryTimer.removeEventListener(TimerEvent.TIMER, manaRecovery);
            _manaRecoveryTimer = null;
        }
        if(_healthRecoveryTimer)
        {
            _healthRecoveryTimer.stop();
            _healthRecoveryTimer.removeEventListener(TimerEvent.TIMER, healthRecovery);
            _healthRecoveryTimer = null;
        }
        _stage.removeEventListener(CustomEvent.JUMP, jump, false);
        _stage.removeEventListener(MouseEvent.MOUSE_MOVE, checkScaleX);

        // remove view
        if(_mainScreen.contains(_view)) _mainScreen.removeChild(_view);
    }

    public function get playerCont():Sprite {return view;}

    public function get crystall():Sprite {return _crystall;}

    public function get contCoordinates():Point{return new Point(_view.x, _view.y);}

    public function get isInvulnerable():Boolean {return _isInvulnerable;}
    public function set isInvulnerable(value:Boolean):void {_isInvulnerable = value;}

    public function get contHalfWidth():Number {return _contHalfWidth;}

    public function get contHalfHeight():Number {return _contHalfHeight;}

    public function get playerModel():MovableModel {return _playerModel;}

    public function get health():int {return _playerData.currentHealth;}
    public function set health(value:int):void
    {
        var _value:int = Math.abs(_playerData.currentHealth-value);
        _view.dispatchEvent(new CustomEvent(CustomEvent.SHOW_DAMAGE, PlayerController, true, false, {value:_value, color:0xFF0B0B, x:_view.x, y:_view.y}));
        _playerData.currentHealth = value;
    }

    public function get fist():Fist {return _fist;}
    public function set fist(value:Fist):void {_fist = value;}

    public function get totalHealth():int {return _totalHealth;}

    public function get movingMode():String {return _movingMode;}
    public function set movingMode(value:String):void {_movingMode = value;}

    public function get shootBox():Sprite {return _shootBox;}


}
}
