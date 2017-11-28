/**
 * Created by ElionSea on 28.09.14.
 */
package gui.guild.staff
{
import flash.display.MovieClip;

import gui.inventory.AItem;

public class StaffSlot extends AItem implements IStaffSlot
{
    /*CONSTRUCTOR*/
    public function StaffSlot(view:MovieClip, buyCost:int, viewName:String, value:Number=0)
    {
        super(view, buyCost, viewName, value);
    }
}
}
