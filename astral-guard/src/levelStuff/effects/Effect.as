/**
 * Created by Sith on 16.07.14.
 */
package levelStuff.effects
{
import custom.CustomMovieClip;

import flash.display.MovieClip;

import player.MovableModel;

public class Effect extends CustomMovieClip implements IEffect
{
    private var _model:MovableModel;

    public function Effect(view:MovieClip, x:Number, y:Number, height:Number=0, width:Number=0)
    {
        super(this, _model, view, x, y, height, width);
        view.stop();
    }
}
}
