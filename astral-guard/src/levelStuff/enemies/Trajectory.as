/**
 * Created by Sith on 02.07.14.
 */
package levelStuff.enemies
{
import com.greensock.TweenMax;
import com.greensock.easing.Quad;

import flash.display.MovieClip;
import flash.geom.Point;

import player.MovableModel;

public class Trajectory
{
    public static const LEANER:String = "leaner";
    public static const SINUS:String = "sinus";
    public static const NEW_SINUS:String = "newSinus";
    public static const NEW_SINUS2:String = "newSinus2";
    public static const NEW_COSINUS:String = "newCosinus";
    public static const NEW_COSINUS2:String = "newCosinus2";
    public static const WALK_TO_PLAYER:String = "walkToPlayer";
    public static const FLY_TO_PLAYER:String = "flyToPlayer";
    public static const WAITING:String = "waiting";
    public static const WALKING_BY_PLAYER:String = "walkingByPlayer";
    public static const ASTEROID:String = "asteroid";
    public static const JUMPER:String = "jumper";
    public static const TWEEN_TO_POINT:String = "tweenToPoint";
    public static const FLY_BY_ANGLE:String = "flyByAngle";                     // безконечное движение под заданным углом до упора в препятствие
    public static const AROUND_THE_POINT:String = "aroundThePoint";             // круговое вращение вокруг заданной точки
    public static const GLUE_TO_POINT:String = "glueToPoint";                   // привязка к точке
    public static const SINUS_BY_ANGLE:String = "sinusByAngle";                 // синусоида под углом
    public static const STATIC:String = "static";                               // бездвижный
    public static const TWEENMAX_TO_POINT:String = "tweenMaxToPoint";           // передвижение tweenmax
    public static const VERTICAL_FALLING_DOWN:String = "verticalFallingDown";   // падение вниз с ускорением
    public static const SNOWFLAKE:String = "snowflake";                         // "как снежинка"

//    private var _startX:Number;
    private var _model:MovableModel;
    private var _startY:Number;
    private var _startX:Number;
    private var _moveWidth:Number;
    private var _freqFactor:Number;
    private var _waitingTime:Number;
    private var _trajectoryType:String;
    private var _view:MovieClip;
    private var _isJump:Boolean;
    private var _angle:Number;
    private var _radius:Number;

    /* CONSTRUCTOR */
    public function Trajectory(
            view:MovieClip,
            startX:Number,
            startY:Number,
            moveWidth:Number,
            trajectoryType:String,
            speedX:Number,
            speedY:Number,
            freqFactor:Number = 1,
            waitingTime:Number = 0,
            angle:Number=0,
            radius:Number=0)
    {
        _view = view;
        _startX = startX;
        _startY = startY;
        _moveWidth = moveWidth;
        _freqFactor = freqFactor;
        _waitingTime = waitingTime;
        _trajectoryType = trajectoryType;
        _angle = angle;
        _radius = radius;
    }

    /* INIT MODEL */
    public function initModel(model:MovableModel):void
    {
        _model = model;
    }

    /* MOVE */
    private var _tempPoint:Point;
    private var _firstJump:Boolean = true;
    public function move(speedX:Number, speedY:Number, targetPoint:Point=null, p2:Point=null, jumpHeight:Number=0, xDir:Number=0, yDir:Number=0):void
    {
        switch (_trajectoryType)
        {
            case LEANER:
                leaner(speedX, speedY);
                break;
            case SINUS:
                sinus(speedX, speedY, targetPoint);
                break;
            case NEW_SINUS:
                newSinus(speedX, speedY, targetPoint);
                break;
            case NEW_SINUS2:
                newSinus2(speedX, speedY, targetPoint);
                break;
            case NEW_COSINUS:
                newCos(speedX, speedY, targetPoint);
                break;
            case NEW_COSINUS2:
                newCos2(speedX, speedY, targetPoint);
                break;
            case WALK_TO_PLAYER:
                walkToPlayer(speedX, speedY, targetPoint);
                break;
            case FLY_TO_PLAYER:
                flyToPlayer(speedX, speedY, targetPoint);
                break;
            case SNOWFLAKE:
                snowflake(speedX, speedY, targetPoint);
                break;
            case JUMPER:
                    if(_firstJump)
                    {
                        _firstJump = false;
                        _tempPoint = targetPoint;
                        jumper(speedX, speedY, targetPoint, jumpHeight);
                    }
                    else
                    {
                        if(_tempPoint != targetPoint)
                        {
                            _tempPoint = targetPoint;
                            if(!_isJump)
                            {
                                _isJump = true;
                                jumper(speedX, speedY, targetPoint, jumpHeight);
                            }
                        }
                    }
                break;
            case TWEEN_TO_POINT:
                    flyToPlayer(speedX, speedY, targetPoint);
                break;
            case FLY_BY_ANGLE:
                    flyByAngle(xDir, yDir, speedX, speedY);
                break;
            case AROUND_THE_POINT:
                    aroundThePoint(speedX, speedY, targetPoint);
                break;
            case GLUE_TO_POINT:
                    glueToPoint(targetPoint);
                break;
            case TWEENMAX_TO_POINT:
                if(_tween == null)
                {
                    tweenMaxToPoint(targetPoint, speedX, speedY);
                }
                else
                {
                    if(!_tween.active)
                    {
                        tweenMaxToPoint(targetPoint, speedX, speedY);
                    }
                }
                break;
            case VERTICAL_FALLING_DOWN:
                    verticalFallingDown(targetPoint, speedY);
                break;
        }
    }

    /* SNOWFLAKE */
    private function snowflake(speedX:Number, speedY:Number, targetPoint:Point):void
    {
        var randomX:Number = (Math.random()*-3)+(Math.random()*3);
        _view.x += randomX;
        _view.y += speedY;
    }

    /* VERTICAL FALLING DOWN */
    private function verticalFallingDown(targetPoint:Point, speedY:Number):void
    {
        speedY += 0.2;
        _view.y += speedY;
    }

    /* TWEENMAX TO POINT */
    private var _isAlreadyTween:Boolean;
    private var _tween:TweenMax;
    private function tweenMaxToPoint(targetPoint:Point, speedX:Number, speedY:Number):void
    {
            _isAlreadyTween = true;
            var xDir:Number = Math.abs(_view.x - targetPoint.x);
            var yDir:Number = Math.abs(_view.y - targetPoint.y);
            var distance:Number = Math.sqrt( (xDir) * (xDir) + (yDir) * (yDir));
    //            trace("distance : " + distance);
            var duration:Number;
            if(distance > 0)  duration = (distance/60);
            else              duration = 1;
    //            trace("duration : " + duration);
            _tween = TweenMax.to(_view, duration, {x:targetPoint.x, y:targetPoint.y, ease:Quad.easeInOut, onComplete:endTweenMax});

    }

    private function endTweenMax():void
    {
        _isAlreadyTween = false;
    }


    /* GLUE TO POINT */
    private function glueToPoint(targetPoint:Point):void
    {
        _view.x = targetPoint.x;
        _view.y = targetPoint.y;
    }

    /* AROUND THE POINT */
    private function aroundThePoint(speedX:Number, speedY:Number, targetPoint:Point):void
    {
        _angle += speedX*3;
        var radian:Number = (_angle/180)*Math.PI;
        _view.x = targetPoint.x + Math.cos(radian)*_radius;
        _view.y = targetPoint.y + Math.sin(radian)*_radius;
    }

    /* FLY TO PLAYER */
    private function flyToPlayer(speedX:Number, speedY:Number, targetPoint:Point=null):void
    {
        var freq:Number = 0.7;
        var yDist:Number = targetPoint.y - _view.y;
        var xDist:Number = targetPoint.x - _view.x;
        var atan:Number = Math.atan2(yDist, xDist);
        if(yDist <= 0) speedY *= -1;
        if(xDist <= 0) speedX *= -1;
        _view.x += Math.cos(atan) * Math.abs(speedX) ;
        _view.y += Math.sin(atan) * Math.abs(speedY);

    }

    /* WALK TO PLAYER */
    private function walkToPlayer(speedX:Number, speedY:Number, targetPoint:Point=null):void
    {
        _view.x += speedX;
    }

    /* LEANER */
    private function leaner(speedX:Number, speedY:Number):void
    {
        _view.x += speedX;
    }

    /* FLY BY ANGLE */
    private function flyByAngle(xDir:Number, yDir:Number, speedX:Number, speedY:Number):void
    {
        _view.x += xDir * speedX;
        _view.y +=  yDir * speedY
    }

    /* SINUS */
    private  var randomWavelength:Number = 0;
    private var randomWaveHeight:Number = 0;
    private function sinus(speedX:Number, speedY:Number, targetPoint:Point):void
    {
        if(randomWavelength == 0) randomWavelength = (Math.random() * 20)+10;
        if(randomWaveHeight == 0)randomWaveHeight = (Math.random() * 20)+10;
        _view.x += speedX ;
        _view.y = (Math.sin(_view.x / randomWavelength) * randomWaveHeight) + _startY;
    }

    private function newSinus(speedX:Number, speedY:Number, targetPoint:Point):void
    {
        if(randomWavelength == 0) randomWavelength = (Math.random() * 10)+5;
        if(randomWaveHeight == 0) randomWaveHeight = (Math.random() * 10)+5;

        if(targetPoint)
        {
            _view.x = ((Math.cos(targetPoint.y / randomWavelength)) * randomWaveHeight) + targetPoint.x;
            _view.y = ((Math.sin(targetPoint.x / randomWavelength)) * randomWaveHeight) + targetPoint.y;
        }

    }

    private function newCos(speedX:Number, speedY:Number, targetPoint:Point):void
    {
//        if(randomWavelength == 0) randomWavelength = (Math.random() * 20)+10;
//        if(randomWaveHeight == 0) randomWaveHeight = (Math.random() * 20)+10;

        if(targetPoint)
        {
            _view.x = ((Math.sin(targetPoint.y / 5)) * 10) + targetPoint.x;
            _view.y = ((Math.cos(targetPoint.x / 5)) * 10) + targetPoint.y;
        }

    }

    private function newSinus2(speedX:Number, speedY:Number, targetPoint:Point):void
    {
//        if(randomWavelength == 0) randomWavelength = (Math.random() * 20)+10;
//        if(randomWaveHeight == 0) randomWaveHeight = (Math.random() * 20)+10;

        if(targetPoint)
        {
            _view.x = ((Math.acos(targetPoint.y / 5)) * 10) + targetPoint.x;
            _view.y = ((Math.asin(targetPoint.x / 5)) * 10) + targetPoint.y;
        }

    }

    private function newCos2(speedX:Number, speedY:Number, targetPoint:Point):void
    {
//        if(randomWavelength == 0) randomWavelength = (Math.random() * 20)+10;
//        if(randomWaveHeight == 0) randomWaveHeight = (Math.random() * 20)+10;

        if(targetPoint)
        {
            _view.x = ((Math.asin(targetPoint.y / 5)) * 10) + targetPoint.x;
            _view.y = ((Math.acos(targetPoint.x / 5)) * 10) + targetPoint.y;
        }

    }

    /* SINUS BY ANGLE */
    private function sinusByAngle():void
    {
        var wavelength:Number = 20;
        var waveHeight:Number = 20;
        _view.x += (Math.cos(_view.y / wavelength) * waveHeight) + _startX ;
        _view.y = (Math.sin(_view.x / wavelength) * waveHeight) + _startY;
    }

    /* JUMPER */
    private  function jumper(speedX:Number, speedY:Number, targetPoint:Point, jumpHeight:Number):void
    {
        var xDist:Number = Math.abs(_view.x - targetPoint.x);
        // tween x
        TweenMax.to(_view, 1, {x:targetPoint.x});
        // tween y
        // TODO: Если будет использоваться - добавить ease для имитации ускорения и замедления
        TweenMax.to(_view, 0.5, {y:targetPoint.y - jumpHeight, onComplete:reverseTweenY});
        function reverseTweenY():void
        {
            TweenMax.to(_view, 0.5, {y:targetPoint.y + jumpHeight, onComplete:endJump});
        }
    }

    /* END JUMP */
    private function endJump():void
    {
        _isJump = false;
    }


    /* JUMP FUNCTION */
    private function jumpFunction(pathDone:Number, y:Number):Number
    {
        if(pathDone > 0 && pathDone < 1)
        {
            if(pathDone < 0.5)
            {
                return y+2;
            }
            else if(pathDone > 0.5)
            {
                return y-2;
            }
        }
        else
        {
            return y;
        }
        trace("[Trajectory] : JUMP function : wrong return");
        return 0;
    }

    public function get trajectoryType():String {
        return _trajectoryType;
    }

    public function set trajectoryType(value:String):void {
        _trajectoryType = value;
    }
}
}
