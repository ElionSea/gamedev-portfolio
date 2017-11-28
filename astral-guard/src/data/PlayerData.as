/**
 * Created by Sith on 01.04.14.
 */
package data
{
import data.PlayerData;

import flash.utils.Dictionary;

import gui.Skill;
import gui.guild.Staff;
import gui.guild.academy.Action;
import gui.guild.staff.ICrystall;
import gui.guild.staff.StaffCrystall;
import gui.inventory.ARune;
import gui.inventory.IItem;
import gui.inventory.IMagnet;
import gui.inventory.IRune;

import levelStuff.bullets.GgBullet;
import levelStuff.treasures.TList;

public class PlayerData implements IData
    {
        // туториал
        private var _isNeedToShowSpellTutPopupOnLevel:Boolean = true;
        private var _isNeedToShowControlsTutPopupOnLevel:Boolean = true;
        private var _isNeedToShowChestTutPopupOnLevel:Boolean = true;
        private var _isNeedToShowTabStoreTutorial:Boolean = true;
        private var _isNeedToShowTabAcademyTutorial:Boolean = true;
        private var _isNeedToShowTabStaffTutorial:Boolean = true;

        // посох
        private var _currentBullet:Class = GgBullet; // класс текущего снаряда у посоха

        // мана и здоровье
        private var _currentMana:int;
        private var _currentHealth:int;

        // заклинания
        private var _spellPoints:int = 100;
        public const TOTAL_SPELL_POINTS:int = 100;
//        /* gag */public const TOTAL_SPELL_POINTS:int = 1000;

        // игровые очки
        private var _gamePoints:int = 0;
        private var _tempGamePoints:int = 0;

        private var _currentCoinsAmount:int = 0; // количество собранных монет
//        private var _currentCoinsAmount:int = 880; // DESERT 730 + 150(for first any spell)
//        private var _currentCoinsAmount:int = 1000000; //

        private var _currentTempCoinsAmount:int = 0; // количество собранных монет на уровне

        /* АКАДЕМИЯ */

            /*НАВЫКИ*/

            // восполнение маны
            private var _manaRecovery:Skill = new Skill(15, checkForThePerfectionAchievement);                                        // количество маны, которая восполняется за одну секунду (стартовое значение)
            private var _avalManaRecovery:Array     = [15, 20, 25, 30, 35, 40, 45, 50];          // значения допустимые для улучшения в академии
            private var _avalManaRecoveryCost:Array = [150, 230, 450, 550, 670, 750, 850];        // стоимость улучшения этих значений

            // восполнение здоровья
            private var _healthRecovery:Skill = new Skill(3, checkForThePerfectionAchievement);                                       // количество здоровья, которое восполняется за одну секунду (стартовое значение)
            private var _avalHealthRecovery:Array       = [3, 7, 12, 18, 25, 30, 40, 55];          //  значения допустимые для улучшения в академии
            private var _avalHealthRecoveryCost:Array   = [100, 200, 400, 600, 650, 750, 800];   //  стоимость улучшения этих значений

            // увеличение шкалы маны
            private var _totalMana:Skill = new Skill(150, checkForThePerfectionAchievement);                                             // текущее значение шкалы маны
            private var _avalManaIncreaces:Array        = [150, 200, 300, 400, 550, 600, 650, 700];  // значения, допустимые для улучшения в академии
            private var _avalManaIncreacesCost:Array    = [150, 230, 450, 550, 670, 750, 850];      // стоимость улучшения этих значений

            // увеличение шкалы здоровья
            private var _totalHealth:Skill = new Skill(200, checkForThePerfectionAchievement);                                           // количество здоровья
            private var _avalHealthIncreaces:Array      = [200, 300, 400, 500, 550, 600, 650, 700];  // значения, допустимые для улучшения в академии
            private var _avalHealthIncreacesCost:Array  = [100, 200, 400, 600, 650, 750, 800];      // стоимость улучшения этих значений

        /* ИНВЕНТАРЬ */
        private var _userItems:Vector.<IItem> = new Vector.<IItem>();
        /* ПОСОХ */
        private var _staff:Staff;
        private var _staffRunes:Vector.<IItem> = new Vector.<IItem>();
        private var _staffCrystall:Vector.<IItem> = new Vector.<IItem>;


        private var _controller:IController;

    /* SPELLS */
         private var _isUpdateAnySpell:Boolean;

        private var _spellsUpdates:Dictionary;
        /* RAINBOW */
        private var _rainbowShellsAmount:int = 8; //5, 8, 12
        private var _rainbowShellDamage:int = 0; // 100, 300, 550
        /* FIST */
        private var _fistHealth:int = 0; // 100, 400, 1000
        /* CROWN */
        private var _crownShellAmount:int = 9;
        private var _crownShellDamage:int = 0;
        /* FREEEZE */
        private var _freezeLength:int = 0; // 5, 6
        /* MINE */
        private var _mineDamage:int = 0; // 100, 400, 1000
        private var _mineAmount:int = 5; // 4, 5

        public static const UP:String = "up_";
        public static const RAINBOW:String = "rainbow_";
        public static const FIST:String = "fist_";
        public static const CROWN:String = "crown_";
        public static const FREEZE:String = "freeze_";
        public static const MINE:String = "mine_";

    /* CONTROLLER */
        public function PlayerData(cotroller:IController = null)
        {
            _controller = cotroller;

            _spellsUpdates = new Dictionary();

            _spellsUpdates[UP+RAINBOW+"1"] = new Action(UP+RAINBOW+"1", 150, true, false, 0xC000FF, 15);
            _spellsUpdates[UP+RAINBOW+"2"] = new Action(UP+RAINBOW+"2", 800, false, false, 0xC000FF, 50);
            _spellsUpdates[UP+RAINBOW+"3"] = new Action(UP+RAINBOW+"3", 1500, false, false, 0xC000FF, 110);

            _spellsUpdates[UP+FIST+"1"] = new Action(UP+FIST+"1", 150, true, false, 0x0056FF, 80);
            _spellsUpdates[UP+FIST+"2"] = new Action(UP+FIST+"2", 750, false, false, 0x0056FF, 150);
            _spellsUpdates[UP+FIST+"3"] = new Action(UP+FIST+"3", 1400, false, false, 0x0056FF, 300);

            _spellsUpdates[UP+CROWN+"1"] = new Action(UP+CROWN+"1", 150, true, false, 0xFFA900, 20);
            _spellsUpdates[UP+CROWN+"2"] = new Action(UP+CROWN+"2", 700, false, false, 0xFFA900, 50);
            _spellsUpdates[UP+CROWN+"3"] = new Action(UP+CROWN+"3", 1700, false, false, 0xFFA900, 150);

            _spellsUpdates[UP+FREEZE+"1"] = new Action(UP+FREEZE+"1", 100, true, false, 0x00F4FF, 5);
            _spellsUpdates[UP+FREEZE+"2"] = new Action(UP+FREEZE+"2", 500, false, false, 0x00F4FF, 7);
            _spellsUpdates[UP+FREEZE+"3"] = new Action(UP+FREEZE+"3", 1000, false, false, 0x00F4FF, 10);

            _spellsUpdates[UP+MINE+"1"] = new Action(UP+MINE+"1", 150, true, false, 0xFF0400, 30);
            _spellsUpdates[UP+MINE+"2"] = new Action(UP+MINE+"2", 850, false, false, 0xFF0400, 60);
            _spellsUpdates[UP+MINE+"3"] = new Action(UP+MINE+"3", 1400, false, false, 0xFF0400, 150);

            // GAG
            // init inventory
           /* _userItems.push(new ARune(new McRune(), 100, TList.SHI_+"1", TList.treasureList[TList.SHI_+"1"].value));
            _userItems.push(new ARune(new McRune(), 100, TList.SHI_+"1", TList.treasureList[TList.SHI_+"1"].value));
            _userItems.push(new ARune(new McRune(), 100, TList.GEN_+"5", TList.treasureList[TList.GEN_+"5"].value));
            _userItems.push(new ARune(new McRune(), 100, TList.GEN_+"5", TList.treasureList[TList.GEN_+"5"].value));
            _userItems.push(new ARune(new McRune(), 100, TList.DOCU_+"5", TList.treasureList[TList.DOCU_+"5"].value));
            _userItems.push(new ARune(new McRune(), 100, TList.TUR_+"3", TList.treasureList[TList.TUR_+"3"].value));
            _userItems.push(new ARune(new McRune(), 100, TList.TUR_+"5", TList.treasureList[TList.TUR_+"5"].value));*/


            /* DESERT */
//            _userItems.push(GameData.getNewItem(TList.MAGNET_1));

//            _staffRunes.push(GameData.getNewItem(TList.DOCU_+"3"));
//            _staffRunes.push(GameData.getNewItem(TList.TUR_+"3"));

            _staffRunes.push(GameData.getNewItem(TList.SHI_+"1"));

            _staffCrystall.push(GameData.getNewItem(TList.CRYSTALL_1));
            _staff = new Staff(_staffRunes, _staffCrystall);
        }

    /* INIT CONTROLLER */
    public function initController(cotroller:IController = null):void
    {
        _controller = cotroller;
    }

    /* CHECK FOR THE PERFECTION ACHIEVEMENT */
    // update PERFECTION achievement if all skills updated
    private function checkForThePerfectionAchievement():void
    {
        if(_manaRecovery.value == _avalManaRecovery[_avalManaRecovery.length-1]
                && _healthRecovery.value == _avalHealthRecovery[_avalHealthRecovery.length-1]
                && _totalMana.value == _avalManaIncreaces[_avalManaIncreaces.length-1]
                && _totalHealth.value == _avalHealthIncreaces[_avalHealthIncreaces.length-1])
        {
            DataController.achievementsData.updateAchievement(AchievementsData.PERFECTION);
        }
    }

    /* GET MAGNET */
    public function getMagnet():IMagnet
    {
        var cur:IMagnet = null;
        for(var i:int = 0; i < userItems.length; i++)
        {
            var item:IItem = userItems[i];
            if(item is IMagnet)
            {
                if(cur == null)  cur = item as IMagnet;
                else
                {
                    if(cur.value < item.value) cur = item as IMagnet;
                }
            }
        }
        return cur;
    }

    /* IS CAN UPDATE SOME MAGIC SKILL */
    // хватает ли денег у игрока, чтобы улучшить какой-нибудь магический навык
    public function isCanUpdateSomeMagicSkill():Boolean
    {
        for each(var spellUpdate:Action in _spellsUpdates)
        {
            if(!spellUpdate.isExplored)
            {
                if(_currentCoinsAmount >= spellUpdate.cost) return true;
            }
        }
        return false;
    }

    /* IS CAN UPDATE SOME SKILL */
    // хватает ли денег у игрока, чтобы улучшить какой-нибудь навык
    public function isCanUpdateSomeSkill():Boolean
    {
//        var coinsAmount:int = DataController.playerData.currentCoinsAmount;
        var needCost:int;

        // mana recovery
        var currentManaRecoveryIndex:int = _avalManaRecovery.indexOf(manaRecovery);
        // если это не последнее доступное улучшение
        if(currentManaRecoveryIndex != _avalManaRecovery.length-1)
        {
            needCost = _avalManaRecoveryCost[currentManaRecoveryIndex+1];
            if(_currentCoinsAmount >= needCost) return true;
        }

        // health recovery
        var currentHealthRecoveryIndex:int = _avalHealthRecovery.indexOf(healthRecovery);
        // если это не последнее доступное улучшение
        if(currentHealthRecoveryIndex != _avalHealthRecovery.length-1)
        {
            needCost = _avalHealthRecoveryCost[currentHealthRecoveryIndex+1];
            if(_currentCoinsAmount >= needCost) return true;
        }

        // mana amount
        var currentTotalManaIndex:int = _avalManaIncreaces.indexOf(totalMana);
        // если это не последнее доступное улучшение
        if(currentTotalManaIndex != _avalManaIncreaces.length-1)
        {
            needCost = _avalManaIncreacesCost[currentTotalManaIndex+1];
            if(_currentCoinsAmount >= needCost) return true;
        }

        // health amount
        var currentTotalHealthIndex:int = _avalHealthIncreaces.indexOf(totalHealth);
        // если это не последнее доступное улучшение
        if(currentTotalHealthIndex != _avalHealthIncreaces.length-1)
        {
            needCost = _avalHealthIncreacesCost[currentTotalHealthIndex+1];
            if(_currentCoinsAmount >= needCost) return true;
        }

        return false;
    }

    public function get currentBullet():Class {return _currentBullet;}
    public function set currentBullet(value:Class):void {_currentBullet = value;}


    /* current health */
    public function get currentHealth():int {return _currentHealth;}
    public function set currentHealth(value:int):void
    {
        if(value <= 0)
        {
            _currentHealth = 0;
            _controller.dispatchDeath();
        }
        else if(value >= _totalHealth.value)_currentHealth = _totalHealth.value;
        else            _currentHealth = value;

        if(_controller) _controller.updateView({curHealth:_currentHealth});
    }
    public function get currentHealthSkill():Skill {return _totalHealth;}

    public function get currentMana():int {return _currentMana;}
    public function set currentMana(value:int):void
    {
        if(value <= 0)              _currentMana = 0;
        else if(value >= _totalMana.value)_currentMana = _totalMana.value;
        else                        _currentMana = value;

        if(_controller) _controller.updateView({curMana:_currentMana});
    }
    public function get currentManaSkill():Skill {return _totalMana;}

    public function get manaRecovery():int {return _manaRecovery.value;}
    public function set manaRecovery(value:int):void
    {
        _manaRecovery.value = value;
    }
    public function get manaRecoverySkill():Skill {return _manaRecovery}

    public function get currentCoinsAmount():int {return _currentCoinsAmount;}
    public function set currentCoinsAmount(value:int):void
    {
//        trace("COINS AMOUNT : " + value);
        _currentCoinsAmount = value;
        if(_currentCoinsAmount >= 5000) DataController.achievementsData.updateAchievement(AchievementsData.MISER);
        if(_controller) _controller.updateView({curCoins:_currentCoinsAmount});
    }

    public function get avalManaRecovery():Array {return _avalManaRecovery;}

    public function get avalHealthRecovery():Array {return _avalHealthRecovery;}

    public function get healthRecovery():int {return _healthRecovery.value;}
    public function set healthRecovery(value:int):void
    {
        _healthRecovery.value = value;
    }
    public function get healthRecoverySkill():Skill {return _healthRecovery;}

    public function get totalHealth():int {return _totalHealth.value;}
    public function set totalHealth(value:int):void
    {
        _totalHealth.value = value;
    }

    public function get totalMana():int {return _totalMana.value;}
    public function set totalMana(value:int):void
    {
        _totalMana.value = value;
    }

    public function get avalManaRecoveryCost():Array {return _avalManaRecoveryCost;}

    public function get avalHealthRecoveryCost():Array {return _avalHealthRecoveryCost;}

    public function get avalHealthIncreaces():Array {return _avalHealthIncreaces;}

    public function get avalHealthIncreacesCost():Array {return _avalHealthIncreacesCost;}

    public function get avalManaIncreaces():Array {return _avalManaIncreaces;}

    public function get avalManaIncreacesCost():Array {return _avalManaIncreacesCost;}

    public function get userItems():Vector.<IItem> {return _userItems;}

    public function set userItems(value:Vector.<IItem>):void {_userItems = value;}

    public function get staffRunes():Vector.<IItem> {return _staffRunes;}

    public function get spellPoints():int {return _spellPoints;}
    public function set spellPoints(value:int):void
    {
        if(value <= 0)              _spellPoints = 0;
        else if(value >= TOTAL_SPELL_POINTS) _spellPoints = TOTAL_SPELL_POINTS;
        else                        _spellPoints = value;

        if(_controller) _controller.updateView({curSpellPoints:_spellPoints});
    }

    public function get rainbowShellsAmount():int {return _rainbowShellsAmount;}
    public function set rainbowShellsAmount(value:int):void {_rainbowShellsAmount = value;}

    public function get rainbowShellDamage():int {return _rainbowShellDamage;}
    public function set rainbowShellDamage(value:int):void {_rainbowShellDamage = value;}

    public function get fistHealth():int {return _fistHealth;}
    public function set fistHealth(value:int):void {_fistHealth = value;}

    public function get crownShellAmount():int {return _crownShellAmount;}
    public function set crownShellAmount(value:int):void {_crownShellAmount = value;}

    public function get crownShellDamage():int {return _crownShellDamage;}
    public function set crownShellDamage(value:int):void {_crownShellDamage = value;}

    public function get freezeLength():int {return _freezeLength;}
    public function set freezeLength(value:int):void {_freezeLength = value;}

    public function get mineDamage():int {return _mineDamage;}
    public function set mineDamage(value:int):void {_mineDamage = value;}

    public function get mineAmount():int {return _mineAmount;}
    public function set mineAmount(value:int):void {_mineAmount = value;}

    public function get gamePoints():int {return _gamePoints;}
    public function set gamePoints(value:int):void {_gamePoints = value;}

    public function get tempGamePoints():int {return _tempGamePoints;}
    public function set tempGamePoints(value:int):void
    {
        _tempGamePoints = value;
        if(_controller) _controller.updateView({curTempGamePoints:_tempGamePoints});
    }

    public function get currentTempCoinsAmount():int{return _currentTempCoinsAmount;}
    public function set currentTempCoinsAmount(value:int):void
    {
        _currentTempCoinsAmount = value;
        if(_controller) _controller.updateView({curTempCoins:_currentTempCoinsAmount});
    }

    public function set staffRunes(value:Vector.<IItem>):void
    {
        _staffRunes = value;
        _staff.updateProperties();
//        if(_controller) _controller.updateView({isUpdateStaff:true});
    }

    public function get staff():Staff {
        return _staff;
    }

    public function get spellsUpdates():Dictionary {
        return _spellsUpdates;
    }

    public function get isUpdateAnySpell():Boolean {return _isUpdateAnySpell;}
    public function set isUpdateAnySpell(value:Boolean):void {_isUpdateAnySpell = value;}

    public function get isNeedToShowSpellTutPopupOnLevel():Boolean {return _isNeedToShowSpellTutPopupOnLevel;}
    public function set isNeedToShowSpellTutPopupOnLevel(value:Boolean):void {_isNeedToShowSpellTutPopupOnLevel = value;}

    public function get isNeedToShowControlsTutPopupOnLevel():Boolean {return _isNeedToShowControlsTutPopupOnLevel;}
    public function set isNeedToShowControlsTutPopupOnLevel(value:Boolean):void {_isNeedToShowControlsTutPopupOnLevel = value;}

    public function get isNeedToShowChestTutPopupOnLevel():Boolean {return _isNeedToShowChestTutPopupOnLevel;}
    public function set isNeedToShowChestTutPopupOnLevel(value:Boolean):void {_isNeedToShowChestTutPopupOnLevel = value;}

    public function get isNeedToShowTabStoreTutorial():Boolean {return _isNeedToShowTabStoreTutorial;}
    public function set isNeedToShowTabStoreTutorial(value:Boolean):void {_isNeedToShowTabStoreTutorial = value;}

    public function get isNeedToShowTabAcademyTutorial():Boolean {return _isNeedToShowTabAcademyTutorial;}
    public function set isNeedToShowTabAcademyTutorial(value:Boolean):void {_isNeedToShowTabAcademyTutorial = value;}

    public function get isNeedToShowTabStaffTutorial():Boolean {return _isNeedToShowTabStaffTutorial;}
    public function set isNeedToShowTabStaffTutorial(value:Boolean):void {_isNeedToShowTabStaffTutorial = value;}
}
}
