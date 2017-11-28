/**
 * Created by Sith on 31.08.14.
 */
package gui
{
public class Skill
{
    private var _value:int;
    private var _callback:Function;

    /*CONSTRUCTOR*/
    public function Skill(startSkill:int, callback:Function)
    {
        _value = startSkill;
        _callback = callback;
    }

    public function get value():int {return _value;}
    public function set value(value:int):void
    {
        _value = value;
        _callback();
    }
}
}
