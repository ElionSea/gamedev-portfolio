/**
 * Created by Sith on 20.07.14.
 */
package levelStuff.enemies
{
import custom.CustomMovieClip;

import flash.display.MovieClip;
import flash.display.Shape;
import flash.display.Sprite;

import levelStuff.controllers.AGravityObjectController;
import levelStuff.controllers.AMovableController;
import levelStuff.controllers.AObstacleController;

import player.MovableModel;

// представляет фрагмент (осколок) разлетевшегося на чатси врага
public class Fragment extends CustomMovieClip
{
    private var _model:MovableModel;
    private var _rotate:Number;
    private var _angle:Number;
    private var _isAlreadyMoved:Boolean;
    private var _accelerationY:Number;

    private var _obstacleController:AObstacleController;
    private var _gravityController:AGravityObjectController;
    private var _moveableController:AMovableController;

    public function Fragment($view:MovieClip, rotation:Number, angle:Number, width:Number, height:Number, x:Number, y:Number)
    {
        _model = new MovableModel();
        super(this, _model, $view, x, y);
        super.hitBox = initHitBox(width, height);
        super.hitBox.alpha = 0;
        _rotate = rotation;
        _angle = angle;

        _obstacleController = new AObstacleController(this, _model);
        _gravityController = new AGravityObjectController(this, _model);
        _moveableController = new AMovableController(this, _model);
    }

    private function initHitBox(width:Number, height:Number):Sprite
    {
        var shape:Shape = new Shape();
        shape.graphics.beginFill(0xFF00AA, 0.3);
        shape.graphics.drawRect(0, 0, width, height);
        shape.graphics.endFill();
        var spr:Sprite = new Sprite();
        _view.addChild(shape);
        _view.x = x;
        _view.y = y;
        return spr;
    }

    public function move():void
    {
//        _obstacleController.hitTestWithObstacles();
//        _gravityController.gravity();
//        _moveableController.moving();
       /* _view.x += Math.cos(_angle) * 2;
        _accelerationY = .2;
//        _accelerationY += 0.5;
        var angle:Number = (Math.sin(_angle) * 2);
        _accelerationY  += angle;
        _view.y += _accelerationY;
        _view.rotation += _rotate;*/
    }

    public function get isAlreadyMoved():Boolean {return _isAlreadyMoved;}
    public function set isAlreadyMoved(value:Boolean):void {_isAlreadyMoved = value;}


    public function get rotate():Number {
        return _rotate;
    }

    public function get angle():Number {
        return _angle;
    }
}
}
