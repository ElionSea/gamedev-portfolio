/**
 * Created by Sith on 06.09.14.
 */
package levelStuff.bullets
{
import custom.ClipLabel;

import data.DataController;

import flash.display.MovieClip;

import levelStuff.enemies.Trajectory;

public class CrownShell extends ABullet implements IBullet
{
    /*CONSTRUCTOR*/
    public function CrownShell(startX:Number, startY:Number, endX:Number, endY:Number, isEnemyBullet:Boolean=false, playerView:MovieClip=null)
    {
        clipLabels = new Vector.<ClipLabel>();
        clipLabels.push(new ClipLabel(ClipLabel.RUN, 1, 0.5));
        clipLabelByDefault = clipLabels[0];
        var view:McCrownShell = new McCrownShell();
        var trajectory:Trajectory = new Trajectory(view, startX, startY, 0, Trajectory.FLY_BY_ANGLE, 0, 0);
        super(view, startX, startY, 3, DataController.playerData.crownShellDamage, endX, endY, isEnemyBullet, trajectory, playerView, true);
    }
}
}
