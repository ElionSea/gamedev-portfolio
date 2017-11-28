/**
 * Created by Sith on 31.08.14.
 */
package gui.inventory
{
import flash.display.MovieClip;

import gui.inventory.AItem;

public class AScroll extends AItem
{

    /*CONSTRUCTOR*/
    public function AScroll(view:MovieClip, buyCost:int, viewName:String)
    {
        super(view, buyCost, viewName, value);
        init();
    }

    /* INIT */
    private function init():void
    {

    }
}
}
