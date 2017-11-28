/**
 * Created by Sith on 24.06.14.
 */
package levelStuff.enemies
{
import custom.ClipLabel;
import custom.ICustomMovieClip;

import levelStuff.IHittableByBullet;
import compositepPattern.ISubController;

import player.MovableModel;

public interface IEnemy extends ICustomMovieClip, IHittableByBullet, ISubController
{
    function init():void
    function move():void
    function get isDeath():Boolean
    function set isDeath(value:Boolean):void
    function set clipLabels(labels:Vector.<ClipLabel>):void
    function get treasure():Array
    function hitCheckWithPlayer():void
    function get isContainEnemies():Boolean
    function get containEnemies():Array
    function get model():MovableModel
    function set isCanMove(value:Boolean):void
    function get isCanMove():Boolean
    function get isHitFist():Boolean
    function get isShootAfterDeath():Boolean
    function get classOfBulletOfShootAfterDeath():Class
    function get shootSound():String
    function fist():void
    function freeze():void
    function unfreeze():void
    function startPoisoning():void
    function slowing():void
    function colored(color:uint, tintAmount:Number, duration:Number=0.5):void
}
}
