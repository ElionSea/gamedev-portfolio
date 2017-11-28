/**
 * Created by Sith on 24.07.14.
 */
package
{
import flash.display.Sprite;
import starling.core.Starling;


public class StarlingMain extends Sprite
{
    private var _myStarling:Starling;

    /*CONSTRUCTOR*/
    public function StarlingMain()
    {
        _myStarling = new Starling(Platformer, stage);
        _myStarling.antiAliasing = 1;
        _myStarling.start();
    }
}
}
