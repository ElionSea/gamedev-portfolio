/**
 * Created by Sith on 03.07.14.
 */
package levelStuff.bosses.concreteBosses
{
import custom.ClipLabel;
import custom.CustomEvent;

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.TimerEvent;
import flash.geom.Point;
import levelStuff.bosses.ABoss;
import levelStuff.bosses.IBoss;
import levelStuff.bosses.Step;
import levelStuff.bosses.StepPoint;
import levelStuff.bosses.StepPoint;
import levelStuff.bosses.StepPoint;
import levelStuff.bosses.StepPoint;
import levelStuff.bullets.BossCastleShell;
import levelStuff.bullets.BulletController;
import levelStuff.bullets.CrownShell;
import levelStuff.bullets.DesertLaser;
import levelStuff.bullets.DesertShell;
import levelStuff.bullets.FallingCastleCeil;
import levelStuff.bullets.IBullet;
import levelStuff.bullets.Mine;
import levelStuff.controllers.EnemyController;
import levelStuff.enemies.EList;
import levelStuff.enemies.IEnemy;
import levelStuff.enemies.Trajectory;
import levelStuff.treasures.TList;
import player.PlayerController;

import sound.SoundManager;

import xmlParsingTiledLevel.LevelObject;

public class BossLordOfDesert extends ABoss implements IEnemy, IBoss
{
    private var _o:LevelObject;
    private var _player:PlayerController;
    private var _bulletController:BulletController;
    private var _gameScreen:Sprite;

    private var _enemyController:EnemyController;

    /* CONSTRUCTOR */
    public function BossLordOfDesert(o:LevelObject, player:PlayerController, bulletController:BulletController, gameScreen:Sprite, enemyController:EnemyController)
    {
        _enemyController = enemyController;
        initLabels();
        _o = o;
        _player = player;
        _bulletController = bulletController;
        _gameScreen = gameScreen;
        var view:MovieClip = new McLordOfDesert();
        var startPoint:Point = new Point(_gameScreen.width/2, _gameScreen.height/2-(view.height/2));
        super(view, startPoint.x, startPoint.y, 88, 110, 0, EList.getBossHealth(BossLordOfDesert), 0.1, [TList.PURPLE_COIN, TList.GREEN_COIN, TList.PURPLE_COIN], _player);
    }

    /* INIT LABELS */
    private function initLabels():void
    {
        clipLabels = new Vector.<ClipLabel>();
        clipLabels.push(new ClipLabel(ClipLabel.WALK, 1, 0.5));
        clipLabels.push(new ClipLabel(ClipLabel.SHOOT, 1, 0.4));
    }

    /* INIT */
    public override function init():void
    {
        initStrategy(_o);
        _currentStrategy = _commonStrategy;
        _currentStep = _currentStrategy[0];
    }

    /* INIT STRATEGY */
    private var step1:Step;
    private var step2:Step;
    private var step3:Step;
    public function initStrategy(o:LevelObject):void
    {
        _commonStrategy = new Vector.<Step>();
        _angryStrategy = new Vector.<Step>();
        // init points
        /* STEP 1
          Появляется в точке 5 */
        var pathTriggers1:Array = [5, 1, 2, 3];
        var step1_path:Vector.<StepPoint> = ABoss.buildPath(o, 1, pathTriggers1);
        var step1_speed:Number = 2.5;
        var step1_trajectoryType:String = Trajectory.TWEENMAX_TO_POINT;
        var step1_trajectory:Trajectory = new Trajectory(view, step1_path[0].x, step1_path[0].y, 0, step1_trajectoryType, step1_speed, step1_speed);
        step1 = new Step(Step.MOVE, step1_trajectory, step1_path, step1_speed, step1_speed, 0, false);
        /* STEP 2
         * Передвигается по пути 2 - 4 - 1 - 3 - 2 * */
        var pathTriggers2:Array = [2, 4, 1, 3, 2];
        var step2_path:Vector.<StepPoint> = ABoss.buildPath(o, 2, pathTriggers2);
        var step2_speed:Number = 3;
        var step2_trajectoryType:String = Trajectory.TWEENMAX_TO_POINT;
        var step2_trajectory:Trajectory = new Trajectory(view, step2_path[0].x, step2_path[0].y, 0, step2_trajectoryType, step2_speed, step2_speed);
        step2 = new Step(Step.SHOOT, step2_trajectory, step2_path, step2_speed, step2_speed, 0, true, 0, 500);
        /* STEP 3
         *  */
        var pathTriggers3:Array = [2, 1, 2, 1];
        var step3_path:Vector.<StepPoint> = ABoss.buildPath(o, 3, pathTriggers3);
        var step3_speed:Number = 1.2;
        var step3_trajectoryType:String = Trajectory.WALK_TO_PLAYER;
        var step3_trajectory:Trajectory = new Trajectory(view, step3_path[0].x, step3_path[0].y, 0, step3_trajectoryType, step3_speed, step3_speed);
        step3 = new Step(Step.SPECIAL_SHOOT, step3_trajectory, step3_path, step3_speed, step3_speed, 0, true, 0, 2000, 9000);


        // COMMON STRATEGY
//        _commonStrategy.push(step1, step2, step3);
        _commonStrategy.push(step1, step2, step3);
        // ANGRY STRATEGY
//        _angryStrategy.push(step1, step2, step3);
    }

    /* ANGRY */
    protected override function angry():void
    {

        if(_commonStrategy.length < 4)
        {
//            trace("ADD ANGRY !!");
            _commonStrategy.push(step3);
        }
    }

    /* SET NEW POINT */
    public override function curPoint(pnt:StepPoint):void
    {
        /*if(pnt == shakePoint)
        {
            // shake game screen
            _view.dispatchEvent(new CustomEvent(CustomEvent.SHAKE_GAMESCREEN, BossLordOfCastle, true, false, {duration:0.1, repeatCount:10, randomRange:7}));
            // falling platforms
            for (var i:int = 0; i < _fallingPlatformAmount; i++)
            {
                var randomX:Number = (Math.random() * 170) + 90;
                var Y:Number = _gameScreen.y+40;
                var shell:FallingCastleCeil = new FallingCastleCeil(randomX, Y, _player.view.x, _player.view.y, true);
                _bulletController.addBullet(shell, _player);
            }
        }*/
    }

    /* SHOOT */
    private var _specialShootCounter:int = 0;
    private var _laser:DesertLaser;
    public override function shoot(e:TimerEvent):void
    {
        if(_currentStep.stepName == Step.SHOOT)
        {

            if(_currentStep.shootAmount > 0)
            {
                _currentStep.shootAmount--;
                if(_currentStep.shootAmount <= 0)
                {
                    stopShoot();
                    setNewCurrentTargetPoint();
                    return;
                }
            }
            _view.dispatchEvent(new CustomEvent(CustomEvent.ENEMY_SHOOT, BossLordOfDesert, true, false,
                    {startX:_view.x, startY:_view.y, targetX:_player.view.x, targetY:_player.view.y, bulletClass:DesertShell, soundName:SoundManager.BOSS_CASTLE_SHOOT}));
            playState(ClipLabel.SHOOT, null, ClipLabel.WALK);
        }
        else if(_currentStep.stepName == Step.SPECIAL_SHOOT)
        {
            _specialShootCounter++;
//            trace("_specialShootCounter : " + _specialShootCounter);
            if(_specialShootCounter == 1)
            {
                _laser = new DesertLaser(_view.x, _view.y-10, _player.view.x, _gameScreen.height-16, true, view);
                _bulletController.addBullet(_laser, _player);
                playState(ClipLabel.SHOOT);
            }
            else if(_specialShootCounter == 2)
            {
                playState(ClipLabel.WALK);
                _bulletController.destroyBullet(_laser);
                _specialShootCounter = 0;
            }

        }
    }

    public override function animateDeath(duration:Number, callback:Function):void
    {
        super.animateDeath(duration, callback);
        // убираем лазер после смерти босса
//        if(_laser) _bulletController.destroyBullet(_laser);
    }
}
}
