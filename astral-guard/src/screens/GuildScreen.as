/**
 * Created by Sith on 01.08.14.
 */
package screens
{
import custom.CustomCursor;

import data.DataController;
import data.IController;
import data.LevelData;

import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.ui.Mouse;

import gui.InfoPanel;
import gui.guild.ITab;
import gui.guild.TabAcademy;
import gui.guild.TabStaff;
import gui.guild.TabStore;
import gui.inventory.IItem;

import compositepPattern.IMainController;

import sound.SoundManager;

/* скрин гильдии */
public class
GuildScreen extends AScreen implements IController
{
    private var _tabAcademy:TabAcademy;
    private var _tabStore:TabStore;
    private var _tabStaff:TabStaff;
    private var _currentTab:ITab;

    private var _tabs:Vector.<ITab> = new Vector.<ITab>();
    private var _tabAcademyTrigger:SimpleButton;
    private var _tabStoreTrigger:SimpleButton;
    private var _tabStaffTrigger:SimpleButton;
    private var _playLevelBtn:SimpleButton;

    private var _storeAttention:McAtention;
    private var _academyAttention:McAtention;

    private static const TAB_ACADEMY:String = "tabAcademy";
    private static const TAB_STAFF:String = "tabStaff";
    private static const TAB_STORE:String = "tabStore";

    private var _tfCoinsAmount:TextField;

    private var _infoPanel:InfoPanel;

    /*CONSTRUCTOR*/
    public function GuildScreen(screenName:String, view:MovieClip, isShowingMouseCursor:Boolean=true)
    {
        super(screenName, view, null, isShowingMouseCursor);

        _storeAttention = new McAtention();
        _academyAttention = new McAtention();

        _view.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
    }

    /* UPDATE VIEW */
    public function addedToStage(e:Event):void
    {
        init();
        // TODO: Не забыть добавить слушатель добавления на сцену назад при деактивации скрина
//        _view.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
        _view.addEventListener(MouseEvent.MOUSE_MOVE, update);
        _view.addEventListener(MouseEvent.CLICK, update);

        SoundManager.playSound(SoundManager.MUSIC_MARKET, 0.7, 0, 3);
    }

    /* INIT */
    private function init():void
    {
        DataController.playerData.initController(this);
        // init elements
        _tfCoinsAmount = _view["txtCoinsAmount"];
        _tfCoinsAmount.text = DataController.playerData.currentCoinsAmount.toString();

        // init tabs
        _tabAcademy = new TabAcademy(TAB_ACADEMY, _view["tabAcademy"], DataController.playerData);
        _tabStaff = new TabStaff(TAB_STAFF, _view["tabStaff"], DataController.playerData);
        _tabStore = new TabStore(TAB_STORE, _view["tabStore"], DataController.playerData);
        _tabs.push(_tabAcademy);
        _tabs.push(_tabStaff);
        _tabs.push(_tabStore);
        _tabAcademyTrigger = _view["btnAcademy"];
        _tabAcademyTrigger.addEventListener(MouseEvent.CLICK, tabTriggerClick);
        _tabStoreTrigger = _view["btnStore"];
        _tabStoreTrigger.addEventListener(MouseEvent.CLICK, tabTriggerClick);
        _tabStaffTrigger = _view["btnStaff"];
        _tabStaffTrigger.addEventListener(MouseEvent.CLICK, tabTriggerClick);
        showTab(TAB_ACADEMY); // show tab academy by default

        _playLevelBtn = _view["btnPlayLevel"];
        _playLevelBtn.addEventListener(MouseEvent.CLICK, playLevel);

        _infoPanel = new InfoPanel(_view["infoPanel"], DataController.playerData);

        _storeAttention.x = _tabStoreTrigger.x + _tabStoreTrigger.width;
        _storeAttention.y = _tabStoreTrigger.y;
        _view.addChild(_storeAttention);
        _storeAttention.visible = false;

        _academyAttention.x = _tabAcademyTrigger.x + _tabAcademyTrigger.width;
        _academyAttention.y = _tabAcademyTrigger.y;
        _view.addChild(_academyAttention);
        _academyAttention.visible = false;

        updateAttention();
    }

    private function updateAttention():void
    {
        _storeAttention.visible = DataController.gameData.isCanBuySomething();
        _academyAttention.visible = (DataController.playerData.isCanUpdateSomeMagicSkill() || DataController.playerData.isCanUpdateSomeSkill());
    }

    /* PLAY LEVEL */
    private function playLevel(e:MouseEvent):void
    {
        SoundManager.playSound(SoundManager.TELEPORT_TO_LEVEL, 0.6);
//        if(LevelData.currentLevel < 14)
//        {
            ScreenManager.show(ScreenManager.MAP_SCREEN);
//        }
//        else
//        {
//            ScreenManager.show(ScreenManager.BLOCK_SCREEN);
//        }
    }

    /* TAB TRIGGER CLICK */
    private function tabTriggerClick(e:MouseEvent):void
    {
        switch (e.target.name)
        {
            case "btnAcademy":showTab(TAB_ACADEMY);break;
            case "btnStore":showTab(TAB_STORE);break;
            case "btnStaff":showTab(TAB_STAFF);break;
        }
        SoundManager.playSound(SoundManager.CHANGE_TAB, 1.2);
    }

    /* SHOW TAB */
    private function showTab(tabName:String):void
    {
        for each(var tab:ITab in _tabs)
        {
            tab.view.visible = (tab.name == tabName);
            if(tab.view.visible)
            {
                tab.updateView();
                _currentTab = tab;
            }
            else                 tab.deselect();
        }
    }

    /* UPDATE INFO PANEL */
    private function update(e:MouseEvent):void
    {
        // update info panel

        // if null show object - show selected
        if(!_infoPanel.showInfo(e.target.name))
        {
            if(_currentTab.selectedItemName != null)
            {
                _infoPanel.showInfo(_currentTab.selectedItemName);
            }
        }
        else
        {
            _infoPanel.showInfo(e.target.name);
        }

        // update mouse cursor
        if(e.target is SimpleButton || e.target is McRune || e.target is McScroll || e.target is McStaffSlot || e.target is McCrystall ||e.target.name.indexOf("up_") == 0 || e.target is McMagnet)
        {
            if(Mouse.cursor != CustomCursor.HAND_CURSOR)
            {
                CustomCursor.changeCursor(CustomCursor.HAND_CURSOR);
            }
        }
        else
        {
            if(Mouse.cursor != CustomCursor.ARROW_CURSOR)
            {
                CustomCursor.changeCursor(CustomCursor.ARROW_CURSOR);
            }
        }
    }

    /* UPDATE VIEW */
    public function updateView(obj:Object):void
    {
        if(obj.curCoins != null) _tfCoinsAmount.text = DataController.playerData.currentCoinsAmount.toString();

        updateAttention();
    }

    /* DEACTIVATE */
    public override function deactivate():void
    {
        _view.removeEventListener(MouseEvent.MOUSE_MOVE, update);
        _view.removeEventListener(MouseEvent.CLICK, update);
        _tabAcademyTrigger.removeEventListener(MouseEvent.CLICK, tabTriggerClick);
        _tabStoreTrigger.removeEventListener(MouseEvent.CLICK, tabTriggerClick);
        _tabStaffTrigger.removeEventListener(MouseEvent.CLICK, tabTriggerClick);
        _playLevelBtn.removeEventListener(MouseEvent.CLICK, playLevel);
        for each(var tab:ITab in _tabs)
        {
            tab.deactivate();
        }
        SoundManager.fadeSound(SoundManager.MUSIC_MARKET, 0, 0.5);
    }

    public function dispatchDeath():void{}

}
}
