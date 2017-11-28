/**
 * Created by Sith on 11.09.14.
 */
package compositepPattern
{
import compositepPattern.ISubController;

public interface IMainController extends ISubController
{
    function addSub(sub:ISubController):void
}
}
