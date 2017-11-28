/**
 * Created by Sith on 31.03.14.
 */
package data
{
import gui.guild.staff.StaffCrystall;
import gui.inventory.AItem;
import gui.inventory.AMagnet;
import gui.inventory.ARune;
import gui.inventory.AScroll;
import gui.inventory.IItem;

import gui.guild.staff.StaffSlot;

import levelStuff.treasures.TList;

public class GameData implements IData
{
    private var _firstLaunch:Boolean = true;
    private var _gameEnded:Boolean;
    private var _storeItems:Vector.<IItem> = new Vector.<IItem>();

    public function GameData()
    {
//        _currentLevel = 1;
//        _currentAmbience = 1;

        _storeItems = getMarketItems(1); // CASTLE
//        _storeItems = getMarketItems(2); // SWAMP
//        _storeItems = getMarketItems(3); // DESERT
        // GAG
        // init store inventory
        /*_storeItems.push(new ARune(new McRune(), 100, TList.SHI_+"1", TList.treasureList[TList.SHI_+"1"].value));
        _storeItems.push(new ARune(new McRune(), 100, TList.SHI_+"1", TList.treasureList[TList.SHI_+"1"].value));
        _storeItems.push(new ARune(new McRune(), 100, TList.SHI_+"2", TList.treasureList[TList.SHI_+"2"].value));

        _storeItems.push(new ARune(new McRune(), 100, TList.GEN_+"1", TList.treasureList[TList.GEN_+"1"].value));
        _storeItems.push(new ARune(new McRune(), 100, TList.GEN_+"1", TList.treasureList[TList.GEN_+"1"].value));
        _storeItems.push(new ARune(new McRune(), 100, TList.GEN_+"2", TList.treasureList[TList.GEN_+"2"].value));

        _storeItems.push(new ARune(new McRune(), 100, TList.DOCU_+"1", TList.treasureList[TList.DOCU_+"1"].value));
        _storeItems.push(new ARune(new McRune(), 100, TList.DOCU_+"1", TList.treasureList[TList.DOCU_+"1"].value));
        _storeItems.push(new ARune(new McRune(), 100, TList.DOCU_+"2", TList.treasureList[TList.DOCU_+"2"].value));

        _storeItems.push(new ARune(new McRune(), 100, TList.TUR_+"1", TList.treasureList[TList.TUR_+"1"].value));
        _storeItems.push(new ARune(new McRune(), 100, TList.TUR_+"1", TList.treasureList[TList.TUR_+"1"].value));
        _storeItems.push(new ARune(new McRune(), 100, TList.TUR_+"2", TList.treasureList[TList.TUR_+"2"].value));

        _storeItems.push(new AMagnet(new McMagnet(), TList.treasureList[TList.MAGNET_1].buyCost, TList.MAGNET_1, 1));*/
//        _storeItems.push(new AMagnet(new McMagnet(), TList.treasureList[TList.MAGNET_2].buyCost, TList.MAGNET_2, 1));
//        _storeItems.push(new AMagnet(new McMagnet(), TList.treasureList[TList.MAGNET_3].buyCost, TList.MAGNET_3, 1));

//        _storeItems.push(new StaffSlot(new McStaffSlot(), TList.treasureList[TList.STAFF_SLOT_4].buyCost, TList.STAFF_SLOT_4, TList.treasureList[TList.STAFF_SLOT_4].value));
//        _storeItems.push(new StaffSlot(new McStaffSlot(), TList.treasureList[TList.STAFF_SLOT_5].buyCost, TList.STAFF_SLOT_5, TList.treasureList[TList.STAFF_SLOT_5].value));

//        _storeItems.push(new StaffCrystall(new McCrystall(), TList.treasureList[TList.CRYSTALL_1].buyCost, TList.CRYSTALL_1));
//        _storeItems.push(new StaffCrystall(new McCrystall(), TList.treasureList[TList.CRYSTALL_2].buyCost, TList.CRYSTALL_2));
//        _storeItems.push(new StaffCrystall(new McCrystall(), TList.treasureList[TList.CRYSTALL_3].buyCost, TList.CRYSTALL_3));
//        _storeItems.push(new StaffCrystall(new McCrystall(), TList.treasureList[TList.CRYSTALL_4].buyCost, TList.CRYSTALL_4));
//        _storeItems.push(new StaffCrystall(new McCrystall(), TList.treasureList[TList.CRYSTALL_5].buyCost, TList.CRYSTALL_5));
//        _storeItems.push(new StaffCrystall(new McCrystall(), TList.treasureList[TList.CRYSTALL_6].buyCost, TList.CRYSTALL_6));

    }

    /* UPDATE MARKET */
    public function updateMarket(curLevel:int):void
    {
        switch (curLevel)
        {
            case 4:
            {
                _storeItems = new Vector.<IItem>();
                _storeItems = getMarketItems(2);
                // TEST
//                DataController.playerData
            }break;
            case 8:
            {
                _storeItems = new Vector.<IItem>();
                _storeItems = getMarketItems(3);
            }break;
            case 11:
            {
                _storeItems = new Vector.<IItem>();
                _storeItems = getMarketItems(4);
            }break;
            case 15:
            {
                _storeItems = new Vector.<IItem>();
                _storeItems = getMarketItems(5);
            }break;
            case 18:
            {
                _storeItems = new Vector.<IItem>();
                _storeItems = getMarketItems(6);
            }break;
        }
    }

    /* GET NEW ITEM */
    public static function getNewItem(itemName:String):IItem
    {
        var item:IItem;
        switch (itemName)
        {
            case TList.SHI_+"1": item = new ARune(new McRune(), TList.treasureList[TList.SHI_+"1"].buyCost, TList.SHI_+"1", TList.treasureList[TList.SHI_+"1"].value); break;
            case TList.SHI_+"2": item = new ARune(new McRune(), TList.treasureList[TList.SHI_+"2"].buyCost, TList.SHI_+"2", TList.treasureList[TList.SHI_+"2"].value); break;
            case TList.SHI_+"3": item = new ARune(new McRune(), TList.treasureList[TList.SHI_+"3"].buyCost, TList.SHI_+"3", TList.treasureList[TList.SHI_+"3"].value); break;
            case TList.SHI_+"4": item = new ARune(new McRune(), TList.treasureList[TList.SHI_+"4"].buyCost, TList.SHI_+"4", TList.treasureList[TList.SHI_+"4"].value); break;
            case TList.SHI_+"5": item = new ARune(new McRune(), TList.treasureList[TList.SHI_+"5"].buyCost, TList.SHI_+"5", TList.treasureList[TList.SHI_+"5"].value); break;

            case TList.GEN_+"1": item = new ARune(new McRune(), TList.treasureList[TList.GEN_+"1"].buyCost, TList.GEN_+"1", TList.treasureList[TList.GEN_+"1"].value); break;
            case TList.GEN_+"2": item = new ARune(new McRune(), TList.treasureList[TList.GEN_+"2"].buyCost, TList.GEN_+"2", TList.treasureList[TList.GEN_+"2"].value); break;
            case TList.GEN_+"3": item = new ARune(new McRune(), TList.treasureList[TList.GEN_+"3"].buyCost, TList.GEN_+"3", TList.treasureList[TList.GEN_+"3"].value); break;
            case TList.GEN_+"4": item = new ARune(new McRune(), TList.treasureList[TList.GEN_+"4"].buyCost, TList.GEN_+"4", TList.treasureList[TList.GEN_+"4"].value); break;
            case TList.GEN_+"5": item = new ARune(new McRune(), TList.treasureList[TList.GEN_+"5"].buyCost, TList.GEN_+"5", TList.treasureList[TList.GEN_+"5"].value); break;

            case TList.DOCU_+"1": item = new ARune(new McRune(), TList.treasureList[TList.DOCU_+"1"].buyCost, TList.DOCU_+"1", TList.treasureList[TList.DOCU_+"1"].value); break;
            case TList.DOCU_+"2": item = new ARune(new McRune(), TList.treasureList[TList.DOCU_+"2"].buyCost, TList.DOCU_+"2", TList.treasureList[TList.DOCU_+"2"].value); break;
            case TList.DOCU_+"3": item = new ARune(new McRune(), TList.treasureList[TList.DOCU_+"3"].buyCost, TList.DOCU_+"3", TList.treasureList[TList.DOCU_+"3"].value); break;
            case TList.DOCU_+"4": item = new ARune(new McRune(), TList.treasureList[TList.DOCU_+"4"].buyCost, TList.DOCU_+"4", TList.treasureList[TList.DOCU_+"4"].value); break;
            case TList.DOCU_+"5": item = new ARune(new McRune(), TList.treasureList[TList.DOCU_+"5"].buyCost, TList.DOCU_+"5", TList.treasureList[TList.DOCU_+"5"].value); break;

            case TList.TUR_+"1": item = new ARune(new McRune(), TList.treasureList[TList.TUR_+"1"].buyCost, TList.TUR_+"1", TList.treasureList[TList.TUR_+"1"].value); break;
            case TList.TUR_+"2": item = new ARune(new McRune(), TList.treasureList[TList.TUR_+"2"].buyCost, TList.TUR_+"2", TList.treasureList[TList.TUR_+"2"].value); break;
            case TList.TUR_+"3": item = new ARune(new McRune(), TList.treasureList[TList.TUR_+"3"].buyCost, TList.TUR_+"3", TList.treasureList[TList.TUR_+"3"].value); break;
            case TList.TUR_+"4": item = new ARune(new McRune(), TList.treasureList[TList.TUR_+"4"].buyCost, TList.TUR_+"4", TList.treasureList[TList.TUR_+"4"].value); break;
            case TList.TUR_+"5": item = new ARune(new McRune(), TList.treasureList[TList.TUR_+"5"].buyCost, TList.TUR_+"5", TList.treasureList[TList.TUR_+"5"].value); break;

            case TList.MAGNET_1: item = new AMagnet(new McMagnet(), TList.treasureList[TList.MAGNET_1].buyCost, TList.MAGNET_1, 1); break;
            case TList.MAGNET_2: item = new AMagnet(new McMagnet(), TList.treasureList[TList.MAGNET_2].buyCost, TList.MAGNET_2, 1); break;
            case TList.MAGNET_3: item = new AMagnet(new McMagnet(), TList.treasureList[TList.MAGNET_3].buyCost, TList.MAGNET_3, 1); break;

            case TList.CRYSTALL_1: item = new StaffCrystall(new McCrystall(), TList.treasureList[TList.CRYSTALL_1].buyCost, TList.CRYSTALL_1); break;
            case TList.CRYSTALL_2: item = new StaffCrystall(new McCrystall(), TList.treasureList[TList.CRYSTALL_2].buyCost, TList.CRYSTALL_2); break;
            case TList.CRYSTALL_3: item = new StaffCrystall(new McCrystall(), TList.treasureList[TList.CRYSTALL_3].buyCost, TList.CRYSTALL_3); break;
            case TList.CRYSTALL_4: item = new StaffCrystall(new McCrystall(), TList.treasureList[TList.CRYSTALL_4].buyCost, TList.CRYSTALL_4); break;
            case TList.CRYSTALL_5: item = new StaffCrystall(new McCrystall(), TList.treasureList[TList.CRYSTALL_5].buyCost, TList.CRYSTALL_5); break;
            case TList.CRYSTALL_6: item = new StaffCrystall(new McCrystall(), TList.treasureList[TList.CRYSTALL_6].buyCost, TList.CRYSTALL_6); break;

            case TList.STAFF_SLOT_4: item = new StaffSlot(new McStaffSlot(), TList.treasureList[TList.STAFF_SLOT_4].buyCost, TList.STAFF_SLOT_4, TList.treasureList[TList.STAFF_SLOT_4].value); break;
            case TList.STAFF_SLOT_5: item = new StaffSlot(new McStaffSlot(), TList.treasureList[TList.STAFF_SLOT_5].buyCost, TList.STAFF_SLOT_5, TList.treasureList[TList.STAFF_SLOT_5].value); break;
        }
        return item;
    }

    /* GET MARKET ITEMS */
    private static var _marketItems1:Array =
            [
                TList.SHI_+"1", TList.SHI_+"2",
                TList.GEN_+"1", TList.GEN_+"2",
                TList.DOCU_+"1", TList.DOCU_+"2",
                TList.TUR_+"1", TList.TUR_+"2",
                TList.MAGNET_1/*, TList.CRYSTALL_1*/
            ];
    private static var _marketItems2:Array =
            [
                TList.SHI_+"1", TList.SHI_+"2", TList.SHI_+"3",
                TList.GEN_+"1", TList.GEN_+"2", TList.GEN_+"3",
                TList.DOCU_+"1", TList.DOCU_+"2", TList.DOCU_+"3",
                TList.TUR_+"1", TList.TUR_+"2", TList.TUR_+"3",
                TList.MAGNET_1, TList.CRYSTALL_6, TList.CRYSTALL_2
            ];
    private static var _marketItems3:Array =
            [
                TList.SHI_+"2", TList.SHI_+"3", TList.SHI_+"4",
                TList.GEN_+"2", TList.GEN_+"3", TList.GEN_+"4",
                TList.DOCU_+"2", TList.DOCU_+"3", TList.DOCU_+"4",
                TList.TUR_+"2", TList.TUR_+"3", TList.TUR_+"4",
                TList.MAGNET_2, TList.CRYSTALL_6, TList.CRYSTALL_2, TList.CRYSTALL_3,
                TList.STAFF_SLOT_4
            ];
    private static var _marketItems4:Array =
            [
                TList.SHI_+"3", TList.SHI_+"4", TList.SHI_+"5",
                TList.GEN_+"3", TList.GEN_+"4", TList.GEN_+"5",
                TList.DOCU_+"3", TList.DOCU_+"4", TList.DOCU_+"5",
                TList.TUR_+"3", TList.TUR_+"4", TList.TUR_+"5",
                TList.MAGNET_2, TList.CRYSTALL_6, TList.CRYSTALL_2, TList.CRYSTALL_3, TList.CRYSTALL_4,
                TList.STAFF_SLOT_5
            ];
    private static var _marketItems5:Array =
            [
                TList.SHI_+"4", TList.SHI_+"5",
                TList.GEN_+"4", TList.GEN_+"5",
                TList.DOCU_+"4", TList.DOCU_+"5",
                TList.TUR_+"4", TList.TUR_+"5",
                TList.MAGNET_3, TList.CRYSTALL_6, TList.CRYSTALL_2, TList.CRYSTALL_3, TList.CRYSTALL_4, TList.CRYSTALL_5
            ];
    private static var _marketItems6:Array =
            [
                TList.SHI_+"5",
                TList.GEN_+"5",
                TList.DOCU_+"5",
                TList.TUR_+"5",
                TList.MAGNET_3, TList.CRYSTALL_6, TList.CRYSTALL_2, TList.CRYSTALL_3, TList.CRYSTALL_4, TList.CRYSTALL_5, TList.CRYSTALL_1
            ];
    public static function getMarketItems(worldNum:int):Vector.<IItem>
    {
        var items:Vector.<IItem> = new Vector.<IItem>();
        switch (worldNum)
        {
            case 1: for each(var itemName1:String in _marketItems1) {items.push(getNewItem(itemName1));} break;
            case 2: for each(var itemName2:String in _marketItems2) {items.push(getNewItem(itemName2));} break;
            case 3: for each(var itemName3:String in _marketItems3) {items.push(getNewItem(itemName3));} break;
            case 4: for each(var itemName4:String in _marketItems4) {items.push(getNewItem(itemName4));} break;
            case 5: for each(var itemName5:String in _marketItems5) {items.push(getNewItem(itemName5));} break;
            case 6: for each(var itemName6:String in _marketItems6) {items.push(getNewItem(itemName6));} break;
        }
        return items;
    }

    /* IS CAN BUT SOMETHING */
    public function isCanBuySomething():Boolean
    {
        var coinsAmount:int = DataController.playerData.currentCoinsAmount;
        for each(var item:IItem in _storeItems)
        {
            if(item)
            {
                if(coinsAmount >= item.buyCost)  return true;
            }
        }
        return false;
    }

    public function get storeItems():Vector.<IItem> {return _storeItems;}
    public function set storeItems(value:Vector.<IItem>):void {_storeItems = value;}

    public function get firstLaunch():Boolean {return _firstLaunch;}
    public function set firstLaunch(value:Boolean):void {_firstLaunch = value;}

    public function get gameEnded():Boolean {return _gameEnded;}
    public function set gameEnded(value:Boolean):void {_gameEnded = value;}
}
}
