/**
 * Created by Sith on 13.08.14.
 */
package gui.guild
{
import cv.Orion;
import cv.orion.filters.ColorFilter;
import cv.orion.filters.GravityFilter;
import cv.orion.filters.ScaleFilter;
import cv.orion.filters.WanderFilter;
import cv.orion.output.BurstOutput;

import data.DataController;
import data.PlayerData;

import flash.display.Sprite;
import flash.geom.Rectangle;
import flash.utils.Dictionary;

import gui.GradualPanel;
import gui.guild.academy.Action;

import popup.PopupController;

import sound.SoundManager;

/* вкладка "Академия" */
public class TabAcademy extends ATab
{

    // elements
    private var _manaRecoveryGrad:GradualPanel;
    private var _healthRecoveryGrad:GradualPanel;
    private var _healthGrad:GradualPanel;
    private var _manaGrad:GradualPanel;
    private var _gradualPanels:Vector.<GradualPanel>;

    private var _spellsUpdates:Dictionary;

    /*CONSTRUCTOR*/
    public function TabAcademy(name:String, view:Sprite, playerData:PlayerData)
    {
        super(name, view, playerData);

        init();
    }

    /* INIT */
    private function init():void
    {
        _gradualPanels = new Vector.<GradualPanel>();
        // skills init
        _manaRecoveryGrad   = new GradualPanel(view["manaRecoveryGradPanel"], _data.manaRecoverySkill, _data.avalManaRecovery, _data.avalManaRecoveryCost, _data, view["upBtn_manaRecovery"], _view, updateView);
        _healthRecoveryGrad = new GradualPanel(view["healthRecoveryGradPanel"], _data.healthRecoverySkill, _data.avalHealthRecovery, _data.avalHealthRecoveryCost, _data, view["upBtn_healthRecovery"],  _view, updateView);
        _healthGrad         = new GradualPanel(view["healthGradPanel"], _data.currentHealthSkill, _data.avalHealthIncreaces, _data.avalHealthIncreacesCost, _data, view["upBtn_healthAmount"],  _view, updateView);
        _manaGrad           = new GradualPanel(view["manaGradPanel"], _data.currentManaSkill, _data.avalManaIncreaces, _data.avalManaIncreacesCost, _data, view["upBtn_manaAmount"],  _view, updateView);

        _gradualPanels.push(_manaRecoveryGrad, _healthRecoveryGrad, _healthGrad, _manaGrad);

        // spells init
        _spellsUpdates = DataController.playerData.spellsUpdates;
        for each(var action:Action in _spellsUpdates)
        {
            action.initView(_view[action.name], updateSpell);
        }
        // TODO: Возможно стоит добавить колбек после обновления вида, чтобы предотвратить момент, когда скрин уже показан, а вид ещё не обновлён
    }

    /* UPDATE SPELL */
    private function updateSpell(action:Action):void
    {
        if(enoughMoney(action))
        {
            DataController.playerData.isUpdateAnySpell = true;

            updateSpellAnimation(action);
            var skillCount:int = int(action.name.charAt(action.name.length-1));
            var skillKey:String = action.name.substr(0, action.name.length-1);
            action.isExplored = true;
            if(skillCount < 3)
            {
                _spellsUpdates[skillKey+(skillCount+1)].isAval = true;
            }
            DataController.playerData.currentCoinsAmount -= action.cost;

            switch (action.name)
            {
                case PlayerData.UP+PlayerData.RAINBOW+skillCount: DataController.playerData.rainbowShellDamage = _spellsUpdates[skillKey+(skillCount)].value; break;
                case PlayerData.UP+PlayerData.FIST+skillCount: DataController.playerData.fistHealth = _spellsUpdates[skillKey+(skillCount)].value; break;
                case PlayerData.UP+PlayerData.CROWN+skillCount: DataController.playerData.crownShellDamage = _spellsUpdates[skillKey+(skillCount)].value; break;
                case PlayerData.UP+PlayerData.FREEZE+skillCount: DataController.playerData.freezeLength = _spellsUpdates[skillKey+(skillCount)].value; break;
                case PlayerData.UP+PlayerData.MINE+skillCount: DataController.playerData.mineDamage = _spellsUpdates[skillKey+(skillCount)].value; break;
            }
//            trace("action update : " + action.name);
            SoundManager.playSound(SoundManager.SPELL_UP, 0.6);
            updateView();
        }
        else
        {
            PopupController.showPopup(PopupController.NOT_ENOUGH_MONEY_POPUP);
        }
    }

    /* UPDATE SPELL ANIMATION */
    private var _particleSettings:Object = {lifeSpan:1000, mass:5, alphaMin:1, alphaMax:0, speedY:1, velocityXMin:-0.5, velocityXMax:0.5, velocityYMin:0.5, velocityYMax:1, scaleMax:2, scaleMin:1.5};
    private function updateSpellAnimation(action:Action):void
    {
        var color:uint = action.color;
        var particleEffectFilters:Object = [new GravityFilter(-1.3), new ScaleFilter(0.95), new WanderFilter(0.5, 0.5), new ColorFilter(color)];
        var o:Orion = new Orion(TreasureParticleMc, new BurstOutput(20, false), {settings:_particleSettings, effectFilters:particleEffectFilters, useCacheAsBitmap:true}, true);
        o.canvas = new Rectangle(0, 0, 10, 25);
        o.x = _view[action.name].x;
        o.y =  _view[action.name].y;
        o.width =  _view[action.name].width;
        o.height =  _view[action.name].height;
        _view.addChild(o);
    }

    /* ENOUGH MONEY */
    private function enoughMoney(action:Action):Boolean
    {
        return DataController.playerData.currentCoinsAmount >= action.cost;
    }

    /* DEACTIVATE */
    public override function deactivate():void
    {
        trace("TAB ACADEMY : deactivated");
        for each(var gradPanel:GradualPanel in _gradualPanels)
        {
            gradPanel.deactivate();
        }

        for each(var action:Action in _spellsUpdates)
        {
            action.deactivate();
        }

    }

    /* SELECTED ITEM NAME */
    public override function get selectedItemName():String
    {
        return null;
    }

    /* UPDATE VIEW */
    public override function updateView():void
    {
        if(DataController.playerData.isNeedToShowTabAcademyTutorial)
        {
            DataController.playerData.isNeedToShowTabAcademyTutorial = false;
            PopupController.showPopup(PopupController.TAB_ACADEMY_POPUP)
        }
        for each(var gradPanel:GradualPanel in _gradualPanels)
        {
            gradPanel.updateView();
        }
    }
}
}
