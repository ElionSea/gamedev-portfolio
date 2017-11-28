/**
 * Created by ElionSea on 31.03.15.
 */
package levelStuff.bullets
{
import custom.ClipLabel;

import flash.display.MovieClip;

import levelStuff.enemies.Trajectory;

public class VolcanoGolemShoot extends ABullet implements IBullet
{
    /*CONSTRUCTOR*/
    public function VolcanoGolemShoot(startX:Number, startY:Number, endX:Number, endY:Number, isEnemyBullet:Boolean=false, playerView:MovieClip=null)
    {
        clipLabels = new Vector.<ClipLabel>();
        clipLabels.push(new ClipLabel(ClipLabel.RUN, 3, 0.5));
        clipLabelByDefault = clipLabels[0];
        var view:McVolcanoShoot = new McVolcanoShoot();
        var trajectory:Trajectory = new Trajectory(view, startX, startY, 0, Trajectory.FLY_BY_ANGLE, 0, 0);
        super(view, startX, startY, 2.5, 100, endX, endY, isEnemyBullet, trajectory, playerView, false, true);
    }
}
}
