/**
 * Created by ElionSea on 28.10.14.
 */
package levelStuff.bullets
{
import custom.ClipLabel;

import flash.display.MovieClip;

import levelStuff.enemies.Trajectory;

public class BossVolcanoSpecialShoot extends ABullet implements IBullet
{
    /*CONSTRUCTOR*/
    public function BossVolcanoSpecialShoot(startX:Number, startY:Number, endX:Number, endY:Number, isEnemyBullet:Boolean=false, enemyView:MovieClip=null)
    {
        clipLabels = new Vector.<ClipLabel>();
        clipLabels.push(new ClipLabel(ClipLabel.RUN, 1, 0.5));
        var view:McBossVolcanoSpecialShoot = new McBossVolcanoSpecialShoot();
        var trajectory:Trajectory = new Trajectory(view, startX, startY, 0, Trajectory.FLY_BY_ANGLE, 0, 0);
        super(view, startX, startY, 0.7, 20, endX, endY, isEnemyBullet, trajectory, null, false, false, false, null);

    }
}
}
