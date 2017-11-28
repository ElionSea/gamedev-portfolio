/**
 * Created by Sith on 02.08.14.
 */
package custom {
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.text.TextField;

public class CustomStats
{
    private var _view:Sprite;
    private var _tf:TextField;
    private var _stage:Stage;

    /*CONSTRUCTOR*/
    public function CustomStats(view:Sprite, stage:Stage)
    {
        _view = view;
        _stage = stage;
        _view.addEventListener(Event.ADDED_TO_STAGE, init);

        _tf = _view["tf_FrameRate"];
    }

    /* INIT */
    private function init(e:Event):void
    {
        _view.removeEventListener(Event.ADDED_TO_STAGE, init);
        _view.addEventListener(Event.ENTER_FRAME, traceFrameRate);
    }

    /* TRACE FRAME RATE */
    private function traceFrameRate(e:Event):void
    {
        _tf.text = String(_stage.frameRate);
    }

    public function get view():Sprite {return _view;}
}
}
