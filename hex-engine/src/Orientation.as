/**
 * Created by GAMES on 26.12.15.
 */
package
{
/*
* Вспомогательный класс для хранения ориентации
* */
public class Orientation
{
    private var _f0:Number, _f1:Number, _f2:Number, _f3:Number;
    private var _b0:Number, _b1:Number, _b2:Number, _b3:Number;
    private var _startAngle:Number;

    public function Orientation(
            f0:Number, f1:Number, f2:Number, f3:Number,
            b0:Number, b1:Number, b2:Number, b3:Number,
            startAngle:Number)
    {
        _f0 = f0;
        _f1 = f1;
        _f2 = f2;
        _f3 = f3;
        _b0 = b0;
        _b1 = b1;
        _b2 = b2;
        _b3 = b3;
        _startAngle = startAngle;
    }

    /* POINTY LAYOUT
     * возвращает горизонтальную проекцию гекса */
    public static function pointyLayout():Orientation
    {
        return new Orientation(
                Math.sqrt(3), Math.sqrt(3)/2, 0, 3/2,
                Math.sqrt(3)/3, -1/3, 0, 2/3,
                0.5
        )
    }

    /* FLAT LAYOUT
     * возвращает вертикальную проекцию гекса */
    public static function flatLayout():Orientation
    {
        return new Orientation(
                3/2, 0, Math.sqrt(3)/2, Math.sqrt(3),
                2/3, 0, -1/3, Math.sqrt(3)/3,
                0
        )
    }

    public function get f0():Number {return _f0;}

    public function get f1():Number {return _f1;}

    public function get f2():Number {return _f2;}

    public function get f3():Number {return _f3;}

    public function get b0():Number {return _b0;}

    public function get b1():Number {return _b1;}

    public function get b2():Number {return _b2;}

    public function get b3():Number {return _b3;}

    public function get startAngle():Number {return _startAngle;}
}
}
