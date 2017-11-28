/**
 * Created by Sith on 31.08.14.
 */
package gui.inventory
{
import flash.display.MovieClip;

import gui.inventory.AItem;

public class ARune extends AItem implements IRune
{

    /*CONSTRUCTOR*/
    public function ARune(view:MovieClip, buyCost:int, viewName:String, value:Number)
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
