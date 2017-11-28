/**
 * Created by Sith on 06.09.14.
 */
package levelStuff.spell
{
import custom.ClipLabel;
import custom.CustomMovieClip;

import flash.display.MovieClip;
import flash.events.FullScreenEvent;
import flash.geom.Point;

import levelStuff.IHittableByBullet;

import levelStuff.IMovable;
import levelStuff.enemies.Trajectory;

import player.MovableModel;

public class Fist extends CustomMovieClip implements IMovable, IHittableByBullet
{
    private var _trajectory:Trajectory;
    private var _playerView:MovieClip;

    private var _health:int;
    private var _totalHealth:int;

    private var _fistDeathCallback:Function;

    /*CONSTRUCTOR*/
    public function Fist(playerView:MovieClip, fistHealth:int, fistDeathCallback:Function)
    {
        _playerView = playerView;
        _health = fistHealth;
        _totalHealth = fistHealth;
        _fistDeathCallback = fistDeathCallback;
        var view:McFist = new McFist();
        _trajectory = new Trajectory(view, 0, 0, 0, Trajectory.GLUE_TO_POINT, 0, 0);
        clipLabels = new Vector.<ClipLabel>();
        clipLabels.push(new ClipLabel(ClipLabel.WALK, 1, 0.2));
        super(this, new MovableModel(), view);
    }

    /* MOVE */
    public function move():void
    {
        _trajectory.move(0, 0, new Point(_playerView.x, _playerView.y));
    }

    public function get health():int {return _health;}
    public function set health(value:int):void
    {
        if(value < 0)
        {
            value = 0;
            _fistDeathCallback();
            return;
        }
        else
        {
            _view.alpha = (value/_totalHealth);
        }
        _health = value;
    }

    public function get totalHealth():int {
        return _totalHealth;
    }

    public function paralized():void {
    }
}
}
