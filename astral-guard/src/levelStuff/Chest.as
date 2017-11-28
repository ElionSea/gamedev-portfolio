/**
 * Created by Sith on 15.08.14.
 */
package levelStuff
{
import custom.ClipLabel;
import custom.CustomMovieClip;
import custom.ICustomMovieClip;

import flash.display.MovieClip;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.utils.Timer;

import levelStuff.enemies.AEnemy;

import levelStuff.enemies.IEnemy;
import levelStuff.enemies.Trajectory;
import levelStuff.enemies.Trajectory;

import player.MovableModel;

public class Chest extends AEnemy implements IEnemy, IHittableByBullet
{
    private var _internalView:MovieClip;
    private var _warning:McChestWarning;
    private var _warningTimer:Timer;

    /*CONSTRUCTOR*/
    public function Chest(x:Number, y:Number, endPoint:Point, treasure:Array)
    {
        _warning = new McChestWarning();
        var view:McChest = new McChest();
        clipLabels = new Vector.<ClipLabel>();
        clipLabels.push(new ClipLabel(ClipLabel.WALK, 9, 0.5));
        var trajectory:Trajectory = new Trajectory(view, x, y, 0, Trajectory.SINUS, 1, 1, 30);
        var path:Vector.<Point> = new Vector.<Point>();
        var randomSpeedX:Number = (Math.random())+1;
        var randomSpeedY:Number = (Math.random())+1;
        path.push(endPoint);
        super(x, y, 0, view.width, view.height, trajectory, 1, path, null, randomSpeedX, randomSpeedY, view, 5, false, false, false, null, null, false, null);

        super.treasure = treasure;



        _internalView = _view["internalView"];
        _internalView.gotoAndStop(Math.ceil(Math.random()*4));
    }

    /* DEACTIVATE */
    public override function deactivate():void
    {
        super.deactivate();
    }

    public function get warning():McChestWarning {return _warning;}

    public function get warningTimer():Timer {
        return _warningTimer;
    }

    public function set warningTimer(value:Timer):void {
        _warningTimer = value;
    }

    public override function paralized():void {
    }
}
}
