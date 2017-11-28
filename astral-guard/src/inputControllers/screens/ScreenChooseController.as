/**
 * Created by Sith on 15.06.14.
 */
package inputControllers.screens
{
import data.DataController;
import data.InputData;

import flash.display.MovieClip;
import flash.events.Event;
import flash.events.GameInputEvent;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.ui.GameInput;
import flash.ui.GameInputControl;
//import flash.ui.GameInputDevice;

import inputControllers.JoypadMap;

import screens.AScreen;

public class ScreenChooseController extends AScreen
{
    private const CHOOSE_KEYBOARD:String = "mc_chooseKeyboard";
    private const CHOOSE_JOYPAD:String = "mc_chooseJoypad";
    private const CONNECTOR_CHEKER:String = "mc_connectorChecker";
    private const KEYBOARD_SCREEN:String = "mc_keyboardOptions";
    private const JOYPAD_SCREEN:String = "mc_joypadOptions";

    private const PLEASE_RECONNECT_MESSAGE:String = "Please, reconnect your pad";
    private const NEED_CUSTOMIZE:String = "Need customize";
    private const PUSH_BUTTON:String = "Push button";

    private const INPUT_JUMP:String = "mc_jumpListener";
    private const INPUT_SHOOT:String = "mc_shootListener";
    private const INPUT_SPECIAL:String = "mc_specialListener";

    private var _chooseKeyboard:MovieClip;
    private var _chooseJoypad:MovieClip;
    private var _joypadConnectorCheker:MovieClip;
    private var _keyboardOptionsScreen:MovieClip;
    private var _joypadOptionsScreen:MovieClip;
    private var _jumpInputChecker:MovieClip;
    private var _shootInputChecker:MovieClip;
    private var _specialInputChecker:MovieClip;

    private var _jumpInputListener:MovieClip;
    private var _shootInputListener:MovieClip;
    private var _specialInputListener:MovieClip;

    private var _wasd_controls_mc:MovieClip;
    private var _arrows_controls_mc:MovieClip;

    private var _infoConsole:TextField;

    private var _gameInput:GameInput;
//    private var _inputDevice:GameInputDevice;


    /* CONSTRUCTOR */
    public function ScreenChooseController(screenName:String, view:MovieClip, isShowingMouseCursor:Boolean=true)
    {
        super(screenName, view, null, isShowingMouseCursor);

        initElements();
    }

    /* INIT ELEMENTS */
    private function initElements():void
    {
        _chooseKeyboard = _view[CHOOSE_KEYBOARD];
        _chooseJoypad = _view[CHOOSE_JOYPAD];
        _joypadConnectorCheker = _view[CONNECTOR_CHEKER];
        _keyboardOptionsScreen = _view[KEYBOARD_SCREEN];
        _joypadOptionsScreen = _view[JOYPAD_SCREEN];
        _infoConsole = _view["tf_infoConsole"];

        _jumpInputChecker = _joypadOptionsScreen["mc_jumpInputCheker"];
        _shootInputChecker = _joypadOptionsScreen["mc_shootInputCheker"];
        _specialInputChecker = _joypadOptionsScreen["mc_specialInputCheker"];

        _jumpInputListener = _joypadOptionsScreen[INPUT_JUMP];
        _shootInputListener = _joypadOptionsScreen[INPUT_SHOOT];
        _specialInputListener = _joypadOptionsScreen[INPUT_SPECIAL];
        _jumpInputListener.mouseChildren = false;
        _shootInputListener.mouseChildren = false;
        _specialInputListener.mouseChildren = false;

        _wasd_controls_mc = _keyboardOptionsScreen["mc_wasd_controls"];
        _arrows_controls_mc = _keyboardOptionsScreen["mc_arrows_controls"];

        _chooseKeyboard.addEventListener(MouseEvent.CLICK, mouseClick);
        _chooseJoypad.addEventListener(MouseEvent.CLICK, mouseClick);

        initElementsState();
//        listenForJoypadConnect();
    }


    /* UPDATE JOYPAD CHECKERS */
    private function updateJoypadCheckers():void
    {
        var totalChecked:int = 0;
        // jump check
        if(DataController.inputData.currentJoypadJump)
        {
            _jumpInputChecker.gotoAndStop(2);
            totalChecked++;
        }
        else
        {
            _jumpInputChecker.gotoAndStop(1);
        }

        // shoot check
        if(DataController.inputData.currentJoypadShoot)
        {
            _shootInputChecker.gotoAndStop(2);
            totalChecked++;
        }
        else
        {
            _shootInputChecker.gotoAndStop(1);
        }

        // special check
        if(DataController.inputData.currentJoypadSpecial)
        {
            _specialInputChecker.gotoAndStop(2);
            totalChecked++;
        }
        else
        {
            _specialInputChecker.gotoAndStop(1);
        }

        if(totalChecked == 3)
        {
            DataController.inputData.currtentJoypadMap = new JoypadMap(
                    DataController.inputData.currentJoypadJump,
                    DataController.inputData.currentJoypadShoot,
                    DataController.inputData.currentJoypadSpecial
            )
        }
        else
        {
            DataController.inputData.currtentJoypadMap = undefined;
        }
    }

    /* INIT ELEMENTS STATE */
    private function initElementsState():void
    {
//        chooseController(KEYBOARD_SCREEN);
        updateJoypadConnector(DataController.inputData.joypadsAmount > 0);
        updateJoypadCheckers();
    }

    /* UPDATE JOYPAD CONNECTOR */
    private function updateJoypadConnector(isActive:Boolean):void
    {
        if(isActive)_joypadConnectorCheker.gotoAndStop(2);
        else        _joypadConnectorCheker.gotoAndStop(1);
    }

    /* CHOOSE CONTROLLER */
    private function chooseController(choosedController:String):void
    {
        if(choosedController == CHOOSE_KEYBOARD)
        {
            _keyboardOptionsScreen.visible = true;
            _joypadOptionsScreen.visible = false;

            _chooseKeyboard.gotoAndStop(2);
            _chooseJoypad.gotoAndStop(1);

            DataController.inputData.currentInput = InputData.INPUT_KEYBOARD;
        }
        else if(choosedController == CHOOSE_JOYPAD)
        {
            if(DataController.inputData.joypadsAmount > 0)
            {
                _keyboardOptionsScreen.visible = false;
                _joypadOptionsScreen.visible = true;

                _chooseKeyboard.gotoAndStop(1);
                _chooseJoypad.gotoAndStop(2);

                DataController.inputData.currentInput = InputData.INPUT_JOYPAD;
            }
            else
            {
                _infoConsole.text = PLEASE_RECONNECT_MESSAGE;
            }
        }
    }

    /* LISTEN FOR JOYPAD CONNECT */
    /*private function listenForJoypadConnect():void
    {
        _gameInput = new GameInput();
        _gameInput.addEventListener(GameInputEvent.DEVICE_ADDED, deviceAdded);
        _gameInput.addEventListener(GameInputEvent.DEVICE_REMOVED, deviceRemoved);
    }*/

    /* DEVICE ADDED */
    /*private function deviceAdded(e:GameInputEvent):void
    {

        if(DataController.inputData.joypadsAmount == 0)
        {
            _inputDevice = e.device;
            _inputDevice.enabled = true;
            DataController.inputData.joypadsAmount++;
            DataController.inputData.inputDevices.push(_inputDevice);
            DataController.inputData.currentDeviceName = _inputDevice.name;

            listenForInputs();

            updateJoypadConnector(true);
        }
    }*/

    /* DEVICE REMOVED */
    /*private function deviceRemoved(e:GameInputEvent):void
    {
        if(DataController.inputData.joypadsAmount == 1)
        {
            var removedDevice:GameInputDevice = e.device;
            if(removedDevice.name == DataController.inputData.currentDeviceName)
            {
                DataController.inputData.joypadsAmount--;
                DataController.inputData.currentDeviceName = undefined;
                DataController.inputData.inputDevices.splice(0, 1);

                DataController.inputData.currentJoypadJump = null;
                DataController.inputData.currentJoypadShoot = null;
                DataController.inputData.currentJoypadSpecial = null;

                updateJoypadConnector(DataController.inputData.joypadsAmount);

                unlistenForInputs();

                updateJoypadConnector(false);
            }
        }
    }*/

    /* LISTEN FOR INPUTS */
    /*private function listenForInputs():void
    {
        _jumpInputListener.addEventListener(MouseEvent.CLICK, putButton);
        _shootInputListener.addEventListener(MouseEvent.CLICK, putButton);
        _specialInputListener.addEventListener(MouseEvent.CLICK, putButton);
        _view.addEventListener(MouseEvent.CLICK, putButton);
    }

    *//* UNLISTEN FOR INPUTS *//*
    private function unlistenForInputs():void
    {
        _jumpInputListener.removeEventListener(MouseEvent.CLICK, putButton);
        _shootInputListener.removeEventListener(MouseEvent.CLICK, putButton);
        _specialInputListener.removeEventListener(MouseEvent.CLICK, putButton);
        _view.removeEventListener(MouseEvent.CLICK, putButton);
    }*/

    /* PUT BUTTON */
    private var _currentChange:MovieClip;
    /*private function putButton(e:MouseEvent):void
    {
        switch (e.target.name)
        {
            case INPUT_JUMP:
                    _jumpInputListener["tf"].text = PUSH_BUTTON;
                    if(DataController.inputData.currentJoypadShoot == null)_shootInputListener["tf"].text = NEED_CUSTOMIZE;
                    else                                                   _shootInputListener["tf"].text = DataController.inputData.currentJoypadShoot;
                    if(DataController.inputData.currentJoypadSpecial == null)_specialInputListener["tf"].text = NEED_CUSTOMIZE;
                    else                                                     _specialInputListener["tf"].text = DataController.inputData.currentJoypadSpecial;
                _currentChange = _jumpInputListener;
                listenJoypad();
                break;
            case INPUT_SHOOT:
                    _shootInputListener["tf"].text = PUSH_BUTTON;
                if(DataController.inputData.currentJoypadJump == null)_jumpInputListener["tf"].text = NEED_CUSTOMIZE;
                    else _jumpInputListener["tf"].text = DataController.inputData.currentJoypadJump;
                if(DataController.inputData.currentJoypadSpecial == null)_specialInputListener["tf"].text = NEED_CUSTOMIZE;
                    else _specialInputListener["tf"].text = DataController.inputData.currentJoypadSpecial;
                _currentChange = _shootInputListener;
                listenJoypad();
                break;
            case INPUT_SPECIAL:
                    _specialInputListener["tf"].text = PUSH_BUTTON;
                if(DataController.inputData.currentJoypadJump == null)_jumpInputListener["tf"].text = NEED_CUSTOMIZE;
                    else _jumpInputListener["tf"].text = DataController.inputData.currentJoypadJump;
                if(DataController.inputData.currentJoypadShoot == null)_shootInputListener["tf"].text = NEED_CUSTOMIZE;
                    else _shootInputListener["tf"].text = DataController.inputData.currentJoypadShoot;
                _currentChange = _specialInputListener;
                listenJoypad();
                break;
            default :
                if(DataController.inputData.currentJoypadSpecial == null)_specialInputListener["tf"].text = NEED_CUSTOMIZE;
                    else _specialInputListener["tf"].text = DataController.inputData.currentJoypadSpecial;
                if(DataController.inputData.currentJoypadJump == null)_jumpInputListener["tf"].text = NEED_CUSTOMIZE;
                    else _jumpInputListener["tf"].text = DataController.inputData.currentJoypadJump;
                if(DataController.inputData.currentJoypadShoot == null)_shootInputListener["tf"].text = NEED_CUSTOMIZE;
                    else _shootInputListener["tf"].text = DataController.inputData.currentJoypadShoot;
                _currentChange = null;
                unlistenJoypad();
                break;
        }
    }*/

    /* LISTEN JOYPAD */
    /*private function listenJoypad():void
    {
        for (var i:Number = 0; i < _inputDevice.numControls; i++)
        {
            var control:GameInputControl = _inputDevice.getControlAt(i);
            control.addEventListener(Event.CHANGE, controlChange);
        }
    }*/

    /* UNLISTEN JOYPAD */
    /*private function unlistenJoypad():void
    {
        for (var i:Number = 0; i < _inputDevice.numControls; i++)
        {
            var control:GameInputControl = _inputDevice.getControlAt(i);
            control.removeEventListener(Event.CHANGE, controlChange);
        }
    }*/

    /* CONTROL CHANGE */
    private function controlChange(e:Event):void
    {
        /*var control:GameInputControl = GameInputControl(e.target);
        trace(control.id, control.value);
        var str:String = control.id.substr(0, 7);
        if(str == JoypadMap.BUTTON && _currentChange)
        {
            // if button already used - removed from used
            (checkButtonForAlreadyUsed(control.id));
            switch (_currentChange)
            {
                case _jumpInputListener:
                        DataController.inputData.currentJoypadJump = control.id;
                        _jumpInputChecker.gotoAndStop(2);
                    break;
                case _shootInputListener:
                    DataController.inputData.currentJoypadShoot= control.id;
                        _shootInputChecker.gotoAndStop(2);
                    break;
                case _specialInputListener:
                    DataController.inputData.currentJoypadSpecial = control.id;
                        _specialInputChecker.gotoAndStop(2);
                    break;
            }
            _currentChange["tf"].text = control.id;
            unlistenJoypad();
        }*/

    }

    /* CHECK BUTTON FOR ALREADY USED */
    private function checkButtonForAlreadyUsed(id:String):void
    {
        if(id == DataController.inputData.currentJoypadJump)
        {
            DataController.inputData.currentJoypadJump = null;
            _jumpInputListener["tf"].text = NEED_CUSTOMIZE;
            _jumpInputChecker.gotoAndStop(1);
        }
        else if(id == DataController.inputData.currentJoypadShoot)
        {
            DataController.inputData.currentJoypadShoot = null;
            _shootInputListener["tf"].text = NEED_CUSTOMIZE;
            _shootInputChecker.gotoAndStop(1);
        }
        else if(id == DataController.inputData.currentJoypadSpecial)
        {
            DataController.inputData.currentJoypadSpecial = null;
            _specialInputListener["tf"].text = NEED_CUSTOMIZE;
            _shootInputChecker.gotoAndStop(1);
        }
    }





    /* UPDATE BUTTON STATE */
    private function updateButtonState(isActive:Boolean, btn:MovieClip):void
    {
        if(isActive)
        {
            btn.useHandCursor = true;
            btn.mouseChildren = false;
            btn.addEventListener(MouseEvent.CLICK, chooseController);
            btn.alpha = 1;
        }
        else
        {
            btn.useHandCursor = false;
            btn.mouseChildren = false;
            btn.removeEventListener(MouseEvent.CLICK, chooseController);
            btn.alpha = 0.5;
        }
    }

    /* MOUSE CLICK */
    private function mouseClick(e:MouseEvent):void
    {
        switch (e.target.name)
        {
            case CHOOSE_KEYBOARD:
                chooseController(CHOOSE_KEYBOARD);
                break;
            case CHOOSE_JOYPAD:
                chooseController(CHOOSE_JOYPAD);
                break;
        }
    }

    /* UPDATE NEXT SCREEN */
    public function updateNextScreen(nextScreen:AScreen):void
    {
        _nextScreen = nextScreen;
    }
}
}
