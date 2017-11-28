/**
 * Created by Sith on 17.08.14.
 */
package levelStuff
{
import flash.display.MovieClip;
import flash.display.Shape;
import flash.geom.Point;

public class Portal
{
    private var _view:MovieClip;
    private var _count:int;
    private var _id:int;
    private var _center:Point;
    private var _output:Portal;

    /*CONSTRUCTOR*/
    public function Portal(id:int, count:int, x:Number, y:Number, width:Number, height:Number)
    {
        _id = id;
        _count = count;
        drawView(x, y, width, height);
    }

    /* DRAW VIEW */
    private function drawView(x:Number, y:Number, width:Number, height:Number):void
    {
        var shape:Shape = new Shape();
        shape.graphics.beginFill(0xFF0000, 0.3);
        shape.graphics.drawRect(0, 0, width, height);
        shape.graphics.endFill();
        _view = new MovieClip();
        _view.addChild(shape);
        _view.x = x;
        _view.y = y;

        _center = new Point(_view.width/2, _view.height/2);
    }

    public function get id():int {return _id;}

    public function get view():MovieClip {return _view;}

    public function get count():int {return _count;}

    public function get center():Point {return _center;}

    public function get output():Portal {
        return _output;
    }

    public function set output(value:Portal):void {
        _output = value;
    }
}
}
