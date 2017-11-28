/**
 * Created by Sith on 04.09.14.
 */
package gui
{
import com.greensock.TweenMax;
import com.greensock.easing.Elastic;

import custom.CustomEvent;

import data.DataController;

import flash.display.SimpleButton;

import flash.display.SimpleButton;

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.utils.setTimeout;

import levelStuff.bosses.IBoss;

import compositepPattern.ISubController;
import levelStuff.enemies.AEnemy;
import levelStuff.enemies.IEnemy;

import levelStuff.spell.Spell;

public class ComboController implements ISubController
{
    private var _gameScreen:Sprite;
    private var _interfaceView:Sprite;

    private var _state:int;
    private const FILLING:int = 1;
    private const FULL:int = 2;

    private var _spellButtons:Vector.<SimpleButton> = new Vector.<SimpleButton>();
    private var _rainbowBtn:SimpleButton;
    private var _fistBtn:SimpleButton;
    private var _goldCrown:SimpleButton;
    private var _freezeBtn:SimpleButton;
    private var _mineBtn:SimpleButton;

    /*CONSTRUCTOR*/
    public function ComboController(gameScreen:Sprite, interfaceView:Sprite)
    {
        _gameScreen = gameScreen;
        _interfaceView = interfaceView;
        _state = FILLING;
        DataController.playerData.spellPoints = 0;

        initSpellButtons();

        _gameScreen.addEventListener(CustomEvent.DIED, enemyDied, true);
    }

    /* INIT SPELL BUTTONS */
    private function initSpellButtons():void
    {
        _rainbowBtn = _interfaceView["btnSpellRainbow"];
        _fistBtn = _interfaceView["btnSpellFist"];
        _goldCrown = _interfaceView["btnSpellGoldCrown"];
        _freezeBtn = _interfaceView["btnSpellFreeze"];
        _mineBtn = _interfaceView["btnSpellMine"];
        _spellButtons.push(_rainbowBtn);
        _spellButtons.push(_fistBtn);
        _spellButtons.push(_goldCrown);
        _spellButtons.push(_freezeBtn);
        _spellButtons.push(_mineBtn);
//        deactivateSpellIcons();
        activateSpellIcons();
    }

    /* ENEMY DIED */
    private var _isCombo:Boolean;
    private var _currentCombo:int = 0;
    private function enemyDied(e:CustomEvent):void
    {
//        trace("ENEMY DIED ! : " + e.obj.controllerClass);
        if(e.obj.controllerClass == AEnemy)
        {
//            trace(_state);
            if(DataController.playerData.spellPoints == DataController.playerData.TOTAL_SPELL_POINTS)
            {
                _state = FULL;
                // если ещё не активированы, активировать иконки магии
                if(!_isIconsActive) activateSpellIcons();
            }
            else
            {
                _state = FILLING;
            }

            if(_state == FILLING)
            {
                _isCombo = true;
//            trace("_currentCombo :" + _currentCombo);
                setTimeout(comboFalse, 1000);
                _currentCombo++;
                if(_currentCombo > 0)
                {
                    if(_currentCombo > 1) showCombo(e.obj.x, e.obj.y);
                    DataController.playerData.spellPoints += (_currentCombo+1);
                }
                else     DataController.playerData.spellPoints += 5;
            }
            else if(_state == FULL)
            {

            }
        }
    }

    /* SHOW COMBO */
    private function showCombo(x:Number, y:Number):void
    {
//        trace("SHOW COMBO !");
        var comboView:McCombo = new McCombo();
        comboView.gotoAndStop(_currentCombo-1);
        comboView.cacheAsBitmap = true;
        comboView.x = x;
        comboView.y = y;
        _gameScreen.addChild(comboView);
        TweenMax.to(comboView, 2, {z:comboView.z+100, y:comboView.y-25, ease:Elastic.easeOut, /*alpha:0.5,*/ onComplete:removeCombo});
//        TweenMax.to(comboView, 2, {alpha:0});
        function removeCombo():void
        {
            _gameScreen.removeChild(comboView);
        }
    }

    /* COMBO */
    private function comboFalse():void
    {
        _isCombo = false;
        _currentCombo = 0;
    }

    /* ACTIVATE SPELL ICONS */
    private var _isIconsActive:Boolean;
    private function activateSpellIcons():void
    {
        _isIconsActive = true;
        for each(var btn:SimpleButton in _spellButtons)
        {
            switch (btn.name)
            {
                case "btnSpellRainbow": activateButton(btn, DataController.playerData.rainbowShellDamage > 0); break;
                case "btnSpellFist": activateButton(btn, DataController.playerData.fistHealth > 0); break;
                case "btnSpellGoldCrown": activateButton(btn, DataController.playerData.crownShellDamage > 0); break;
                case "btnSpellFreeze": activateButton(btn, DataController.playerData.freezeLength > 0); break;
                case "btnSpellMine": activateButton(btn, DataController.playerData.mineDamage > 0); break;
            }
        }
    }

    /* ACTIVATE BUTTON */
    private function activateButton(btn:SimpleButton, isActivate:Boolean):void
    {
        btn.enabled = isActivate;
        btn.mouseEnabled = isActivate;
        btn.alpha = int(isActivate);
        if(isActivate)
        {
            if(!btn.hasEventListener(MouseEvent.CLICK)) btn.addEventListener(MouseEvent.CLICK, dispatchSpell);
        }
        else
        {
            if(btn.hasEventListener(MouseEvent.CLICK)) btn.removeEventListener(MouseEvent.CLICK, dispatchSpell);
        }
    }

    /* DEACTIVATE SPELL ICONS */
    private function deactivateSpellIcons():void
    {
        _isIconsActive = false;
        for each(var btn:SimpleButton in _spellButtons)
        {
            if(btn.hasEventListener(MouseEvent.CLICK)) btn.removeEventListener(MouseEvent.CLICK, dispatchSpell);
            btn.enabled = false;
            btn.mouseEnabled = false;
            btn.alpha = 0.1;
        }
    }

    /* DISPATCH SPELL */
    private function dispatchSpell(e:MouseEvent):void
    {
        deactivateSpellIcons();
        DataController.playerData.spellPoints = 0;
        switch (e.target.name)
        {
            case "btnSpellRainbow":     _gameScreen.dispatchEvent(new CustomEvent(CustomEvent.SPELL_CAST, ComboController, false, false, {spellType:Spell.RAINBOW}));     break;
            case "btnSpellFist":        _gameScreen.dispatchEvent(new CustomEvent(CustomEvent.SPELL_CAST, ComboController, false, false, {spellType:Spell.FIST}));        break;
            case "btnSpellGoldCrown":   _gameScreen.dispatchEvent(new CustomEvent(CustomEvent.SPELL_CAST, ComboController, false, false, {spellType:Spell.CROWN}));       break;
            case "btnSpellFreeze":      _gameScreen.dispatchEvent(new CustomEvent(CustomEvent.SPELL_CAST, ComboController, false, false, {spellType:Spell.FREEZE}));       break;
            case "btnSpellMine":        _gameScreen.dispatchEvent(new CustomEvent(CustomEvent.SPELL_CAST, ComboController, false, false, {spellType:Spell.MINE}));       break;
        }
    }

    /* LOOP */
    public function loop():void{}

    /* DEACTIVATE */
    public function deactivate():void
    {
        deactivateSpellIcons();
        _gameScreen.removeEventListener(CustomEvent.DIED, enemyDied, true);
    }
}
}
