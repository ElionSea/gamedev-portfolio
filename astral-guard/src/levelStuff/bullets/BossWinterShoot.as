/**
 * Created by Sith on 22.08.14.
 */
package levelStuff.bullets
{
import custom.ClipLabel;

import data.DataController;

import flash.display.MovieClip;

import levelStuff.enemies.Trajectory;

public class BossWinterShoot extends ABullet implements IBullet
{
    /*CONSTRUCTOR*/
    public function BossWinterShoot(startX:Number, startY:Number, endX:Number, endY:Number, isEnemyBullet:Boolean=false, enemyView:MovieClip=null)
    {
        clipLabels = new Vector.<ClipLabel>();
        clipLabels.push(new ClipLabel(ClipLabel.RUN, 1, 0.5));
        var view:McBossWinterShoot = new McBossWinterShoot();
        var trajectory:Trajectory = new Trajectory(view, startX, startY, 0, Trajectory.FLY_BY_ANGLE, 0, 0);
        super(view, startX, startY, 2.3, 35, endX, endY, isEnemyBullet, trajectory, null, false);
    }
}
}
