/**
 * Created by Sith on 11.06.14.
 */
package inputControllers
{
import custom.CustomEvent;

import data.DataController;

import flash.display.Sprite;
import flash.events.MouseEvent;

import compositepPattern.ISubController;

import player.*;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.GameInputEvent;
import flash.events.KeyboardEvent;
import flash.ui.GameInput;
import flash.ui.Keyboard;
import flash.utils.setTimeout;

public class KeyboardController implements IInputController
{
    private var _playerModel:MovableModel;

    private var _left:int;
    private var _right:int;
    private var _up:int;
    private var _down:int;
    private var _shoot:int;
    private var _jump:int;

    private var _stage:Stage;

    public function KeyboardController(playerModel:MovableModel, stage:Stage)
    {
        _playerModel = playerModel;
        _stage = stage;

        var curMap:KeyboardMap = DataController.inputData.currentKeyboardMap;
        if(curMap == null)
        {
            DataController.inputData.currentKeyboardMap = new KeyboardMap(KeyboardMap.ARROWS_CONTROLLS);
            curMap = DataController.inputData.currentKeyboardMap;
        }

        _left = curMap.left;
        _down = curMap.down;
        _right = curMap.right;
        _up = curMap.up;
        _shoot = curMap.shoot;
        _jump = curMap.jump;

        _stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        _stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
    }

    /* ON KET DOWN */
    private function onKeyDown(e:KeyboardEvent):void
    {
        if(e.keyCode == _left || e.keyCode == Keyboard.A || e.keyCode == Keyboard.LEFT)
        {
            _playerModel.isLeft = true;
        }
        if(e.keyCode == _jump || e.keyCode == Keyboard.W || e.keyCode == Keyboard.UP)
        {
            _stage.dispatchEvent(new CustomEvent(CustomEvent.JUMP));
        }
        if(e.keyCode == _right || e.keyCode == Keyboard.D || e.keyCode == Keyboard.RIGHT)
        {
            _playerModel.isRight = true;
        }
        if(e.keyCode == _down)
        {
            _playerModel.isDown = true;
        }
    }

    /* ON KET UP */
    private function onKeyUp(e:KeyboardEvent):void
    {
        if(e.keyCode == _left || e.keyCode == Keyboard.A || e.keyCode == Keyboard.LEFT)
        {
            _playerModel.isLeft = false;
        }
        if(e.keyCode == _right || e.keyCode == Keyboard.D || e.keyCode == Keyboard.RIGHT)
        {
            _playerModel.isRight = false;
        }
    }

    /* DEACTIVATE */
    public function deactivate():void
    {
        _stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        _stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
    }

    public function loop():void{}
}
}
