/**
 * Created by Sith on 29.08.14.
 */
package gui
{
import custom.CustomCursor;

import cv.Orion;
import cv.orion.filters.ColorFilter;
import cv.orion.filters.GravityFilter;
import cv.orion.filters.ScaleFilter;
import cv.orion.filters.WanderFilter;
import cv.orion.output.BurstOutput;

import data.PlayerData;

import flash.display.MovieClip;

import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.ui.Mouse;

import sound.SoundManager;

/* панель развития абстрактного навыка */
public class GradualPanel
{
    private var _view:McGradPanelView;
    private var _mainView:Sprite;

    private var _updateButton:SimpleButton;
    private var _lineSectors:Vector.<McLineSector>;

    private var _updateSkill:Skill;
    private var _avalUpdates:Array;
    private var _avalUpdatesCosts:Array;

    private var _currentSkillIndex:int;
    private var _nextSkillIndex:int;

    private var _playerData:PlayerData;

    private var _updateTabViewCallback:Function;

    /*CONSTRUCTOR*/
    public function GradualPanel(view:McGradPanelView, updateSkill:Skill, avalUpdates:Array, avalUpdatesCosts:Array, playerData:PlayerData, upgradeButton:SimpleButton, mainView:Sprite, updateTabViewCallback:Function)
    {
        _updateButton = upgradeButton;
        _view = view;
        _updateTabViewCallback = updateTabViewCallback;

        _lineSectors = new Vector.<McLineSector>();
        for (var i:int = 1; i <= avalUpdates.length; i++)
        {
            var lineSector:McLineSector = _view["lineSec_" + i];
            _lineSectors.push(lineSector);
        }

        _updateSkill = updateSkill;
        _avalUpdates = avalUpdates;
        _avalUpdatesCosts = avalUpdatesCosts;
        _playerData = playerData;

        _currentSkillIndex = _avalUpdates.indexOf(updateSkill.value);
        _nextSkillIndex = _currentSkillIndex+1;
        _mainView = mainView;

        _updateTabViewCallback();
    }

    /* MOUSE CLICK */
    private function mouseClick(e:MouseEvent):void
    {
        // если есть возможность повышения
        if(_nextSkillIndex < _avalUpdates.length)
        {
            // если достаточно денег для повышения
            if(_avalUpdatesCosts[_nextSkillIndex-1] <= _playerData.currentCoinsAmount)
            {
//                trace("index : " + _nextSkillIndex);
                SoundManager.playSound(SoundManager.SKILL_UP+_nextSkillIndex);
                _updateSkill.value = _avalUpdates[_nextSkillIndex];
                _playerData.currentCoinsAmount -= _avalUpdatesCosts[_currentSkillIndex];
                _currentSkillIndex = _nextSkillIndex;
                _nextSkillIndex++;
                animateUpdate(_lineSectors[_nextSkillIndex-1].x + _view.x, _lineSectors[_nextSkillIndex-1].y + + _view.y);
            }
        }
        _updateTabViewCallback();
    }

    /* ANIMATE UPDATE */
    private var _particleSettings:Object = {lifeSpan:1000, mass:5, alphaMin:1, alphaMax:0, speedY:1, velocityXMin:-0.5, velocityXMax:0.5, velocityYMin:0.5, velocityYMax:1, scaleMax:2, scaleMin:1.5};
    private function animateUpdate(x:Number, y:Number):void
    {
        var color:uint = 0x00EF92;
        var particleEffectFilters:Object = [new GravityFilter(-1.3), new ScaleFilter(0.95), new WanderFilter(0.5, 0.5), new ColorFilter(color)];
        var o:Orion = new Orion(TreasureParticleMc, new BurstOutput(15, false), {settings:_particleSettings, effectFilters:particleEffectFilters, useCacheAsBitmap:true}, true);
        o.canvas = new Rectangle(0, 0, 10, 25);
        o.x = x;
        o.y = y;
        o.width =  10;
        o.height =  15;
        _mainView.addChild(o);
    }

    /* UPDATE VIEW */
    public function updateView():void
    {
        for (var i:int = 0; i < _lineSectors.length; i++)
        {
            if(i > _currentSkillIndex) _lineSectors[i].gotoAndStop(2);
            else                       _lineSectors[i].gotoAndStop(1);
        }

        // если есть возможность повышения
        if(_nextSkillIndex < _avalUpdates.length)
        {
            // если достаточно денег для повышения
            if(_avalUpdatesCosts[_nextSkillIndex-1] <=  _playerData.currentCoinsAmount)
            {
                updateUpgradeButton(ACTIVE);
            }
            else
            {
                updateUpgradeButton(DEACTIVE);
            }
        }
        // скилл полностью прокачан
        else
        {
            updateUpgradeButton(NONE);
        }
    }

    /* UPDATE UPGRADE BUTTON */
    private const ACTIVE:String = "active";
    private const DEACTIVE:String = "deactive";
    private const NONE:String = "none";
    private function updateUpgradeButton(isActivate:String):void
    {
        switch (isActivate)
        {
            case ACTIVE:
                    _updateButton.enabled = true;
                    _updateButton.visible = true;
                    _updateButton.alpha = 1;
                    if(!_updateButton.hasEventListener(MouseEvent.CLICK))       _updateButton.addEventListener(MouseEvent.CLICK, mouseClick);
                break;
            case DEACTIVE:
                    CustomCursor.changeCursor(CustomCursor.ARROW_CURSOR);
                    _updateButton.enabled = false;
                    _updateButton.visible = true;
                    _updateButton.alpha = 0.5;
                    if(_updateButton.hasEventListener(MouseEvent.CLICK))       _updateButton.removeEventListener(MouseEvent.CLICK, mouseClick);
                break;
            case NONE:
                    CustomCursor.changeCursor(CustomCursor.ARROW_CURSOR);
                    _updateButton.enabled = false;
                    _updateButton.visible = false;
                    _updateButton.alpha = 0;
                    if(_updateButton.hasEventListener(MouseEvent.CLICK))       _updateButton.removeEventListener(MouseEvent.CLICK, mouseClick);
                break;
        }
    }

    /* DEACTIVATE */
    public function deactivate():void
    {
        if(_updateButton.hasEventListener(MouseEvent.CLICK)) _updateButton.removeEventListener(MouseEvent.CLICK, mouseClick);
    }


}
}
