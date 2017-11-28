/**
 * Created by Sith on 26.06.14.
 */
package levelStuff.bullets {
import custom.ClipLabel;
import custom.CustomMovieClip;

import data.DataController;

import flash.display.MovieClip;
import flash.display.Sprite;

import levelStuff.enemies.Trajectory;

public class RainbowShell extends ABullet implements IBullet
{
    public function RainbowShell(startX:Number, startY:Number, endX:Number, endY:Number, isEnemyBullet:Boolean=false, angle:Number=0, radius:Number=0, targetObj:MovieClip=null, mainScreen:Sprite=null)
    {
        clipLabels = new Vector.<ClipLabel>();
        clipLabels.push(new ClipLabel(ClipLabel.RUN, 1, 0.2));
        clipLabelByDefault = clipLabels[0];
        var view:McRainbowShell = new McRainbowShell();
        var trajectory:Trajectory = new Trajectory(view, startX, startY, 0, Trajectory.AROUND_THE_POINT, endX, endY, 1, 0, angle, radius);
        super(view, startX, startY, DataController.playerData.staff.speed, DataController.playerData.rainbowShellDamage, endX, endY, isEnemyBullet, trajectory,targetObj, false, true, false, mainScreen);
    }
}
}
