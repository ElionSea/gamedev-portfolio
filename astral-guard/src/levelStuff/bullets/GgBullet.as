/**
 * Created by Sith on 26.06.14.
 */
package levelStuff.bullets {
import custom.ClipLabel;
import custom.CustomMovieClip;

import data.DataController;

import flash.display.MovieClip;
import flash.display.Sprite;

import levelStuff.ScreenActors;

import levelStuff.enemies.Trajectory;

public class GgBullet extends ABullet implements IBullet
{
    public static const SMALL:int = 1;
    public static const MEDIUM:int = 2;
    public static const BIG:int = 3;
    public static const LARGE:int = 4;
    public static const HUGE:int = 5;

    public function GgBullet
            (
                shellSize:int,
                startX:Number,
                startY:Number,
                endX:Number,
                endY:Number,
                isEnemyBullet:Boolean=false,
                enemyView:MovieClip=null,
                color:int=1,
                trajectoryType:String=Trajectory.FLY_BY_ANGLE,
                followedByObject:MovieClip=null,
                mainScreen:Sprite=null
            )
    {
        clipLabels = ScreenActors.getClipLabelsByClassName(GgBullet);
        clipLabelByDefault = clipLabels[color-1];
        var view:MovieClip;
        switch(shellSize)
        {
            case 1:view = new McGgBullet01(); break;
            case 2:view = new McGgBullet02(); break;
            case 3:view = new McGgBullet03(); break;
            case 4:view = new McGgBullet04(); break;
            case 5:view = new McGgBullet05(); break;
        }
        view.gotoAndStop(color*2);
        var trajectory:Trajectory = new Trajectory(view, startX, startY, 0, trajectoryType, 0, 0);
        super(view, startX, startY, DataController.playerData.staff.speed, DataController.playerData.staff.damage, endX, endY, isEnemyBullet, trajectory, followedByObject, false, true, false, mainScreen, true, LightBulletMc);
    }
}
}
