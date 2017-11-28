/**
 * Created by Sith on 25.06.14.
 */
package levelStuff.enemies
{

public class EnemyInitializer
{
    public static function classByType(type:String, o:EListObject):IEnemy
    {
        switch(type)
        {
            case "skeleton":
//                return new Skeleton(o);
                break;
        }
        trace("Sorry, but no movieClip by this type");
        return null;
    }
}
}
