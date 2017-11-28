/**
 * Created by Sith on 28.07.14.
 */
package gui
{
import com.greensock.TweenLite;

import flash.display.Sprite;

public class ScaleBar extends Sprite
{
    private var _totalValue:int;
    private var _totalValueChanged:int;
    private var _view:Sprite;

    /*CONSTRUCTOR*/
    public function ScaleBar(totalValue:int, view:Sprite, isStartFull:Boolean=true)
    {
        _totalValue = totalValue;
        _totalValueChanged = totalValue;
        _view = view;
        addChild(_view);
        if(!isStartFull) _view.scaleX = 0;
    }

    /* UPDATE */
    public function update(newValue:int, isMinus:Boolean=false):void
    {
        var val:int;
        if(isMinus)
        {
            _totalValueChanged -= newValue;
            val = _totalValueChanged;
        }
        else        val = newValue;
        if(val > 0)
        {
            TweenLite.to(_view, 0.3, {scaleX:val/_totalValue});
        }
        else
        {
            TweenLite.to(_view, 0.3, {scaleX:0});
        }
    }

    public function get view():Sprite {return _view;}
}
}
