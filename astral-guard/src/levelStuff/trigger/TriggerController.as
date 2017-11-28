/**
 * Created by Sith on 24.06.14.
 */
package levelStuff.trigger
{
import flash.display.DisplayObject;
import flash.display.Sprite;

public class TriggerController
{
    private var _triggers:Vector.<Trigger> = new Vector.<Trigger>();
    private var _mainSprite:Sprite;
    private var _playerHitBox:Sprite;

    public function TriggerController(triggers:Vector.<Trigger>, mainSprite:Sprite, hitBox:Sprite)
    {
        _triggers = triggers;
        _mainSprite = mainSprite;
        _playerHitBox = hitBox;
        initTriggers();
    }

    private function initTriggers():void
    {
        for each(var trigger:Trigger in _triggers)
        {
            trigger.view.alpha = 0;
        }
    }

    public function hitTest():void
    {
        // TODO: Если понадобится лишняя производительность - заменить функцию hitTestObject на tiledHitTest
        for each(var trigger:Trigger in _triggers)
        {
            if(trigger.view.hitTestObject(_playerHitBox))
            {
                trigger.triggeredHitBox();
                destroyTrigger(trigger);
            }
        }
    }

    private function destroyTrigger(trigger:Trigger):void
    {
        _triggers.splice(_triggers.indexOf(trigger), 1);
        _mainSprite.removeChild(trigger.view);
    }
}
}
