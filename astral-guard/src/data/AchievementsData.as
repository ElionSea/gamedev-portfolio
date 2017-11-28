/**
 * Created by ElionSea on 27.03.15.
 */
package data {
import flash.utils.Dictionary;

import locale.InfoNode;
import locale.Locale;

import popup.AchievementController;

public class AchievementsData
{
    public static const ABANDONED_SOUL:String = "AbandonedSoul";
    public static const SWAMP_INTRUDER:String = "SwampIntruder";
    public static const SANDY_EYE:String = "SandyEye";
    public static const POWER_OF_VORTEX:String = "PowerOfVortex";
    public static const BUZZY_GUARD:String = "BuzzyGuard";
    public static const ICE_SPIKE:String = "IceSpike";
    public static const VOLCANO_TAMER:String = "VolcanoTamer";
    public static const POWER_OF_BUBBLE:String = "PowerOfBubble";
    public static const APPRENTICE:String = "Apprentice";
    public static const VETERAN:String = "Veteran";
    public static const ASTRAL_GUARDIAN:String = "AstralGuardian";
    public static const POWER_OF_GOLDEN_CROWN:String = "PowerOfGoldenCrown";
    public static const CHEST_HUNTER_NOVICE:String = "ChestHunterNovice";
    public static const CHEST_HUNTER_SKILLED:String = "ChestHunterSkilled";
    public static const CHEST_HUNTER_EXPERT:String = "ChestHunterExpert";
    public static const POWER_OF_FREEZING:String = "PowerOfFreezing";
    public static const PERFECTION:String = "Perfection";
    public static const STAFF_BOOSTER:String = "StaffBooster";
    public static const MISER:String = "Miser";
    public static const POWER_OF_PLASMOIDS:String = "PowerOfPlasmoids";

    private var _achievements:Dictionary;
    private var _keys:Array = [ABANDONED_SOUL, SWAMP_INTRUDER, SANDY_EYE, POWER_OF_VORTEX, BUZZY_GUARD, ICE_SPIKE, VOLCANO_TAMER, POWER_OF_BUBBLE, APPRENTICE, VETERAN, ASTRAL_GUARDIAN, POWER_OF_GOLDEN_CROWN,
        CHEST_HUNTER_NOVICE, CHEST_HUNTER_SKILLED, CHEST_HUNTER_EXPERT, POWER_OF_FREEZING, PERFECTION, STAFF_BOOSTER, MISER, POWER_OF_PLASMOIDS];

    /*CONSTRUCTOR*/

    public function AchievementsData()
    {
        _achievements = new Dictionary();
        for each(var key:String in _keys)
        {
            _achievements[key] = new Achievement();
        }
    }

    /* UPDATE ACHIEVEMENT */
    public function updateAchievement(key:String):void
    {
        if(!_achievements[key].opened)
        {
            _achievements[key].opened = true;
            var infoNode:InfoNode = Locale.getAchievementsScreenInfo(["icons", (key)]);
            AchievementController.showAchieve(_keys.indexOf(key)+1, infoNode);
        }
    }

    public function get achievements():Dictionary {return _achievements;}

    public function get keys():Array {return _keys;}
}
}
