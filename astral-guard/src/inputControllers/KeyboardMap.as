/**
 * Created by Sith on 15.06.14.
 */
package inputControllers
{
import data.DataController;

import flash.ui.Keyboard;

public class KeyboardMap
{
    private var _jump:uint;
    private var _shoot:uint;
    private var _special:uint;
    private var _up:uint;
    private var _down:uint;
    private var _left:uint;
    private var _right:uint;

    public static const WASD_CONTROLLS:uint = 1;
    public static const ARROWS_CONTROLLS:uint = 2;
    public static const CUSTOMIZABLE_CONTROLLS:uint = 3;

    public function KeyboardMap(choosedControlls:uint, custom:KeyboardMap=null)
    {
        switch (choosedControlls)
        {
            case WASD_CONTROLLS:
                _jump = Keyboard.SPACE;
                _shoot = Keyboard.J;
                _special = Keyboard.K;
                _up = Keyboard.W;
                _down = Keyboard.S;
                _left = Keyboard.A;
                _right = Keyboard.D;
                break;
            case ARROWS_CONTROLLS:
                _jump = Keyboard.Z;
                _shoot = Keyboard.X;
                _special = Keyboard.C;
                _up = Keyboard.UP;
                _down = Keyboard.DOWN;
                _left = Keyboard.LEFT;
                _right = Keyboard.RIGHT;
                break;
            case CUSTOMIZABLE_CONTROLLS:
                updateControls(custom);
                break;
        }
    }

    private function updateControls(custom:KeyboardMap):void
    {
        DataController.inputData.currentCustomMap = custom;
        _jump = custom.jump;
        _shoot = custom.shoot;
        _special = custom.special;
        _up = custom.up;
        _down = custom.down;
        _left  = custom.left;
        _right = custom.right;
    }

    public function get jump():uint {return _jump;}

    public function get shoot():uint {return _shoot;}

    public function get special():uint {return _special;}

    public function get up():uint {return _up;}

    public function get down():uint {return _down;}

    public function get left():uint {return _left;}

    public function get right():uint {return _right;}
}
}
