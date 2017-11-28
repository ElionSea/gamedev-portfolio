/**
 * Created by ElionSea on 28.11.14.
 */
package popup
{
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.MouseEvent;

public class APopup implements IPopup
{
    private var _view:Sprite;
    private var _skipArea:Sprite;
    private var _mainScreen:Sprite;
    /*CONSTRUCTOR*/
    public function APopup(mainScreen:Sprite, view:Sprite, x:Number=-1, y:Number=0-1)
    {
        _mainScreen = mainScreen;

        _view = view;
        _skipArea = _view["skipArea"];
        if(x == -1) _view.x = _mainScreen.stage.width/2;
        else _view.x = x;
        if(x == -1) _view.y = _mainScreen.stage.height/2;
        else _view.y = y;
        _view.scaleX = Platformer.SCALE_FACTOR;
        _view.scaleY = Platformer.SCALE_FACTOR;
    }

    public function get view():Sprite {return _view}

    public function get skipArea():Sprite {return _skipArea;}
}
}
