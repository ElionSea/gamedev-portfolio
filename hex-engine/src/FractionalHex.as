/**
 * Created by GAMES on 20.12.15.
 */
package
{
public class FractionalHex
{
    private var _q:Number, _r:Number, _s:Number;

    public function FractionalHex(q:Number, r:Number, s:Number)
    {
        _q = q;
        _r = r;
        _s = s;
    }

    public function get q():Number {return _q;}

    public function get r():Number {return _r;}

    public function get s():Number {return _s;}
}
}
