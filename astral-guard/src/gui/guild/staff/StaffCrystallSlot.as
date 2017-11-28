/**
 * Created by ElionSea on 13.10.14.
 */
package gui.guild.staff
{
import flash.display.MovieClip;

public class StaffCrystallSlot
{
    private var _view:MovieClip;

    /*CONSTRUCTOR*/
    function StaffCrystallSlot(view:MovieClip)
    {
        _view = view;
    }

    public function get view():MovieClip {return _view;}
}
}
