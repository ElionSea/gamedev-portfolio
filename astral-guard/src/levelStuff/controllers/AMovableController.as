/**
 * Created by Sith on 05.07.14.
 */
package levelStuff.controllers
{
import custom.ICustomMovieClip;

import flash.display.MovieClip;

import player.MovableModel;

public class AMovableController
{
    private var _object:ICustomMovieClip;
    private var _objectView:MovieClip;
    private var _model:MovableModel;

    /* CONSTRUCTOR */
    public function AMovableController(object:ICustomMovieClip, objectModel:MovableModel)
    {
        _object = object;
        _objectView = _object.view;
        _model = objectModel;
        _tempModelMaxSpeed = _model.maxSpeed;
    }

    /* PARALIZED */
    public function paralized():void
    {
        _model.maxSpeed = 0;
        _model.accelerationX = 0;
        _model.speedX = 0;
        _model.vx = 0;
        _model.accelerationY = 0;
        _model.speedY = 0;
        _model.vy = 0;
    }

    /* SLIDING */
    private var _sliding:Number = 0;
    public function sliding():void
    {
        if(_model.hitDown)
        {
            if(_model.isLeft && !_model.hitLeft)
            {
                _sliding += -0.2;
                _sliding *= 1.05;
            }
            else if(_model.isRight && !_model.hitRight)
            {
                _sliding += 0.2;
                _sliding *= 1.05;
            }
            else
            {
                _sliding *= 0.05;
            }

        }
        if(!_model.hitLeft && !_model.hitRight)
        {
            _model.vx += _sliding;

        }
        moving();
    }

    /* SLOUGH */
    private var _tempModelMaxSpeed:Number;
    private var _isSlough:Boolean;
    public function slough():void
    {
        _model.maxSpeed = 0.2;
        moving();
    }

    /* MOVING */
    public function moving():void
    {
        if(!_isSlough) _model.maxSpeed = _tempModelMaxSpeed;
        if(_model.isLeft && !_model.hitLeft)
        {
            _model.accelerationX = -0.2;
            _model.speedX += _model.accelerationX;
            _model.vx = _model.speedX;
        }
        else if(_model.isRight && !_model.hitRight)
        {
            _model.accelerationX = 0.2;
            _model.speedX += _model.accelerationX;
            _model.vx = _model.speedX;
        }

        // limit vx speed by maxSpeed
        if(_model.vx > 0 && _model.vx >  _model.maxSpeed)
        {
            _model.vx = _model.maxSpeed;
        }
        else if(_model.vx < 0 &&  _model.vx <  -(_model.maxSpeed))
        {
            _model.vx = -(_model.maxSpeed);
        }

        _model.jumpForce = MovableModel.PLAYER_JUMP_FORCE;
        if(_model.hitDown)
        {
            _model.jumpAmount = 0;
            _model.vy = 0;
        }

        _objectView.x += _model.vx;
    }

    public function get isSlough():Boolean {return _isSlough;}
    public function set isSlough(value:Boolean):void {_isSlough = value;}
}
}
