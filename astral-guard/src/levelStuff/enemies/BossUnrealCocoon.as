/**
 * Created by ElionSea on 29.10.14.
 */
package levelStuff.enemies
{
import custom.ClipLabel;

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.geom.Point;

import player.PlayerController;

public class BossUnrealCocoon extends AEnemy
{
    /*CONSTRUCTOR*/
    public function BossUnrealCocoon(startX:Number, startY:Number, endX:Number, endY:Number, isEnemyBullet:Boolean=false, targetObj:MovieClip=null, mainScreen:Sprite=null, player:PlayerController=null, internalEnemies:Array=null)
    {
        var view:McCocoon = new McCocoon();
        var trajectory:Trajectory = new Trajectory(view, startX, startY, 0, Trajectory.FLY_TO_PLAYER, 0, 0, 0, 0);
        var path:Vector.<Point> = new Vector.<Point>();
        path.push(null);
        super(startX, startY, 0, endX, endY, trajectory, 0, path, trajectory.trajectoryType, 0.2, 0.2, view, 25, false, false, false, player, null, true, internalEnemies, false, null, 0, targetObj, false);
        clipLabels = new Vector.<ClipLabel>();
        clipLabels.push(new ClipLabel(ClipLabel.WALK, 4, 0.4));
    }
}
}
