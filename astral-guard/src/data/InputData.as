/**
 * Created by Sith on 15.06.14.
 */
package data
{
import flash.ui.GameInputDevice;
import inputControllers.JoypadMap;
import inputControllers.KeyboardMap;

public class InputData implements IData
{

    public static const INPUT_KEYBOARD:String = "inputKeyboard";
    public static const INPUT_JOYPAD:String = "inputJoypad";

    private var _currentInput:String = undefined;
    private var _currentCustomMap:KeyboardMap;
    private var _currentKeyboardMap:KeyboardMap;
    private var _currtentJoypadMap:JoypadMap;
    private var _joypadsAmount:int = 0;
//    private var _inputDevices:Vector.<GameInputDevice> = new Vector.<GameInputDevice>();
    private var _currentDeviceName:String;
    private var _currentJoypadJump:String;
    private var _currentJoypadShoot:String;
    private var _currentJoypadSpecial:String;

    public function InputData()
    {

    }

    public function get currentInput():String {return _currentInput;}
    public function set currentInput(value:String):void {_currentInput = value;}

    public function get currentCustomMap():KeyboardMap {return _currentCustomMap;}
    public function set currentCustomMap(value:KeyboardMap):void {_currentCustomMap = value;}

    public function get currentKeyboardMap():KeyboardMap {return _currentKeyboardMap;}
    public function set currentKeyboardMap(value:KeyboardMap):void {_currentKeyboardMap = value;}

    public function get currtentJoypadMap():JoypadMap {return _currtentJoypadMap;}
    public function set currtentJoypadMap(value:JoypadMap):void {_currtentJoypadMap = value;}

    public function get joypadsAmount():int {return _joypadsAmount;}
    public function set joypadsAmount(value:int):void {_joypadsAmount = value;}

//    public function get inputDevices():Vector.<GameInputDevice> {return _inputDevices;}
//    public function set inputDevices(value:Vector.<GameInputDevice>):void {_inputDevices = value;}

    public function get currentDeviceName():String {return _currentDeviceName;}
    public function set currentDeviceName(value:String):void {_currentDeviceName = value;}

    public function get currentJoypadJump():String {return _currentJoypadJump;}
    public function set currentJoypadJump(value:String):void {_currentJoypadJump = value;}

    public function get currentJoypadShoot():String {return _currentJoypadShoot;}
    public function set currentJoypadShoot(value:String):void {_currentJoypadShoot = value;}

    public function get currentJoypadSpecial():String {return _currentJoypadSpecial;}
    public function set currentJoypadSpecial(value:String):void {_currentJoypadSpecial = value;}
}
}
