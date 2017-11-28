/**
 * Created by Sith on 22.08.14.
 */
package levelStuff
{
import custom.ICustomMovieClip;

public interface IHittableByBullet extends ICustomMovieClip
{
    function set health(value:int):void
    function get health():int
    function get totalHealth():int
    function paralized():void
}
}
