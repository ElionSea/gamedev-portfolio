/**
 * Created by Sith on 09.08.14.
 */
package gui.guild.academy
{
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.MouseEvent;

/* общая структура для исследований, построек зданий и наёма юнитов. В общем любые действия, требующие определённых ресурсов */
public class Action
{
    private var _type:String;
    private var _name:String;
    private var _cost:int;
    private var _isAval:Boolean;
    private var _isExplored:Boolean;
    private var _color:uint;
    private var _value:int;

    protected var _warning:String = "";

    protected var _callbackAction:Function;
    protected var _view:MovieClip;

    public static const IS_EXPLORED:String = "explored";
    public static const IS_AVALIABLE:String = "aval";
    public static const IS_NON_AVAL:String = "nonAval";

    /*CONSTRUCTOR*/
    public function Action(name:String, cost:int, isAval:Boolean, isExplored:Boolean, color:uint, value:int)
    {
        _name = name;
        _cost = cost;
        _isAval = isAval;
        _isExplored = isExplored;
        _color = color;
        _value = value;
    }

    /* INIT VIEW */
    public function initView(view:MovieClip, callbackAction:Function):void
    {
        _view = view;

        _callbackAction = callbackAction;

        updateView();

        if(!_view.hasEventListener(MouseEvent.CLICK)) _view.addEventListener(MouseEvent.CLICK, onClick);
    }

    /* ON CLICK */
    protected function onClick(e:MouseEvent):void
    {
        if(!isExplored)
        {
            if(isAval)
            {
//                _view.removeEventListener(MouseEvent.CLICK, onClick);
                _callbackAction(this);
            }
        }
        updateView();
    }

    /* UPDATE VIEW */
    public function updateView():void
    {
        // если доступно
        if(_isAval)
        {
            // если исследовано
            if(_isExplored)  _view.gotoAndStop(IS_EXPLORED);
            else             _view.gotoAndStop(IS_AVALIABLE);
        }
        else                 _view.gotoAndStop(IS_NON_AVAL);
    }

    /* DEACTIVATE */
    public function deactivate():void
    {
        _view.removeEventListener(MouseEvent.CLICK, onClick);
    }

    public function get isExplored():Boolean {return _isExplored;}
    public function set isExplored(value:Boolean):void
    {
        _isExplored = value;
        if(_view) updateView();
    }

    public function get isAval():Boolean {return _isAval;}
    public function set isAval(value:Boolean):void
    {
        _isAval = value;
        if(_view) updateView();
    }

    public function get cost():int {return _cost;}
    public function set cost(value:int):void {_cost = value;}

    public function get name():String {return _name;}
    public function set name(value:String):void {_name = value;}

    public function get type():String {return _type;}

    public function get warning():String {return _warning;}

    public function get color():uint {return _color;}

    public function get value():int {return _value;}
    public function set value(value:int):void {_value = value;}
}
}
