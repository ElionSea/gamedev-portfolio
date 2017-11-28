/**
 * Created by Sith on 22.08.14.
 */
package levels.bg
{
import custom.ClipLabel;
import custom.CustomMovieClip;

import flash.display.MovieClip;

import player.MovableModel;

public class BgVolcano extends CustomMovieClip
{
    /*CONSTRUCTOR*/
    public function BgVolcano(x:Number, y:Number, height:Number, width:Number)
    {
        var view:MovieClip = new McVolcanoBG();
        var model:MovableModel = new MovableModel();
        clipLabels = new Vector.<ClipLabel>();
        clipLabels.push(new ClipLabel(ClipLabel.WALK, 40, 2));
        super(this, model, view, x, y, height, width);
        addChild(view);
        playState(ClipLabel.WALK);
    }
}
}
