/**
 * Created by Sith on 14.06.14.
 */
package inputControllers
{
import flash.display.Stage;
import flash.events.Event;
import flash.events.GameInputEvent;
import flash.events.KeyboardEvent;
//import flash.ui.GameInput;
//import flash.ui.GameInputControl;
import flash.ui.GameInputDevice;

import player.MovableModel;

public class JoypadController implements IInputController
{
//    private var gameInput:GameInput;

        public function JoypadController(playerModel:MovableModel, stage:Stage):void
        {
//            gameInput = new GameInput();
//            gameInput.addEventListener(GameInputEvent.DEVICE_ADDED, deviceAdded);
//            gameInput.addEventListener(GameInputEvent.DEVICE_REMOVED, deviceRemoved);

//            stage.addEventListener(.KEY_DOWN, test);
        }

    /*private function test(event:KeyboardEvent):void
    {

     trace("JJJJJJJJJ");
    }

        private function deviceAdded(e:GameInputEvent):void
        {
            var device:GameInputDevice = e.device;
            device.enabled = true;

            for (var i:Number = 0; i < device.numControls; i++)
            {
                var control:GameInputControl = device.getControlAt(i);
                control.addEventListener(Event.CHANGE, controlChange);
            }
        }

        private function controlChange(e:Event):void
        {
//            var control:GameInputControl = GameInputControl(e.target);
//            trace(control.id, control.value);
//            trace(e);
        }

        private function deviceRemoved(e:GameInputEvent):void
        {
            trace("Device is removed");
        }*/
}
}
