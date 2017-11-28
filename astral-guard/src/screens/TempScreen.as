/**
 * Created by ElionSea on 01.11.14.
 */
package screens
{
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.display.Stage;

public class TempScreen extends AScreen
{
    /*CONSTRUCTOR*/
    public function TempScreen(screenName:String, view:MovieClip, isShowingMouseCursor:Boolean, nextScreen:IScreen)
    {
        super(screenName, view, nextScreen, isShowingMouseCursor);
    }
}
}
