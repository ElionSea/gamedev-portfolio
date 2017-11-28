/**
 * Created by Sith on 05.07.14.
 */
package levelStuff.controllers
{
import custom.ICustomMovieClip;

import flash.display.MovieClip;

import flash.geom.Point;

import levelStuff.enemies.AEnemy;

import player.MovableModel;

import xmlParsingTiledLevel.ArrayTile;
import xmlParsingTiledLevel.LevelObject;

/* сталкивается по-простому */
public class ASimpleObstacleController
{
    private var _object:ICustomMovieClip;
    private var _objectView:MovieClip;
    private var _objectModel:MovableModel;

    private var _contHalfWidth:Number;
    private var _contHalfHeight:Number;

    // new method
    private var _underTile:ArrayTile;
    private var _blockLevel:Number;

    /* CONSTRUCTOR */
    public function ASimpleObstacleController(object:ICustomMovieClip, objectModel:MovableModel, blockLevel:Number)
    {
        _object = object;
        _objectView = _object.view;
        _objectModel = objectModel;
        _blockLevel = blockLevel;

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
        // hit left side
        var leftSideX:Number = (_objectView.x-_contHalfWidth);
        if(leftSideX < 80)
        {
            _objectView.x = 80+_contHalfWidth;
            _objectModel.hitLeft = true;
//            _objectModel.isLeft = false;
        }
        else
        {
            _objectModel.hitLeft = false;
        }
        // hit right side
        var rightSideX:Number = (_objectView.x+_contHalfWidth);
        if(rightSideX > 272)
        {
            _objectView.x = 272-_contHalfWidth;
            _objectModel.hitRight = true;
//            _objectModel.isRight = false;
        }
        else
        {
            _objectModel.hitRight = false;
        }

        // new HIT DOWN
            var viewY:Number = _objectView.y+_contHalfHeight+5;
            // если в воздухе
            if(viewY < _blockLevel)
            {
                _objectModel.isOnGround = false;
                _objectModel.hitDown = false;
                _objectModel.isJump = false;
            }
            else if(viewY >= _blockLevel)
            {
                // fix
                if(((_objectView.y+_contHalfHeight) > _blockLevel))
                {
                    _objectView.y = _blockLevel-_contHalfHeight;
                }
                _objectModel.hitDown = true;
                _objectModel.isOnGround = true;
                _objectModel.isDown = false;
            }

    }
}
}
