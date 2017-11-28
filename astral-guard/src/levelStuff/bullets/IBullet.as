/**
 * Created by Sith on 26.06.14.
 */
package levelStuff.bullets
{
import custom.ClipLabel;
import custom.ICustomMovieClip;

import flash.display.MovieClip;

import levelStuff.IMovable;
import compositepPattern.ISubController;

public interface IBullet extends ICustomMovieClip, IMovable, ISubController
{
    function get isDamaged():Boolean
    function set isDamaged(value:Boolean):void
    function get bulletDamage():int
    function set isDied(bool:Boolean):void
    function get isDied():Boolean
    function get isEnemyBullet():Boolean
    function get isLaser():Boolean
    function get isParalized():Boolean
    function initTargetObj(targetObject:MovieClip):void
    function set clipLabelByDefault(clipLabelName:ClipLabel):void
    function get clipLabelByDefault():ClipLabel
}
}
