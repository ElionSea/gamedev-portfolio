/**
 * Created by Sith on 24.06.14.
 */
package levelStuff.trigger {
import flash.events.Event;

public class TriggerEvent extends Event
{
    public static const TRIGGERED:String = "Triggered";
    private var _eventId:int;


    public function TriggerEvent(eventId:int, type:String, bubbles:Boolean = false, cancelable:Boolean = false)
    {
        super(type, bubbles, cancelable);
        _eventId = eventId;
    }

    public function get eventId():int {return _eventId;}
}
}
