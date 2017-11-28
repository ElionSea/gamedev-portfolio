/**
 * Created by Sith on 06.09.14.
 */
package levelStuff.bullets
{
import custom.ClipLabel;

import data.DataController;

import flash.display.MovieClip;

import levelStuff.enemies.Trajectory;

public class FallingCastleCeil extends ABullet implements IBullet
{
    /*CONSTRUCTOR*/
    public function FallingCastleCeil(startX:Number, startY:Number, endX:Number, endY:Number, isEnemyBullet:Boolean=false, playerView:MovieClip=null)
    {
        clipLabels = new Vector.<ClipLabel>();
        clipLabels.push(new ClipLabel(ClipLabel.RUN, 1, 0.5));
        var view:McFallingCastleShell = new McFallingCastleShell();
        var trajectory:Trajectory = new Trajectory(view, startX, startY, 0, Trajectory.VERTICAL_FALLING_DOWN, 0, 0);
        super(view, startX, startY, 3, 60, endX, endY, isEnemyBullet, trajectory, playerView, true, false);
    }
}
}
