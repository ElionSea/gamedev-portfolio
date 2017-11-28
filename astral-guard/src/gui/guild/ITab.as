/**
 * Created by Sith on 31.08.14.
 */
package gui.guild
{
import flash.display.Sprite;

import compositepPattern.ISubController;

public interface ITab extends ISubController
{
    function get view():Sprite
    function get name():String
    function updateView():void
    function deselect():void
    function get selectedItemName():String
}
}
