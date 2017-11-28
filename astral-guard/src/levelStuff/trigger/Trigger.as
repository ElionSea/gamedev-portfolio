/**
 * Created by Sith on 24.06.14.
 */
package levelStuff.trigger {
import flash.display.Shape;
import flash.display.Sprite;

public class Trigger extends Sprite
{
    private var _view:Sprite;
    private var _eventId:int;

    public function Trigger(eventId:int, x:Number, y:Number, width:Number, height:Number)
    {
        _eventId = eventId;

        drawView(x, y, width, height);
    }

    /* DRAW VIEW */
    private function drawView(x:Number, y:Number, width:Number, height:Number):void
    {
        var shape:Shape = new Shape();
        shape.graphics.beginFill(0xFF00FF, 0.3);
        shape.graphics.drawRect(0, 0, width, height);
        shape.graphics.endFill();
        _view = new Sprite();
        _view.addChild(shape);
        _view.x = x;
        _view.y = y;
    }

    public function triggeredHitBox():void
    {
        trace("TRIGGER HIT");
        _view.dispatchEvent(new TriggerEvent(_eventId, TriggerEvent.TRIGGERED));
    }

    public function get view():Sprite {return _view;}
}
}
