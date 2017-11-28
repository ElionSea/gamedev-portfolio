/**
 * Created by ElionSea on 31.03.15.
 */
package levelStuff.bullets
{
import custom.ClipLabel;

import flash.display.MovieClip;

import levelStuff.enemies.Trajectory;

public class YetiShoot extends ABullet implements IBullet
{
    /*CONSTRUCTOR*/
    public function YetiShoot(startX:Number, startY:Number, endX:Number, endY:Number, isEnemyBullet:Boolean=false, playerView:MovieClip=null)
    {
        clipLabels = new Vector.<ClipLabel>();
        clipLabels.push(new ClipLabel(ClipLabel.RUN, 1, 0.5));
        clipLabelByDefault = clipLabels[0];
        var view:McYetiShoot = new McYetiShoot();
        var trajectory:Trajectory = new Trajectory(view, startX, startY, 0, Trajectory.VERTICAL_FALLING_DOWN, 0, 0);
        super(view, startX, startY, 3.3, 85, endX, endY, isEnemyBullet, trajectory, null, false, false, false, null, false, null, false);
    }
}
}
