/**
 * Created by Sith on 22.08.14.
 */
package levelStuff.bullets
{
import custom.ClipLabel;

import data.DataController;

import flash.display.MovieClip;
import flash.geom.Point;

import levelStuff.enemies.Trajectory;

public class DesertLaser extends ABullet implements IBullet
{
    private var _glueView:MovieClip;

    /*CONSTRUCTOR*/
    public function DesertLaser(startX:Number, startY:Number, endX:Number, endY:Number, isEnemyBullet:Boolean=false, glueView:MovieClip=null)
    {
        _glueView = glueView;
        clipLabels = new Vector.<ClipLabel>();
        clipLabels.push(new ClipLabel(ClipLabel.BORN, 1, 0.5));
        clipLabels.push(new ClipLabel(ClipLabel.RUN, 1, 0.5));
        var view:McDesertLaser = new McDesertLaser();
        var height:Number = Math.abs(startY - endY);
        var scaleHeight:Number = height/10;
        view["internalView"].scaleY = scaleHeight;
        view["hitBox"].scaleY = scaleHeight;
        var laserEnd:MovieClip = view["laserEnd"];
        laserEnd.x = 0;
        laserEnd.y =  view["internalView"].height-5;
        view.addChild(laserEnd);
        var trajectory:Trajectory = new Trajectory(view, startX, startY, 0, Trajectory.GLUE_TO_POINT, 0, 0);
        super(view, startX, startY, 3.5, 3, endX, endY, isEnemyBullet, trajectory, null, false, false, true);
    }

    /* MOVE */
    public override function move():void
    {
        isDamaged = true;
        _trajectory.move(0, 0, new Point(_glueView.x, _glueView.y-10));
    }
}
}
