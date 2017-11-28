/**
 * Created by Sith on 12.07.14.
 */
package levelStuff.enemies
{
import custom.ClipLabel;
import flash.utils.Dictionary;

import levelStuff.bosses.concreteBosses.BossLordOfCastle;
import levelStuff.bosses.concreteBosses.BossLordOfDesert;
import levelStuff.bosses.concreteBosses.BossLordOfFire;
import levelStuff.bosses.concreteBosses.BossLordOfIce;
import levelStuff.bosses.concreteBosses.BossLordOfSwamp;
import levelStuff.bosses.concreteBosses.BossLordOfUnreal;
import levelStuff.bullets.BossVolcanoShoot;
import levelStuff.bullets.BossVolcanoSpecialShoot;
import levelStuff.bullets.BossWinterShoot;
import levelStuff.bullets.BossWinterSpecialShoot;

import levelStuff.bullets.PlantShoot;
import levelStuff.bullets.ScorpionShoot;
import levelStuff.bullets.SpiderShoot;
import levelStuff.bullets.VolcanoGolemShoot;
import levelStuff.bullets.YetiShoot;
import levelStuff.bullets.ZKShoot;
import levelStuff.treasures.TList;

public class EList
{
    private static var _enemyList:Dictionary;

    public static function get enemyList():Dictionary
    {
        if(_enemyList == null)
        {
            _enemyList = new Dictionary();

            _enemyList[BAT]             = new EListObject(
                    BAT,
                    Trajectory.FLY_TO_PLAYER,
                    BatMc,
                    false,
                    false,
                    0.7,
                    0.5 ,
                    10,
                    ClipLabel.getClipLabels([[ClipLabel.WALK, 9, 0.3]]),
                    10,
                    true,
                    [TList.GOLD_COIN, TList.GOLD_COIN],
                    false
            );
            _enemyList[SKELETON]        = new EListObject(SKELETON,  Trajectory.WALK_TO_PLAYER, SkeletonMc, false, false, 0.6, 0, 15, ClipLabel.getClipLabels([[ClipLabel.WALK, 12, 0.8]]), 20, false, [TList.GOLD_COIN, TList.GOLD_COIN, TList.GOLD_COIN], false);
            _enemyList[ZOMBIE_KNIGHT]   = new EListObject(ZOMBIE_KNIGHT, Trajectory.WALK_TO_PLAYER, McZombieKnight, false, false, 0.27,  0, 20, ClipLabel.getClipLabels([[ClipLabel.WALK, 10, 0.7], [ClipLabel.SHOOT, 4, 0.3]]), 35, true, [TList.RED_COIN], false, null, true, ZKShoot, 2500);

            _enemyList[ROLLING_EYE]     = new EListObject(ROLLING_EYE, Trajectory.WALK_TO_PLAYER, RollingEyeMc, true, true, 0.5,  0.5, 15, ClipLabel.getClipLabels([[ClipLabel.WALK, 12, 0.3]]), 7, true, [TList.GOLD_COIN, TList.GOLD_COIN, TList.GOLD_COIN], false);
            _enemyList[BLOODY_EYE]      = new EListObject(BLOODY_EYE, Trajectory.FLY_TO_PLAYER, BloodyEyeMc, false, false, 0.5,  0.5, 20,  ClipLabel.getClipLabels([[ClipLabel.WALK, 9, 0.3]]), 25, true, [TList.RED_COIN], true, [ROLLING_EYE, ROLLING_EYE]);
            _enemyList[GREEN_PLANT]     = new EListObject(GREEN_PLANT, Trajectory.WALK_TO_PLAYER, McGreenPlant, false, false, 0.2,  0.2, 25,  ClipLabel.getClipLabels([[ClipLabel.WALK, 7, 0.6], [ClipLabel.SHOOT, 1, 0.3]]), 60, false, [TList.RED_COIN, TList.GOLD_COIN, TList.GOLD_COIN, TList.GOLD_COIN], false, null, true, PlantShoot, 2000);

            _enemyList[WORM]            = new EListObject(WORM, Trajectory.WALK_TO_PLAYER, McWorm, false, false, 0.45,  0, 20,  ClipLabel.getClipLabels([[ClipLabel.WALK, 7, 0.3]]), 30, true, [TList.RED_COIN], false);
            _enemyList[RED_BEE]         = new EListObject(RED_BEE, Trajectory.FLY_TO_PLAYER, McRedBee, false, false, 0.45,  0.45, 25,  ClipLabel.getClipLabels([[ClipLabel.WALK, 9, 0.6]]), 60, false, [TList.RED_COIN, TList.RED_COIN], false);
            _enemyList[SCORPION]        = new EListObject(SCORPION, Trajectory.WALK_TO_PLAYER, McScorpion, false, false, 0.3,  0, 30, ClipLabel.getClipLabels([[ClipLabel.WALK, 9, 0.6], [ClipLabel.SHOOT, 4, 0.3]]), 100, false, [TList.RED_COIN, TList.GREEN_COIN], false, null, true, ScorpionShoot, 2000);

            _enemyList[UNREAL_COCKROACH]= new EListObject(UNREAL_COCKROACH, Trajectory.WALK_TO_PLAYER, McUnrealCockroach, false, false, 0.4,  0.4, 25, ClipLabel.getClipLabels([[ClipLabel.WALK, 5, 0.12]]), 50, true, [TList.RED_COIN, TList.RED_COIN], false);
            _enemyList[UNREAL_BEE]      = new EListObject(UNREAL_BEE, Trajectory.FLY_TO_PLAYER, McUnrealBee, false, false, 0.3,  0.4, 30, ClipLabel.getClipLabels([[ClipLabel.WALK, 8, 0.2]]), 75, false, [TList.RED_COIN, TList.RED_COIN], false);
            _enemyList[UNREAL_SPIDER]   = new EListObject(UNREAL_SPIDER, Trajectory.WALK_TO_PLAYER, McUnrealSpider, false, false, 0.3,  0.4, 40,  ClipLabel.getClipLabels([[ClipLabel.WALK, 6, 1.0], [ClipLabel.SHOOT, 1, 0.3]]), 130, false, [TList.RED_COIN, TList.RED_COIN], false, null, true, SpiderShoot, 2500);

            _enemyList[SNOWFLAKE]       = new EListObject(SNOWFLAKE, Trajectory.WALK_TO_PLAYER, McSnowflake, false, false, 0.6,  0, 30, ClipLabel.getClipLabels([[ClipLabel.WALK, 6, 0.3]]), 70, true, [TList.RED_COIN, TList.RED_COIN], false);
            _enemyList[WINTER_BAT]      = new EListObject(WINTER_BAT, Trajectory.FLY_TO_PLAYER, McWinterBat, false, false, 0.45,  0.35, 45, ClipLabel.getClipLabels([[ClipLabel.WALK, 9, 0.4]]), 100, false, [TList.RED_COIN, TList.RED_COIN], false, null, false, null, 0, true, BossWinterShoot);
            _enemyList[YETI]            = new EListObject(YETI, Trajectory.WALK_TO_PLAYER, McYeti, false, false, 0.4,  0, 60, ClipLabel.getClipLabels([[ClipLabel.WALK, 9, 0.8], [ClipLabel.SHOOT, 1, 0.3]]), 165, false, [TList.RED_COIN, TList.RED_COIN], false, null, true, YetiShoot, 3000);

            _enemyList[FIRE_EYE]        = new EListObject(FIRE_EYE, Trajectory.FLY_TO_PLAYER, McFireEye, false, false, 1.2,  0.4, 40, ClipLabel.getClipLabels([[ClipLabel.WALK, 4, 0.3]]), 85, true, [TList.RED_COIN, TList.RED_COIN], false, null, false, null, 0, true, BossVolcanoShoot);
            _enemyList[FIREMAN]         = new EListObject(FIREMAN, Trajectory.WALK_TO_PLAYER, McFireman, false, false, 0.47,  0, 55, ClipLabel.getClipLabels([[ClipLabel.WALK, 9, 0.6]]), 140, true, [TList.RED_COIN, TList.RED_COIN], false);
            _enemyList[VOLCANO_GOLEM]   = new EListObject(VOLCANO_GOLEM, Trajectory.WALK_TO_PLAYER, McVolcanoGolem, false, false, 0.35,  0, 120, ClipLabel.getClipLabels([[ClipLabel.WALK, 5, 1.2], [ClipLabel.SHOOT, 2, 0.3]]), 200, false, [TList.RED_COIN, TList.RED_COIN], false, null, true, VolcanoGolemShoot, 2500);
        }
        return _enemyList;
    }

    /* ENEMY LIST */
    public static const SKELETON:int = 0;
    public static const BAT:int = 1;
    public static const ZOMBIE_KNIGHT:int = 2;
    public static const ROLLING_EYE:int = 3;
    public static const BLOODY_EYE:int = 4;
    public static const GREEN_PLANT:int = 5;
    public static const WORM:int = 6;
    public static const RED_BEE:int = 7;
    public static const SCORPION:int = 8;
    public static const FIRE_EYE:int = 9;
    public static const FIREMAN:int = 10;
    public static const VOLCANO_GOLEM:int = 11;
    public static const WINTER_BAT:int = 12;
    public static const YETI:int = 13;
    public static const SNOWFLAKE:int = 14;
    public static const UNREAL_BEE:int = 15;
    public static const UNREAL_SPIDER:int = 16;
    public static const UNREAL_COCKROACH:int = 17;


    public static function getBossHealth(bossClass:Class):int
    {
        switch(bossClass)
        {
            case BossLordOfCastle: return 800;
            case BossLordOfSwamp: return 1000;
            case BossLordOfDesert: return 1300;
            case BossLordOfUnreal: return 1650;
            case BossLordOfIce: return 2000;
            case BossLordOfFire: return 2400;
        }
        return 0;
    }

    public function EList()
    {

    }


}
}
