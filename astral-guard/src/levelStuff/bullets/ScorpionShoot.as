/**
 * Created by Sith on 22.08.14.
 */
package levelStuff.bullets
{
import custom.ClipLabel;
import flash.display.MovieClip;
import levelStuff.enemies.Trajectory;

public class ScorpionShoot extends ABullet implements IBullet
{
    /*CONSTRUCTOR*/
    public function ScorpionShoot(startX:Number, startY:Number, endX:Number, endY:Number, isEnemyBullet:Boolean=false, enemyView:MovieClip=null)
    {
        clipLabels = new Vector.<ClipLabel>();
        clipLabels.push(new ClipLabel(ClipLabel.BORN, 1, 0.5));
        clipLabels.push(new ClipLabel(ClipLabel.RUN, 3, 0.5));
        var view:McScorpionShoot = new McScorpionShoot();
        var trajectory:Trajectory = new Trajectory(view, startX, startY, 0, Trajectory.FLY_BY_ANGLE, 0, 0);
        super(view, startX, startY, 2, 65, endX, endY, isEnemyBullet, trajectory, null, false, true);
    }
}
}
