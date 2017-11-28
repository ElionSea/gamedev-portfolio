/**
 * Created by ElionSea on 29.10.14.
 */
package levelStuff.bullets
{
import custom.ClipLabel;

import flash.display.MovieClip;

import levelStuff.enemies.Trajectory;

public class BossWinterSpecialShoot extends ABullet implements IBullet
{
    /*CONSTRUCTOR*/
    public function BossWinterSpecialShoot(startX:Number, startY:Number, endX:Number, endY:Number, isEnemyBullet:Boolean=false, enemyView:MovieClip=null)
    {
        clipLabels = new Vector.<ClipLabel>();
        clipLabels.push(new ClipLabel(ClipLabel.RUN, 1, 0.5));
        var view:McBossWinterSpecialShoot = new McBossWinterSpecialShoot();
        var trajectory:Trajectory = new Trajectory(view, startX, startY, 0, Trajectory.SNOWFLAKE, 0, 0);
        super(view, startX, startY, 2, 40, endX, endY, isEnemyBullet, trajectory, null, false, false, false, null, false, null, true);
    }
}
}
