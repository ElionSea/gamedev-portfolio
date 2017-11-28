/**
 * Created by Sith on 24.06.14.
 */
package levelStuff.controllers
{
import compositepPattern.ISubController;

import custom.ClipLabel;
import custom.CustomEvent;

import data.Achievement;

import data.AchievementsData;

import data.DataController;

import data.PlayerData;

import flash.display.DisplayObject;

import flash.display.MovieClip;

import flash.display.Sprite;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.utils.Timer;
import flash.utils.setTimeout;

import levelStuff.bosses.IBoss;
import levelStuff.bosses.concreteBosses.BossLordOfCastle;
import levelStuff.bosses.concreteBosses.BossLordOfDesert;
import levelStuff.bosses.concreteBosses.BossLordOfFire;
import levelStuff.bosses.concreteBosses.BossLordOfIce;
import levelStuff.bosses.concreteBosses.BossLordOfSwamp;
import levelStuff.bosses.concreteBosses.BossLordOfUnreal;

import levelStuff.enemies.EList;
import levelStuff.enemies.AEnemy;
import levelStuff.enemies.EListObject;
import levelStuff.enemies.IEnemy;
import levelStuff.enemies.Trajectory;

import player.PlayerController;

import popup.AchievementController;

public class EnemyController implements ISubController
{
    private var _enemies:Vector.<IEnemy> = new Vector.<IEnemy>();
    private var _activeEnemies:Vector.<IEnemy> = new Vector.<IEnemy>();
    private var _mainScreen:Sprite;
    private var _player:PlayerController;

    private static var s_enemyDeathCounter:int = 0;

    private var _endGameCallback:Function;

    /* CONSTRUCTOR */
    public function EnemyController(levelEnemies:Vector.<IEnemy>, mainScreen:Sprite, player:PlayerController, endGame:Function)
    {
        _enemies = levelEnemies;
        _mainScreen = mainScreen;
        _player = player;
        _endGameCallback = endGame;
    }

    /* INIT ENEMIES */
    public function initEnemies():void
    {
        _tempEnemies = new Vector.<IEnemy>();
        for each(var enemy:IEnemy in _enemies)
        {
            enemy.init();
        }

        _mainScreen.addEventListener(CustomEvent.DIED, enemyFromDiedEnemy, true);
    }

    /* UPDATE ACTIVE ENEMIES */
    public function updateActiveEnemies(eventId:int):void
    {
        /*for each(var enemy:IEnemy in _enemies)
        {
            if(enemy.eventId == eventId)
            {
                _activeEnemies.push(enemy);
                enemy.playState(ClipLabel.WALK);
                _mainScreen.addChild(enemy.view);
            }
            else
            {
                _activeEnemies.splice(_activeEnemies.indexOf(enemy), 1);
                _mainScreen.removeChild(enemy.view);
            }
        }*/
    }

    /* PAUSE */
    public function pause():void
    {
        for each(var e:IEnemy in _activeEnemies)
        {
            e.pause();
        }
        if(_endGameTimer) _endGameTimer.stop();
    }

    /* RESUME */
    public function resume():void
    {
        for each(var e:IEnemy in _activeEnemies)
        {
            e.resume();
        }
        if(_endGameTimer) _endGameTimer.start();
    }

    /* ENEMIES FROM DIED ENEMY */
    private var randomVX:Number;
    private function enemyFromDiedEnemy(e:CustomEvent):void
    {
        if(e.obj.isContainEnemies)
        {
            for (var i:int = 0; i < e.obj.containEnemies.length; i++)
            {
                var curEnemy:int = e.obj.containEnemies[i];
                var o:EListObject = EList.enemyList[curEnemy];
                var view:MovieClip = new o.view;
                var trajectory:Trajectory = new Trajectory(view, 0, 0, 0, o.trajectoryType, o.speedX, o.speedY);
                o.path = new Vector.<Point>();
                o.path.push(new Point(0, 0));
                var newEnemy:IEnemy = new AEnemy(
                        e.obj.x,
                        e.obj.y,
                        o.hitDamageAmount,
                        o.width,
                        o.height,
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
                        o.internalEnemies);
                randomVX = (Math.random()*-4)+(Math.random()*4);
//                trace("randomVX : "  + randomVX);
                newEnemy.model.vx = randomVX;
                newEnemy.clipLabels = o.clipLabels;
                newEnemy.isCanMove = false;
                _tempEnemies.push(newEnemy);
                updateEnemy(newEnemy);
            }
            setTimeout(canMove, 500);
        }
    }

    /* CAN MOVE */
    private var _tempEnemies:Vector.<IEnemy>;
    private function canMove():void
    {
        if(_tempEnemies)
        {
            for each(var enemy:IEnemy in _tempEnemies)
            {
                enemy.isCanMove = true;
            }
        }
    }

    /* UPDATE ENEMY */
    public function updateEnemy(enemy:IEnemy):void
    {
        resetTimer();
        _activeEnemies.push(enemy);
        enemy.playState(ClipLabel.WALK);
        _mainScreen.addChild(enemy.view);
    }

    /* ENEMY CONTROLLER LOOP */
    public function loop():void
    {
        checkForDeath();
        moveActiveEnemies();
    }

    /* DEACTIVATE */
    public function deactivate():void
    {
        for each(var enemy:IEnemy in _activeEnemies)
        {
            enemy.pause();
            enemy.deactivate();
            _mainScreen.removeChild(enemy.view);
            enemy = null;
        }
        _activeEnemies = null;
        _tempEnemies = null;
        _mainScreen.removeEventListener(CustomEvent.DIED, enemyFromDiedEnemy, true);
        resetTimer();
    }

    /* CHECK FOR DEATH */
    private function checkForDeath():void
    {
        for each(var enemy:IEnemy in _activeEnemies)
        {
            if(enemy.health <= 0)
            {
                if(!enemy.isDeath)
                {
                    enemy.isDeath = true;
                    diedEnemy(enemy);
                }
            }
        }
    }

    /* ENEMY DEATH*/
    private function enemyDeath(enemy:IEnemy):void
    {


//        _fragmentController.initFragments(enemy, diedEnemy);
        diedEnemy(enemy);
//        enemy.playState(ClipLabel.DEATH, diedEnemy);
    }

    /* DIED ENEMY */
    public function diedEnemy(enemy:IEnemy):void
    {
        _activeEnemies.splice(_activeEnemies.indexOf(enemy), 1);
        enemy.deactivate();
        if(enemy is IBoss)
        {
            enemy.view.dispatchEvent(new CustomEvent(CustomEvent.STOP_GENERATE));

//            trace("BOSS DIED");
            // после смерти каждого босса увеличивается количество снарядов в посохе
            DataController.playerData.staff.shellSize++;
            _mainScreen.dispatchEvent(new CustomEvent(CustomEvent.SHOW_POWER_INCREASED, EnemyController, false, false, {x:_player.view.x, y:_player.view.y}));
            for each(var e:IEnemy in _activeEnemies)
            {
                e.health = 0;
                _mainScreen.removeChild(e.view);
                DataController.playerData.tempGamePoints += e.totalHealth;
            }
            IBoss(enemy).deactivateBehavior();
            DataController.playerData.tempGamePoints += enemy.totalHealth;

            // update achievement
            if(enemy is BossLordOfCastle) DataController.achievementsData.updateAchievement(AchievementsData.ABANDONED_SOUL);
            if(enemy is BossLordOfSwamp) DataController.achievementsData.updateAchievement(AchievementsData.SWAMP_INTRUDER);
            if(enemy is BossLordOfDesert) DataController.achievementsData.updateAchievement(AchievementsData.SANDY_EYE);
            if(enemy is BossLordOfUnreal) DataController.achievementsData.updateAchievement(AchievementsData.BUZZY_GUARD);
            if(enemy is BossLordOfIce) DataController.achievementsData.updateAchievement(AchievementsData.ICE_SPIKE);
            if(enemy is BossLordOfFire) DataController.achievementsData.updateAchievement(AchievementsData.VOLCANO_TAMER);


            IBoss(enemy).animateDeath(7000, destroyBoss);
            function destroyBoss():void
            {
                _mainScreen.removeChild(enemy.view);
                enemy = null;
                startCheckEndGame();
            }
        }
        else
        {
            if(enemy is AEnemy) enemyDeathCounter(1);
            enemy.view.dispatchEvent(new CustomEvent(CustomEvent.DIED, IEnemy, true, false,
                {
                    x:enemy.view.x,
                    y:enemy.view.y,
                    enemyWidth:enemy.hitBox.width,
                    enemyHeight:enemy.hitBox.height,
                    isContainEnemies:enemy.isContainEnemies,
                    containEnemies:enemy.containEnemies,
                    controllerClass:AEnemy
                }));
            enemy.view.dispatchEvent(new CustomEvent(CustomEvent.TREASURE_FROM_DIED, IEnemy, true, false,
                    {
                        x:enemy.view.x,
                        y:enemy.view.y,
                        treasure:enemy.treasure
                    }));

            // если враг стреляет после смерти
            if(enemy.isShootAfterDeath)
            {
                var startX:Number = enemy.view.x;
                var startY:Number = enemy.view.y;
                enemy.view.dispatchEvent(new CustomEvent(CustomEvent.ENEMY_SHOOT, AEnemy, true, false,
                        {
                            startX:startX,
                            startY:startY,
                            targetX:_player.view.x,
                            targetY:_player.view.y,
                            bulletClass:enemy.classOfBulletOfShootAfterDeath,
                            soundName:enemy.shootSound}));
            }


            if(_mainScreen.contains(enemy.view)) _mainScreen.removeChild(enemy.view);
            DataController.playerData.tempGamePoints += enemy.totalHealth;
            enemy = null;
            if(_activeEnemies.length < 1)
            {
                startCheckEndGame();
            }
        }

    }

    /* START CHECK END GAME */
    private var _endGameTimer:Timer;
    private function startCheckEndGame():void
    {
        // !!! Значиение таймера не должно быть меньше ни одного из значений таймера генераторов, указанных в LevelData
        _endGameTimer  = new Timer(10000, 1);
        _endGameTimer.addEventListener(TimerEvent.TIMER_COMPLETE, levelCompleted);
        _endGameTimer.start();
    }

    /* LEVEL COMPLETED */
    private function levelCompleted(e:TimerEvent):void
    {
        _endGameCallback(true);
    }

    /* RESET TIMER */
    // сброс таймера, который следит за окончанием уровня
    private function resetTimer():void
    {
        if(_endGameTimer)
        {
            _endGameTimer.stop();
            _endGameTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, levelCompleted);
            _endGameTimer = null;
        }
    }

    /* MOVE ACTIVE ENEMIES */
    private function moveActiveEnemies():void
    {
        if(_activeEnemies.length > 0)
        {
            for each(var enemy:IEnemy in _activeEnemies)
            {
               enemy.move();
                enemy.hitCheckWithPlayer();
                if(enemy.isHitFist) enemy.fist();
            }
        }
    }

    public function get activeEnemies():Vector.<IEnemy> {return _activeEnemies;}


    public function enemyDeathCounter(value:int):void {
        EnemyController.s_enemyDeathCounter += value;
        if(EnemyController.s_enemyDeathCounter == 100) DataController.achievementsData.updateAchievement(AchievementsData.APPRENTICE);
        if(EnemyController.s_enemyDeathCounter == 400) DataController.achievementsData.updateAchievement(AchievementsData.VETERAN);
        if(EnemyController.s_enemyDeathCounter == 1000) DataController.achievementsData.updateAchievement(AchievementsData.ASTRAL_GUARDIAN);
    }
}
}
