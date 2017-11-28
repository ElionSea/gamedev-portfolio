/**
 * Created by Sith on 26.06.14.
 */
package levelStuff.bullets
{
import com.greensock.TweenMax;

import custom.ClipLabel;
import custom.CustomEvent;
import custom.CustomMovieClip;
import custom.ICustomMovieClip;

import data.DataController;

import data.DataController;
import data.PlayerData;

import flash.display.MovieClip;

import flash.display.Sprite;
import flash.display.Stage;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.filters.GlowFilter;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.ui.Mouse;
import flash.utils.Timer;

import levelStuff.IHittableByBullet;
import compositepPattern.ISubController;

import levelStuff.enemies.IEnemy;
import levelStuff.enemies.Trajectory;
import levelStuff.treasures.TList;

import player.PlayerController;

import sound.SoundManager;

import xmlParsingTiledLevel.ArrayTile;

import xmlParsingTiledLevel.LevelObject;

public class BulletController implements ISubController
{
    private var _activeEnemies:Vector.<IEnemy>;
    private var _chests:Vector.<IEnemy>;
    private var _bullets:Vector.<IBullet> = new Vector.<IBullet>();
    private var _mainScreen:Sprite;
    private var _player:PlayerController;
    private var _stage:Stage;

    private var _playerData:PlayerData;
    private var _restrictRect:Rectangle; // ограничительное пространство

    // точность
    private var _accuracyHitted:int = 0;
    private var _accuracyMissed:int = 0;

    private const PLAYER_SHOOT_DURATION:int = 500; // скорость стрельбы по зажатию мыши

    /* CONSTRUCTOR */
    public function BulletController(activeEnemies:Vector.<IEnemy>, chests:Vector.<IEnemy>, mainScreen:Sprite, player:PlayerController, stage:Stage, playerData:PlayerData, restrictRect:Rectangle)
    {
        _activeEnemies = activeEnemies;
        _chests = chests;
        _mainScreen = mainScreen;
        _player = player;
        _stage = stage;
        _playerData = playerData;
        _restrictRect = restrictRect;

        _mainScreen.addEventListener(CustomEvent.DIED, diedListener, true);
        _stage.addEventListener(CustomEvent.ENEMY_SHOOT, enemyShoot, false, 0, false);
        _mainScreen.addEventListener(MouseEvent.MOUSE_MOVE, mouseUpdate, false, 0, false);
        _mainScreen.addEventListener(MouseEvent.MOUSE_DOWN, startShoot, false, 0, false);
        _mainScreen.addEventListener(MouseEvent.MOUSE_UP, stopShoot, false, 0, false);
        _mainScreen.addEventListener(CustomEvent.STOP_GENERATE, bossDied, true);

        _mainScreen.mouseChildren = false;
    }

    private function mouseUpdate(e:MouseEvent):void
    {
        _mouseEvent = e;
    }



    /* START SHOOT */
    private var _shootTimer:Timer;
    private var _mouseEvent:MouseEvent;
    private function startShoot(e:MouseEvent):void
    {
        playerShoot();
        if(_shootTimer == null)
        {
            _shootTimer = new Timer(PLAYER_SHOOT_DURATION);
            _shootTimer.addEventListener(TimerEvent.TIMER, playerShoot);
        }

        _shootTimer.reset();
        _shootTimer.start();
    }

    /* STOP SHOOT */
    private function stopShoot(e:MouseEvent):void
    {
        if(_shootTimer)
        {
            _shootTimer.stop();
        }
    }

    public function pause():void
    {
        if(_shootTimer)
        {
            _shootTimer.stop();
        }
    }

    /* SHOOT */
    private function playerShoot(e:TimerEvent=null):void
    {
        // если достаточно маны для выстрела
        if(_playerData.currentMana >= _playerData.staff.shootCost && _mouseEvent)
        {
            _playerData.currentMana -= _playerData.staff.shootCost;

            _stage.dispatchEvent(new CustomEvent(CustomEvent.PLAYER_SHOOT, null, false, false, {e:e}));

            // play shoot
            var sounds:Array = [SoundManager.NEW_SHOOT_01, SoundManager.NEW_SHOOT_02, SoundManager.NEW_SHOOT_03];
            var random:int = Math.floor(Math.random()*sounds.length);
            var randomShootSoundName:String = sounds[random];
            SoundManager.playSound(randomShootSoundName, 0.3);

            var startPoint:Point = new Point(_player.shootBox.x+_player.view.x,  _player.shootBox.y+_player.view.y);
            startPoint = _stage.localToGlobal(startPoint);
            var targetPoint:Point = new Point(_mouseEvent.localX, _mouseEvent.localY);

            addBullet(new GgBullet(DataController.playerData.staff.shellSize, startPoint.x, startPoint.y, targetPoint.x, targetPoint.y, false, null, DataController.playerData.staff.shellColor),
                    _player);
        }
    }

    /* ENEMY SHOOT */
    private function enemyShoot(e:CustomEvent):void
    {
//        trace("enemy shoot");
        SoundManager.playSound(e.obj.soundName, 0.7);
        var startPoint:Point = new Point(e.obj.startX,  e.obj.startY);
        startPoint = _stage.localToGlobal(startPoint);
        var targetPoint:Point = new Point(e.obj.targetX, e.obj.targetY);
        var bulletClass:Class = e.obj.bulletClass;
        addBullet(new bulletClass(startPoint.x, startPoint.y, targetPoint.x, targetPoint.y, true),
                _player);
    }


    /* BULLETS LOOP */
    public function loop():void
    {
        for each(var bullet:IBullet in _bullets)
        {
            if(bullet)
            {
                bullet.move();
                // enemy bullet
                if(bullet.isEnemyBullet)
                {
                    // check first with fist if it is
                    if(_player.fist)
                    {
                        if(bullet.hitBox.hitTestObject(_player.fist.hitBox) && bullet.isDamaged)
                        {
                            bullet.isDamaged = false;
                            hitObjectByBullet(_player.fist, bullet);
                        }
                    }
                    // check for player collisions
                    else
                    {
                        if((bullet.hitBox.hitTestObject(_player.hitBox) && bullet.isDamaged))
                        {
                            bullet.isDamaged = false;
                            hitObjectByBullet(_player, bullet);
                        }
                    }
                }
                // player bullet
                else
                {
                    // check for enemy  collisions
                    for each(var enemy:IHittableByBullet in _activeEnemies)
                    {
                        if(bullet.hitBox.hitTestObject(enemy.hitBox) && bullet.isDamaged)
                        {
                            bullet.isDamaged = false;
                            _accuracyHitted++;
                            hitObjectByBullet(enemy, bullet);
                        }
                    }
                    // check for chests collisions
                    for each(var chest:IHittableByBullet in _chests)
                    {
                        if(bullet.hitBox.hitTestObject(chest.hitBox) && bullet.isDamaged)
                        {
                            bullet.isDamaged = false;
                            hitObjectByBullet(chest, bullet);
                        }
                    }

                }
                // restrict rect
                if(bullet.view.x < _restrictRect.x || bullet.view.x > _restrictRect.width || bullet.view.y < _restrictRect.y || bullet.view.y > _restrictRect.height)
                {
                    _accuracyMissed++;
                    hitObjectByBullet(null, bullet);
                }
            }
        }
    }

    /* HIT ENEMY */
    private function hitObjectByBullet(hittableObject:IHittableByBullet, bullet:IBullet):void
    {
        if(hittableObject)
        {
//            hittableObject.alphaFlashing(0.1, 1);
            hittableObject.damaged();
            hittableObject.health -= bullet.bulletDamage;
            if(bullet.isParalized) hittableObject.paralized();
        }

        // если пуля не лазер - уничтожается при контакте.
        if(!bullet.isLaser)
        {
            bullet.speedX = 0;
            bullet.view.dispatchEvent(new CustomEvent(CustomEvent.HIT, null, false, false, {bulletX:bullet.view.x, bulletY:bullet.view.y}));
            SoundManager.playSound(SoundManager.HIT_1, 0.7);
            if(!bullet.isDied) destroyBullet(bullet);
        }
    }

    /* DIED LISTENER */
    private function diedListener(e:CustomEvent):void
    {
        if(e.controllerClass is ABullet)
        {
            var bullet:IBullet = e.target as IBullet;
            if(!bullet.isDied)destroyBullet(bullet);
        }
    }

    /* ADD BULLET */
    public function addBullet(bullet:IBullet, player:PlayerController):void
    {
//        if(_bullets.length < _bulletAmount)
//        {
//            trace("add bullet");
            _player = player;
            _bullets.push(bullet);
            _mainScreen.addChild(bullet.view);
            bullet.setOrientation(_player.playerModel.scaleX * -1);
//            bullet.playState(ClipLabel.BORN, null, ClipLabel.RUN);

            TweenMax.fromTo(bullet.view, 0.2, {alpha:0}, {alpha:1});

            if(bullet.isEnemyBullet) bullet.playState(ClipLabel.RUN);
            else bullet.playState(bullet.clipLabelByDefault.name);

//        }
    }

    /* DESTROY BULLET */
    public function destroyBullet(bullet:IBullet):void
    {
        if(bullet.isLaser && !_mainScreen.contains(bullet.view))
        {
//            trace("LASER DESTROYED !!!");
            _mainScreen.removeChild(bullet.view);
        }
        bullet.isDied = true;
        if(_mainScreen.contains(bullet.view))
        {

            _mainScreen.removeChild(bullet.view);
        }
        _bullets.splice(_bullets.indexOf(bullet), 1);
        bullet.deactivate();
        bullet = null;
    }

    /* BOSS DIED */
    private function bossDied(e:CustomEvent):void
    {
//        trace("BULLET CONTROLLER : boss died !");
        deactivate();
    }

    /* DEACTIVATE */
    public function deactivate():void
    {
        for each(var bullet:IBullet in _bullets)
        {
            bullet.pause();
            if(_mainScreen.contains(bullet.view))_mainScreen.removeChild(bullet.view);
            bullet.deactivate();
            bullet = null;
        }

        if(_shootTimer)
        {
            _shootTimer.stop();
            _shootTimer.removeEventListener(TimerEvent.TIMER, playerShoot);
            _shootTimer = null;
        }
        if(_mainScreen.hasEventListener(CustomEvent.DIED)) _mainScreen.removeEventListener(CustomEvent.DIED, diedListener);
        if(_stage.hasEventListener(CustomEvent.ENEMY_SHOOT)) _stage.removeEventListener(CustomEvent.ENEMY_SHOOT, enemyShoot);
        if(_mainScreen.hasEventListener(MouseEvent.MOUSE_DOWN)) _mainScreen.removeEventListener(MouseEvent.MOUSE_DOWN, startShoot);
        if(_mainScreen.hasEventListener(MouseEvent.MOUSE_UP)) _mainScreen.removeEventListener(MouseEvent.MOUSE_UP, stopShoot);
        if(_mainScreen.hasEventListener(CustomEvent.STOP_GENERATE)) _mainScreen.removeEventListener(CustomEvent.STOP_GENERATE, bossDied);
    }

    public function get bullets():Vector.<IBullet> {return _bullets;}

    public function set bullets(value:Vector.<IBullet>):void {_bullets = value;}

    public function get accuracyMissed():int {return _accuracyMissed;}

    public function get accuracyHitted():int {return _accuracyHitted;}
}
}
