/**
 * Created by Sith on 22.08.14.
 */
package levelStuff.bullets
{
import custom.ClipLabel;

import data.DataController;

import flash.display.MovieClip;

import levelStuff.enemies.Trajectory;

public class BossVolcanoShoot extends ABullet implements IBullet
{
    /*CONSTRUCTOR*/
    public function BossVolcanoShoot(startX:Number, startY:Number, endX:Number, endY:Number, isEnemyBullet:Boolean=false, enemyView:MovieClip=null)
    {
        clipLabels = new Vector.<ClipLabel>();
        clipLabels.push(new ClipLabel(ClipLabel.RUN, 3, 0.25));
        var view:McVolcanoBossShoot = new McVolcanoBossShoot();
        var trajectory:Trajectory = new Trajectory(view, startX, startY, 0, Trajectory.VERTICAL_FALLING_DOWN, 0, 0);
        super(view, startX, startY, 3.5, 60, endX, endY, isEnemyBullet, trajectory, null, false, false, false, null);
    }
}
}
