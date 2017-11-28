/**
 * Created by Sith on 05.07.14.
 */
package custom
{
import flash.display.MovieClip;
import flash.display.Sprite;

public interface ICustomMovieClip
{
    function get view():MovieClip
    function damaged(damage:int=0):void
    function playState(labelName:String, callback:Function=null, nextLabel:String=null):void
    function setOrientation(value:int, withoutTouchSpeedX:Boolean=false):void
    function get orientation():int
    function get hitBox():Sprite
    function get speedX():Number
    function set speedX(value:Number):void
    function alphaFlashing(duration:Number=1, $repeatCount:int=1, callback:Function=null):void
    function colorFlashingIn(color:uint=0, duration:Number=0, repeatCount:int=1):void
    function endColorFlashing(duration:Number=0.5):void
    function pause():void
    function resume():void
}
}
