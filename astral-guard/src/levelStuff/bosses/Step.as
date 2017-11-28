/**
 * Created by Sith on 03.07.14.
 */
package levelStuff.bosses
{
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.utils.Timer;
import flash.utils.setTimeout;

import levelStuff.enemies.Trajectory;

/* Класс реализующий один шаг поведения */
public class Step
{
    private var _stepPath:Vector.<StepPoint>;   // Точки пути этого шага
    private var _trajectoryType:String;         // тип движения по траектории
    private var _trajectory:Trajectory;     // траектория шага по которой босс будет двигаться от точки до точки
    private var _currentPoint:StepPoint;        // текущая точка шага
    private var _nextPoint:StepPoint;           // следующая точка шага
    private var _speedX:Number;
    private var _speedY:Number;
    private var _jumpHeight:Number;
    private var _isShootable:Boolean;       // стреляет ли на это шаге
    private var _shootAmount:int;           // количество снарядов на шаге
    private var _shootAmountNonUsable:int;  // количество снарядов на шаге, не трогаемое число
    private var _shootDuration:int;         // временной промежуток между стрельбой в миллисекундах
    private var _stepTimerDuration:int;     // временной отрезок для шага (если равен нолю - привязка к точке)
    private var _currentStepTimerAlreadySrart:Boolean;
    private var _timeEnd:Boolean;

    private var _stepName:String;           // имя шага

    public static const MOVE:String = "move";
    public static const SHOOT:String = "shoot";
    public static const SPECIAL_SHOOT:String = "specialShoot";

    /* CONSTRUCTOR */
    public function Step(
            stepName:String,
            trajectory:Trajectory,
            stepPath:Vector.<StepPoint>,
            speedX:Number,
            speedY:Number,
            jumpHeight:Number=0,
            isShootable:Boolean=false,
            shootAmount:int=0,
            shootDuration:int=700,
            stepTimerDuration:int=0)
    {
        _stepName = stepName;
        _trajectory = trajectory;
        _stepPath = stepPath;
        _speedX = speedX;
        _speedY = speedY;
        _currentPoint = _stepPath[0];
        _jumpHeight = jumpHeight;
        _isShootable = isShootable;
        _shootAmount = shootAmount;
        _shootAmountNonUsable = _shootAmount;
        _shootDuration = shootDuration;
        _stepTimerDuration = stepTimerDuration;
    }

    /* GET NEXT POINT */
    public function getNextPoint(curPoint:StepPoint):StepPoint
    {
        var curPointIndex:int = _stepPath.indexOf(curPoint);
        var nextPointIndex:int = curPointIndex + 1;
        if(nextPointIndex >= _stepPath.length)
        {
//            trace("[Step] Sorry, no point by this Id");
            return null;
        }
        else
        {
//            trace("NEW POINT : " + _stepPath[nextPointIndex]);
            return _stepPath[nextPointIndex];
        }
    }

    public function resetStepTimer(e:TimerEvent):void
    {
        _stepTimer.stop();
        _timeEnd = true;
        _currentStepTimerAlreadySrart = false;
//        setTimeout(resetStep, 1000);
//        resetStep();
    }

    private function resetStep():void
    {
//        _timeEnd = false;
//        _currentStepTimerAlreadySrart = false;
    }

    private var _stepTimer:Timer;
    public function beginTime():void
    {
//        trace("begin timer !!!");
        if(_stepTimer == null)
        {
            _stepTimer = new Timer(_stepTimerDuration, 1);
            _stepTimer.addEventListener(TimerEvent.TIMER_COMPLETE, resetStepTimer);
        }
        else
        {
            _stepTimer.reset();
        }

        _stepTimer.start();
    }

    public function get stepPath():Vector.<StepPoint> {return _stepPath;}

    public function get trajectoryType():String {return _trajectory.trajectoryType;}

    public function get trajectory():Trajectory {return _trajectory;}

    public function get speedX():Number {return _speedX;}

    public function get speedY():Number {return _speedY;}

    public function get nextPoint():StepPoint {return _nextPoint;}

    public function get currentPoint():StepPoint {return _currentPoint;}
    public function set currentPoint(value:StepPoint):void {_currentPoint = value;}

    public function get jumpHeight():Number {return _jumpHeight;}

    public function get isShootable():Boolean {return _isShootable;}

    public function get shootAmount():int {return _shootAmount;}
    public function set shootAmount(value:int):void {_shootAmount = value;}

    public function get shootDuration():int {return _shootDuration;}

    public function get shootAmountNonUsable():int {return _shootAmountNonUsable;}
    public function set shootAmountNonUsable(value:int):void {_shootAmountNonUsable = value;}

    public function set speedX(value:Number):void {_speedX = value;}

    public function set speedY(value:Number):void {_speedY = value;}

    public function get stepName():String {return _stepName;}

    public function get stepTimerDuration():int {return _stepTimerDuration;}

    public function get currentStepTimerAlreadySrart():Boolean {return _currentStepTimerAlreadySrart;}

    public function get timeEnd():Boolean {
        return _timeEnd;
    }

    public function set currentStepTimerAlreadySrart(value:Boolean):void {
        _currentStepTimerAlreadySrart = value;
    }

    public function set timeEnd(value:Boolean):void {
        _timeEnd = value;
    }
}
}
