/**
 * Created by Sith on 03.07.14.
 */
package levelStuff.bosses
{
import levelStuff.enemies.EListObject;
import levelStuff.enemies.IEnemy;

public interface IBoss extends IEnemy
{
//    function initStrategy(o:EnemyParserObject):void
    function deactivateBehavior():void;
    function animateDeath(duration:Number, callback:Function):void;
}
}
