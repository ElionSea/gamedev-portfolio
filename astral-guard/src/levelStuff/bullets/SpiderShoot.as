/**
 * Created by ElionSea on 29.03.15.
 */
package levelStuff.bullets
{
import custom.ClipLabel;

import data.DataController;

import flash.display.MovieClip;

import levelStuff.enemies.Trajectory;

public class SpiderShoot extends ABullet implements IBullet
{
    /*CONSTRUCTOR*/
    public function SpiderShoot(startX:Number, startY:Number, endX:Number, endY:Number, isEnemyBullet:Boolean=false, playerView:MovieClip=null)
    {
        clipLabels = new Vector.<ClipLabel>();
        clipLabels.push(new ClipLabel(ClipLabel.RUN, 1, 0.5));
        clipLabelByDefault = clipLabels[0];
        var view:McSpiderShoot = new McSpiderShoot();
        var trajectory:Trajectory = new Trajectory(view, startX, startY, 0, Trajectory.FLY_BY_ANGLE, 0, 0);
        super(view, startX, startY, 2.4, 70, endX, endY, isEnemyBullet, trajectory, null, false, true, false, null, false, null, true);
    }
}
}
