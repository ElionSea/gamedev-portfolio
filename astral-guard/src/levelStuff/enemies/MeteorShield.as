/**
 * Created by ElionSea on 24.10.14.
 */
package levelStuff.enemies
{
import custom.ClipLabel;

import data.DataController;

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.geom.Point;

import levelStuff.enemies.AEnemy;

import levelStuff.enemies.Trajectory;
import levelStuff.generators.EnemyGenerator;

import player.PlayerController;

public class MeteorShield extends AEnemy
    {
        public function MeteorShield(startX:Number, startY:Number, endX:Number, endY:Number, isEnemyBullet:Boolean=false, angle:Number=0, radius:Number=0, targetObj:MovieClip=null, mainScreen:Sprite=null, player:PlayerController=null)
        {
            var view:McMeteorShield = new McMeteorShield();
            var trajectory:Trajectory = new Trajectory(view, startX, startY, 0, Trajectory.AROUND_THE_POINT, 0, 0, 0, 0, angle, radius);
            var path:Vector.<Point> = new Vector.<Point>();
            path.push(null);
            super(startX, startY, 0, endX, endY, trajectory, 0, path, trajectory.trajectoryType, 0.2, 0.2, view, 500, false, false, false, player, null, false, null, false, null, 0, targetObj, false);
            clipLabels = new Vector.<ClipLabel>();
            clipLabels.push(new ClipLabel(ClipLabel.WALK, 1, 0.2));
        }
    }
}
