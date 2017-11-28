/**
 * Created by Sith on 01.09.14.
 */
package gui.inventory
{
import flash.display.MovieClip;

public class AItem implements IItem
{
    private var _view:MovieClip;
    private var _viewName:String;
    private var _sellCost:int;
    private var _buyCost:int;
    private var _value:Number;

    /*CONSTRUCTOR*/
    public function AItem(view:MovieClip, buyCost:int, viewName:String, value:Number)
    {
        _view = view;
        _buyCost = buyCost;
        // цена продажи - это всегда 20 % процентов от цены покупки
        _sellCost = int((_buyCost/100)*50);
        _viewName = viewName;
        _value = value;
        _view.name = _viewName;
        _view.gotoAndStop(viewName);

        _view.mouseChildren = false;
    }

    public function get view():MovieClip {return _view;}

    public function get sellCost():int {return _sellCost;}

    public function get buyCost():int {return _buyCost;}

    public function get viewName():String {return _viewName;}

    public function get value():Number {return _value;}
}
}
