/**
 * Created by ElionSea on 27.03.15.
 */
package data {
import locale.InfoNode;

public class Achievement
{
    private var _opened:Boolean;

    /*CONSTRUCTOR*/
    public function Achievement()
    {

    }

    public function get opened():Boolean {return _opened;}
    public function set opened(value:Boolean):void
    {
        _opened = value;
    }
}
}
