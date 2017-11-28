/**
 * Created by Sith on 01.04.14.
 */
package data {
import flash.utils.Dictionary;

import levelStuff.bosses.concreteBosses.BossLordOfCastle;
import levelStuff.bosses.concreteBosses.BossLordOfDesert;
import levelStuff.bosses.concreteBosses.BossLordOfFire;
import levelStuff.bosses.concreteBosses.BossLordOfIce;
import levelStuff.bosses.concreteBosses.BossLordOfSwamp;
import levelStuff.bosses.concreteBosses.BossLordOfUnreal;

import levels.bg.BgCastle;
import levels.bg.BgDesert;
import levels.bg.BgSwamp;
import levels.bg.BgUnreal;
import levels.bg.BgVolcano;
import levels.bg.BgWinter;

import xmlParsingTiledLevel.Level;

public class LevelData implements IData
{
    private static var allLevels:Dictionary;
    private static var _currentLevel:int = 1;

    public static const LEVEL_:String = "level_";


    public static const CASTLE:String = "castle";
    public static const SWAMP:String = "swamp";
    public static const DESERT:String = "desert";
    public static const INNER:String = "inner";
    public static const ICEWORLD:String = "iceworld";
    public static const VOLCANO:String = "volcano";

    /* EMBEDED PNG TILESET */
    [Embed(source="../../../Art/out/bg_01/dungeon.png")]
    public static var  tilesetBitmap:Class;




    /* EMBEDED XML's (levels)*/

        [Embed(source='../../../levels/new_concept.xml', mimeType="application/octet-stream")]
        private static var wave_level:Class;
        /*______________________________CASTLE______________________________*/

                            /* 1 */
                                private static var level_castle1_durations:Array = [4000, 4000, 4000, 4000];
                                private static var level_castle1_enemies:Array = [
                                            [1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
                                            [1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
                                            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                                            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
                                        ];
                            /* 2 */
                                private static var level_castle2_durations:Array = [5000, 5000, 5500, 5500];
                                private static var level_castle2_enemies:Array = [
                                    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
                                    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
                                    [2, 0, 0, 2, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0],
                                    [0, 2, 2, 0, 0, 2, 2, 0, 0, 0, 0, 2, 0, 0, 2]
                                ];
                            /* 3 CASTLE BOSS */
                                [Embed(source='../../../levels/boss_Castle_level.xml', mimeType="application/octet-stream")]
                                private static var boss_castle_level:Class;
                                private static var level_castle_boss_durations:Array = [6000, 6000, 6000, 6000];
                                private static var castle_boss_enemies:Array = [
                                    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                                    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
                                ];

        /*______________________________SWAMP______________________________*/
                            /* 4 */
                                private static var level_swamp1_durations:Array = [9000, 9000, 5500, 5500];
                                private static var level_swamp1_enemies:Array = [
                                    [4, 4, 4, 4, 4, 4],
                                    [4, 4, 4, 4, 4, 4],
                                    [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3],
                                    [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3]

                                ];
                            /* 5 */
                                private static var level_swamp2_durations:Array = [10000, 10000, 7000, 7000];
                                private static var level_swamp2_enemies:Array = [
                                    [4, 4, 4, 4, 4, 4, 4, 4, 4, 4],
                                    [4, 4, 4, 4, 4, 4, 4, 4, 4, 4],
                                    [3, 3, 5, 3, 3, 3, 5, 3, 3, 3, 3, 3, 3, 3, 3, 3],
                                    [5, 3, 3, 3, 5, 3, 3, 3, 5, 3, 3, 3, 3, 3, 3, 3]
                                ];
                            /* 6 SWAMP_BOSS */
                                    private static var level_swamp_boss_durations:Array = [7000, 8000, 7000, 8000];
                                    private static var swamp_boss_enemies:Array =
                                    [
                                        [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,3, 3, 3, 3, 3, 3],
                                        [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,3, 3, 3, 3, 3, 3]
                                    ];
                                    [Embed(source='../../../levels/boss_Swamp_level.xml', mimeType="application/octet-stream")]
                                    private static var boss_swamp_level:Class;



        /* 7 - BONUS LEVEL - 1 */
                private static var bonus_level:Array =
                        [
                            [],
                            []
                        ];

        /*______________________________DESERT______________________________*/
                        /* 8 */
                                private static var level_desert1_durations:Array = [10000, 10000, 7000, 7000];
                                private static var level_desert1_enemies:Array = [
                                    [7, 7, 7, 7, 7, 7, 7, 7],
                                    [7, 7, 7, 7, 7, 7, 7, 7],
                                    [6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6],
                                    [6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6]
                                ];
                        /* 9 */
                                private static var level_desert2_durations:Array  = [9000, 9000, 6500, 6500];
                                private static var level_desert2_enemies:Array = [
                                    [7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7],
                                    [7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7],
                                    [6, 6, 8, 6, 6, 6, 6, 8, 6, 8, 6, 6, 6, 8, 6, 8],
                                    [8, 6, 6, 8, 6, 8, 6, 6, 6, 6, 8, 6, 8, 6, 6, 6]
                                ];

                        /*10 desert_boss*/
                        [Embed(source='../../../levels/boss_Desert_level.xml', mimeType="application/octet-stream")]
                        private static var boss_desert_level:Class;
                        private static var level_desert_boss_durations:Array  = [12000, 12000, 12000, 12000];
                                private static var desert_boss_enemies:Array =
                                        [
                                            [7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7],
                                            [7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7]
                                        ];

    /*______________________________INNER (UNREAL)______________________________*/
                        /*11*/
                        private static var level_inner_1_durations:Array  = [8000, 8000, 5500, 5500];
                        private static var level_inner_1_enemies:Array = [
                            [15, 15, 15, 15, 15, 15, 15, 15, 15],
                            [15, 15, 15, 15, 15, 15, 15, 15, 15],
                            [17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17],
                            [17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17]

                        ];
                        /*12*/
                        private static var level_inner_2_durations:Array  = [9000, 9000, 6500, 6500];
                        private static var level_inner_2_enemies:Array = [
                            [15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15],
                            [15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15],
                            [16, 17, 16, 17, 17, 16, 17, 17, 17, 16, 17, 17, 17, 16, 17],
                            [16, 16, 17, 16, 17, 17, 17, 16, 17, 17, 17, 16, 17, 17, 16]

                        ];

                        /*13*/
                        [Embed(source='../../../levels/boss_Unreal_level.xml', mimeType="application/octet-stream")]
                        private static var boss_unreal_level:Class;
                        private static var boss_unreal_enemies_durations:Array = [8000, 8000, 5500, 5500];
                        private static var boss_unreal_enemies:Array = [
                            [17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17],
                            [17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17]
                        ];
                        /* 14 BONUS LEVEL */

    /*______________________________WINTER______________________________**/
                        /*15*/
                        private static var level_winter1_durations:Array = [8000, 8000, 5500, 5500];
                        private static var level_winter_enemies_1:Array = [
                            [12, 12, 12, 12, 12, 12, 12, 12, 12, 12],
                            [12, 12, 12, 12, 12, 12, 12, 12, 12, 12],
                            [14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14],
                            [14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14]
                        ];

                        /*16*/
                        private static var level_winter2_durations:Array = [8000, 8000, 5000, 5000];
                        private static var level_winter_enemies_2:Array = [
                            [12, 12, 12, 12, 12, 12, 12, 12, 12, 12],
                            [12, 12, 12, 12, 12, 12, 12, 12, 12, 12],
                            [13, 13, 14, 13, 14, 14, 14, 13, 14, 14, 14, 13, 14, 14, 14, 14, 13],
                            [13, 14, 13, 14, 14, 13, 14, 14, 14, 13, 14, 14, 14, 13, 14, 14, 14]
                        ];

                        /*17 BOSS WINTER */
                        [Embed(source='../../../levels/boss_Winter_level.xml', mimeType="application/octet-stream")]
                        private static var boss_winter_level:Class;
                        private static var boss_winter_durations:Array = [8000, 8000, 5500, 5500];
                        private static var boss_winter_enemies:Array = [
                            [14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14],
                            [14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14]
                        ];
    /*______________________________VOLCANO______________________________**/
                        /*18*/
                        private static var level_volcano1_durations:Array = [8000, 8000, 5500, 5500];
                        private static var level_volcano1_enemies:Array = [
                            [9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9],
                            [9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9],
                            [10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10],
                            [10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10]

                        ];
                        /*19*/
                        private static var level_volcano2_durations:Array = [6500, 6500, 7000, 7000];
                        private static var level_volcano2_enemies:Array = [
                            [9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9],
                            [9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9],
                            [11, 11, 10, 11, 10, 10, 10, 11, 10, 10, 10, 11, 10, 10, 10],
                            [11, 10, 11, 10, 10, 11, 10, 10, 10, 11, 10, 10, 10, 11, 11]

                        ];

                        /*20*/
                        [Embed(source='../../../levels/boss_Volcano_level.xml', mimeType="application/octet-stream")]
                                            private static var boss_volcano_level:Class;
                        private static var boss_volcanos_durations:Array = [5000, 5000, 5000, 5000];
                        private static var boss_volcanos_enemies:Array = [
                                                [9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9],
                                                [9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9]
                                            ];


            /*new concept */

            // time generate 5+5

            // все возможные пути
            // здесь указывается count pathTrigger'a
            private static var level_6_paths:Array = [
                [1]
            ];
            // доступные генераторам пути
            private static var level_6_generatorPaths:Array = [
                [level_6_paths[0]],
                [level_6_paths[0]],
                [level_6_paths[0]],
                [level_6_paths[0]]
            ];

    public function LevelData(){}

    public static function levelUp():void
    {
        _currentLevel++;
    }


    /* INIT LEVELS */
    public static function initLevels(checkForInit:Function):void
    {
        allLevels = new Dictionary();
        // GHOST CASTLE
        allLevels[LEVEL_ + "1"] = new Level(1, wave_level, CASTLE, BgCastle, 1, level_castle1_enemies, level_6_paths, level_6_generatorPaths, false, null , false, level_castle1_durations);
        allLevels[LEVEL_ + "2"] = new Level(2, wave_level, CASTLE, BgCastle, 2, level_castle2_enemies, level_6_paths, level_6_generatorPaths, false, null , false, level_castle2_durations);
        allLevels[LEVEL_ + "3"] = new Level(3, boss_castle_level, CASTLE, BgCastle, 4, castle_boss_enemies, level_6_paths, level_6_generatorPaths, true, BossLordOfCastle, false, level_castle_boss_durations);

        // SWAMP
        allLevels[LEVEL_ + "4"] = new Level(4, wave_level, SWAMP, BgSwamp, 1, level_swamp1_enemies, level_6_paths, level_6_generatorPaths, false, null , false, level_swamp1_durations);
        allLevels[LEVEL_ + "5"] = new Level(5, wave_level, SWAMP, BgSwamp, 2, level_swamp2_enemies, level_6_paths, level_6_generatorPaths, false, null , false, level_swamp2_durations);
        allLevels[LEVEL_ + "6"] = new Level(6, boss_swamp_level, SWAMP, BgSwamp, 4, swamp_boss_enemies, level_6_paths, level_6_generatorPaths, true, BossLordOfSwamp, false, level_swamp_boss_durations);
        // bonus level
        allLevels[LEVEL_ + "7"] = new Level(7, wave_level, "bonus_level", BgSwamp, 3, bonus_level, level_6_paths, level_6_generatorPaths, false, null, true);
        // DESERT
        allLevels[LEVEL_ + "8"] = new Level(8, wave_level, DESERT, BgDesert, 1, level_desert1_enemies, level_6_paths, level_6_generatorPaths, false, null , false, level_desert1_durations);
        allLevels[LEVEL_ + "9"] = new Level(9, wave_level, DESERT, BgDesert, 2, level_desert2_enemies, level_6_paths, level_6_generatorPaths, false, null , false, level_desert2_durations);
        allLevels[LEVEL_ + "10"] = new Level(10, boss_desert_level, DESERT, BgDesert, 4, desert_boss_enemies, level_6_paths, level_6_generatorPaths, true, BossLordOfDesert, false, level_desert_boss_durations);
        // INNER
        allLevels[LEVEL_ + "11"] = new Level(11, wave_level, INNER, BgUnreal, 1, level_inner_1_enemies, level_6_paths, level_6_generatorPaths, false, null , false, level_inner_1_durations);
        allLevels[LEVEL_ + "12"] = new Level(12, wave_level, INNER, BgUnreal, 2, level_inner_2_enemies, level_6_paths, level_6_generatorPaths, false, null , false, level_inner_2_durations);
        allLevels[LEVEL_ + "13"] = new Level(13, boss_unreal_level, INNER, BgUnreal, 4, boss_unreal_enemies, level_6_paths, level_6_generatorPaths, true, BossLordOfUnreal, false, boss_unreal_enemies_durations);
        // bonus level
        allLevels[LEVEL_ + "14"] = new Level(14, wave_level, "bonus_level", BgUnreal, 3, bonus_level, level_6_paths, level_6_generatorPaths, false, null, true);
        // ICEWORLD
        allLevels[LEVEL_ + "15"] = new Level(15, wave_level, ICEWORLD, BgWinter, 1, level_winter_enemies_1, level_6_paths, level_6_generatorPaths, false, null, false, level_winter1_durations);
        allLevels[LEVEL_ + "16"] = new Level(16, wave_level, ICEWORLD, BgWinter, 2, level_winter_enemies_2, level_6_paths, level_6_generatorPaths, false, null , false, level_winter2_durations);
        allLevels[LEVEL_ + "17"] = new Level(17, boss_winter_level, ICEWORLD, BgWinter, 4, boss_winter_enemies, level_6_paths, level_6_generatorPaths, true, BossLordOfIce, false, boss_winter_durations);

        // VOLCANO
        allLevels[LEVEL_ + "18"] = new Level(18, wave_level, VOLCANO, BgVolcano, 1, level_volcano1_enemies, level_6_paths, level_6_generatorPaths, false, null , false, level_volcano1_durations);
        allLevels[LEVEL_ + "19"] = new Level(19, wave_level, VOLCANO, BgVolcano, 2, level_volcano2_enemies, level_6_paths, level_6_generatorPaths, false, null , false, level_volcano2_durations);
        allLevels[LEVEL_ + "20"] = new Level(20, boss_volcano_level, VOLCANO, BgVolcano, 4, boss_volcanos_enemies, level_6_paths, level_6_generatorPaths, true, BossLordOfFire, false, boss_volcanos_durations);

        checkForInit();
    }

    /* GET LEVEL */
    public static function getLevel(curLevel:int):Level
    {
        return allLevels[LEVEL_+curLevel];
    }

    /* GET LEVEL XML */
    public static function getLevelXML(curLevel:int):XML
    {
        switch (curLevel)
        {
            case 1 :return new XML(new wave_level);break;
            case 2 :return new XML(new wave_level);break;
            case 3 :return new XML(new boss_castle_level);break;
            case 4 :return new XML(new wave_level);break;
            case 5 :return new XML(new wave_level);break;
            case 6 :return new XML(new boss_swamp_level);break;
            case 7 :return new XML(new wave_level);break;
            case 8 :return new XML(new wave_level);break;
            case 9 :return new XML(new wave_level);break;
            case 10 :return new XML(new boss_desert_level);break;
            case 11 :return new XML(new wave_level);break;
            case 12 :return new XML(new wave_level);break;
            case 13 :return new XML(new boss_unreal_level);break;
            case 14 :return new XML(new wave_level);break;
            case 15 :return new XML(new wave_level);break;
            case 16 :return new XML(new wave_level);break;
            case 17 :return new XML(new boss_winter_level);break;
            case 18 :return new XML(new wave_level);break;
            case 19 :return new XML(new wave_level);break;
            case 20 :return new XML(new boss_volcano_level);break;
        }
        return null;
    }

    public static function get currentLevel():int {
        return _currentLevel;
    }

    public static function set currentLevel(value:int):void {
        _currentLevel = value;
    }
}

}
