/**
 * Created by ElionSea on 29.10.14.
 */
package levelStuff.bullets
{
import custom.ClipLabel;

import flash.display.MovieClip;

import levelStuff.enemies.Trajectory;

public class BossUnrealShoot extends ABullet implements IBullet
{
    /*CONSTRUCTOR*/
    public function BossUnrealShoot(startX:Number, startY:Number, endX:Number, endY:Number, isEnemyBullet:Boolean=false, enemyView:MovieClip=null)
    {
        clipLabels = new Vector.<ClipLabel>();
        clipLabels.push(new ClipLabel(ClipLabel.RUN, 1, 0.5));
        var view:McBossUnrealShoot = new McBossUnrealShoot();
        var trajectory:Trajectory = new Trajectory(view, startX, startY, 0, Trajectory.FLY_BY_ANGLE, 0, 0);
        super(view, startX, startY, 3.5, 30, endX, endY, isEnemyBullet, trajectory, null, false, false, false, null);
    }
}
}
