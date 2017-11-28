/**
 * Created by Sith on 12.07.14.
 */
package levelStuff.generators
{
import flash.display.MovieClip;
import flash.display.Shape;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.utils.Timer;
import flash.utils.setTimeout;

import levelStuff.controllers.EnemyController;
import levelStuff.enemies.EList;
import levelStuff.enemies.EListObject;
import levelStuff.enemies.AEnemy;
import levelStuff.enemies.IEnemy;
import levelStuff.enemies.Trajectory;
import levelStuff.pathTrigger.PathTrigger;

import player.PlayerController;

public class EnemyGenerator
{
    private var _view:MovieClip;
    private var _count:int;
    private var _center:Point;

    private var _mainTimer:Timer;
    private var _activeEnemies:Vector.<IEnemy>;
    private var _levelEnemies:Array;
    private var _enemyController:EnemyController;
    private var _avaliablePaths:Vector.<Vector.<PathTrigger>>;
    private var _player:PlayerController;
    private var _duration:Number;

    public function EnemyGenerator(count:int, x:Number, y:Number, width:Number, height:Number)
    {
        _count = count;
        drawView(x, y, width, height);
    }

    /* INIT GENERATOR */
    public function initGenerator(levelEnemies:Array, enemyController:EnemyController, avaliablePaths:Array, levelPathTriggers:Vector.<PathTrigger>, player:PlayerController, duration:Number):void
    {
        _levelEnemies = levelEnemies.concat();
        _enemyController = enemyController;
        _player = player;
        _duration = duration;

//        trace("avaliablePaths : " + avaliablePaths.toString());
        initAvaliablePaths(avaliablePaths, levelPathTriggers);
    }

    /* INIT AVALIABLE PATHS */
    private function initAvaliablePaths(avaliablePaths:Array, levelPathTriggers:Vector.<PathTrigger>):void
    {
        _avaliablePaths = new Vector.<Vector.<PathTrigger>>();
        for each(var path:Array in avaliablePaths)
        {
            _avaliablePaths.push(initPath(path, levelPathTriggers));
        }
    }

    /* INIT PATH */
    private function initPath(path:Array, levelPathTriggers:Vector.<PathTrigger>):Vector.<PathTrigger>
    {
        var avaPath:Vector.<PathTrigger> = new Vector.<PathTrigger>();
        for(var i:int = 0; i < path.length; i++)
        {
            avaPath.push(getTriggerByCount(path[i], levelPathTriggers));
        }
        return avaPath;
    }

    /* GET TRIGGER BY COUNT */
    private static function getTriggerByCount(triggerCount:int, levelPathTriggers:Vector.<PathTrigger>):PathTrigger
    {
        for(var i:int = 0; i < levelPathTriggers.length; i++)
        {
            var trigger:PathTrigger = levelPathTriggers[i];
            if(trigger.count == triggerCount)
            {
//                trace("trigger.count : " + trigger.count);
                return  trigger;
            }
        }
        trace("Sorry, no trigger by this count");
        return null;
    }

    /* DRAW VIEW */
    private function drawView(x:Number, y:Number, width:Number, height:Number):void
    {
        var shape:Shape = new Shape();
        shape.graphics.beginFill(0xFF0000, 0.3);
        shape.graphics.drawRect(0, 0, width, height);
        shape.graphics.endFill();
        _view = new MovieClip();
        _view.addChild(shape);
        _view.x = x;
        _view.y = y;

        _center = new Point(_view.width/2, _view.height/2);
    }

    /* STOP GENERATE */
    public function stopGenerate():void
    {
        if(_mainTimer)
        {
            _mainTimer.stop();
            _mainTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, addEnemy);
            _mainTimer = null;
        }
    }

    /* START */
    public function startGenerate(activeEnemies:Vector.<IEnemy>=null):void
    {
        if(activeEnemies) _activeEnemies = activeEnemies;
        var randomDelay:Number = Math.ceil((Math.random()*_duration/10)+_duration);
//        setTimeout(addEnemy, randomDelay);
        _mainTimer = new Timer(randomDelay, 1);
        _mainTimer.addEventListener(TimerEvent.TIMER_COMPLETE, addEnemy);
        _mainTimer.start();
    }

    /* ADD ENEMY */
    private function addEnemy(e:TimerEvent):void
    {
        _mainTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, addEnemy);

        var curEnemy:int = _levelEnemies[_levelEnemies.length-1];
        var o:EListObject = EList.enemyList[curEnemy];
        _levelEnemies.pop();
        var view:MovieClip = new o.view;
//        o.clipLabels = new Vector.<ClipLabel>();
//        o.view = new EList.enemiesList[curEnemy][EList.VIEW];
//        o.trajectoryType = EList.enemiesList[curEnemy][EList.TRAJECTORY_TYPE];
//        o.speedX = EList.enemiesList[curEnemy][EList.SPEED_X];
//        o.speedY = EList.enemiesList[curEnemy][EList.SPEED_Y];
//        o.health = EList.enemiesList[curEnemy][EList.HEALTH];
        var trajectory:Trajectory = new Trajectory(view, 0, 0, 0, o.trajectoryType, o.speedX, o.speedY);
//        o.isGravityObject = EList.enemiesList[curEnemy][EList.IS_GRAVITY];
//        o.isHittingObstacles = EList.enemiesList[curEnemy][EList.IS_HTITING_OBSTACLES];
//        o.isOrientationRight = EList.enemiesList[curEnemy][EList.IS_ORIENTATION_RIGHT];
//        o.fragmentsAmount = EList.enemiesList[curEnemy][EList.FRAGMENTS_AMOUNT];
//        o.treasure = EList.enemiesList[curEnemy][EList.TREASURE];
//        o.isContainEnemies = EList.enemiesList[curEnemy][EList.IS_CONTAIN_ENEMIES];
//        if(o.isContainEnemies)  o.internalEnemies =  EList.enemiesList[curEnemy][EList.CONTAIN_ENEMIES];
        o.path = new Vector.<Point>();
        trace("_avaliablePaths.toString() : " + _avaliablePaths.toString());
        var count:int = Math.ceil(Math.random()*_avaliablePaths.length-1);
        trace("count : " + count);
        var randomPath:Vector.<PathTrigger> = _avaliablePaths[count];
        trace("randomPath : " + randomPath);
        o.path = triggersToPoints(randomPath);
        var enemyClass:IEnemy = new AEnemy(
                _center.x + _view.x,
                _center.y + _view.y,
                o.hitDamageAmount,
                0,
                0,
                trajectory,
                o.orientation,
                o.path,
                o.movementType,
                o.speedX,
                o.speedY,
                view,
                o.health,
                o.isOrientationRight,
                o.isGravityObject,
                o.isHittingObstacles,
                _player,
                o.treasure,
                o.isContainEnemies,
                o.internalEnemies,
                o.isShooting,
                o.shootingBullet,
                o.shootDuration,
                null,
                true,
                o.isShootAfterDeath,
                o.classOfBulletOfShootAfterDeath
                // TODO: Добавить для каждого Enemy специальный звук стрельбы (только для тех кто стреляет)
//
        );
        enemyClass.clipLabels = o.clipLabels;
        _enemyController.updateEnemy(enemyClass);

        // если в массивах ещё есть враги - запускаем таймер генератора снова
        if(_levelEnemies.length > 0)
        {
            startGenerate();
        }
        else
        {
//            trace("ENEMY GENERATOR : enemies ended");

        }
    }

    /* PAUSE */
    public function pause():void
    {
        if(_mainTimer) _mainTimer.stop();
    }

    /* RESUME */
    public function resume():void
    {
        if(_mainTimer) _mainTimer.start();
    }

    /* DEACTIVATE */
    public function deactivate():void
    {
        stopGenerate();
    }

    /* TRIGGERS TO POINTS */
    private static function triggersToPoints(randomPath:Vector.<PathTrigger>):Vector.<Point>
    {
        var pathPoints:Vector.<Point> = new Vector.<Point>();
        for each(var trigger:PathTrigger in randomPath)
        {
            if(trigger) pathPoints.push(trigger.center);
        }
        return pathPoints;
    }

    public function get count():int {return _count;}
}
}
