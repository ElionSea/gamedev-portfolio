/**
 * Created by ElionSea on 14.03.15.
 */
package levelStuff
{
import custom.ClipLabel;

import flash.utils.Dictionary;

import levelStuff.bullets.GgBullet;

/* SCREEN ACTORS
    Класс, регулирующий инициализацию всех актёров сцены, у которых есть шкала кадров. Все представители класса Custom Movie Clip
*
* */
public class ScreenActors
{
    public static const GG_BULLET_SMALL:String = "ggBulletSmall";

    private static var _allActorLabels:Dictionary;
    /*CONSTRUCTOR*/
    public function ScreenActors()
    {

    }

    public static function init(checkForInit:Function):void
    {
        _allActorLabels = new Dictionary();
        initLabels();
        checkForInit();
    }

    private static function initLabels():void
    {
        _allActorLabels[GgBullet] = ClipLabel.getClipLabels([
            [ClipLabel.RUN + "_" + ClipLabel.YELLOW, 2, 0.3],
            [ClipLabel.RUN + "_" + ClipLabel.RED, 2, 0.3],
            [ClipLabel.RUN + "_" + ClipLabel.BLUE, 2, 0.3],
            [ClipLabel.RUN + "_" + ClipLabel.GREEN, 2, 0.3],
            [ClipLabel.RUN + "_" + ClipLabel.PURPLE, 2, 0.3],
            [ClipLabel.RUN + "_" + ClipLabel.LIGHT_BLUE, 2, 0.3]
        ])

    }

    public static function getClipLabelsByClassName(className:Class):Vector.<ClipLabel>
    {
        return _allActorLabels[className];
    }
}
}
