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
import levelStuff.bullets.BossCastleShell;
import levelStuff.bullets.BulletController;
import levelStuff.bullets.CrownShell;
import levelStuff.bullets.FallingCastleCeil;
import levelStuff.bullets.Mine;
import levelStuff.controllers.EnemyController;
import levelStuff.enemies.EList;
import levelStuff.enemies.IEnemy;
import levelStuff.enemies.Trajectory;
import levelStuff.treasures.TList;
import player.PlayerController;

import sound.SoundManager;

import xmlParsingTiledLevel.LevelObject;

public class BossLordOfCastle extends ABoss implements IEnemy, IBoss
{
    private var _o:LevelObject;
    private var _player:PlayerController;
    private var _bulletController:BulletController;
    private var _gameScreen:Sprite;

    private var _fallingPlatformAmount:int; // количество  платформ, падающих с потолка

    /* CONSTRUCTOR */
    public function BossLordOfCastle(o:LevelObject, player:PlayerController, bulletController:BulletController, gameScreen:Sprite, enemyController:EnemyController)
    {
        initLabels();
        _o = o;
        _player = player;
        _bulletController = bulletController;
        _gameScreen = gameScreen;
        var view:MovieClip = new McLordOfCastle();
        var startPoint:Point = o.getPathTriggerCenter(1);
        super(view, startPoint.x, startPoint.y, 88, 110, 0, EList.getBossHealth(BossLordOfCastle), 0.2, [TList.PURPLE_COIN, TList.RED_COIN, TList.RED_COIN]);
    }

    /* INIT LABELS */
    private function initLabels():void
    {
        clipLabels = new Vector.<ClipLabel>();
        clipLabels.push(new ClipLabel(ClipLabel.WALK, 1, 0.5));
        clipLabels.push(new ClipLabel(ClipLabel.SHOOT, 6, 0.4));
    }

    /* INIT */
    private var shakePoint:Point;
        public override function init():void
    {
        initStrategy(_o);
        _currentStrategy = _commonStrategy;
        _currentStep = _currentStrategy[0];

//        shakePoint = new StepPoint("shakePoint", _o.getPathTriggerCenter(5));
        _fallingPlatformAmount = 4;
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
        * Появляется в точке 1 и стреляет 3 раза* */
        var pathTriggers1:Array = [1];
        var step1_path:Vector.<StepPoint> = ABoss.buildPath(o, 1, pathTriggers1);
        var step1_speed:int = 0;
        var step1_trajectory:Trajectory = new Trajectory(view, step1_path[0].x, step1_path[0].y, 0, Trajectory.STATIC, step1_speed, step1_speed);
        step1 = new Step(Step.SHOOT, step1_trajectory, step1_path, step1_speed, step1_speed, 0, true, 5);
        /* STEP 2
         * Передвигается по пути 1 - 2 - 3 - 4 - 1  */
        var pathTriggers2:Array = [1, 2, 3, 4, 1];
        var step2_path:Vector.<StepPoint> = ABoss.buildPath(o, 1, pathTriggers2);
        var step2_speed:int = 2;
        var step2_trajectory:Trajectory = new Trajectory(view, step2_path[0].x, step2_path[0].y, 0, Trajectory.TWEENMAX_TO_POINT, step2_speed, step2_speed);
        step2 = new Step(Step.MOVE, step2_trajectory, step2_path, step2_speed, step2_speed, 0, false);
        /* STEP 3
         * Передвигается по пути 1 - 5 - 1 c большой скоростью. В точке 5 происходит землетрясение и с потолка падают несколько платформ **/
        var p3_1:StepPoint = new StepPoint("p3_1", o.getPathTriggerCenter(1));
        var p3_2:StepPoint = new StepPoint("shakePoint", o.getPathTriggerCenter(5));
        shakePoint = p3_2;
        var p3_3:StepPoint = new StepPoint("p3_3", o.getPathTriggerCenter(1));
        var step3_path:Vector.<StepPoint> = new Vector.<StepPoint>();
        step3_path.push(p3_2, p3_3);
        var step3_speed:int = 4;
        var step3_trajectoryType:String = Trajectory.TWEEN_TO_POINT;
        var step3_trajectory:Trajectory = new Trajectory(view, p3_1.x, p3_1.y, 0, step3_trajectoryType, step3_speed, step3_speed);
        step3 = new Step(Step.SPECIAL_SHOOT, step3_trajectory, step3_path, step3_speed, step3_speed, 0, false);


        // COMMON STRATEGY
        _commonStrategy.push(step1, step2, step3);
        // ANGRY STRATEGY
//        _angryStrategy.push(step1, step2, step3);
    }

    /* ANGRY */
    protected override function angry():void
    {
        _fallingPlatformAmount = 6;
    }

    /* SET NEW POINT */
    public override function curPoint(pnt:StepPoint):void
    {
        if(pnt.index == "shakePoint")
        {
            // shake game screen
            SoundManager.playSound(SoundManager.BOSS_CASTLE_HEAD_IMPACT, 0.8);
            _view.dispatchEvent(new CustomEvent(CustomEvent.SHAKE_GAMESCREEN, BossLordOfCastle, true, false, {duration:0.1, repeatCount:10, randomRange:7}));
            // falling platforms
            for (var i:int = 0; i < _fallingPlatformAmount; i++)
            {
                var randomX:Number = (Math.random() * 170) + 90;
                var randomY:Number = Math.random() * 40;
                var Y:Number = _gameScreen.y+randomY;
                var shell:FallingCastleCeil = new FallingCastleCeil(randomX, Y, _player.view.x, _player.view.y, true);
                _bulletController.addBullet(shell, _player);
            }
        }
    }

    /* SHOOT */
    public override function shoot(e:TimerEvent):void
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
        _view.dispatchEvent(
                new CustomEvent(
                        CustomEvent.ENEMY_SHOOT,
                        BossLordOfCastle,
                        true,
                        false,
                        {startX:_view.x, startY:_view.y, targetX:_player.view.x, targetY:_player.view.y, bulletClass:BossCastleShell, soundName:SoundManager.BOSS_CASTLE_SHOOT}));
        playState(ClipLabel.SHOOT, null, ClipLabel.WALK);
    }
}
}
