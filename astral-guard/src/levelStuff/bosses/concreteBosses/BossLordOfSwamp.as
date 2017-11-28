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
import levelStuff.bullets.BulletController;
import levelStuff.bullets.PoisonShell;
import levelStuff.controllers.EnemyController;
import levelStuff.enemies.EList;
import levelStuff.enemies.IEnemy;
import levelStuff.enemies.Trajectory;
import levelStuff.treasures.TList;
import player.PlayerController;

import sound.SoundManager;

import xmlParsingTiledLevel.LevelObject;

public class BossLordOfSwamp extends ABoss implements IEnemy, IBoss
{
    private var _o:LevelObject;
    private var _player:PlayerController;
    private var _bulletController:BulletController;
    private var _gameScreen:Sprite;

    private var _fallingPlatformAmount:int; // количество  платформ, падающих с потолка

    /* CONSTRUCTOR */
    public function BossLordOfSwamp(o:LevelObject, player:PlayerController, bulletController:BulletController, gameScreen:Sprite, enemyController:EnemyController)
    {
        initLabels();
        _o = o;
        _player = player;
        _bulletController = bulletController;
        _gameScreen = gameScreen;
        var view:MovieClip = new McBossLordOfSwamp();
        var startPoint:Point = new Point(_gameScreen.width/2, _gameScreen.height/2-(view.height/2));
        var p:Point = o.getPathTriggerCenter(2);
        super(view, startPoint.x, startPoint.y, 88, 110, 0, EList.getBossHealth(BossLordOfSwamp), 0.2, [TList.PURPLE_COIN, TList.PURPLE_COIN, TList.PURPLE_COIN]);
    }

    /* INIT LABELS */
    private function initLabels():void
    {
        clipLabels = new Vector.<ClipLabel>();
        clipLabels.push(new ClipLabel(ClipLabel.WALK, 10, 0.8));
        clipLabels.push(new ClipLabel(ClipLabel.SHOOT, 3, 0.2));
    }

    /* INIT */
//    private var shakePoint:Point;
    public override function init():void
    {
        initStrategy(_o);
        _currentStrategy = _commonStrategy;
        _currentStep = _currentStrategy[0];

//        shakePoint = _o.getPathTriggerCenter(5);
        _fallingPlatformAmount = 4;
    }

    private var _levelObject:LevelObject;
    /* INIT STRATEGY */
    private var step1:Step;
    private var step2:Step;
    private var step3:Step;
    public function initStrategy(o:LevelObject):void
    {
        _levelObject = o;
        _commonStrategy = new Vector.<Step>();
        _angryStrategy = new Vector.<Step>();
        // init points
        /* STEP 1
         * Появляется в точке 1 и стреляет 3 раза* */
        var pathTriggers1:Array = [5, 3, 6, 2, 4, 1, 5];
        var step1_path:Vector.<StepPoint> = ABoss.buildPath(o, 1, pathTriggers1);
        var step1_speed:int = 0;
        var step1_trajectoryType:String = Trajectory.TWEENMAX_TO_POINT;
        var step1_trajectory:Trajectory = new Trajectory(view, step1_path[0].x, step1_path[0].y, 0, step1_trajectoryType, step1_speed, step1_speed);
        step1 = new Step(Step.SHOOT, step1_trajectory, step1_path, step1_speed, step1_speed, 0, true);
        /* STEP 2
         * Передвигается по пути 1 - 2 - 3 - 4 - 1 * */
        var pathTriggers2:Array = [1, 5];
        var step2_path:Vector.<StepPoint> = ABoss.buildPath(o, 2, pathTriggers2);
        var step2_speed:int = 2;
        var step2_trajectoryType:String = Trajectory.STATIC;
        var step2_trajectory:Trajectory = new Trajectory(view, step2_path[0].x, step2_path[0].y, 0, step2_trajectoryType, step2_speed, step2_speed);
        step2 = new Step(Step.SPECIAL_SHOOT, step2_trajectory, step2_path, step2_speed, step2_speed, 0, true, 6);

        // COMMON STRATEGY
        _commonStrategy.push(step1, step2);
        // ANGRY STRATEGY
//        _angryStrategy.push(step1, step2, step3);
    }

    /* ANGRY */
    private var _isAlreadyAngry:Boolean;
    protected override function angry():void
    {
        if(!_isAlreadyAngry)
        {
            _isAlreadyAngry = true;
//            trace("PUSH ANGRY STEP !!");
            var pathTriggers3:Array = [1, 5];
            var step3_path:Vector.<StepPoint> = ABoss.buildPath(_levelObject, 3, pathTriggers3);
            var step3_speed:int = 2;
            var step3_trajectoryType:String = Trajectory.STATIC;
            var step3_trajectory:Trajectory = new Trajectory(view, step3_path[0].x, step3_path[0].y, 0, step3_trajectoryType, step3_speed, step3_speed);
            step3 = new Step(Step.SPECIAL_SHOOT, step3_trajectory, step3_path, step3_speed, step3_speed, 0, true, 6);
            _commonStrategy.push(step3);
        }
    }

    /* SHOOT */
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
            _view.dispatchEvent(new CustomEvent(CustomEvent.ENEMY_SHOOT, BossLordOfSwamp, true, false,
                    {startX:_view.x, startY:_view.y, targetX:_player.view.x, targetY:_player.view.y, bulletClass:PoisonShell, soundName:SoundManager.BOSS_CASTLE_SHOOT}));
            playState(ClipLabel.SHOOT, null, ClipLabel.WALK);
        }
        else if(_currentStep.stepName == Step.SPECIAL_SHOOT)
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
            var radius:uint = 20;
            var delta:Number = 180 / 7;
            var randomOffset:int = Math.ceil(Math.random()*10);
            var angle:Number;
            for (var i:int = 0; i < 7; i++)
            {
                angle = -((i * (delta+randomOffset) * Math.PI)/180);
                var pos:Point = Point.polar(radius, angle);
                var shell:PoisonShell = new PoisonShell(pos.x+_view.x, pos.y+_view.y, _view.x, _view.y, true);
//                shell.view.rotation = angle * 180 / Math.PI;
                _bulletController.addBullet(shell, _player);
            }
            playState(ClipLabel.SHOOT);
        }
    }
}
}
