/**
 * Created by ElionSea on 28.10.14.
 */
package levelStuff.bullets
{
import flash.utils.Dictionary;

import levelStuff.enemies.Trajectory;

public class BulletList
{

    private static var _bulletsList:Dictionary;

    // list keys
    public static const BOSS_VOLCANO_SHOOT:int = 0;
    public static const BOSS_VOLCANO_SPECIATL_SHOOT:int = 1;

    public static function get bulletsList():Dictionary
    {
        if(_bulletsList == null)
        {
            _bulletsList = new Dictionary();

            _bulletsList[BOSS_VOLCANO_SHOOT] = new BulletListObject(BOSS_VOLCANO_SHOOT, 15, Trajectory.FLY_BY_ANGLE, McVolcanoBossShoot, 3.5);
        }

    }


    /*CONSTRUCTOR*/
    public function BulletList()
    {

    }
}
}
