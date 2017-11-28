/**
 * Created by Sith on 26.07.14.
 */
package levelStuff.treasures
{
import data.LevelData;

import flash.utils.Dictionary;

import gui.inventory.AItem;

import xmlParsingTiledLevel.Level;

public class TList
{
    private static var _treasureList:Dictionary;

    /* TREASURE LIST */
    // keys
    public static const GOLD_COIN:String = "coinGold";
    public static const RED_COIN:String = "coinRed";
    public static const PURPLE_COIN:String = "coinPurple";
    public static const GREEN_COIN:String = "coinGreen";
    public static const BLUE_COIN:String = "coinBlue";
    public static const BRILLIANT:String = "coinBrilliant";

    public static const HEALTH_POTION_SMALL:String = "potionHealthSmall";
    public static const HEALTH_POTION_MID:String = "potionHealthMid";
    public static const HEALTH_POTION_BIG:String = "potionHealthBig";
    public static const MANA_POTION_SMALL:String = "potionManaSmall";
    public static const MANA_POTION_MID:String = "potionManaMid";
    public static const MANA_POTION_BIG:String = "potionManaBig";

    public static const SHI_:String = "runeShi_";
    public static const GEN_:String = "runeGen_";
    public static const DOCU_:String = "runeDocu_";
    public static const TUR_:String = "runeTur_";
//    public static const RYU:String = "runeRyu";

    public static const STAFF_SLOT_4:String = "staffSlot_4";
    public static const STAFF_SLOT_5:String = "staffSlot_5";

    public static const CRYSTALL_1:String = "crystall_1";
    public static const CRYSTALL_2:String = "crystall_2";
    public static const CRYSTALL_3:String = "crystall_3";
    public static const CRYSTALL_4:String = "crystall_4";
    public static const CRYSTALL_5:String = "crystall_5";
    public static const CRYSTALL_6:String = "crystall_6";

    public static const MAGNET_1:String = "magnet_1";
    public static const MAGNET_2:String = "magnet_2";
    public static const MAGNET_3:String = "magnet_3";

//    public static const SCROLL:String = "scroll";



    private static var _coinsKeys:Array     = [GOLD_COIN, RED_COIN, PURPLE_COIN, GREEN_COIN, BLUE_COIN, BRILLIANT];
    private static var _bottles:Array     = [MANA_POTION_BIG, MANA_POTION_MID, MANA_POTION_SMALL, HEALTH_POTION_BIG, HEALTH_POTION_MID, HEALTH_POTION_SMALL];
    private static var _potionsKeys:Array   = [HEALTH_POTION_SMALL, HEALTH_POTION_MID, HEALTH_POTION_BIG, MANA_POTION_SMALL, MANA_POTION_MID, MANA_POTION_BIG];
    private static var _runesKeys:Array     = [SHI_+"1", SHI_+"2", SHI_+"3", SHI_+"4", SHI_+"5",
                                              GEN_+"1", GEN_+"2", GEN_+"3", GEN_+"4", GEN_+"5",
                                              DOCU_+"1", DOCU_+"2", DOCU_+"3", DOCU_+"4", DOCU_+"5",
                                              TUR_+"1", TUR_+"2", TUR_+"3", TUR_+"4", TUR_+"5"];
//    private static var _scrollsKeys:Array   = [SCROLL];

    private static var _allKeys:Array       = [_coinsKeys, _potionsKeys, _runesKeys];

    public function TList(){}

    /* GET RANDOM TREASURE */
    public static function getRandomTreasure(curLevel:int):Array
    {
        var keys:Array = [];
        var random:Number = Math.random();
        var randomCoinsAmount:int;
        var bonus1Coins:Array = [GOLD_COIN, RED_COIN, PURPLE_COIN];
        var bonus2Coins:Array = [RED_COIN, PURPLE_COIN, GREEN_COIN];

        // если это бонусный уровень
        if(LevelData.getLevel(LevelData.currentLevel).isBonus)
        {
            randomCoinsAmount = Math.floor(Math.random()*5)+2;
            if(LevelData.currentLevel == 7)
            {
                for(var bonus1Coin:int = 0; bonus1Coin < randomCoinsAmount; bonus1Coin++)
                {
                    var randomCoin:String = bonus1Coins[Math.floor(Math.random()*bonus1Coins.length)];
                    keys.push(randomCoin);
                }
            }
            else
            {
               // второй бонусный уровень (14-й)
                for(var bonus2Coin:int = 0; bonus2Coin < randomCoinsAmount; bonus2Coin++)
                {
                    var randomCoin2:String = bonus2Coins[Math.floor(Math.random()*bonus2Coins.length)];
                    keys.push(randomCoin2);
                }
            }
        }
        // ... не бонусный уровень
        else
        {
            if(random <= 0.90)
            {
                // coins
                if(curLevel <= 3) // CASTLE (1-3)
                {
                    // 3-10 GOLD COIN
                    randomCoinsAmount = Math.floor(Math.random()*7)+3;
                    for(var i:int = 0; i < randomCoinsAmount; i++) keys.push(GOLD_COIN);
                }
                else if(curLevel >= 4 && curLevel <= 6) // SWAMP (4-6)
                {
                    // от 2 до 4 RED COIN
                    randomCoinsAmount = Math.floor(Math.random()*2)+2;
                    for(var j:int = 0; j < randomCoinsAmount; j++) keys.push(RED_COIN);
                }
                else if(curLevel >= 8 && curLevel <= 10) // DESERT (8-10)
                {
                    // от 4 до 6 RED COIN
                    randomCoinsAmount = Math.floor(Math.random()*4)+2;
                    for(var l:int = 0; l < randomCoinsAmount; l++) keys.push(RED_COIN);
                }
                else if(curLevel >= 11 && curLevel <= 13) // INNER (11-13)
                {
                    // от 2 до 4 PURPLE COIN
                    randomCoinsAmount = Math.floor(Math.random()*4)+2;
                    for(var q:int = 0; q < randomCoinsAmount; q++) keys.push(PURPLE_COIN);
                }
                else if(curLevel >= 15 && curLevel <= 17) // ICEWORLD (11-13)
                {
                    // от 4 до 7 PURPLE COIN
                    randomCoinsAmount = Math.floor(Math.random()*3)+4;
                    for(var ic:int = 0; ic < randomCoinsAmount; ic++) keys.push(PURPLE_COIN);
                }
                else if(curLevel >= 18 && curLevel <= 20) // VOLCANO (18-20)
                {
                    // от 2 до 5 GREEN COIN
                    randomCoinsAmount = Math.floor(Math.random()*3)+2;
                    for(var vo:int = 0; vo < randomCoinsAmount; vo++) keys.push(GREEN_COIN);
                }
            }
            else
            {
                // смена концепции - теперь вместо рун будут выпадать бутылочки с 10 проц вероятностью
                //runs
                var randomPotion:String = getRandomPotion();
                keys.push(randomPotion);
            }

        }
        return keys;
    }

    /* GET RANDOM POTION */
    private static function getRandomPotion():String
    {
        var randomIndex:int = Math.floor(Math.random()*_bottles.length);
        var str:String = _bottles[randomIndex];
        return str;
    }

    private static function getRandomRuneByRange(range:int):String
    {
        var names:Array = [SHI_, GEN_, DOCU_, TUR_];
        var randomIndex:int = Math.floor(Math.random()*names.length);
        var str:String = names[randomIndex]+String(range);
//        trace("RUNE NAME : " + str);
        var runeName:String = _runesKeys[_runesKeys.indexOf(str)];
//        trace("RUNE NAME : " + runeName);
        return runeName;
    }

    public static function get treasureList():Dictionary
    {
        if(_treasureList == null)
        {
            _treasureList = new Dictionary();
            // coins
            _treasureList[GOLD_COIN]    = new TreasureDict(0xFFF901, 1);
            _treasureList[RED_COIN]     = new TreasureDict(0xF53121, 5);
            _treasureList[PURPLE_COIN]  = new TreasureDict(0xB72BEA, 10);
            _treasureList[GREEN_COIN]   = new TreasureDict(0x44AA33, 25);
            _treasureList[BLUE_COIN]   = new TreasureDict(0x6EF6FF, 50);
            _treasureList[BRILLIANT]   = new TreasureDict(0xBFFFEA, 100);
            // bottles
            _treasureList[HEALTH_POTION_SMALL]   = new TreasureDict(0xF30000);
            _treasureList[HEALTH_POTION_MID]     = new TreasureDict(0xF30000);
            _treasureList[HEALTH_POTION_BIG]     = new TreasureDict(0xF30000);
            _treasureList[MANA_POTION_SMALL]     = new TreasureDict(0x0400F3);
            _treasureList[MANA_POTION_MID]       = new TreasureDict(0x0400F3);
            _treasureList[MANA_POTION_BIG]       = new TreasureDict(0x0400F3);
            // runes
            _treasureList[SHI_+"1"]   = new TreasureDict(0xFF0000, 5, 100, SHI_+"1");
            _treasureList[SHI_+"2"]   = new TreasureDict(0x146DE2, 7, 300, SHI_+"2");
            _treasureList[SHI_+"3"]   = new TreasureDict(0x56F9F2, 10, 500, SHI_+"3");
            _treasureList[SHI_+"4"]   = new TreasureDict(0x00FF15, 14, 850, SHI_+"4");
            _treasureList[SHI_+"5"]   = new TreasureDict(0xFDF900, 19, 1000, SHI_+"5");

            _treasureList[GEN_+"1"]   = new TreasureDict(0xFF0000, 0.1, 90, GEN_+"1");
            _treasureList[GEN_+"2"]   = new TreasureDict(0x146DE2, 0.15, 150, GEN_+"2");
            _treasureList[GEN_+"3"]   = new TreasureDict(0x56F9F2, 0.19, 300, GEN_+"3");
            _treasureList[GEN_+"4"]   = new TreasureDict(0x00FF15, 0.22, 500, GEN_+"4");
            _treasureList[GEN_+"5"]   = new TreasureDict(0xFDF900, 0.3, 750, GEN_+"5");

            _treasureList[DOCU_+"1"]   = new TreasureDict(0xFF0000, 4, 100, DOCU_+"1");
            _treasureList[DOCU_+"2"]   = new TreasureDict(0x146DE2, 7, 190, DOCU_+"2");
            _treasureList[DOCU_+"3"]   = new TreasureDict(0x56F9F2, 8, 300, DOCU_+"3");
            _treasureList[DOCU_+"4"]   = new TreasureDict(0x00FF15, 11, 700, DOCU_+"4");
            _treasureList[DOCU_+"5"]   = new TreasureDict(0xFDF900, 19, 1100, DOCU_+"5");

            _treasureList[TUR_+"1"]   = new TreasureDict(0xFF0000, 0.2, 100, TUR_+"1");
            _treasureList[TUR_+"2"]   = new TreasureDict(0x146DE2, 0.3, 300, TUR_+"2");
            _treasureList[TUR_+"3"]   = new TreasureDict(0x56F9F2, 0.5, 500, TUR_+"3");
            _treasureList[TUR_+"4"]   = new TreasureDict(0x00FF15, 0.6, 850, TUR_+"4");
            _treasureList[TUR_+"5"]   = new TreasureDict(0xFDF900, 0.8, 1200, TUR_+"5");

            // staff slots
            _treasureList[STAFF_SLOT_4]   = new TreasureDict(0xFDF900, 0, 800, STAFF_SLOT_4);
            _treasureList[STAFF_SLOT_5]   = new TreasureDict(0xFDF900, 0, 1000, STAFF_SLOT_5);

            // crystall
            _treasureList[CRYSTALL_1]       = new TreasureDict(0xFDF900, 1, 100, CRYSTALL_1);
            _treasureList[CRYSTALL_2]       = new TreasureDict(0xFDF900, 2, 100, CRYSTALL_2);
            _treasureList[CRYSTALL_3]       = new TreasureDict(0xFDF900, 3, 150, CRYSTALL_3);
            _treasureList[CRYSTALL_4]       = new TreasureDict(0xFDF900, 4, 150, CRYSTALL_4);
            _treasureList[CRYSTALL_5]       = new TreasureDict(0xFDF900, 5, 150, CRYSTALL_5);
            _treasureList[CRYSTALL_6]       = new TreasureDict(0xFDF900, 6, 200, CRYSTALL_6);


            // magnet
            _treasureList[MAGNET_1]       = new TreasureDict(0xFDF900, 1, 100, MAGNET_1);
            _treasureList[MAGNET_2]       = new TreasureDict(0xFDF900, 2, 300, MAGNET_2);
            _treasureList[MAGNET_3]       = new TreasureDict(0xFDF900, 3, 600, MAGNET_3);

        }
        return _treasureList;
    }

    public static function get coinsKeys():Array {return _coinsKeys;}
    public static function get potionsKeys():Array {return _potionsKeys;}
    public static function get runesKeys():Array {return _runesKeys;}
}
}
