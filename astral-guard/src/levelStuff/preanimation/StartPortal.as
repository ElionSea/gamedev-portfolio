/**
 * Created by Sith on 10.09.14.
 */
package levelStuff.preanimation
{
import custom.ClipLabel;
import custom.CustomMovieClip;

import player.MovableModel;

public class StartPortal extends CustomMovieClip
{
    /*CONSTRUCTOR*/
    public function StartPortal()
    {
        clipLabels = new Vector.<ClipLabel>();
        clipLabels.push(new ClipLabel(ClipLabel.SHOW, 9, 0.25));
        clipLabels.push(new ClipLabel(ClipLabel.WALK, 11, 0.5));
        clipLabels.push(new ClipLabel(ClipLabel.HIDE, 9, 0.25));
        super(StartPortal, new MovableModel(), new McPortal());
    }
}
}
