/**
 * Created by ElionSea on 13.10.14.
 */
package gui.inventory
{
import flash.display.MovieClip;

import levelStuff.treasures.TList;

public class AMagnet extends AItem implements IMagnet
{
    private var _dist:Number;

    /*CONSTRUCTOR*/
    public function AMagnet(view:MovieClip, buyCost:int, viewName:String, value:Number)
    {
        switch (viewName)
        {
            case TList.MAGNET_1:
                _dist = 30;
                break;
            case TList.MAGNET_2:
                _dist = 60;
                break;
            case TList.MAGNET_3:
                _dist = 90;
                break;
        }

        super(view, buyCost, viewName, value);
    }

    public function get dist():Number {return _dist;}
}
}
