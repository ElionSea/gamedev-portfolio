/**
 * Created by ElionSea on 13.10.14.
 */
package gui.guild.staff
{
import flash.display.MovieClip;

import gui.inventory.AItem;

public class StaffCrystall extends AItem implements ICrystall
{
    /*CONSTRUCTOR*/
    public function StaffCrystall(view:MovieClip, buyCost:int, viewName:String, value:Number=0)
    {
        super(view, buyCost, viewName, value);
    }
}
}
