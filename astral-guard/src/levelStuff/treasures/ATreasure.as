/**
 * Created by Sith on 27.06.14.
 */
package levelStuff.treasures
{
import custom.CustomEvent;
import custom.CustomMovieClip;

import data.GameData;
import data.PlayerData;
import flash.display.Sprite;
import flash.events.TimerEvent;
import flash.filters.GlowFilter;
import flash.utils.Timer;

import gui.inventory.ARune;
import gui.inventory.AScroll;
import gui.inventory.IItem;
import gui.inventory.IMagnet;

import levelStuff.controllers.AGravityObjectController;
import levelStuff.controllers.AMovableController;
import levelStuff.controllers.ASimpleObstacleController;
import player.MovableModel;
import player.PlayerController;

import sound.SoundManager;

public class ATreasure extends CustomMovieClip implements ITreasure
{
    private var _value:int;
    private var _isHitByPlayer:Boolean;
//    private var _glow:GlowFilter;
    private var _color:uint;

    private var _model:MovableModel;
    private var _obsController:ASimpleObstacleController;
    private var _moveController:AMovableController;
    private var _gravityController:AGravityObjectController;

    private var _type:String;

    private var _playerData:PlayerData;
    private var _playerController:PlayerController;

    private var _isTimeoutHiding:Boolean; // пропадает ли ценность интервал времени
    private const HIDING_TIME:Number = 4000;
    private var _destroyCallback:Function;

    /* CONSTRUCTOR */
    public function ATreasure(x:Number, y:Number, type:String, value:int, playerData:PlayerData, playerController:PlayerController, color:uint, isTimeoutHiding:Boolean=true, destroyCallback:Function=null)
    {
        _type = type;
        _color = color;
        _model = new MovableModel();

        super(ATreasure, _model, null, x, y);
        _playerData = playerData;

        _playerController = playerController;

        _destroyCallback = destroyCallback;

        _value = value;

        _obsController = new ASimpleObstacleController(this, _model, 240);
        _moveController = new AMovableController(this, _model);
        _gravityController = new AGravityObjectController(this, _model);
    }

    /* ACTIVATE */
    public function activate():void
    {
        switch (_type)
        {
            case TList.HEALTH_POTION_SMALL:
                    var thirdHealth:int = int(_playerData.totalHealth/3);
                    _playerData.currentHealth += thirdHealth;
                    view.dispatchEvent(new CustomEvent(CustomEvent.HIT_POTION, ATreasure, true, false, {potionType:"red"}));
                    break;
            case TList.HEALTH_POTION_MID:
                var halfHealth:int = int(_playerData.totalHealth/2);
                _playerData.currentHealth += halfHealth;
                view.dispatchEvent(new CustomEvent(CustomEvent.HIT_POTION, ATreasure, true, false, {potionType:"red"}));
                break;
            case TList.HEALTH_POTION_BIG:
                var totalHealth:int = int(_playerData.totalHealth);
                _playerData.currentHealth += totalHealth;
                view.dispatchEvent(new CustomEvent(CustomEvent.HIT_POTION, ATreasure, true, false, {potionType:"red"}));
                break;
            case TList.MANA_POTION_SMALL:
                var thirdMana:int = int(_playerData.totalMana/3);
                _playerData.currentMana += thirdMana;
                view.dispatchEvent(new CustomEvent(CustomEvent.HIT_POTION, ATreasure, true, false, {potionType:"blue"}));
                break;
            case TList.MANA_POTION_MID:
                var halfMana:int = int(_playerData.totalMana/2);
                _playerData.currentMana += halfMana;
                view.dispatchEvent(new CustomEvent(CustomEvent.HIT_POTION, ATreasure, true, false, {potionType:"blue"}));
                break;
            case TList.MANA_POTION_BIG:
                var totalMana:int = int(_playerData.totalMana);
                _playerData.currentMana += totalMana;
                view.dispatchEvent(new CustomEvent(CustomEvent.HIT_POTION, ATreasure, true, false, {potionType:"blue"}));
                break;
            default :
                    // coins
                    if(_type.indexOf("coin") == 0)
                    {
                        SoundManager.playSound(SoundManager.TREASURE_TAKE, 0.6);
                        _playerData.currentTempCoinsAmount += _value;
                    }
                    else if(_type.indexOf("rune") == 0)
                    {
                        // TODO: sound "take rune"
                        var item:IItem = GameData.getNewItem(_type);
                        _playerData.userItems.push(item);
                    }
                break;
        }
    }

    /* LOOP */
    private var _magnet:IMagnet;
    public function loop():void
    {
        if(!model.hitDown)
        {
            _obsController.hitTestWithObstacles();
            _gravityController.gravity();
            _moveController.moving();
        }
        // притягиваем только упавшие сокровища
        else
        {
            if(!_isStartHiding && _isTimeoutHiding)
            {
                _isStartHiding = true;
                startHide();
            }
            // если у игрока в рюкзаке есть магнит
            if(_playerData.getMagnet && _magnet == null)
            {
                _magnet = _playerData.getMagnet();
            }
        }

        if(_magnet)
        {
            var curDist:Number = Math.abs(_playerController.view.x - _view.x);
            // если ценности в радиусе охвата магнитом - притягиваем её
            if(curDist < _magnet.dist)
            {
                var ratio:Number = curDist/_magnet.dist;
                var tresSpeed:Number = 2 * ratio;
                var _isRightDir:Boolean;
                _isRightDir = _playerController.view.x > _view.x;
                if(_isRightDir) _view.x += tresSpeed;
                else            _view.x -= tresSpeed;
            }
        }
    }

    /* START HIDE */
    private var _isStartHiding:Boolean = false;
    private var _hidingTimer:Timer;
    private function startHide():void
    {
//        trace("start HIDING treasure !");
        _hidingTimer = new Timer(HIDING_TIME, 1);
        _hidingTimer.addEventListener(TimerEvent.TIMER_COMPLETE, startFlashing);
        _hidingTimer.start();
    }

    /* START FLASHING */
    private function startFlashing(e:TimerEvent):void
    {
        if(_hidingTimer)
        {
            _hidingTimer.stop();
            _hidingTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, startFlashing);
            _hidingTimer = null;
        }
//        trace("start alpha flashing !");
        alphaFlashing(HIDING_TIME/1000, 6, destroyCallback);
    }

    private function destroyCallback():void
    {
        _destroyCallback(this);
    }

    /* INIT VIEW */
    public override function initView(x:Number, y:Number, height:Number, width:Number):void
    {
        // если драгоценности или бутылочки
        if(_type.indexOf("coin") == 0)_view = new TreasuresMc();
        else if(_type.indexOf("rune") == 0)_view = new McRune();
        else if(_type.indexOf("scroll") == 0)_view = new McScroll();
        else if(_type.indexOf("potion") == 0)_view = new TreasuresMc();
        _view.cacheAsBitmap = true;
        hitBox = _view["hitBox"];
        hitBox.alpha = 0;
        _view.gotoAndStop(_type);
//        _view.filters = [new GlowFilter(_color, 0.2, 7, 10, 3)];
        _view.x = x;
        _view.y = y;
    }

    /* DEACTIVATE */
    public override function deactivate():void
    {
        if(_hidingTimer)
        {
            _hidingTimer.stop();
            _hidingTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, startFlashing);
            _hidingTimer = null;
        }
        super.deactivate();

    }

    public function get value():int {return _value;}

    public function get isHitByPlayer():Boolean {return _isHitByPlayer;}
    public function set isHitByPlayer(value:Boolean):void {_isHitByPlayer = value;}

    public function get model():MovableModel {return _model;}

    public function get type():String {return _type;}
}
}
