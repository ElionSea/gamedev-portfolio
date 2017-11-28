/**
 * Created by Sith on 01.04.14.
 */
package levels
{
import flash.display.Sprite;

public class LevelPart extends Sprite
    {
        private var _units:Vector.<Object>;
        private var _view:Sprite;

        public function LevelPart(view:Sprite)
        {
            _view = view;
            addChild(_view);
        }

    public function get view():Sprite {return _view;}
}
}
