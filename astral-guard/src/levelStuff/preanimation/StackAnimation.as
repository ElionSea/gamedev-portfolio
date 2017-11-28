/**
 * Created by Sith on 10.09.14.
 */
package levelStuff.preanimation
{
import com.greensock.TweenMax;

import custom.ClipLabel;
import custom.CustomMovieClip;

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.utils.Timer;
import flash.utils.setTimeout;

import levelStuff.bosses.concreteBosses.BossLordOfCastle;
import levelStuff.bosses.concreteBosses.BossLordOfDesert;
import levelStuff.bosses.concreteBosses.BossLordOfFire;
import levelStuff.bosses.concreteBosses.BossLordOfIce;
import levelStuff.bosses.concreteBosses.BossLordOfSwamp;
import levelStuff.bosses.concreteBosses.BossLordOfUnreal;

import levels.LevelManager;

import locale.InfoNode;
import locale.Locale;

import player.MovableModel;
import player.PlayerController;

import sound.SoundManager;

import xmlParsingTiledLevel.Level;

public class StackAnimation
{
    private var _portal:StartPortal;
    private var _bg:CustomMovieClip;
    private var _gameScreen:Sprite;
    private var _functions:Array;
    private var _durations:Array;
    private var _endCallback:Function;
    private var _level:Level;
    private var _levelInfo:McLevelInfo;
    private var _levelManager:LevelManager;
    private var _player:PlayerController;

    public static const LEVEL_START_1:String = "levelStart1";  // появление игрока, когда он впервые в мире
    public static const LEVEL_START_2:String = "levelStart2";  // игрок уже находится в мире
    public static const BOSS_LEVEL:String = "bossLevel";  // уровень с боссом

    /*CONSTRUCTOR*/
    public function StackAnimation(bg:CustomMovieClip, gameScreen:Sprite, endCallback:Function, level:Level, levelManager:LevelManager)
    {
        _bg = bg;
        _gameScreen = gameScreen;
        _endCallback = endCallback;
        _level = level;
        _levelManager = levelManager;
    }

    /* INIT PLAYER */
    public function initPlayer(player:PlayerController):void
    {
        _player = player;
    }

    /* INIT */
    public function init(functions:Array, durations:Array):void
    {
        _functions = functions;
        _durations = durations;
    }

    public function start():void
    {
        switch (_level.levelWave)
        {
            case 1:
                _levelManager.playerStartPoint = new Point(_gameScreen.width/2, _gameScreen.height/2);
                _functions = [showPortal, _levelManager.initPlayer, hidePortal, removePortal,  removeLevelInfo];
                _durations = [2000, 1000, 1000, 250, 500];
                startAnimation(StackAnimation.LEVEL_START_1); break;
            case 2:
                _levelManager.playerStartPoint = new Point(_gameScreen.width/2, _gameScreen.height-Platformer.TILE_SIZE-(32/2));
                _functions = [_levelManager.initPlayer,  removeLevelInfo];
                _durations = [3000, 500];
                startAnimation(StackAnimation.LEVEL_START_2); break;
            case 3:
                _levelManager.playerStartPoint = new Point(_gameScreen.width/2, _gameScreen.height-Platformer.TILE_SIZE-(32/2));
                _functions = [_levelManager.initPlayer,  removeLevelInfo];
                _durations = [3000, 500];
                startAnimation(StackAnimation.LEVEL_START_2); break;
            case 4:
                _functions = [_levelManager.initPlayer, showBossAppearClip, tempFunction, removeLevelInfo];
                _durations = [2000, 1000, 3000, 500];
                _levelManager.playerStartPoint = new Point(_gameScreen.width/2, _gameScreen.height-Platformer.TILE_SIZE-(32/2));
                startAnimation(StackAnimation.BOSS_LEVEL); break;
        }
    }

    /* SHOW BOSS APPEAR CLIP */
    private var _bossClip:CustomMovieClip;
    private function showBossAppearClip():void
    {
        switch (_level.bossClass)
        {
            case BossLordOfCastle:
                    _bossClip = new CustomMovieClip(_bossClip, new MovableModel(), new McBossCastleAppear, _gameScreen.width/2, _gameScreen.height/2-15);
                _bossClip.clipLabels = new Vector.<ClipLabel>();
                    _bossClip.clipLabels.push(new ClipLabel(ClipLabel.WALK, 48, 3.3));
                break;
            case BossLordOfSwamp:
                    _bossClip = new CustomMovieClip(_bossClip, new MovableModel(), new McBossSwampAppear, _gameScreen.width/2, _gameScreen.height/2);
                    _bossClip.clipLabels = new Vector.<ClipLabel>();
                    _bossClip.clipLabels.push(new ClipLabel(ClipLabel.WALK, 71, 1.5));
                break;
            case BossLordOfDesert:
                    _bossClip = new CustomMovieClip(_bossClip, new MovableModel(), new McBossDesertAppear, _gameScreen.width/2, _gameScreen.height/2);
                    _bossClip.clipLabels = new Vector.<ClipLabel>();
                    _bossClip.clipLabels.push(new ClipLabel(ClipLabel.WALK, 42, 3));
                break;
            case BossLordOfUnreal:
                _bossClip = new CustomMovieClip(_bossClip, new MovableModel(), new McBossAppearingInner(), _gameScreen.width/2, _gameScreen.height/2);
                _bossClip.clipLabels = new Vector.<ClipLabel>();
                _bossClip.clipLabels.push(new ClipLabel(ClipLabel.WALK, 50, 1.5));
                break;
            case BossLordOfIce:
                _bossClip = new CustomMovieClip(_bossClip, new MovableModel(), new McBossAppearingIceworld(), _gameScreen.width/2, _gameScreen.height/2);
                _bossClip.clipLabels = new Vector.<ClipLabel>();
                _bossClip.clipLabels.push(new ClipLabel(ClipLabel.WALK, 50, 0.75));
                break;
            case BossLordOfFire:
                _bossClip = new CustomMovieClip(_bossClip, new MovableModel(), new McBossAppearingVolcano(), _gameScreen.width/2, _gameScreen.height/2);
                _bossClip.clipLabels = new Vector.<ClipLabel>();
                _bossClip.clipLabels.push(new ClipLabel(ClipLabel.WALK, 22, 1));
                break;
        }
        _gameScreen.addChild(_bossClip.view);
        SoundManager.playSound(SoundManager.BOSS_CASTLE_APPEAR, 0.8);
        _bossClip.playState(ClipLabel.WALK, hideBossAppearClip);
    }

    /* HIDE BOSS APPEAR CLIP */
    private function hideBossAppearClip(clip:MovieClip):void
    {
        _gameScreen.removeChild(_bossClip.view);
        _bossClip.deactivate();
        _bossClip = null;
    }

    private function tempFunction():void{}

    /* START ANIMATION */
    public function startAnimation(animationType:String):void
    {
        switch (animationType)
        {
            case LEVEL_START_1:
                addLevelInfo();
                _bg.colored(0xFFFFFF, 0.2);
                break;
            case LEVEL_START_2:
                addLevelInfo();
                _bg.colored(0xFFFFFF, 0.2);
                break;
            case BOSS_LEVEL:
                addLevelInfo();
                _bg.colored(0xFFFFFF, 0.2);
                break;
        }
        playAnimation(_functions, _durations);
    }

    /* ADD LEVEL INFO */
    private function addLevelInfo():void
    {
        _levelInfo = new McLevelInfo();
        _levelInfo.x = _gameScreen.width/2;
        _levelInfo.y = (_gameScreen.height/2) - _levelInfo.height - 20;
        var keys:Array = ["startGame", "levels", _level.levelName];
        var infoNode:InfoNode = Locale.getLevelScreenInfo(keys);
        _levelInfo.tfCaption.text = infoNode.caption;
        _levelInfo.tfCaption.textColor = uint(infoNode.color);
        var desc:String;
        if(_level.isBoss)
        {
            desc = infoNode.bossName;
            _level.bossName = infoNode.bossName;
        }
        else if(_level.isBonus) desc = "";
        else desc = "wave " + _level.levelWave;
        _levelInfo.tfDesc.text = desc;
        _levelInfo.tfDesc.textColor = uint(infoNode.color);
        _levelInfo.alpha =0;
        TweenMax.to(_levelInfo, 0.5, {alpha:1});
        _gameScreen.addChild(_levelInfo);
    }

    /* REMOVE LEVEL INFO */
    public function removeLevelInfo():void
    {
        _bg.uncolored();
        TweenMax.to(_levelInfo, 0.5, {alpha:0, onComplete:remove});
        function remove():void
        {
            _gameScreen.removeChild(_levelInfo);
            _levelInfo = null;
        }
    }



    /* PLAY ANIMATION */
    private var _currentAnimationIndex:int;
    private var _amount:int;
    private function playAnimation(functions:Array=null, durations:Array=null):void
    {
        if(functions)
        {
            // первый раз
            _functions = functions;
            _durations = durations;
            _amount = functions.length;
            _currentAnimationIndex = 0;
        }
        if(_amount > 0)
        {
            setTimeout(_functions[_currentAnimationIndex], _durations[_currentAnimationIndex]);
            var timer:Timer = new Timer(_durations[_currentAnimationIndex], 1);
            timer.addEventListener(TimerEvent.TIMER_COMPLETE, completeTimer);
            timer.start();
            function completeTimer(e:TimerEvent):void
            {
                timer.removeEventListener(TimerEvent.TIMER_COMPLETE, completeTimer);
                timer = null;
                _currentAnimationIndex++;
                if(_currentAnimationIndex < _amount) playAnimation();
                else _endCallback();
            }
        }
    }

    /* PLAY PLAYER DEATH */
    public function playPlayerDeath(callback:Function):void
    {
        SoundManager.playSound(SoundManager.PLAYER_DEATH, 0.4);
        var deathMask:McPlayerDeathMask = new McPlayerDeathMask();
        deathMask.x  = 80;
        _gameScreen.addChild(deathMask);
        _gameScreen.addChild(_player.view);
        _player.playState(ClipLabel.DEATH);
        TweenMax.to(_player.view, 4, {y:_player.view.y-60, onComplete:endAnimation});
        function endAnimation():void
        {
            deathMask.stop();
            callback();
        }
    }


    /* ___________________________PORTAL ANIMATION______________________________*/

                    /* SHOW PORTAL */
                    public function showPortal():void
                    {
                        _portal = new StartPortal();
                        _portal.view.x = _gameScreen.width/2;
                        _portal.view.y = _gameScreen.height/2;
                        _gameScreen.addChild(_portal.view);
                        SoundManager.playSound(SoundManager.PORTAL);
                        _portal.playState(ClipLabel.SHOW, showPortalWalk);
                    }

                    /* SHOW PORTAL WALK */
                    private function showPortalWalk(obj:Class=null):void
                    {
                        _portal.playState(ClipLabel.WALK);
                    }

                    /* HIDE PORTAL */
                    public function hidePortal():void
                    {
                        _portal.playState(ClipLabel.HIDE);
                    }

                    /* REMOVE PORTAL */
                    public function removePortal():void
                    {
                        if(_portal.view.parent)_gameScreen.removeChild(_portal.view);
                        _portal = null;
                    }
}
}
