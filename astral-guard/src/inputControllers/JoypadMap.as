/**
 * Created by Sith on 15.06.14.
 */
package inputControllers
{
public class JoypadMap
{
    public static const BUTTON:String  = "BUTTON_";

    private var _jump:String;
    private var _shoot:String;
    private var _special:String;

    public function JoypadMap(jump:String, shoot:String, special:String)
    {
        _jump = jump;
        _shoot = shoot;
        _special = special;
    }

    public function get jump():String {return _jump;}
    public function set jump(value:String):void {_jump = value;}

    public function get shoot():String {return _shoot;}
    public function set shoot(value:String):void {_shoot = value;}

    public function get special():String {return _special;}
    public function set special(value:String):void {_special = value;}
}
}
