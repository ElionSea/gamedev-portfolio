/**
 * Created by Sith on 12.07.14.
 */
package levelStuff.pathTrigger
{
import flash.display.Sprite;

public class PathTriggerController
{
    private var _triggers:Vector.<PathTrigger> = new Vector.<PathTrigger>();
    private var _mainScreen:Sprite;

    public function PathTriggerController(levelPathTriggers:Vector.<PathTrigger>, mainScreen:Sprite)
    {
        _triggers = levelPathTriggers;
        _mainScreen = mainScreen;
    }

    public function initTriggers():void
    {
        for each(var trigger:PathTrigger in _triggers)
        {
            trigger.view.alpha = 0;
            _mainScreen.addChild(trigger.view);
        }
    }

    /* PATH TRIGGER CONTROLLER LOOP */
    public function pathTriggerControllerLoop():void
    {

    }
}
}
