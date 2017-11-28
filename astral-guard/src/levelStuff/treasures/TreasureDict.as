/**
 * Created by Sith on 02.09.14.
 */
package levelStuff.treasures
{
/* TREASURE LIST ELEMENT */
public class TreasureDict
{
    private var _color:uint;
    private var _value:Number;
    private var _buyCost:int;
    private var _key:String;
    private var _isTimeoutHiding:Boolean;

    /*CONSTRUCTOR*/
    public function TreasureDict(color:uint, value:Number=0, buyCost:int=0, key:String = "", isTimeoutHiding:Boolean=true)
    {
        _color = color;
        _value = value;
        _buyCost = buyCost;
        _key = key;
        _isTimeoutHiding = isTimeoutHiding;
    }

    public function get color():uint {return _color;}

    public function get value():Number {return _value;}

    public function get buyCost():int {return _buyCost;}

    public function get key():String {return _key;}

    public function get isTimeoutHiding():Boolean {return _isTimeoutHiding;}
}
}
