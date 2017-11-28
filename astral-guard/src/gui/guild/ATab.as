/**
 * Created by Sith on 31.08.14.
 */
package gui.guild
{
import data.PlayerData;

import flash.display.Sprite;

import popup.PopupController;

public class ATab implements ITab
{
    protected var _view:Sprite;
    protected var _data:PlayerData;
    protected var _name:String;
//    protected var _isFirstShow:Boolean;

    /*CONSTRUCTOR*/
    public function ATab(name:String, view:Sprite, playerData:PlayerData)
    {
        _name = name;
        _view = view;
        _data = playerData;
    }

    public function updateView():void
    {

    }

    public function get selectedItemName():String{ return null; }

    public function get view():Sprite {return _view;}

    public function get name():String {return _name;}

    public function deselect():void{}

    public function deactivate():void{}
    public function loop():void{}
}
}
