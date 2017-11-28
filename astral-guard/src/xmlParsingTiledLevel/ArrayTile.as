/**
 * Created by Sith on 22.06.14.
 */
package xmlParsingTiledLevel
{
public class ArrayTile
{
    private var _x:Number;
    private var _y:Number;
    private var _isObstacle:Boolean;
    private var _id:int;
    private var _wIndex:int;
    private var _hIndex:int;

    public function ArrayTile(id:int, x:Number, y:Number, isObstacle:Boolean, wIndex:int=0, hIndex:int=0)
    {
        _id = id;
        _isObstacle = isObstacle;
        _x = x;
        _y = y;
        _wIndex = wIndex;
        _hIndex = hIndex;
    }

    public function get x():Number {return _x;}

    public function get y():Number {return _y;}

    public function get isObstacle():Boolean {return _isObstacle;}

    public function set isObstacle(value:Boolean):void {_isObstacle = value;}

    public function get id():int {return _id;}

    public function get wIndex():int {return _wIndex;}

    public function get hIndex():int {return _hIndex;}
}
}
