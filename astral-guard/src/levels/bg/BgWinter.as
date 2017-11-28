/**
 * Created by Sith on 26.08.14.
 */
package levels.bg
{
import custom.ClipLabel;
import custom.CustomMovieClip;

import flash.display.MovieClip;

import player.MovableModel;

public class BgWinter extends CustomMovieClip
{
    /*CONSTRUCTOR*/
    public function BgWinter(x:Number, y:Number, height:Number, width:Number)
    {
        var view:MovieClip = new McWinterBg();
        var model:MovableModel = new MovableModel();
        clipLabels = new Vector.<ClipLabel>();
        clipLabels.push(new ClipLabel(ClipLabel.WALK, 1, 1));
        super(this, model, view, x, y, height, width);
        addChild(view);
        playState(ClipLabel.WALK);
    }
}
}
