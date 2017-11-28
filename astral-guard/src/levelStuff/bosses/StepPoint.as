/**
 * Created by Sith on 15.09.14.
 */
package levelStuff.bosses
{
import flash.geom.Point;

public class StepPoint extends Point
{
    private var _index:String;

    /*CONSTRUCTOR*/
    public function StepPoint(index:String, pnt:Point)
    {
        x = pnt.x;
        y = pnt.y;
        _index = index;
    }

    public function get index():String {return _index;}
}
}
