/**
 * Created by Sith on 31.08.14.
 */
package gui.inventory
{
import data.DataController;

import flash.display.DisplayObject;

import flash.display.MovieClip;
import flash.events.MouseEvent;

public class Inventory
{
    private var _view:MovieClip;
    private var _cells:Vector.<Cell>;
    private var _contents:Vector.<IItem>;
    private var _getItemCallback:Function;
    private var _id:int;
    private var _amountCells:int;
    private var _inventoryClass:Class;

    /*CONSTRUCTOR*/
    public function Inventory(id:int, view:MovieClip, content:Vector.<IItem>, getItemCallback:Function, inventoryClass:Class, amountCells:int=16)
    {
        _view = view;
        _contents = content;
        _getItemCallback = getItemCallback;
        _id = id;
        _amountCells = amountCells;
        _inventoryClass = inventoryClass;

        init();
    }

    /* INIT */
    private function init():void
    {
        // init cells
        _cells = new Vector.<Cell>();
        for (var i:int = 0; i < _amountCells; i++)
        {
            var cell:Cell = new Cell(_id, _view["cell_" + (i+1)], i);
            _cells.push(cell);
            if(i < _contents.length) cell.content = _contents[i];
            if(cell.content)
            {
                if(cell.content is _inventoryClass)
                {
                    cell.view.addChild(cell.content.view);
                }
            }
            cell.view.addEventListener(MouseEvent.CLICK, selectItem);
        }
    }

    /* HIDE NON AVAL CELLS */
    public function hideNonAvalCells():void
    {
        for (var i:int = 0; i < 5; i++)
        {
            var cell:MovieClip = _view["cell_" + (i+1)];
            if(i >= _amountCells) cell.visible = false;
        }
    }

    /* ADD CELL */
    public function addCell(cellIndex:int):void
    {
//        trace("ADD NEW CELL : " + cellIndex);
        var cell:Cell = new Cell(_id, _view["cell_" + (cellIndex+1)], cellIndex);
        _cells.push(cell);
        cell.view.visible = true;
        cell.view.addEventListener(MouseEvent.CLICK, selectItem);
    }

    /* UPDATE VIEW */
    public function updateView():void
    {

        for (var i:int = 0; i < _amountCells; i++)
        {
            if(i >= _cells.length)  addCell(i);
            var cell:Cell = _cells[i];
            if(i < _contents.length) cell.content = _contents[i];

            if(cell.view) // Очищаем ячейку от предыдущего контента
            {
                var amountChildren:int = cell.view.numChildren;

                for (var child:int=amountChildren; child > 1; child--)
                {
                    var view:DisplayObject = cell.view.getChildAt(child-1);
                    cell.view.removeChild(view);
                }
            }

            if(cell.content)
            {
                if(cell.content is _inventoryClass)
                {

                    cell.view.addChild(cell.content.view);
                }
            }
        }
    }

    /* ADD ITEM */
    public function addItem(cellIndex:int, cellContent:IItem):void
    {
        _contents[cellIndex] = cellContent;
        _cells[cellIndex].content = cellContent;
        _cells[cellIndex].view.addChild(cellContent.view);
    }

    /* REMOVE ITEM */
    public function removeItem(cellIndex:int, isRemoveView:Boolean=true):void
    {
        if(isRemoveView)_cells[cellIndex].view.removeChild(_cells[cellIndex].content.view);
        _contents[cellIndex] = null;
        _cells[cellIndex].content = null;
    }

    /* SELECT ITEM */
    private function selectItem(e:MouseEvent):void
    {
        var cellIndex:int = int(String(e.currentTarget.name).substr(5, e.currentTarget.name.length));
        _getItemCallback(_cells[cellIndex-1]);
    }

    /* GET EMPTY CELL */
    public function getEmptyCell():int
    {
        for each(var cell:Cell in _cells)
        {
            if(!cell.content) return _cells.indexOf(cell);
        }
        return -1;
    }

    /* DEACTIVATE */
    public function deactivate():void
    {
//        trace("INVENTORY : deactivated");
        for each(var cell:Cell in _cells)
        {
            cell.view.removeEventListener(MouseEvent.CLICK, selectItem);
        }
    }

    public function get contents():Vector.<IItem> {return _contents;}

    public function set amountCells(value:int):void {
        _amountCells = value;
    }
}
}
