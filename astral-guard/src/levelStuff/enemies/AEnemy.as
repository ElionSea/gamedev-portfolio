/**
 * Created by Sith on 24.06.14.
 */
package levelStuff.enemies {
import com.greensock.TweenMax;

import custom.ClipLabel;
import custom.CustomEvent;
import custom.CustomMovieClip;
import custom.ICustomMovieClip;

import data.DataController;

import flash.display.MovieClip;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.utils.Timer;

import levelStuff.Chest;
import levelStuff.bullets.IBullet;

import levelStuff.controllers.AGravityObjectController;
import levelStuff.controllers.AMovableController;
import levelStuff.controllers.AObstacleController;
import levelStuff.controllers.ASimpleObstacleController;

import player.MovableModel;
import player.PlayerController;

import sound.SoundManager;

public class AEnemy extends CustomMovieClip implements IEnemy, ICustomMovieClip
{

    public static const LOOP_TYPE:String = "loopType";
    public static const ENDED_TYPE:String = "endedType";
    public static const WALK:int = 1;
    private const RUN:int = 2;
    private const DEATH:int = 3;

    private var _model:MovableModel;
    private var _type:String;
    private var _health:int;
    private var _totalHealth:int;
    private var _isDeath:Boolean;
    private var _isGravityObject:Boolean;
    private var _isHittingObstacles:Boolean;
    private var _isContainEnemies:Boolean;
    private var _isCanMove:Boolean = true;
    private var _isHitFist:Boolean;
    private var _isShooting:Boolean;
    private var _isFreezable:Boolean;        // поддающийся заморозке

    private var _movementType:String
    private var _currentTargetPoint:Point;
    private var _stringPath:String;
    private var _path:Vector.<Point>;
    private var _trajectory:Trajectory;
    private var _startPoint:Point;
    private var _endPoint:Point;
    private var _player:PlayerController;
    private var _fragmentsAmount:int;
    private var _treasure:Array;
    private var _containEnemies:Array;
    private var _hitDamageAmount:int = 10;
    private var _shootSound:String;

    // controllers
    private var _gravityController:AGravityObjectController;
    private var _obstacleController:ASimpleObstacleController;
    private var _moveableController:AMovableController;

    private var _callbackDeath:Function;

    private var _shootBullet:Class;
    private var _shootDuration:Number;
    private var _targetObj:MovieClip;
    private var _isShootAfterDeath:Boolean;
    private var _classOfBulletOfShootAfterDeath:Class;

    /* CONSTRUCTOR */
    public function AEnemy(
            x:Number,
            y:Number,
            hitDamageAmount:int,
            width:Number,
            height:Number,
            trajectory:Trajectory,
            orientation:int,
            path:Vector.<Point>,
            movementType:String,
            $speedX:Number,
            speedY:Number,
            view:MovieClip,
            health:int,
            isStartOrientationRight:Boolean,
            isGravityObject:Boolean,
            isHittingObstacles:Boolean,
            player:PlayerController,
            treasure:Array,
            isContainEnemies:Boolean,
            containEnemies:Array,
            isShooting:Boolean=false,
            shootBullet:Class=null,
            shootDuration:Number=500,
            targetObj:MovieClip=null,
            isFreezable:Boolean=true,
//            shootSound:String=SoundManager.GG_SHOOT,
            isShootAfterDeath:Boolean=false,
            classOfBulletOfShootAfterDeath:Class=null
            )
    {
        _player = player;
        _isShootAfterDeath = isShootAfterDeath;
        _classOfBulletOfShootAfterDeath = classOfBulletOfShootAfterDeath;
        _model = new MovableModel();
        _targetObj = targetObj;
        super(this, _model, view, x, y, height, width);

        _model.speedX = $speedX;
        _model.tempSpeedX = $speedX;
        _model.speedY = speedY;
        _health = health;
        _totalHealth = health;
        _trajectory = trajectory;
        _trajectory.initModel(_model);
        _movementType = movementType;
//        _type = type;
        _path = path;
        _treasure = treasure;
        if(_path.length > 0) _currentTargetPoint = _path[0];
        _hitDamageAmount = hitDamageAmount;

        _isStartOrientationRight = isStartOrientationRight;

        _isGravityObject = isGravityObject;
        _isHittingObstacles = isHittingObstacles;
        _isContainEnemies = isContainEnemies;

        _containEnemies = containEnemies;

        _shootSound = SoundManager.GG_SHOOT;

        if(isGravityObject) _gravityController = new AGravityObjectController(this, _model);
        if(isHittingObstacles) _obstacleController = new ASimpleObstacleController(this, _model, 240);
        _moveableController = new AMovableController(this, _model);
//        _fragmentsAmount = fragmentsAmount;

        _isShooting = isShooting;
        _shootBullet = shootBullet;
        _shootDuration = shootDuration;

        _poisonEffect = DataController.playerData.staff.poison;
        _slowingEffect = DataController.playerData.staff.slowing;
//        setOrientation = orientation;

        _isFreezable = isFreezable;
    }

    /* INIT */
    public function init():void
    {

    }

    /* HIT CHECK WITH PLAYER */
    private var _hitPlayerTimer:Timer;
    public function hitCheckWithPlayer():void
    {
        // если активно заклинание "FIST" (защитная сфера), взаимодействуем с ней, а не с игроком
        if(_player.fist != null)
        {
            if(hitBox.hitTestObject(_player.fist.view))
            {
                fist();
            }
        }
        else
        {
            if(hitBox.hitTestObject(_player.hitBox))
            {
                if(_hitPlayerTimer == null)
                {
                    _hitPlayerTimer = new Timer(250);
                    _hitPlayerTimer.addEventListener(TimerEvent.TIMER, hitPlayer);
                    _player.damaged(_hitDamageAmount);
                }
                if(_hitPlayerTimer) _hitPlayerTimer.start();
            }
            else
            {
                if(_hitPlayerTimer)
                {
                    _hitPlayerTimer.reset();
                    _hitPlayerTimer.stop();
                }
            }
        }
    }

    /* HIT PLAYER */
    private function hitPlayer(e:TimerEvent):void
    {
        _player.damaged(_hitDamageAmount);
    }

    /* SHOOTING */
    private var _shootingTimer:Timer;
    public function shooting():void
    {
        _shootingTimer = new Timer(_shootDuration);
        _shootingTimer.addEventListener(TimerEvent.TIMER, shoot);
        _shootingTimer.start();
    }

    /* SHOOT */
    private function shoot(e:TimerEvent):void
    {
        var startX:Number = _view.x;
        var startY:Number = _view.y;
        // специализация выстрела
        if(_view is McYeti) // снежный шар падает сверху
        {
            startX = _player.view.x;
            startY = 0;
        }

        _view.dispatchEvent(new CustomEvent(CustomEvent.ENEMY_SHOOT, AEnemy, true, false, {startX:startX, startY:startY, targetX:_player.view.x, targetY:_player.view.y, bulletClass:_shootBullet, soundName:_shootSound}));
        playState(ClipLabel.SHOOT, null, ClipLabel.WALK);
    }

    /* MOVE */
    public function move():void
    {
        if(_poisonEffect > 0 && _isPoisoning)
        {
            _damageShowColor = LIGHT_GREEN;
            startPoisoning();
        }
        else
        {
            _damageShowColor = RED;
        }
//        if(_slowingEffect > 0 && _isSlowing) slowing();
        if(_isHittingObstacles) _obstacleController.hitTestWithObstacles();
        if(_isGravityObject) _gravityController.gravity();
        if(_isShooting && _shootingTimer==null) shooting();

        if(_model.hitLeft || _model.hitRight)
        {
            if(/*_model.jumpAmount == 0 && */_model.hitDown)
            {
                _model.isOnGround = false;
                _model.isUp = false;
                _model.jumpAmount++;
                _model.isJump = true;
//                _model.vx = _model.speedX;
//            _view.dispatchEvent(new CustomEvent(CustomEvent.JUMP));
            }
        }
        if(isCanMove)
        {
            // если путь - "стремление к игроку"
            if(_trajectory.trajectoryType == Trajectory.FLY_TO_PLAYER || _trajectory.trajectoryType == Trajectory.WALK_TO_PLAYER)
            {
                _currentTargetPoint = _player.contCoordinates;
                _trajectory.move(_model.speedX, _model.speedY, _currentTargetPoint);
                checkForBitmapOrientation();
            }
            else if(_trajectory.trajectoryType == Trajectory.AROUND_THE_POINT)
            {
                _trajectory.move(_model.speedX, _model.speedY, new Point(_targetObj.x, _targetObj.y));
            }
            else
            {
                // если враг не статический...
                if(_path.length > 0)
                {
                    var xDist:uint = Math.abs(_currentTargetPoint.x - _view.x);
                    var yDist:uint = Math.abs(_currentTargetPoint.y - _view.y);
                    // если враг не достиг ещё точки..
                    // идеальный вариант как для ф
                    if((xDist > 0) || (yDist > 0))
                    {
                        _trajectory.move(_model.speedX, _model.speedY, _currentTargetPoint);
                    }
                    // если враг достиг точки...
                    else
                    {
                        // и путь его не конечен, то есть большое одной точки...
                        if(_path.length > 1)
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
        else
        {
            _trajectory.move(_model.vx, _model.vy, _currentTargetPoint);
        }
    }

    /* FIST */
    public function fist():void
    {
        _player.fist.damaged();
        _player.fist.health -= 3;
        health -= 3;
        damaged();
    }

    /* CHECK FOR BITMAP ORIENTATION */
    private function checkForBitmapOrientation():void
    {
        // если нужная точка левее текущей...
        if(_view.x > _currentTargetPoint.x)
        {
            // ...поворачиваем объект влево
            setOrientation(LEFT_ORI);
        }
        // если нужная точка правее текущей...
        else if(_view.x < _currentTargetPoint.x)
        {
            //...поворачиваем объект вправо.
            setOrientation(RIGHT_ORI);
        }
    }

    /* FREEZE */
    public function freeze():void
    {
        if(_isFreezable)
        {
            isCanMove = false;
            _model.vx = 0;
            _model.vy = 0;
            pause();
            colored(0x7592E5, 0.75);
        }
    }

    /* PAUSE */
    public override function pause():void
    {
        super.pause();
        if(_hitPlayerTimer) _hitPlayerTimer.stop();
        if(_shootingTimer) _shootingTimer.stop();
        if(_poisonTimer) _poisonTimer.stop();
    }

    /* RESUME */
    public override function resume():void
    {
        super.resume();
        if(_hitPlayerTimer) _hitPlayerTimer.start();
        if(_shootingTimer) _shootingTimer.start();
        if(_poisonTimer) _poisonTimer.start();
    }

    /* UNFREEZE */
    public function unfreeze():void
    {
        isCanMove = true;
        resume();
        uncolored();
    }

    /* START POISONING */
    private var _isPoisoning:Boolean;
    private var _poisonEffect:int;
    private var _isPoisonStart:Boolean;
    private var _poisonTimer:Timer;
    public function startPoisoning():void
    {
        if(!_isPoisonStart)
        {
            _isPoisonStart = true;
            _poisonTimer = new Timer(1000);
            _poisonTimer.addEventListener(TimerEvent.TIMER, poisoning);
            _poisonTimer.start();
        }
    }

    /* POISONING */
    private function poisoning(e:TimerEvent):void
    {
        health -= _poisonEffect;
    }

    /* SLOWING */
    private var _isSlowing:Boolean;
    private var _slowingEffect:Number;
    private const MIN_SPEED:Number = 0.1;
    public function slowing():void
    {
        if(!_isSlowing)
        {
            _isSlowing = true;
//            trace("before speedX : " + _model.speedX);
//            trace("before speedY : " + _model.speedY);
//            trace("_slowingEffect : " + _slowingEffect);

            if(_model.speedX > 0)
            {
                _model.speedX -= _slowingEffect;
                if(_model.speedX < MIN_SPEED) _model.speedX = MIN_SPEED;
            }
            else
            {
                _model.speedX += _slowingEffect;
                if(_model.speedX > MIN_SPEED) _model.speedX = -MIN_SPEED;
            }


            if(_model.speedY > 0)
            {
                _model.speedY -= _slowingEffect;
                if(_model.speedY < MIN_SPEED) _model.speedY = MIN_SPEED;
            }
            else
            {
                _model.speedY += _slowingEffect;
                if(_model.speedY > MIN_SPEED) _model.speedY = -MIN_SPEED;
            }
//            trace("after speedX : " + _model.speedX);
//            trace("after speedY : " + _model.speedY);
        }

    }


    /* SET NEW CURRENT TARGET POINT */
    private function setNewCurrentTargetPoint():void
    {
        var pointIndex:int = _path.indexOf(_currentTargetPoint);
        var nextTargetPoint:Point;
        var nextPointIndex:int = pointIndex + 1;
        // если следующая точка последняя...
        if(nextPointIndex >= _path.length)
        {
            // определяем первую точку пути.
            nextTargetPoint = _path[0];
        }
        // если не последняя...
        else
        {
            // ... выбираем слудующую
            nextTargetPoint = _path[nextPointIndex];
        }
        checkForBitmapOrientation();

        _currentTargetPoint = nextTargetPoint;
    }

    public function get health():int {return _health;}

    public function set health(value:int):void
    {
        var _value:int = Math.abs(_health-value);
        _view.dispatchEvent(new CustomEvent(CustomEvent.SHOW_DAMAGE, AEnemy, true, false, {value:_value, color:_damageShowColor, x:_view.x, y:_view.y}));
        _health = value;
        _isPoisoning = true;
        slowing();
        if(_health <= 0)
        {
            removeHitBox();
            deactivate();
        }
    }

    /* SHOW DAMAGE */
    private const RED:uint = 0xA33912;
    private const LIGHT_GREEN:uint = 0x43FFA6;
    private var _damageShowColor:uint;



    /* DEACTIVATE */
    public override function deactivate():void
    {
        if(_poisonTimer)
        {
            _poisonTimer.stop();
            _poisonTimer.removeEventListener(TimerEvent.TIMER, poisoning);
            _poisonTimer = null;
        }

        if(_shootingTimer)
        {
            _shootingTimer.stop();
            _shootingTimer.removeEventListener(TimerEvent.TIMER, shoot);
            _shootingTimer = null;
        }

        if(_hitPlayerTimer)
        {
            _hitPlayerTimer.stop();
            _hitPlayerTimer.removeEventListener(TimerEvent.TIMER, hitPlayer);
            _hitPlayerTimer = null;
        }
        super.deactivate();
    }

    public function loop():void{}

    public function get isDeath():Boolean {return _isDeath;}

    public function set isDeath(value:Boolean):void {_isDeath = value;}

    public function get fragmentsAmount():int {return _fragmentsAmount}





    /* INIT PATH */
    private function initPath(path:String):void
    {
        /* var pathCoordinates:Array = path.split(",");
         _path = new Vector.<Point>();
         var curTile1:int = -1;
         var curTile2:int = -1;
         var pathPoint:Point;
         for(var i:int = 0; i < pathCoordinates.length; i++)
         {
         if(i == 0 || i%2 == 0)  curTile1 = pathCoordinates[i];
         else                    curTile2 = pathCoordinates[i];
         if(curTile1 != -1 && curTile2 != -1)
         {
         pathPoint = LevelObject.getTilePointByIndexes(curTile1, curTile2);
         _path.push(pathPoint);
         curTile1 = -1;
         curTile2 = -1;
         }
         }
         if(_currentTargetPoint == null)
         {
         _currentTargetPoint = _path[0];
         }*/
    }

    public function get treasure():Array {return _treasure;}
    public function set treasure(value:Array):void {_treasure = value;}

    public function get model():MovableModel {return _model;}

    public function get isContainEnemies():Boolean {return _isContainEnemies;}

    public function get containEnemies():Array {return _containEnemies;}

    public function get isCanMove():Boolean {return _isCanMove;}
    public function set isCanMove(value:Boolean):void {_isCanMove = value;}

    public function get isHitFist():Boolean {return _isHitFist;}
    public function set isHitFist(value:Boolean):void {_isHitFist = value;}

    public function get totalHealth():int {return _totalHealth;}

    public function paralized():void {
    }

    public function get isShootAfterDeath():Boolean {
        return _isShootAfterDeath;
    }

    public function get classOfBulletOfShootAfterDeath():Class {
        return _classOfBulletOfShootAfterDeath;
    }

    public function get shootSound():String {
        return _shootSound;
    }
}
}
