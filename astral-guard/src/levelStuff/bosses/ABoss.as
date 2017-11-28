/**
 * Created by Sith on 03.07.14.
 */
package levelStuff.bosses
{
import com.greensock.TweenMax;

import custom.CustomEvent;
import custom.CustomMovieClip;

import flash.display.MovieClip;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.utils.Timer;

import levelStuff.enemies.Trajectory;

import player.MovableModel;
import player.PlayerController;

import xmlParsingTiledLevel.LevelObject;

public class ABoss extends CustomMovieClip implements IBoss
{
    protected var _commonStrategy:Vector.<Step>; // стратегия босса по умолчанию
    protected var _angryStrategy:Vector.<Step>;  // стратегия босса в разозлённом состоянии
    protected var _currentStrategy:Vector.<Step>;// текущая стратегия босса

    private var _model:MovableModel;

    protected var _currentStep:Step;

    private var _health:int;
    private var _totalHealth:int;
    private var _isDeath:Boolean;
    private var _isAngryStrategy:Boolean;
    private var _isAlreadyShoot:Boolean;
    private var _isCanMove:Boolean;
    private var _eventId:int;
    private var _currentState:int;
    private var _fragmentsAmount:int;
    private var _treasure:Array;

    private var _isContainEnemies:Boolean;
    private var _containEnemies:Array;

    private var _isHitFist:Boolean;
    private var _player:PlayerController;

    /* CONSTRUCTOR */
    public function ABoss(view:MovieClip, x:Number, y:Number, width:Number, height:Number, eventId:int, health:int, $speedX:Number, treasure:Array, player:PlayerController = null)
    {
        _model = new MovableModel();
        super(this, _model, view, x, y, height, width, false);
        _eventId = eventId;
        _health = health;
        _totalHealth = health;
        speedX = $speedX;
        _treasure = treasure;
        setOrientation(CustomMovieClip.LEFT_ORI);
        _player = player;
    }

    /* POISON */
    public function startPoisoning():void
    {

    }

    /* SLOWING */
    public function slowing():void
    {

    }

    /* DEACTIVATE */
    public override function deactivate():void
    {
        super.deactivate();
        if(_explosiveTimer)
        {
            _explosiveTimer.stop();
            _explosiveTimer.removeEventListener(TimerEvent.TIMER, explose);
            _explosiveTimer = null;
        }
        if(_shootTimer)
        {
            _shootTimer.stop();
            _shootTimer.removeEventListener(TimerEvent.TIMER, shoot);
            _shootTimer = null;
        }
        if(_treasureTimer)
        {
            _treasureTimer.stop();
            _treasureTimer.removeEventListener(TimerEvent.TIMER, tres);
            _treasureTimer = null;
        }
    }

    /* INIT */
    public function init():void{}

    public function hitCheckWithPlayer():void{}

    public function fist():void{}

    public function freeze():void{}
    public function unfreeze():void{}

    /* DEACTIVATE BEHAVIOR */
    // отключение поведения
    public function deactivateBehavior():void
    {
        startShoot(false);
    }

    /* ANIMATE DEATH */
    private var _explosiveTimer:Timer;
    private var _treasureTimer:Timer;
    public function animateDeath(duration:Number, callback:Function):void
    {
        TweenMax.to(_view, duration/1000, {y:_view.y+80, onComplete:endAnimation});
        colored(0xFFFFFF, 2, duration/1000);

        _explosiveTimer = new Timer(duration/100, 100);
        _explosiveTimer.addEventListener(TimerEvent.TIMER, explose);
        _explosiveTimer.start();

        // shake camera
        _view.dispatchEvent(new CustomEvent(CustomEvent.SHAKE_GAMESCREEN, ABoss, true, false, {duration:0.1, repeatCount:duration/100, randomRange:7}));
        _treasureTimer = new Timer(duration/10, 10);
        _treasureTimer.addEventListener(TimerEvent.TIMER, tres);
        _treasureTimer.start();

        function endAnimation():void
        {
            _explosiveTimer.stop();
            _explosiveTimer.removeEventListener(TimerEvent.TIMER, explose);
            _explosiveTimer = null;
            callback();
        }
    }

    /* EXPLOSE */
    private function explose(e:TimerEvent):void
    {
        var randomX:Number = (Math.random()*view.width) + (view.x-(view.width/2));
        var randomY:Number = (Math.random()*view.height) + (view.y-(view.height/2));
        _view.dispatchEvent(new CustomEvent(CustomEvent.DIED, IBoss, true, false,
                {
                    x:randomX,
                    y:randomY,
                    enemyWidth:hitBox.width,
                    enemyHeight:hitBox.height,
                    isShakeScreen:false
                }));
    }

    /* TRES */
    private function tres(e:TimerEvent):void
    {
        view.dispatchEvent(new CustomEvent(CustomEvent.TREASURE_FROM_DIED, IBoss, true, false,
                {
                    x:view.x,
                    y:view.y,
                    treasure:treasure
                }));
    }

    /* MOVE */
    private var _currentTargetPoint:Point;
    public function move():void
    {
        // если враг не статический...
        if(_currentStep.stepPath.length > 0)
        {
            // если этот шаг со стрельбой...
            if(_currentStep.isShootable)
            {
                // ... и стрельба ещё не производилась
                if(!_isAlreadyShoot)
                {
                    _isAlreadyShoot = true;
                    startShoot(true);
                }

            }
            // ... этот шаг без стрельбы
            else
            {
                if(_isAlreadyShoot)
                {
                    _isAlreadyShoot = false;
                    // останавливаем стрельбу
                    stopShoot();
                }
            }
            // если этот шаг ориентирован НА ВРЕМЯ
            if(_currentStep.stepTimerDuration > 0)
            {
                if(_currentStep.trajectory.trajectoryType == Trajectory.FLY_TO_PLAYER || _currentStep.trajectory.trajectoryType == Trajectory.WALK_TO_PLAYER)
                {
                    _currentTargetPoint = _player.contCoordinates;
                }

                if(_currentTargetPoint.x < _view.x)  _model.speedX = -Math.abs(_model.speedX);
                else                                 _model.speedX = Math.abs(_model.speedX);

                _currentStep.trajectory.move(_model.speedX, _model.speedY, _currentTargetPoint);
                // время закончилось
                if(_currentStep.timeEnd)
                {
                    _currentStep.timeEnd = false;
                    setNewCurrentStep();
                }

                // таймер шага ещё не запущен
                if(!_currentStep.currentStepTimerAlreadySrart)
                {
                    _currentStep.currentStepTimerAlreadySrart = true;
                    _currentStep.beginTime();
                }
            }
            // если этот шаг ориентирован НА ДОСТИЖЕНИЕ ТОЧКИ
            else
            {
                var xDist:uint = Math.abs(_currentStep.currentPoint.x - _view.x);
                var yDist:uint = Math.abs(_currentStep.currentPoint.y - _view.y);
                // если враг не достиг ещё точки..
                if((xDist > 0) || (yDist > 0))
                {
                    _currentStep.trajectory.move(_model.speedX, _model.speedY, _currentStep.currentPoint, _currentStep.getNextPoint(_currentStep.currentPoint), _currentStep.jumpHeight);
                }
                // если враг достиг точки...
                else
                {
                    // и путь его не конечен, то есть большое одной точки...
                    if(_currentStep.stepPath.length > 1)
                    {

                        // определяем новую точку направления
                        setNewCurrentTargetPoint();
                    }
                    else
                    {
                        // destroyChild();
                    }
                }
            }
        }
    }

    /* START SHOOT */
    private var _shootTimer:Timer;
    private function startShoot(isShoot:Boolean):void
    {
//        trace("start Shoot !!!");
        if(isShoot)
        {
            // если заданное на шаге количество снарядов
            if(_currentStep.shootAmount > 0)
            {
                if(_shootTimer == null)
                {
                    _shootTimer = new Timer(_currentStep.shootDuration, _currentStep.shootAmount);
                    _shootTimer.addEventListener(TimerEvent.TIMER, shoot);
                }
            }
            // безконечное количество снарядов на шаге
            else
            {
                if(_shootTimer == null)
                {
                    _shootTimer = new Timer(_currentStep.shootDuration);
                    _shootTimer.addEventListener(TimerEvent.TIMER, shoot);
                }
            }
            _shootTimer.reset();
            _shootTimer.delay = _currentStep.shootDuration;
//            trace("duration : " + _currentStep.shootDuration);
            _shootTimer.start();
        }
        else
        {
            if(_shootTimer)
            {
                _shootTimer.stop();
            }
        }
    }

    /* SHOOT */
    public function shoot(e:TimerEvent):void{}

    /* STOP SHOOT */
    protected function stopShoot():void
    {
//        trace("stopShoot !!!");
        _isAlreadyShoot = false;
        startShoot(false);
        _currentStep.shootAmount = _currentStep.shootAmountNonUsable;
    }

    /* SET NEW CURRENT TARGET POINT */
    protected function setNewCurrentTargetPoint():void
    {
        var pointIndex:int = _currentStep.stepPath.indexOf(_currentStep.currentPoint);
        curPoint(_currentStep.currentPoint);
        var nextTargetPoint:StepPoint;
        var nextPointIndex:int = pointIndex + 1;
        // если следующая точка последняя...
//        if(nextPointIndex >= _currentStep.stepPath.length)
        if(nextPointIndex >= _currentStep.stepPath.length)
        {
            // если у пути несколько шагов
            if(_currentStrategy.length > 1)
            {
                // меняем шаг, предварительно проверив не нужно ли изменить стратегию на агрессивную
                if(_isAngryStrategy)
                {
//                    _currentStrategy = _angryStrategy;
//                    _currentStep = _currentStrategy[0];
                    angry();
                }
                else
                {
                    // если стратегия не изменилась - выбираем следующий шаг

                }
                setNewCurrentStep();
            }
            // определяем первую точку пути.
            nextTargetPoint = _currentStep.stepPath[0];
        }
        // если не последняя...
        else
        {
            // ... выбираем следующую
            nextTargetPoint = _currentStep.stepPath[nextPointIndex];
        }

        // если нужная точка левее текущей...
        if(nextTargetPoint.x < _currentStep.currentPoint.x)
        {
            // ...поворачиваем объект влево
            setOrientation(LEFT_ORI);
        }
        // если нужная точка правее текущей...
        else if(nextTargetPoint.x > _currentStep.currentPoint.x)
        {
            //...поворачиваем объект вправо.
            setOrientation(RIGHT_ORI);
        }
        _currentStep.currentPoint = nextTargetPoint;
//        trace("set new point : " + _currentStep.currentPoint.index);
    }

    /* ANGRY */
    protected function angry():void{}

    /* SET NEW POINT */
    // реакция наследника на точку
    public function curPoint(pnt:StepPoint):void{}

    /* SET NEW CURRENT STEP */
    protected function setNewCurrentStep():void
    {
        var currentStepIndex:int = _currentStrategy.indexOf(_currentStep);
        var nextStepIndex:int = currentStepIndex+1;

        // если текущий шаг последний в стратегии
        if(nextStepIndex >= _currentStrategy.length)
        {
            // выбираем начальный шаг
            _currentStep = _currentStrategy[0];
        }
        else
        {
            // если не последний - выбираем следующий
            _currentStep = _currentStrategy[nextStepIndex];
        }

        _model.speedX = _currentStep.speedX;
        _model.speedY = _currentStep.speedY;

        stopShoot();
//        trace("current step : " + _currentStep.stepName);
    }

    public function get health():int {return _health;}
    public function set health(value:int):void
    {
        var _value:int = Math.abs(_health-value);
        _view.dispatchEvent(new CustomEvent(CustomEvent.SHOW_DAMAGE, ABoss, true, false, {value:_value, color:0xFF0B0B, x:_view.x, y:_view.y}));
        _health = value;
        // если у босса остаётся меньше жизней, чем 25 процентов - меняем стратегию на агрессивную
        if(_isAngryStrategy == false)
        {
            if(_health < _totalHealth/4)
            {
                _isAngryStrategy = true;
            }
        }

        if(_health <= 0)
        {
            removeHitBox();
        }
    }

    public function loop():void{}

    /* BUILD PATH */
    public static function buildPath(o:LevelObject, stepCount:int, pathTriggers:Array):Vector.<StepPoint>
    {
        var path:Vector.<StepPoint> = new Vector.<StepPoint>();
        for (var i:int = 0; i < pathTriggers.length; i ++)
        {
          var stepPoint:StepPoint = new StepPoint("p"+stepCount+"_"+i, o.getPathTriggerCenter(pathTriggers[i]));
            path.push(stepPoint);
        }
        return path;
    }

    /* PAUSE */
    public override function pause():void
    {
        if(_explosiveTimer) _explosiveTimer.stop();
        if(_shootTimer) _shootTimer.stop();
        if(_treasureTimer) _treasureTimer.stop();
    }

    /* RESUME */
    public override function resume():void
    {
        if(_explosiveTimer) _explosiveTimer.start();
        if(_shootTimer) _shootTimer.start();
        if(_treasureTimer) _treasureTimer.start();
    }

    public function get eventId():int{return _eventId}
    public function get currentState():int {return _currentState}
    public function set currentState(value:int):void {_currentState = value}

    public function  get isDeath():Boolean{return _isDeath}
    public function set isDeath(value:Boolean):void{ _isDeath = value}

    public function get fragmentsAmount():int {return _fragmentsAmount}

    public function get treasure():Array {return _treasure;}
    public function set treasure(value:Array):void {_treasure = value;}

    public function get isContainEnemies():Boolean {return _isContainEnemies;}

    public function get containEnemies():Array {return _containEnemies;}

    public function get model():MovableModel {return _model;}

    public function get isCanMove():Boolean {return _isCanMove;}
    public function set isCanMove(value:Boolean):void {_isCanMove = value;}

    public function get isHitFist():Boolean {return _isHitFist;}
    public function set isHitFist(value:Boolean):void {_isHitFist = value;}

    public function get totalHealth():int {return _totalHealth;}

    public function paralized():void {
    }

    public function get isShootAfterDeath():Boolean {
        return false;
    }

    public function get classOfBulletOfShootAfterDeath():Class {
        return null;
    }

    public function get shootSound():String {
        return "";
    }
}
}
