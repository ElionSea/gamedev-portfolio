/**
 * Created by ElionSea on 07.12.14.
 */
package screens {
import flash.display.MovieClip;

public class BlockScreen extends AScreen
{
    /*CONSTRUCTOR*/
    public function BlockScreen(screenName:String, view:MovieClip, isShowingMouseCursor:Boolean, nextScreen:IScreen)
    {
        super(screenName, view, nextScreen, isShowingMouseCursor);
    }
}
}
