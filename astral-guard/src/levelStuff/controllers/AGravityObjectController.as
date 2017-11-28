/**
 * Created by Sith on 05.07.14.
 */
package levelStuff.controllers
{

import custom.ICustomMovieClip;

import flash.display.MovieClip;
import flash.events.TimerEvent;
import flash.utils.Timer;

import levelStuff.enemies.AEnemy;

import player.MovableModel;
import player.PlayerController;

public class AGravityObjectController
{
    private var _object:ICustomMovieClip;
    private var _objectView:MovieClip;
    private var _objectModel:MovableModel;
    private var _gravity:Number = GRAVITY;
    private const GRAVITY:Number = 0.2;

    /* CONSTRUCTOR */
    public function AGravityObjectController(object:ICustomMovieClip, objectModel:MovableModel)
    {
        _object = object;
        _objectView = _object.view;
        _objectModel = objectModel;
    }

    /* GRAVITY */
    public function gravity():void
    {
        if(!_objectModel.isJump)
        {

            if(!_objectModel.hitDown)
            {
                _objectModel.vy +=  _objectModel.accelerationY;
                _objectView.y += _objectModel.vy;
                _objectModel.accelerationY = _gravity;
                _gravity = MovableModel.GRAVITY;
            }
            else
            {
                _objectModel.vy +=  0;
                _objectView.y += 0;
                _objectModel.accelerationY = 0;
                _gravity = 0;
            }
        }
        // is Jump
        else
        {
            if(_objectModel.hitDown)
            {
                if(_object is AEnemy)
                {
//                    _objectModel.accelerationY = MovableModel.ENEMY_JUMP_FORCE;
//                   TweenMax.to(_objectView, 0.4, {x:_objectView.x + (15*_objectView.scaleX), delay:0.4, onComplete:endTween});
                }
                else if(_object is PlayerController)
                {
                    _objectModel.accelerationY = MovableModel.PLAYER_JUMP_FORCE;
                }
                _objectModel.vy += _objectModel.accelerationY;
                _objectView.y += _objectModel.vy;
                _gravity = MovableModel.GRAVITY;
                var timer:Timer = new Timer(500, 1);
                timer.addEventListener(TimerEvent.TIMER_COMPLETE, endJump);
                timer.start();

                function endJump(e:TimerEvent):void
                {
                    _objectModel.isJump = false;
                    timer.removeEventListener(TimerEvent.TIMER_COMPLETE, endJump);
                    timer = null;
                }
            }
        }
    }

    private function endTween():void
    {
        _objectModel.isLeft = true;
        _objectModel.isRight = true;
        _objectModel.hitDown = true;
        _objectModel.speedX = _objectModel.tempSpeedX * _objectView.scaleX;
        _objectModel.accelerationX = _objectModel.tempAccelerationX;
    }
}
}
