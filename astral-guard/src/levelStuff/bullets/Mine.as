/**
 * Created by Sith on 07.09.14.
 */
package levelStuff.bullets
{
import custom.ClipLabel;

import data.DataController;

import flash.display.MovieClip;

import levelStuff.enemies.Trajectory;

public class Mine  extends ABullet implements IBullet
{
    /*CONSTRUCTOR*/
    public function Mine(startX:Number, startY:Number, endX:Number, endY:Number, isEnemyBullet:Boolean=false, playerView:MovieClip=null)
    {
        clipLabels = new Vector.<ClipLabel>();
        clipLabels.push(new ClipLabel(ClipLabel.RUN, 1, 0.5));
        clipLabelByDefault = clipLabels[0];
        var view:McMine = new McMine();
        var trajectory:Trajectory = new Trajectory(view, startX, startY, 0, Trajectory.STATIC, 0, 0);
        super(view, startX, startY, 0, DataController.playerData.mineDamage, 0, 0, isEnemyBullet, trajectory, playerView, false, false);
    }
}
}
