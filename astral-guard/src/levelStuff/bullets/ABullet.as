/**
 * Created by Sith on 26.06.14.
 */
package levelStuff.bullets
{
import com.greensock.TweenLite;

import custom.ClipLabel;

import custom.CustomMovieClip;

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.TimerEvent;
import flash.filters.GlowFilter;
import flash.geom.Point;
import flash.utils.Timer;

import levelStuff.enemies.Trajectory;

import player.MovableModel;

public class ABullet extends CustomMovieClip implements IBullet
{
    private var _isDamaged:Boolean;
    private var _model:MovableModel;
    private var _bulletDamage:int;
    protected var _trajectory:Trajectory;
    private var _glowFilter:GlowFilter = new GlowFilter(0xFFF69F, 0.4, 10, 10, 3);

    private var _endX:Number;
    private var _endY:Number;

    private var _angle:Number;
    private var _rotation:Number;

    private var _clipLabelByDefault:ClipLabel;

    private var _xDir:Number;
    private var _yDir:Number;

    private var _isDied:Boolean;
    private var _isLaser:Boolean;
    private var _isEnemyBullet:Boolean;
    private var _isWithTail:Boolean;
    private var _isParalized:Boolean;

    private var _targetObject:MovieClip;
    private var _mainScreen:Sprite;

    private var _tailView:Class;

    /* CONSTRUCTOR */
    public function ABullet(
            view:MovieClip,
            startX:Number,
            startY:Number,
            $speed:Number,
            bulletDamage:int,
            endX:Number,
            endY:Number,
            isEnemyBullet:Boolean,
            trajectory:Trajectory,
            targetObject:MovieClip=null,
            reverseDir:Boolean=false,
            isRotationable:Boolean=true,
            isLaser:Boolean=false,
            mainScreen:Sprite=null,
            isWithTail:Boolean=false,
            tailView:Class=null,
            isParalized:Boolean=false)
    {
        _mainScreen = mainScreen;
        _model = new MovableModel();
        _endX = endX;
        _endY = endY;
        _isLaser = isLaser;
        _targetObject = targetObject;
        if(_targetObject != null) _isTargetObjectWas = true;
        _trajectory = trajectory;
        _isEnemyBullet = isEnemyBullet;
        super(this, _model, view, startX, startY);
        _bulletDamage = bulletDamage;
        _view.x = startX;
        _view.y = startY;
        _model.speedX = $speed;
        _model.speedY = $speed;
        _isDamaged = true;
        _isWithTail = isWithTail;
        _tailView = tailView;
        _isParalized = isParalized;

        var yDist:Number;
        var xDist:Number;
        if(reverseDir)
        {
            yDist = _view.y - _endY;
            xDist = _view.x - _endX;
        }
        else
        {
            yDist = (_endY) - _view.y;
            xDist = (_endX) - _view.x;
        }
        var angle:Number = Math.atan2(yDist, xDist);
        _xDir = Math.cos(angle);
        _yDir =  Math.sin(angle);

        if(angle != 0)
        {
            if(isRotationable) _view.rotation = angle * 180 / Math.PI;
        }
    }

    /* INIT TARGET OBJECT */
    public function initTargetObj(targetObject:MovieClip):void
    {
        _targetObject = targetObject;
    }

    /* MOVE */
    private var _isTargetObjectWas:Boolean;
    private var _tailTimer:Timer;
    public function move():void
    {
//        if(_isWithTail && (_tailTimer == null)) showTail();
        // если у траектории есть цель привязки
        if(_targetObject)
        {
            // если цель привязки на сцене
            if(_mainScreen.contains(_targetObject))
            {
                var pnt:Point = new Point(_targetObject.x, _targetObject.y);
                _trajectory.move(_model.speedX, _model.speedY, pnt, null, 0, _xDir, _yDir);
            }
            // если цель привязки пропала со сцены
            else
            {
                _trajectory.trajectoryType = Trajectory.FLY_BY_ANGLE;
                _trajectory.move(_model.speedX, _model.speedY, null, null, 0, _xDir, _yDir);
            }
        }
        else
        {
            _trajectory.move(_model.speedX, _model.speedY, null, null, 0, _xDir, _yDir);
        }
    }

    /* SHOW TAIL */
    private function showTail():void
    {
//        trace("SHOW TAIL !");
        _tailTimer = new Timer(250);
        _tailTimer.addEventListener(TimerEvent.TIMER, addTail);
        _tailTimer.start();
    }

    /* ADD TAIL */
    private function addTail(e:TimerEvent):void
    {
        var tail:MovieClip = new _tailView;
        tail.x = _view.x;
        tail.y = _view.y;
        _mainScreen.addChild(tail);
        TweenLite.to(tail, 0.5, {alpha:0, onComplete:deleteTail});
        function deleteTail():void
        {
            _mainScreen.removeChild(tail);
            tail = null;
        }
    }

    /* DEACTIVATE */
    public override function deactivate():void
    {
        if(_tailTimer)
        {
            _tailTimer.stop();
            _tailTimer.removeEventListener(TimerEvent.TIMER, addTail);
            _tailTimer = null;
        }
        super.deactivate();

    }

    public function loop():void{}

    public function get isDamaged():Boolean {return _isDamaged;}

    public function set isDamaged(value:Boolean):void {_isDamaged = value;}

    public function get bulletDamage():int {return _bulletDamage;}

    public function get isDied():Boolean {return _isDied;}

    public function set isDied(value:Boolean):void {_isDied = value;}

    public function get isEnemyBullet():Boolean {return _isEnemyBullet;}

    public function get isLaser():Boolean {return _isLaser;}

    public function set clipLabelByDefault(clipLabelName:ClipLabel):void {_clipLabelByDefault = clipLabelName;}

    public function get clipLabelByDefault():ClipLabel {return _clipLabelByDefault;}

    public function get isParalized():Boolean {
        return _isParalized;
    }

    public function set isParalized(value:Boolean):void {
        _isParalized = value;
    }
}
}
