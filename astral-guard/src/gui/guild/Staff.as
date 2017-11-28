/**
 * Created by Sith on 26.09.14.
 */
package gui.guild
{
import data.AchievementsData;
import data.DataController;

import gui.guild.staff.ICrystall;
import gui.inventory.IItem;
import gui.inventory.IRune;

import levelStuff.treasures.TList;

public class Staff
{
    private var _staffRunes:Vector.<IItem>;
    private var _staffCrystall:Vector.<IItem>;

    // properties
    private var _shellSize:int = 1; // CASTLE
//    private var _shellSize:int = 2; // SWAMP
//    private var _shellSize:int = 3; // DESERT
//    private var _shellSize:int = 4; // INNER
//    private var _shellSize:int = 5; // ICEWORLD
    private const AMOUNTS_SHELLS_DEFAULT:int = 1;
    private var _damage:int;
    private const DAMAGE_DEFAULT:int = 5;
    private var _speed:Number;
    private const SPEED_DEFAULT:int = 2;
    private var _poison:int;
    private const POISON_DEFAULT:int = 0;
    private var _slowing:Number;
    private const SLOWING_DEFAULT:int = 0;
    private var _amountSlots:int = 3;
    private var _shellColor:int;
    private var _shootCost:int;
    private const DEFAULT_COST:int = 5;

    /*CONSTRUCTOR*/
    public function Staff(staffRunes:Vector.<IItem>, staffCrystall:Vector.<IItem>)
    {
        _staffRunes = staffRunes;
        _staffCrystall = staffCrystall;

        updateProperties();
    }

    /* UPDATE PROPERTIES */
    public function updateProperties():void
    {
        var costForOneShell:int = 0; // стоимость выстрела одного из снарядов
        _damage = DAMAGE_DEFAULT;
        _slowing = SLOWING_DEFAULT;
        _poison = POISON_DEFAULT;
        _speed = SPEED_DEFAULT;
        costForOneShell += DEFAULT_COST;
        _shellColor = TList.treasureList[_staffCrystall[0].viewName].value;
        if(_staffRunes.length == 5) DataController.achievementsData.updateAchievement(AchievementsData.STAFF_BOOSTER);
        for each(var item:IItem in _staffRunes)
        {
            if(item is IRune)
            {
                     if(item.viewName.indexOf(TList.SHI_) == 0)       _damage += item.value;
                else if(item.viewName.indexOf(TList.GEN_) == 0)       _slowing += item.value;
                else if(item.viewName.indexOf(TList.DOCU_) == 0)       _poison += item.value;
                else if(item.viewName.indexOf(TList.TUR_) == 0)     _speed += item.value;
                costForOneShell += DEFAULT_COST; // каждая руна увеличивает стоимость выстрела на DEFAULT COST
            }
        }
        _shootCost =  costForOneShell/* * _amountShells*/;
//        trace("STAFF : shoot cost " + _shootCost);
    }

    public function get amountSlots():int {return _amountSlots;}
    public function set amountSlots(value:int):void {_amountSlots = value;}

    public function get shellSize():int {return _shellSize;}

    public function set shellSize(value:int):void
    {
        if(value > 5) value=5;
        _shellSize = value;
    }

    public function get damage():int {return _damage;}

    public function get speed():Number {return _speed;}

    public function get poison():int {return _poison;}

    public function get slowing():Number {return _slowing;}

    public function get staffCrystall():Vector.<IItem> {return _staffCrystall;}

    public function set staffCrystall(value:Vector.<IItem>):void{_staffCrystall = value;}

    public function get shellColor():int {return _shellColor;}

    public function get shootCost():int {return _shootCost;}
}
}
