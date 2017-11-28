/**
 * Created by Sith on 05.07.14.
 */
package levelStuff.controllers {
import custom.ICustomMovieClip;

import flash.display.MovieClip;

import flash.geom.Point;

import levelStuff.enemies.AEnemy;

import player.MovableModel;

import xmlParsingTiledLevel.ArrayTile;
import xmlParsingTiledLevel.LevelObject;

public class AObstacleController
{
    private var _object:ICustomMovieClip;
    private var _objectView:MovieClip;
    private var _objectModel:MovableModel;

    private var _contHalfWidth:Number;
    private var _contHalfHeight:Number;

    private var _upTile:ArrayTile;
    private var _tempUpTile:ArrayTile;
    private var _leftTile:ArrayTile;
    private var _rightTile:ArrayTile;
    private var _currentUnderTile:ArrayTile  = new ArrayTile(0, 0, 0, false);
    private var _prevUnderTile:ArrayTile = new ArrayTile(0, 0, 0, false);
    private var tempDownTile:ArrayTile;
    private var downSideXLeft:Number;
    private var downSideY:Number;
    private var first:Boolean = true;

    // new method
    private var _leftUnderTile:ArrayTile;
    private var _rightUnderTile:ArrayTile;


    /* CONSTRUCTOR */
    public function AObstacleController(object:ICustomMovieClip, objectModel:MovableModel)
    {
        _object = object;
        _objectView = _object.view;
        _objectModel = objectModel;

        initConteinerSides();
    }

    /* INIT CONTEINER SIDES */
    private function initConteinerSides():void
    {
        _contHalfWidth = _object.hitBox.width/2;
        _contHalfHeight = _object.hitBox.height/2;
    }

    /* HIT TEST WITH OBSTACLES */
    public function hitTestWithObstacles():void
    {
        var leftSide:Point = new Point(_objectView.x-_contHalfWidth-5, _objectView.y/*+_contHalfHeight-Platformer.TILE_SIZE*/);
        var rightSide:Point = new Point(_objectView.x+_contHalfWidth+5, _objectView.y/*+_contHalfHeight-Platformer.TILE_SIZE*/);
        var upSide:Point = new Point(_objectView.x, _objectView.y-_contHalfHeight);

        // HIT LEFT
        _leftTile = LevelObject.getTileByPoint(leftSide.x, leftSide.y);
        _rightTile = LevelObject.getTileByPoint(rightSide.x, rightSide.y);

        if(_leftTile)
        {
            if(_leftTile.isObstacle)
            {
                _objectModel.hitLeft = true;
                var tempHitLeft:Number = _objectView.x;
//                _objectModel.vx = 0;
//                _objectModel.speedX = 0;
//                _objectModel.accelerationX = 0;
                _objectModel.isLeft = false;
            }
            else
            {
                _objectModel.hitLeft = false;
            }
        }

        // HIT RIGHT

        if(_rightTile)
        {
            if(_rightTile.isObstacle)
            {
                _objectModel.hitRight = true;
                var tempHitRight:Number = _objectView.x;
//                _objectModel.vx = 0;
//                _objectModel.speedX = 0;
//                _objectModel.accelerationX = 0;
                _objectModel.isRight = false;
            }
            else
            {
                _objectModel.hitRight = false;
            }
        }

        // HIT UP
        _tempUpTile = LevelObject.getTileByPoint(upSide.x, upSide.y);
        if(_tempUpTile)
        {
            if(_tempUpTile.isObstacle)
            {
                _objectModel.hitUp = true;
                _objectModel.isUp = false;
                _objectModel.jumpForce = -2.1;
                _objectView.y = _tempUpTile.y + Platformer.TILE_SIZE + _contHalfHeight;
            }
            else
            {
                _objectModel.hitUp = false;
            }
        }

        // new HIT DOWN
        var viewY:Number = _objectView.y+_contHalfHeight+2;
        _leftUnderTile = LevelObject.getTileByPoint(_objectView.x-_contHalfWidth-2, viewY);
        _rightUnderTile = LevelObject.getTileByPoint(_objectView.x+_contHalfWidth+2, viewY);

        if(_leftUnderTile && _rightUnderTile)
        {
            // если в воздухе
            if((!_leftUnderTile.isObstacle) && (!_rightUnderTile.isObstacle))
            {
                _objectModel.isOnGround = false;
                _objectModel.hitDown = false;
                _objectModel.isJump = false;
            }
            else if((_leftUnderTile.isObstacle) || (_rightUnderTile.isObstacle))
            {
                // fix
                if(((_objectView.y+_contHalfHeight) > _leftUnderTile.y))
                {
                    _objectView.y = _leftUnderTile.y-_contHalfHeight;
                }
                else if( ((_objectView.y+_contHalfHeight) > _rightUnderTile.y))
                {
                    _objectView.y = _rightUnderTile.y-_contHalfHeight;
                }
                _objectModel.hitDown = true;
                _objectModel.isOnGround = true;
                _objectModel.isDown = false;
            }
        }

    }
}
}
