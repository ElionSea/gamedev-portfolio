/**
 * Created by Sith on 13.08.14.
 */
package gui.guild
{
import custom.CustomCursor;

import data.DataController;
import data.PlayerData;

import flash.display.MovieClip;

import flash.display.SimpleButton;

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.text.TextField;

import gui.guild.staff.ICrystall;
import gui.guild.staff.StaffCrystallSlot;

import gui.inventory.Cell;
import gui.inventory.IItem;

import gui.inventory.IItem;
import gui.inventory.IRune;

import gui.inventory.Inventory;

import popup.PopupController;

import sound.SoundManager;

import utils.ShiftingTextField;

import utils.ShiftingTextField;

/* вкладка "Посох" */
public class TabStaff extends ATab
{
    private var _staffInventory:Inventory;
    private var _userInventory:Inventory;
    private var _crystallSlot:Inventory;

    private var _selectedItem:IItem;
    private var _selectedCell:Cell;
    private var _selector:McSelector;

    public static const ID_STAFF:int = 1;
    public static const ID_USER:int = 2;

    private var _installBtn:SimpleButton;
    private var _removeBtn:SimpleButton;

    // staff fx's
    private var _tf_Amount:ShiftingTextField;
    private var _tf_Damage:ShiftingTextField;
    private var _tf_Speed:ShiftingTextField;
    private var _tf_Poison:ShiftingTextField;
    private var _tf_Slowing:ShiftingTextField;

    private var _changeCursorClip:MovieClip;
    private var _changeCursorUp:SimpleButton;
    private var _changeCursorDown:SimpleButton;

    /*CONSTRUCTOR*/
    public function TabStaff(name:String, view:Sprite, playerData:PlayerData)
    {
        super(name, view, playerData);

        init();
    }

    /* INIT */
    private function init():void
    {
        // init selector
        _selector = new McSelector();
        _view.addChild(_selector);
        _selector.visible = false;

        // init buttons
        _installBtn = _view["btnInstall"];
        _installBtn.visible = false;
        _installBtn.addEventListener(MouseEvent.CLICK, install);
        _removeBtn = _view["btnRemove"];
        _removeBtn.visible = false;
        _removeBtn.addEventListener(MouseEvent.CLICK, remove);

        // init inventories
        _userInventory = new Inventory(ID_USER, view["userInventory"], DataController.playerData.userItems, getItem, IItem);
        _staffInventory = new Inventory(ID_STAFF, view["staffInventory"], DataController.playerData.staffRunes, getItem, IRune, DataController.playerData.staff.amountSlots);
        _staffInventory.hideNonAvalCells();

        // init staff tf's
        _tf_Amount = new ShiftingTextField(_view["tf_Amount"]);
        _tf_Damage = new ShiftingTextField(_view["tf_Damage"]);
        _tf_Speed = new ShiftingTextField(_view["tf_Speed"], true, true);
        _tf_Poison = new ShiftingTextField(_view["tf_Poison"]);
        _tf_Slowing = new ShiftingTextField(_view["tf_Slowing"], true, true);

        // init crystallSlot
        _crystallSlot = new Inventory(ID_STAFF, _view["crystallSlot"], DataController.playerData.staff.staffCrystall, tempFunc, ICrystall, 1);

        // init change cursor
        _changeCursorClip = _view["changeCursor"];
        changeCursor();

        _changeCursorUp = _view["cursor_up"];
        _changeCursorUp.addEventListener(MouseEvent.CLICK, changeCursor);
        _changeCursorDown = _view["cursor_down"];
        _changeCursorDown.addEventListener(MouseEvent.CLICK, changeCursor);

    }

    /* CHANGE CURSOR */
    private function changeCursor(e:MouseEvent=null):void
    {
        var cur:int = CustomCursor.shootCursors.indexOf(CustomCursor._currentShootCursor);

        if(e)
        {
            if(e.target.name == "cursor_up")
            {
                if(cur == CustomCursor.shootCursors.length-1)
                {
                    cur = 0;
                }
                else
                {
                    cur++;
                }

            }
            else if(e.target.name == "cursor_down")
            {
                if(cur == 0)
                {
                    cur = CustomCursor.shootCursors.length-1;
                }
                else
                {
                    cur--;
                }
            }
            CustomCursor._currentShootCursor = CustomCursor.shootCursors[cur];
        }
        _changeCursorClip.gotoAndStop(cur+1);
    }

    private function tempFunc(cell:Cell):void{}

    /* GET ITEM */
    private function getItem(cell:Cell):void
    {
        // если ячейка с содержимым
        if(cell.content)
        {
            SoundManager.playSound(SoundManager.SELECT_ITEM, 0.8);
            if(cell.content is IRune)
            {
                _selectedItem = cell.content;
                _selectedCell = cell;
                var pnt:Point = new Point(cell.view.x, cell.view.y);
                _selector.x = pnt.x + _selectedItem.view.parent.parent.x;
                _selector.y = pnt.y + _selectedItem.view.parent.parent.y;
                _selector.visible = true;
                if(cell.id == ID_USER)
                {
                    if(_staffInventory.getEmptyCell() > -1) _installBtn.visible = true;
                    _removeBtn.visible = false;
                }
                else if(cell.id == ID_STAFF)
                {
                    if(_userInventory.getEmptyCell() > -1) _installBtn.visible = false;
                    _removeBtn.visible = true;
                }
            }
            else if(cell.content is ICrystall)
            {
                if(cell.id == ID_USER)
                {
                    _selectedItem = cell.content;
                    _selectedCell = cell;
                    var pnt2:Point = new Point(cell.view.x, cell.view.y);
                    _selector.x = pnt2.x + _selectedItem.view.parent.parent.x;
                    _selector.y = pnt2.y + _selectedItem.view.parent.parent.y;
                    _selector.visible = true;
                    _installBtn.visible = true;
                    _removeBtn.visible = false;
                }
            }
        }
        else
        {
            _selectedCell = null;
            _selectedItem = null;
            _selector.visible = false;
            _installBtn.visible = false;
            _removeBtn.visible = false;
        }
    }

    /* REMOVE */
    private function remove(e:MouseEvent):void
    {
        // если есть место в инвентаре игрока
        if(_userInventory.getEmptyCell() > -1)
        {
            SoundManager.playSound(SoundManager.INSTALL_RUNE, 0.8);
            _selector.visible = false;
            _installBtn.visible = false;
            _removeBtn.visible = false;
            var userIndex:int = _userInventory.getEmptyCell();
            _userInventory.addItem(userIndex, _selectedCell.content);
            _staffInventory.removeItem(_selectedCell.count, false);
            updateStaffInfo();
        }
        else
        {
            trace("not enough space");
        }
    }

    /* INSTALL */
    private function install(e:MouseEvent):void
    {
        if(_selectedItem is ICrystall)
        {
            SoundManager.playSound(SoundManager.INSTALL_CRYSTALL, 1.1);
            _selector.visible = false;
            _installBtn.visible = false;
            _removeBtn.visible = false;
            var tempItem:IItem;
            tempItem = _crystallSlot.contents[0];
            _crystallSlot.removeItem(0);

            _crystallSlot.addItem(0, _selectedCell.content);
            var crystallSlot:Vector.<IItem> = new Vector.<IItem>();
            crystallSlot.push(_selectedCell.content);
            DataController.playerData.staff.staffCrystall = crystallSlot;
            _userInventory.addItem(_selectedCell.count, tempItem);
            // TODO: install sound
            updateStaffInfo();
        }
        else
        {
            // если есть место для установки
            if(_staffInventory.getEmptyCell() > -1)
            {
                SoundManager.playSound(SoundManager.INSTALL_RUNE, 0.8);
                _selector.visible = false;
                _installBtn.visible = false;
                _removeBtn.visible = false;
                var staffIndex:int = _staffInventory.getEmptyCell();
                _staffInventory.addItem(staffIndex, _selectedCell.content);
                _userInventory.removeItem(_selectedCell.count, false);
                updateStaffInfo();
            }
            else
            {
                trace("not enough space");
            }
        }
    }

    /* UPDATE VIEW */
    public override function updateView():void
    {
        if(DataController.playerData.isNeedToShowTabStaffTutorial)
        {
            DataController.playerData.isNeedToShowTabStaffTutorial = false;
            PopupController.showPopup(PopupController.TAB_STAFF_POPUP)
        }
        _crystallSlot.updateView();
        _userInventory.updateView();
        _staffInventory.amountCells = DataController.playerData.staff.amountSlots;
        _staffInventory.updateView();
        updateStaffInfo();
    }

    /* UPDATE STAFF INFO */
    private function updateStaffInfo():void
    {
        var staff:Staff = DataController.playerData.staff;
        staff.updateProperties();
        _tf_Amount.tweenNumbers(staff.shellSize);
        _tf_Damage.tweenNumbers(staff.damage);
        _tf_Poison.tweenNumbers(staff.poison);
        _tf_Slowing.tweenNumbers(staff.slowing * 10);
        _tf_Speed.tweenNumbers(staff.speed);
    }

    /* DESELECT */
    public override function deselect():void
    {
        _selectedCell = null;
        _selectedItem = null;
        _selector.visible = false;
        _installBtn.visible = false;
        _removeBtn.visible = false;
    }

    /* SELECTED ITEM NAME */
    public override function get selectedItemName():String
    {
        if(_selectedItem) return _selectedItem.viewName
        else                return null;
    }

    /* DEACTIVATE */
    public override function deactivate():void
    {
//        trace("TAB STAFF : deactivated");
        _installBtn.removeEventListener(MouseEvent.CLICK, install);
        _removeBtn.removeEventListener(MouseEvent.CLICK, remove);
        deselect();
        _userInventory.deactivate();
        _staffInventory.deactivate();
        _crystallSlot.deactivate();
    }
}
}
