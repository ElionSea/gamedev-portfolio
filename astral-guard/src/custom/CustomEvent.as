/**
 * Created by Sith on 22.06.14.
 */
package custom {
import flash.events.Event;

public class CustomEvent extends Event
{
    public static const JUMP:String = "jump";
    public static const PLAYER_SHOOT:String = "playerShoot";
    public static const ENEMY_SHOOT:String = "enemyShoot";
    public static const DIED:String = "died";
    public static const TREASURE_FROM_DIED:String = "treasureFromDied";
    public static const FALL:String = "fall";
    public static const HIT:String = "hit";
    public static const DUST:String = "dust";
    public static const PLAYER_DEATH:String = "playerDeath";
    public static const SPELL_CAST:String = "spellCast";
    public static const SHAKE_GAMESCREEN:String = "shakeGameScreen";
    public static const LEVEL_COMPLETED:String = "levelCompleted";
    public static const STOP_GENERATE:String = "stopGenerate";
    public static const SHOW_DAMAGE:String = "showDamage";
    public static const HIT_POTION:String = "hitPotion";
    public static const SHOW_POWER_INCREASED:String = "powerIncreased";
    public static const SHOW_PARALIZED:String = "showParalized";

    private var _controllerClass:Class;
    private var _obj:Object;

    /* CONSTRUCTOR */
    public function CustomEvent(type:String, controlledClass:Class=null, bubbles:Boolean=false, cancelable:Boolean=false, obj:Object=null)
    {
        _controllerClass = controlledClass;
        _obj = obj;
        super(type, bubbles, cancelable);
    }

    public function get controllerClass():Class {return _controllerClass;}

    public function get obj():Object {return _obj;}
}
}
