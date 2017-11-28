/**
 * Created by Sith on 22.08.14.
 */
package levelStuff.bullets
{
import custom.ClipLabel;

import data.DataController;

import flash.display.MovieClip;

import levelStuff.enemies.Trajectory;

public class BossCastleShell extends ABullet implements IBullet
{
    /*CONSTRUCTOR*/
    public function BossCastleShell(startX:Number, startY:Number, endX:Number, endY:Number, isEnemyBullet:Boolean=false, enemyView:MovieClip=null)
    {
        clipLabels = new Vector.<ClipLabel>();
        clipLabels.push(new ClipLabel(ClipLabel.BORN, 1, 0.5));
        clipLabels.push(new ClipLabel(ClipLabel.RUN, 3, 0.5));
        var view:McBossCastleShell = new McBossCastleShell();
        var trajectory:Trajectory = new Trajectory(view, startX, startY, 0, Trajectory.FLY_BY_ANGLE, 0, 0);
        super(view, startX, startY, 3.5, 25, endX, endY, isEnemyBullet, trajectory, null, false, false);
    }
}
}
