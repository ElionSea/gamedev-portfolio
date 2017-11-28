/**
 * Created by Sith on 27.06.14.
 */
package levelStuff.treasures
{
public class TreasureParserObject
{
    private var _x:Number;
    private var _y:Number;
    private var _width:Number;
    private var _height:Number;
    private var _type:String;

    public function TreasureParserObject()
    {

    }

    public function get x():Number {return _x;}

    public function get y():Number {return _y;}

    public function get width():Number {return _width;}

    public function get height():Number {return _height;}

    public function get type():String {return _type;}

    public function set x(value:Number):void {_x = value;}

    public function set y(value:Number):void {_y = value;}

    public function set width(value:Number):void {_width = value;}

    public function set height(value:Number):void {_height = value;}

    public function set type(value:String):void {_type = value;}
}
}
