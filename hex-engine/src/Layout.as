/**
 * Created by GAMES on 20.12.15.
 */
package
{
import flash.geom.Point;

public class Layout
{
    private var _orientation:Orientation;
    private var _size:Point;
    private var _origin:Point;

    public function Layout(orientation:Orientation, size:Point, origin:Point)
    {
        _orientation = orientation;
        _size = size;
        _origin = origin;
    }

    /* HEX TO PIXEL
     * определяет координаты гекса */
    public static function hexToPixel(layout:Layout, h:Hex):Point
    {
        var o:Orientation = layout.orientation;
        var x:Number = (o.f0 * h.q + o.f1 * h.r) * layout.size.x;
        var y:Number = (o.f2 * h.q + o.f3 * h.r) * layout.size.y;
        return new Point(x + layout.origin.x, y + layout.origin.y);
    }

    /* PIXEL TO HEX */
    public static function pixelToHex(layout:Layout, p:Point):FractionalHex
    {
        var o:Orientation = layout.orientation;
        var pt:Point = new Point((p.x - layout.origin.x) / layout.size.x,
                     (p.y - layout.origin.y) / layout.size.y);
        var q:Number = o.b0 * pt.x + o.b1 * pt.y;
        var r:Number = o.b2 * pt.x + o.b3 * pt.y;
        return new FractionalHex(q, r, -q - r);
    }

    /* HEX ROUND */
    public static function hexRound(h:FractionalHex):Hex
    {
        //trace("=====================");
        //trace("FRACTIONAL: " + h.q +  ", "+ h.r +  ", "+ h.s);
        var q:int = int(Math.round(h.q));
        var r:int = int(Math.round(h.r));
        var s:int = int(Math.round(h.s));
        var qDiff:Number = Math.abs(q - h.q);
        var rDiff:Number = Math.abs(r - h.r);
        var sDiff:Number = Math.abs(s - h.s);
        if(qDiff > rDiff && qDiff > sDiff) q = -r-s;
        else if(rDiff > sDiff) r = -q-s;
        else s = -q-r;
        var newHex:Hex = new Hex(q, r, s);
        //trace("HEX : " + newHex.q +  ", "+ newHex.r +  ", "+ newHex.s);
        return newHex;
    }

    /* HEX CORNER OFFSET */
    public static function hexCornerOffset(layout:Layout, corner:int):Point
    {
        var size:Point = layout.size;
        var angle:Number = 2 * Math.PI * (corner + layout.orientation.startAngle)/6;
        return new Point(size.x * Math.cos(angle), size.y * Math.sin(angle));
    }

    /* POLYGON CORNERS */
    public static function polygonCorners(layout:Layout, h:Hex):Vector.<Point>
    {
        var corners:Vector.<Point> = new Vector.<Point>();
        var center:Point = hexToPixel(layout, h);
        for(var i:int=0; i < 6; i++)
        {
            var offset:Point = hexCornerOffset(layout, i);
            corners.push(new Point(
                    center.x + offset.x,
                    center.y + offset.y));
        }
        return corners;
    }

    public function get orientation():Orientation {return _orientation;}

    public function get size():Point {return _size;}

    public function get origin():Point {return _origin;}
}
}
