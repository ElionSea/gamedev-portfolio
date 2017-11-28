/**
 * Created by ElionSea on 28.03.15.
 */
package popup {
import com.greensock.TweenLite;
import com.greensock.easing.Sine;

import flash.display.Sprite;
import flash.geom.Rectangle;

import locale.InfoNode;

import sound.SoundManager;

public class AchievementController
{
    private static var _totalScreen:Sprite;
    private var _showingAhieves:Array; // количество просходящих анимаций ачивок в данный момент

    private static var _instance:AchievementController;
    public static function getInstance():AchievementController
    {
        if(_instance == null) _instance = new AchievementController();
        return _instance;
    }

    public static function init(totalScreen:Sprite):void
    {
        _totalScreen = totalScreen;
    }

    /*CONSTRUCTOR*/
    public function AchievementController()
    {

    }

    /* SHOW ACHIEVEMENT*/
    public static function showAchieve(frameNumber:int, infoNode:InfoNode):void
    {
        SoundManager.playSound(SoundManager.ACHIEVE, 0.7);

        // init container
        var cont:Sprite = new Sprite();
        cont.x = 120;
        cont.y = 100;
        cont.scaleX = cont.scaleY = Platformer.SCALE_FACTOR;

        // init achieve
        var achieveViewClip:McAchievementShow = new McAchievementShow();
        achieveViewClip.gotoAndStop(frameNumber);
        achieveViewClip.tfCaption.text = infoNode.caption;
        achieveViewClip.tfDesc.text = infoNode.description;

        // init mask
        var mask:Sprite = new Sprite();
        mask.graphics.beginFill(0xFFFFFF);
        mask.graphics.drawRect(0, 0, achieveViewClip.width, achieveViewClip.height);
        mask.graphics.endFill();
        mask.x = achieveViewClip.x - mask.width;
        achieveViewClip.mask = mask;

        // add all to cont
        cont.addChild(achieveViewClip);
        cont.addChild(mask);

        _totalScreen.addChild(cont);

        // show achieve (mask to right)
        TweenLite.to(mask, 2, {x:achieveViewClip.x, onComplete:blikCont});

        // blik cont
        function blikCont():void
        {
            TweenLite.to(cont, 0.5,
                    {
                        tint:0xFFFFFF,
                        colorTransform:{tint:0xFFFFFF, tintAmount:1},
                        ease:Sine.easeIn,
                        onComplete:uncolored
                    });
        }
        function uncolored():void
        {
            TweenLite.to(cont, 0.5, {removeTint:true, ease:Sine.easeOut, onComplete:hideAchieve});
        }
        function hideAchieve():void
        {
            TweenLite.to(mask, 2, {x:achieveViewClip.x+achieveViewClip.width, onComplete:deleteClip});
        }
        function deleteClip():void
        {
            _totalScreen.removeChild(cont);
            cont = null;
        }
    }
}
}
