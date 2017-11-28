/**
 * Created by Sith on 31.08.14.
 */
package gui.inventory
{
import flash.display.MovieClip;

public interface IItem
{
    function get view():MovieClip
    function get viewName():String
    function get sellCost():int
    function get buyCost():int
    function get value():Number
}
}
