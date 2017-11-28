/**
 * Created by Sith on 30.08.14.
 */
package gui
{
import data.DataController;
import data.PlayerData;

import flash.text.TextField;

import levelStuff.treasures.TList;

import locale.InfoNode;
import locale.Locale;

/* информационная панель, описывающая все элементы */
public class
InfoPanel
{
    private var _view:McInfoPanel;
    private var _tfCaption:TextField;
    private var _tfDesc:TextField;
    private var _tfCost:TextField;

    private var _playerData:PlayerData;

    public static const TAB_ACADEMY:String = "tabAcademy";
    public static const TAB_STORE:String = "tabStore";
    public static const TAB_STAFF:String = "tabStaff";
    public static const RUNS:String = "runs";
    public static const ICONS:String = "icons";
    public static const STAFF_ICONS:String = "staffIcons";
    public static const OTHER_ICONS:String = "otherIcons";
    public static const SPELLS:String = "spells";
    public static const OTHER:String = "other";
    public static const INCREASES:String = "increases";
    public static const CAPTION:String = "caption";
    public static const DESC:String = "description";
    public static const COST:String = "cost";
    public static const COINS:String = "coins";

    /*CONSTRUCTOR*/
    public function InfoPanel(view:McInfoPanel, playerData:PlayerData)
    {
        _view = view;
        _tfCaption = _view.tfCaption;
        _tfDesc = _view.tfDesc;
        _tfCost = _view.tfCost;
        _playerData = playerData;
    }

    /* SHOW INFO */
    public function showInfo(targetName:String):Boolean
    {
        var getInfo:InfoNode;
        var keys:Array;
        // init locale keys
        if(targetName.indexOf("icon") == 0)
        {
            keys = [TAB_ACADEMY, ICONS, targetName];
        }
        else if(targetName.indexOf("upBtn") == 0)
        {
            keys = [TAB_ACADEMY, INCREASES, targetName.substr(6, targetName.length-6)];
        }
        else if(targetName.indexOf("rune") == 0)
        {
            keys = [TAB_STORE, RUNS, targetName.substr(4, targetName.length-4)];
        }
        else if(targetName.indexOf("staffSlot_") == 0)
        {
            keys = [TAB_STORE, OTHER, targetName];
        }
        else if(targetName.indexOf("crystall_") == 0)
        {
            keys = [TAB_STORE, OTHER, targetName];
        }
        else if(targetName.indexOf("magnet_") == 0)
        {
            keys = [TAB_STORE, OTHER, targetName];
        }
        else if(targetName.indexOf("staffInfo_") == 0)
        {
            keys = [TAB_STAFF, STAFF_ICONS, targetName];
        }
        else if(targetName.indexOf("coinIcon") == 0)
        {
            keys = [TAB_STORE, COINS, targetName];
        }
        else if(targetName.indexOf("btnPlayLevel") == 0)
        {
            keys = [TAB_STORE, OTHER_ICONS, targetName];
        }
        // прокачка заклинаний
        else if(targetName.indexOf("up_") == 0)
        {
            keys = [TAB_ACADEMY, SPELLS, targetName.substr(0, targetName.length-1)];
        }

        if(keys)
        {
            if(keys[0] == TAB_ACADEMY)
            {
                if(keys[1] == ICONS)
                {
                    getInfo = Locale.getGuildScreenInfo(keys);
                    _tfCaption.text = getInfo.caption;
                    _tfDesc.text = getInfo.description;
                }
                else if(keys[1] ==  INCREASES)
                {
                    getInfo = Locale.getGuildScreenInfo(keys);
                    _tfCaption.text = getInfo.caption;
                    var current:int;
                    var next:int = 0;
                    switch (keys[2])
                    {
                        case "manaRecovery":
                                current = _playerData.avalManaRecovery.indexOf(_playerData.manaRecovery);
                                if(current < _playerData.avalManaRecovery.length-1) next = current+1;
                                _tfDesc.text = "Current : " + _playerData.manaRecovery;
                                if(next < _playerData.avalManaRecovery.length && (_playerData.avalManaRecovery.indexOf(_playerData.avalManaRecovery[next]) != 0))
                                {
                                    _tfDesc.text += "\n Next : " + _playerData.avalManaRecovery[next] + ". ";
                                    _tfCost.text = _playerData.avalManaRecoveryCost[next-1];
                                }
                            break;
                        case "healthRecovery":
                            current = _playerData.avalHealthRecovery.indexOf(_playerData.healthRecovery);
                            if(current < _playerData.avalHealthRecovery.length-1) next = current+1;
                            _tfDesc.text = "Current : " + _playerData.healthRecovery;
                            if(next < _playerData.avalHealthRecovery.length && (_playerData.avalHealthRecovery.indexOf(_playerData.avalHealthRecovery[next]) != 0))
                            {
                                _tfDesc.text += "\n Next : " + _playerData.avalHealthRecovery[next] + ". ";
                                _tfCost.text = _playerData.avalHealthRecoveryCost[next-1];
                            }
                            break;
                        case "manaAmount":
                            current = _playerData.avalManaIncreaces.indexOf(_playerData.totalMana);
                            if(current < _playerData.avalManaIncreaces.length-1) next = current+1;
                            _tfDesc.text = "Current " + _playerData.totalMana;
                            if(next < _playerData.avalManaIncreaces.length && (_playerData.avalManaIncreaces.indexOf(_playerData.avalManaIncreaces[next]) != 0))
                            {
                                _tfDesc.text += "\n Next : " + _playerData.avalManaIncreaces[next]  + ". ";
                                _tfCost.text = _playerData.avalManaIncreacesCost[next-1];
                            }
                            break;
                        case "healthAmount":
                            current = _playerData.avalHealthIncreaces.indexOf(_playerData.totalHealth);
                            if(current < _playerData.avalHealthIncreaces.length-1) next = current+1;
                            _tfDesc.text = "Current : " + _playerData.totalHealth;
                            if(next < _playerData.avalHealthIncreaces.length  && (_playerData.avalHealthIncreaces.indexOf(_playerData.avalHealthIncreaces[next]) != 0))
                            {
                                _tfDesc.text += "\n Next : " + _playerData.avalHealthIncreaces[next] + ". ";
                                _tfCost.text = _playerData.avalHealthIncreacesCost[next-1];
                            }
                            break;

                    }

                }
                else if(keys[1] == SPELLS)
                {
                    getInfo = Locale.getGuildScreenInfo(keys);
                    var level:String;
                    var index:int = int(targetName.charAt(targetName.length-1));
                    switch (index)
                    {
                        case 1: level = "I"; break;
                        case 2: level = "II"; break;
                        case 3: level = "III"; break;
                    }
                    _tfCaption.text = getInfo.caption + level;
                    _tfDesc.text = getInfo.description + DataController.playerData.spellsUpdates[targetName].value.toString();
                    _tfCost.text = DataController.playerData.spellsUpdates[targetName].cost.toString();
                }
            }
            else if(keys[0] == TAB_STORE)
            {
                if(keys[1] == RUNS)
                {
                    getInfo = Locale.getGuildScreenInfo(keys);
                    _tfCaption.text = getInfo.caption;
                    var val:Number = TList.treasureList[targetName].value;
                    var traceVal:String;
                    if(val < 0)  traceVal = String(val*10);
                    else         traceVal = String(val);
                    _tfDesc.text = getInfo.description + traceVal;
                    _tfCost.text = TList.treasureList[targetName].buyCost.toString();
                }
                else if(keys[1] == OTHER)
                {
                    getInfo = Locale.getGuildScreenInfo(keys);
                    _tfCaption.text = getInfo.caption;
                    _tfDesc.text = getInfo.description;
                    _tfCost.text = TList.treasureList[targetName].buyCost.toString();
                }
                else
                {
                    getInfo = Locale.getGuildScreenInfo(keys);
                    _tfCaption.text = getInfo.caption;
                    _tfDesc.text = getInfo.description;
                }
            }
            else if(keys[0] == TAB_STAFF)
            {
                if(keys[1] == STAFF_ICONS)
                {
                    getInfo = Locale.getGuildScreenInfo(keys);
                    _tfCaption.text = getInfo.caption;
                    _tfDesc.text = getInfo.description;
                }
            }
        }
        else
        {
            _tfCaption.text = "";
            _tfDesc.text = "";
            _tfCost.text = "";
            return false;
        }
        return true;
    }
}
}
