/**
 * Created by Sith on 05.09.14.
 */
package levelStuff.controllers
{
import com.greensock.TweenLite;

import compositepPattern.ISubController;

import custom.ClipLabel;

import custom.CustomEvent;
import custom.CustomMovieClip;

import data.AchievementsData;

import data.DataController;
import data.PlayerData;

import flash.display.Sprite;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.utils.Timer;

import levelStuff.bullets.BulletController;
import levelStuff.bullets.CrownShell;
import levelStuff.bullets.Mine;
import levelStuff.bullets.RainbowShell;
import levelStuff.enemies.IEnemy;
import levelStuff.spell.Fist;
import levelStuff.spell.Spell;

import levels.LevelManager;

import player.MovableModel;

import player.PlayerController;

import sound.SoundManager;

public class SpellController implements ISubController
{
    private var _levelManager:LevelManager;
    private var _gameScreen:Sprite;
    private var _bulletController:BulletController;
    private var _player:PlayerController;
    private var _playerData:PlayerData;
    private var _enemyController:EnemyController;

    // counters for achievements
    private static var s_vortexCounter:int = 0;
    private static var s_fistCounter:int = 0;
    private static var s_crownCounter:int = 0;
    private static var s_freezeCounter:int = 0;
    private static var s_mineCounter:int = 0;

    /*CONSTRUCTOR*/
    public function SpellController(levelManager:LevelManager, gameScreen:Sprite, bulletController:BulletController, player:PlayerController, playerData:PlayerData, enemyController:EnemyController)
    {
        _levelManager = levelManager;
        _gameScreen = gameScreen;
        _bulletController = bulletController;
        _player = player;
        _playerData = playerData;
        _enemyController = enemyController;

        initEffects();

        _gameScreen.addEventListener(CustomEvent.SPELL_CAST, spellCast);
    }

    private var _rainbowEffect:CustomMovieClip;
    private var _fistEffect:CustomMovieClip;
    private var _crownAnimation:CustomMovieClip;
    private var _freezeAnimation:CustomMovieClip;
    private var _mineAnimation:CustomMovieClip;
    private function initEffects():void
    {
        _rainbowEffect = new CustomMovieClip(this, new MovableModel(), new McRainbowSpellAnimation, 0, 0);
        _rainbowEffect.clipLabels = new Vector.<ClipLabel>();
        _rainbowEffect.clipLabels.push(new ClipLabel(ClipLabel.WALK, 8, 0.5));

        _fistEffect = new CustomMovieClip(this, new MovableModel(), new McFistAnimation(), 0, 0);
        _fistEffect.clipLabels = new Vector.<ClipLabel>();
        _fistEffect.clipLabels.push(new ClipLabel(ClipLabel.WALK, 8, 0.5));

        _crownAnimation = new CustomMovieClip(this, new MovableModel(), new McCrownAnimation(), 0, 0);
        _crownAnimation.clipLabels = new Vector.<ClipLabel>();
        _crownAnimation.clipLabels.push(new ClipLabel(ClipLabel.WALK, 8, 0.5));

        _freezeAnimation = new CustomMovieClip(this, new MovableModel(), new McFreezeAnimation(), 0, 0);
        _freezeAnimation.clipLabels = new Vector.<ClipLabel>();
        _freezeAnimation.clipLabels.push(new ClipLabel(ClipLabel.WALK, 8, 0.5));

        _mineAnimation = new CustomMovieClip(this, new MovableModel(), new McMineSpellAnimation(), 0, 0);
        _mineAnimation.clipLabels = new Vector.<ClipLabel>();
        _mineAnimation.clipLabels.push(new ClipLabel(ClipLabel.WALK, 9, 0.5));
    }

    /* SPELL CAST */
    private function spellCast(e:CustomEvent):void
    {
        _levelManager.loopPause();
        SoundManager.playSound(SoundManager.SPELL, 0.7);
        var startPoint:Point;
        var preEffect:CustomMovieClip;
        var afterEffectFunction:Function;
        switch (e.obj.spellType)
        {
            case Spell.RAINBOW:
                vortexCounter(1);
                startPoint = new Point(_player.view.x,  _player.view.y);
                preEffect = _rainbowEffect;
                afterEffectFunction = castRainbow;
                break;
            case Spell.FIST:
                fistCounter(1);
                startPoint = new Point(_player.view.x,  _player.view.y);
                preEffect = _fistEffect;
                afterEffectFunction = castFist;
                break;
            case Spell.CROWN:
                crownCounter(1);
                startPoint = new Point(_player.view.x,  _player.view.y);
                preEffect = _crownAnimation;
                afterEffectFunction = castCrown;
                break;
            case Spell.FREEZE:
                freezeCounter(1);
                startPoint = new Point(_player.view.x,  _player.view.y);
                preEffect = _freezeAnimation;
                afterEffectFunction = castFreeze;
                break;
            case Spell.MINE:
                mineCounter(1);
                startPoint = new Point(80,  0);
                preEffect = _mineAnimation;
                afterEffectFunction = castMine;
                break;
        }

        preEffect.view.x = startPoint.x;
        preEffect.view.y = startPoint.y;
        _gameScreen.addChild(preEffect.view);
        preEffect.playState(ClipLabel.WALK);
        preEffect.view.alpha = 1;
        TweenLite.to(preEffect.view, 0.5, {alpha:1, onComplete:endEffect});
        function endEffect():void
        {
            _gameScreen.removeChild(preEffect.view);
            _levelManager.loopResume();

            afterEffectFunction();
        }
    }

    /* SPELL CONTROLLER LOOP */
    public function loop():void
    {
        if(_player.fist) _player.fist.move();
    }

    /* CAST RAINBOW */
    private function castRainbow():void
    {
        var shellsAmount:int = DataController.playerData.rainbowShellsAmount;
        var radius:uint = 30;
        var delta:int = 360 / shellsAmount;
        var angle:Number;
        for (var i:int = 0; i < shellsAmount; i++)
        {
            angle = (i * delta * Math.PI)/180;
            var pos:Point = Point.polar(radius, angle);
            var roundAngle:Number = Math.atan2(pos.y, pos.x) * 180 / Math.PI;
            var shell:RainbowShell = new RainbowShell(pos.x+_player.view.x, pos.y+_player.view.y, _player.view.x, _player.view.y, false, roundAngle, radius, _player.view, _gameScreen);
            _bulletController.addBullet(shell, _player);
        }
    }

    /* CAST FIST */
    private function castFist():void
    {
        // если ещё остался старый щит - удаляем его
        if(_player.fist) fistEnd();
        _player.fist = new Fist(_player.view, DataController.playerData.fistHealth, fistEnd);
        _gameScreen.addChild(_player.fist.view);
    }

    /* FIST END */
    private function fistEnd():void
    {
        _gameScreen.removeChild(_player.fist.view);
        _player.fist = null;
    }

    /* CAST CROWN */
    private function castCrown():void
    {
        var radius:uint = 15;
        var delta:int = 180 /  DataController.playerData.crownShellAmount;
        var angle:Number;
        for (var i:int = 0; i < DataController.playerData.crownShellAmount; i++)
        {
            angle = -((i * delta * Math.PI)/180);
            var pos:Point = Point.polar(radius, angle);
            var shell:CrownShell = new CrownShell(pos.x+_player.view.x, pos.y+_player.view.y, _player.view.x, _player.view.y, false);
            shell.view.rotation = angle * 180 / Math.PI;
            _bulletController.addBullet(shell, _player);
        }
    }

    /* CAST FREEZE */
    private var _freezeTimer:Timer;
    private function castFreeze():void
    {
        _freezeTimer = new Timer(DataController.playerData.freezeLength*1000, 1);
        _freezeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, freezeEnd);
        for each(var enemy:IEnemy in _enemyController.activeEnemies)
        {
            enemy.freeze();
            enemy.view.gotoAndStop(1);
        }
        _freezeTimer.start();
    }

    /* FREEZE END */
    private function freezeEnd(e:TimerEvent=null):void
    {
        if(_freezeTimer)
        {
            _freezeTimer.stop();
            _freezeTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, freezeEnd);
            _freezeTimer = null;
        }

        if(_enemyController)
        {
            for each(var enemy2:IEnemy in _enemyController.activeEnemies)
            {
                enemy2.unfreeze();
            }

        }
    }

    /* CAST MINE */
    private function castMine():void
    {
        var amount:int = DataController.playerData.mineAmount;
        var segment:int = 32;
        for (var i:int = 0; i < amount; i++)
        {
            var randomX:Number = 80 + segment + (i * segment);
            var Y:Number = (Platformer.HEIGHT)-16;
            var shell:Mine = new Mine(randomX, Y, _player.view.x, _player.view.y, false);
            _bulletController.addBullet(shell, _player);
        }
    }

    /* DEACTIVATE */
    public function deactivate():void
    {
        freezeEnd();
        if(_player.fist) fistEnd();
        _gameScreen.removeEventListener(CustomEvent.SPELL_CAST, spellCast);
    }

    public function vortexCounter(value:int):void {
        SpellController.s_vortexCounter += value;
        if(SpellController.s_vortexCounter == 10) DataController.achievementsData.updateAchievement(AchievementsData.POWER_OF_VORTEX);
    }

    public function fistCounter(value:int):void {
        SpellController.s_fistCounter += value;
        if(SpellController.s_fistCounter == 10) DataController.achievementsData.updateAchievement(AchievementsData.POWER_OF_BUBBLE);
    }

    public function crownCounter(value:int):void {
        SpellController.s_crownCounter += value;
        if(SpellController.s_crownCounter == 10) DataController.achievementsData.updateAchievement(AchievementsData.POWER_OF_GOLDEN_CROWN);
    }

    public function freezeCounter(value:int):void {
        SpellController.s_freezeCounter += value;
        if(SpellController.s_freezeCounter == 10) DataController.achievementsData.updateAchievement(AchievementsData.POWER_OF_FREEZING);
    }

    public function mineCounter(value:int):void {
        SpellController.s_mineCounter += value;
        if(SpellController.s_mineCounter == 10) DataController.achievementsData.updateAchievement(AchievementsData.POWER_OF_PLASMOIDS);
    }
}
}
