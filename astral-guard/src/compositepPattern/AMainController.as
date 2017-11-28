/**
 * Created by Sith on 11.09.14.
 */
package compositepPattern
{
import compositepPattern.IMainController;
import compositepPattern.ISubController;

import flash.display.Sprite;

/* шаблон проектирования "Компоновщик" */
public class AMainController extends Sprite implements IMainController
{
    private var _subControllers:Vector.<ISubController> = new Vector.<ISubController>();

    /*CONSTRUCTOR*/
    public function AMainController()
    {
    }

    /* DEACTIVATE */
    public function deactivate():void
    {
        for each(var sub:ISubController in _subControllers)
        {
            sub.deactivate();
            sub = null;
        }
    }

    /* LOOP */
    public function loop():void
    {
        for each(var sub:ISubController in _subControllers)
        {
            sub.loop();
        }
    }

    /* ADD SUB */
    public function addSub(sub:ISubController):void
    {
        _subControllers.push(sub);
    }
}
}
