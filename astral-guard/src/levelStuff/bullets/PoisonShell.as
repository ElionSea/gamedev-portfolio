/**
 * Created by Sith on 06.09.14.
 */
package levelStuff.bullets
{
import custom.ClipLabel;

import data.DataController;

import flash.display.MovieClip;

import levelStuff.enemies.Trajectory;

public class PoisonShell extends ABullet implements IBullet
{
    /*CONSTRUCTOR*/
    public function PoisonShell(startX:Number, startY:Number, endX:Number, endY:Number, isEnemyBullet:Boolean=false, playerView:MovieClip=null)
    {
        clipLabels = new Vector.<ClipLabel>();
        clipLabels.push(new ClipLabel(ClipLabel.RUN, 1, 0.5));
        var view:McPoisonShell = new McPoisonShell();
        var trajectory:Trajectory = new Trajectory(view, startX, startY, 0, Trajectory.FLY_BY_ANGLE, 0, 0);
        super(view, startX, startY, 3, 25, endX, endY, isEnemyBullet, trajectory, playerView, false);
    }
}
}
