/**
 * Created by Sith on 28.07.14.
 */
package gui
{
import custom.CustomEvent;

import data.DataController;
import data.IController;
import data.LevelData;

import flash.display.MovieClip;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;

import compositepPattern.ISubController;

import levelStuff.bosses.ABoss;
import levelStuff.enemies.EList;

import sound.SoundManager;

import utils.ShiftingTextField;

import utils.ShiftingTextField;

/* интерфейс во время игры на уровне */
public class GameInterfaceController implements IController, ISubController
{
    private var _view:Sprite;
    private var _gameScreen:Sprite;

    private var _healthBar:ScaleBar;
    private var _manaBar:ScaleBar;
    private var _spellBar:ScaleBar;
    private var _bossBar:ScaleBar;
    private var _bossBarCaption:McBossCaption;
    private var _healthCounter:ShiftingTextField;
    private var _manaCounter:ShiftingTextField;
    private var _spellCounter:ShiftingTextField;

    private var _musicBtn:MovieClip;
    private var _soundBtn:MovieClip;


//    private var _coinCounter:ShiftingTextField;
    private var _gamePointsCounter:ShiftingTextField;



    /*CONSTRUCTOR*/
    public function GameInterfaceController(view:Sprite, gameScreen:Sprite)
    {
        _view = view;
        _gameScreen = gameScreen;
//        _view.addEventListener(Event.ADDED_TO_STAGE, init);
        init();
    }

    /* INIT */
    private function init(/*e:Event*/):void
    {
//        _view.removeEventListener(Event.ADDED_TO_STAGE, init);

        initBars();

//        _coinCounter = new ShiftingTextField(_view["txtCoinCounter"]);

    }

    /* INIT BARS */
    private function initBars():void
    {
        // init bars
        _healthBar = new ScaleBar(DataController.playerData.totalHealth, new barTapeRedMc());
        _healthBar.view.x = _view["barBg_health"].x;
        _healthBar.view.y = _view["barBg_health"].y;
        _view.addChildAt(_healthBar, 5);

        _manaBar = new ScaleBar(DataController.playerData.totalMana, new barTapeBlueMc());
        _manaBar.view.x = _view["barBg_Mana"].x;
        _manaBar.view.y = _view["barBg_Mana"].y;
        _view.addChildAt(_manaBar, 5);

        // init boss health bar
        if(LevelData.getLevel(LevelData.currentLevel).isBoss)
        {
            _bossBar = new ScaleBar(EList.getBossHealth(LevelData.getLevel(LevelData.currentLevel).bossClass), new barTapeBossMc());
            _bossBar.view.x = _view["barBg_boss"].x;
            _bossBar.view.y = _view["barBg_boss"].y;
            _view.addChildAt(_bossBar, 5);

            _bossBarCaption = new McBossCaption();
            _bossBarCaption.tfCaption.text = LevelData.getLevel(LevelData.currentLevel).bossName;
            _bossBarCaption.x = _bossBar.view.x;
            _bossBarCaption.y = _bossBar.view.y;
            _view.addChildAt(_bossBarCaption, 6);
        }
        else
        {
            _gamePointsCounter = new ShiftingTextField(_view["txtGamePointsCounter"]);
            _gamePointsCounter.text = DataController.playerData.gamePoints.toString();
        }

        // init spell bar if though spell updated
        if(DataController.playerData.isUpdateAnySpell)
        {
            _spellBar = new ScaleBar(DataController.playerData.TOTAL_SPELL_POINTS, new barTapeYellowMc(), false);
            _spellBar.view.x = _view["barBg_Spell"].x;
            _spellBar.view.y = _view["barBg_Spell"].y;
            _view.addChildAt(_spellBar, 5);

            _spellCounter = new ShiftingTextField(_view["tf_SP_points"]);
        }


        // init bars counters

        _healthCounter = new ShiftingTextField(_view["tf_HP_points"]);
        _manaCounter = new ShiftingTextField(_view["tf_MP_points"]);


        // sound & music
        _musicBtn = _view["btnMusic"];
        _musicBtn.mouseChildren = false;
        _musicBtn.stop();
        _musicBtn.addEventListener(MouseEvent.CLICK, updateMusic);
        updateMusic();

        _soundBtn = _view["btnSound"];
        _soundBtn.mouseChildren = false;
        _soundBtn.stop();
        _soundBtn.addEventListener(MouseEvent.CLICK, updateSound);
        updateSound();

        _gameScreen.addEventListener(CustomEvent.SHOW_DAMAGE, updateBossHealthBar, true);
    }

    private function updateBossHealthBar(e:CustomEvent):void
    {
        if(e.controllerClass == ABoss)
        {
            _bossBar.update(e.obj.value, true);
        }
    }

    /* UPDATE SOUND */
    private function updateSound(e:MouseEvent=null):void
    {
//        trace("SOUND IS : " + SoundManager.isPlayingSounds);
        var bool:Boolean = SoundManager.isPlayingSounds;
        if(e)
        {
            SoundManager.setPlayingSounds(!bool);
        }
         _soundBtn.gotoAndStop(int(SoundManager.isPlayingSounds)+1);
    }

    /* UPDATE MUSIC */
    private function updateMusic(e:MouseEvent=null):void
    {
//        trace("MUSIC IS : " + SoundManager.isPlayingMusic);
        var bool:Boolean = SoundManager.isPlayingMusic;
        if(e)
        {
            SoundManager.setPlayingMusic(!bool);
        }
         _musicBtn.gotoAndStop(int(SoundManager.isPlayingMusic)+1);
    }

    /* DISPATCH DEATH */
    public function dispatchDeath():void
    {
        _view.dispatchEvent(new CustomEvent(CustomEvent.PLAYER_DEATH, GameInterfaceController, true));
    }

    /* UPDATE VIEW */
    public function updateView(obj:Object):void
    {
        if(_gamePointsCounter) _gamePointsCounter.text = DataController.playerData.gamePoints.toString();
        if(obj.curMana != null)
        {
            _manaBar.update(obj.curMana);
            _manaCounter.tweenNumbers(obj.curMana);
        }
        if(obj.curHealth != null)
        {
            _healthBar.update(obj.curHealth);
//            trace("obj.curHealth : " + obj.curHealth);
            _healthCounter.tweenNumbers(obj.curHealth);
        }
//        if(obj.curTempCoins != null) _coinCounter.tweenNumbers(obj.curTempCoins, (int(_coinCounter.text)-obj.curTempCoins));
        if(obj.curTempGamePoints != null)
        {
            if(_gamePointsCounter) _gamePointsCounter.tweenNumbers(int(_gamePointsCounter.text) + obj.curTempGamePoints, 10);
        }
        if(obj.curSpellPoints != null)
        {
//            trace("obj.curSpellPoints : "  + obj.curSpellPoints);
            if(_spellBar) _spellBar.update(obj.curSpellPoints);
            if(_spellCounter) _spellCounter.tweenNumbers(obj.curSpellPoints);
        }
    }

    /* DEACTIVATE */
    public function deactivate():void
    {
        _musicBtn.removeEventListener(MouseEvent.CLICK, updateMusic);
        _soundBtn.removeEventListener(MouseEvent.CLICK, updateSound);
        _gameScreen.removeEventListener(CustomEvent.SHOW_DAMAGE, updateBossHealthBar);
    }

    public function loop():void{}

    public function get view():Sprite {return _view;}
}
}
