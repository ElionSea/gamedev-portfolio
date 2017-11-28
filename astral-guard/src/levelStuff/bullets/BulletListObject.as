/**
 * Created by ElionSea on 28.10.14.
 */
package levelStuff.bullets
{
import flash.display.MovieClip;

public class BulletListObject
{
    private var _key:int;
    private var _damage:int;
    private var _trajectoryType:String;
    private var _view:Class;
    private var _speed:Number;

    /*CONSTRUCTOR*/
    public function BulletListObject(key:int, damage:int, trajectoryType:String, view:Class, speed:Number)
    {
        _key = key;
        _damage = damage;
        _trajectoryType = trajectoryType;
        _view = view;
        _speed = speed;
    }

    public function get key():int {return _key;}

    public function get damage():int {return _damage;}

    public function get trajectoryType():String {return _trajectoryType;}

    public function get view():Class {return _view;}

    public function get speed():Number {return _speed;}
}
}
