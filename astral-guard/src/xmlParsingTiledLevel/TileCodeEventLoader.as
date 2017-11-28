/**
 * Created by Sith on 13.03.14.
 */
package xmlParsingTiledLevel
{
import flash.display.Loader;

public class TileCodeEventLoader extends Loader
{
    private var _tileSet:TileSet;

    public function TileCodeEventLoader()
    {

    }

    public function get tileSet():TileSet {return _tileSet;}
    public function set tileSet(value:TileSet):void {_tileSet = value;}
}
}
