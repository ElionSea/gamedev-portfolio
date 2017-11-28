/**
 * Created by Sith on 13.08.14.
 */
package gui.guild
{
import custom.CustomSimpleButton;

import data.DataController;
import data.PlayerData;

import flash.display.MovieClip;
import flash.display.SimpleButton;

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Point;

import gui.inventory.Cell;

import gui.inventory.IItem;

import gui.inventory.Inventory;

import gui.guild.staff.IStaffSlot;

import popup.PopupController;

import sound.SoundManager;

/* вкладка "Лавка" */
    public class TabStore extends ATab
    {
        private var _userInventory:Inventory;
        private var _storeInventory:Inventory;

        private var _selectedItem:IItem;
        private var _selectedCell:Cell;
        private var _selector:McSelector;

        public static const ID_STORE:int = 1;
        public static const ID_USER:int = 2;

        private var _sellBtn:SimpleButton;
        private var _buyBtn:SimpleButton;

        /*CONSTRUCTOR*/
        public function TabStore(name:String, view:Sprite, playerData:PlayerData)
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

            // init trade buttons
            _sellBtn = _view["btnSell"];
            _sellBtn.visible = false;
            _sellBtn.addEventListener(MouseEvent.CLICK, sell);
            _buyBtn = _view["btnBuy"];
            _buyBtn.visible = false;
            _buyBtn.addEventListener(MouseEvent.CLICK, buy);
//            _cancelBtn = _view["btnCancel"];

            // init inventories
            _userInventory = new Inventory(ID_USER, view["userInventory"], DataController.playerData.userItems, getItem, IItem, 16);
            _storeInventory = new Inventory(ID_STORE, view["storeInventory"], DataController.gameData.storeItems, getItem, IItem, 28);
        }

        /* GET ITEM */
        private function getItem(cell:Cell):void
        {
            // если ячейка с содержимым
            if(cell.content)
            {
                SoundManager.playSound(SoundManager.SELECT_ITEM, 0.8);
                _selectedItem = cell.content;
                _selectedCell = cell;
                var pnt:Point = new Point(cell.view.x, cell.view.y);
//                pnt = _guildScreen.localToGlobal(pnt);
                _selector.x = pnt.x + _selectedItem.view.parent.parent.x;
                _selector.y = pnt.y + _selectedItem.view.parent.parent.y;
                _selector.visible = true;
                if(cell.id == ID_USER)
                {
                    _sellBtn.visible = true;
                    CustomSimpleButton.updateButtonWeight(_sellBtn, cell.content.sellCost);
                    _buyBtn.visible = false;
                }
                else if(cell.id == ID_STORE)
                {
                    _sellBtn.visible = false;
                    _buyBtn.visible = true;
                    CustomSimpleButton.updateButtonWeight(_buyBtn, cell.content.buyCost);
                }
            }
            else
            {
                deselect();
            }
        }

        /* SELL */
        private function sell(e:MouseEvent):void
        {
            _selector.visible = false;
            _sellBtn.visible = false;
            _buyBtn.visible = false;
//            trace("sell item : " + _selectedCell.content.sellCost);
            DataController.playerData.currentCoinsAmount += _selectedCell.content.sellCost;
            _userInventory.removeItem(_selectedCell.count);
            DataController.playerData.userItems[DataController.playerData.userItems.indexOf(_selectedCell.content)] = null;
            SoundManager.playSound(SoundManager.MONEY);
        }

        /* BUY */
        private function buy(e:MouseEvent):void
        {
            if(DataController.playerData.currentCoinsAmount >= _selectedItem.buyCost)
            {
                _selectedCell.view.removeChild(_selectedCell.content.view);
                _selector.visible = false;
                _sellBtn.visible = false;
                _buyBtn.visible = false;
                DataController.gameData.storeItems[DataController.gameData.storeItems.indexOf(_selectedCell.content)] = null;
//                trace("buy item : " + _selectedCell.content);
                if(_selectedCell.content is IStaffSlot)
                {
                    DataController.playerData.staff.amountSlots++;
                }
                else
                {
                    _userInventory.addItem(_userInventory.getEmptyCell(), _selectedCell.content);
                }
                DataController.playerData.currentCoinsAmount -= _selectedCell.content.buyCost;
                SoundManager.playSound(SoundManager.MONEY);
            }
            // not enough money case
            else
            {
                PopupController.showPopup(PopupController.NOT_ENOUGH_MONEY_POPUP);
            }
        }

        /* UPDATE VIEW */
        public override function updateView():void
        {
            if(DataController.playerData.isNeedToShowTabStoreTutorial)
            {
                DataController.playerData.isNeedToShowTabStoreTutorial = false;
                PopupController.showPopup(PopupController.TAB_STORE_POPUP)
            }
            _userInventory.updateView();
            _storeInventory.updateView();
        }

        /* DESELECT */
        public override function deselect():void
        {
            _selectedCell = null;
            _selectedItem = null;
            _selector.visible = false;
            _sellBtn.visible = false;
            _buyBtn.visible = false;
        }

        /* SELECTED ITEM NAME */
        public override function get selectedItemName():String
        {
            if(_selectedItem) return _selectedItem.viewName;
            else                return null;
        }

        /* DEACTIVATED */
        public override function deactivate():void
        {
//            trace("TAB STORE : deacticated");
            _sellBtn.removeEventListener(MouseEvent.CLICK, sell);
            _buyBtn.removeEventListener(MouseEvent.CLICK, buy);
            deselect();
            _userInventory.deactivate();
            _storeInventory.deactivate();
        }
    }
}
