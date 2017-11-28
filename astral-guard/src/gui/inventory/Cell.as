/**
 * Created by Sith on 31.08.14.
 */
package gui.inventory
{
import flash.display.MovieClip;
import flash.events.MouseEvent;

public class Cell
{
    private var _view:MovieClip;
    private var _content:IItem;
    private var _id:int;
    private var _count:int;

    /*CONSTRUCTOR*/
    public function Cell(id:int, view:MovieClip, count:int)
    {
        _id = id;
        _view = view;
        _count = count;

//        _view.mouseChildren = false;
    }

    public function get content():IItem {return _content;}
    public function set content(value:IItem):void {_content = value;}

    public function get view():MovieClip {return _view;}

    public function get id():int {return _id;}

    public function get count():int {return _count;}
}
}
