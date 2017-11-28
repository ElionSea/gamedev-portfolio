/**
 * Created by Sith on 12.07.14.
 */
package levelStuff.pathTrigger
{
import flash.display.Shape;
import flash.display.Sprite;
import flash.geom.Point;

public class PathTrigger extends Sprite
{
    private var _view:Sprite;
    private var _count:int;
    private var _center:Point;

    public function PathTrigger(count:int, x:Number, y:Number, width:Number, height:Number)
    {
        _count = count;
        drawView(x, y, width, height);
    }

    /* DRAW VIEW */
    private function drawView(x:Number, y:Number, width:Number, height:Number):void
    {
        var shape:Shape = new Shape();
        shape.graphics.beginFill(0xFF00FF, 0.3);
        shape.graphics.drawRect(0, 0, width, height);
        shape.graphics.endFill();
        _view = new Sprite();
        _view.addChild(shape);
        _view.x = x;
        _view.y = y;

        _center = new Point(x+_view.width/2, y+_view.height/2)
    }

    public function get count():int {return _count;}

    public function get center():Point {return _center;}

    public function get view():Sprite {return _view;}
}
}
