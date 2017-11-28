
/**
 * Created by Sith on 08.08.14.
 */
package locale
{
import gui.*;

public class Locale
{
    private static var _gameDesc:XML;

    [Embed(source='gameDescription_EN.xml', mimeType="application/octet-stream")]
    private static var gameDescription:Class;

    public static const GUILD_SCREEN:String = "guildScreen";
    public static const LEVEL_SCREEN:String = "levelScreen";
    public static const VIDEO_SCREEN:String = "videoScreen";
    public static const ACHIEVEMENTS_SCREEN:String = "achievementsScreen";


    /*CONSTRUCTOR*/
    public function Locale()
    {
    }

    public static function getGuildScreenInfo(keys:Array):InfoNode
    {
        var infoNode:InfoNode = new InfoNode();
        if(_gameDesc == null) _gameDesc = new XML(new gameDescription);
        var infoNodeXML:XML = new XML(_gameDesc[GUILD_SCREEN][keys[0]][keys[1]][keys[2]]);
        infoNode.caption        = infoNodeXML.attribute("caption");
        infoNode.description    = infoNodeXML.attribute("desc");
        infoNode.cost           = infoNodeXML.attribute("cost");
        return infoNode;
    }

    public static function getLevelScreenInfo(keys:Array):InfoNode
    {
        var infoNode:InfoNode = new InfoNode();
        if(_gameDesc == null) _gameDesc = new XML(new gameDescription);
        var infoNodeXML:XML = new XML(_gameDesc[LEVEL_SCREEN][keys[0]][keys[1]][keys[2]]);
        infoNode.caption        = infoNodeXML.attribute("caption");
        infoNode.description    = infoNodeXML.attribute("desc");
        infoNode.color           = infoNodeXML.attribute("color");
        infoNode.bossName           = infoNodeXML.attribute("bossName");
        return infoNode;
    }

    public static function getAchievementsScreenInfo(keys:Array):InfoNode
    {
        var infoNode:InfoNode = new InfoNode();
        if(_gameDesc == null) _gameDesc = new XML(new gameDescription);
        var infoNodeXML:XML = new XML(_gameDesc[ACHIEVEMENTS_SCREEN][keys[0]][keys[1]]);
        infoNode.caption        = infoNodeXML.attribute("caption");
        infoNode.description           = infoNodeXML.attribute("desc");
        return infoNode;
    }

    public static function getVideoScreenInfo(keys:Array):InfoNode
    {
        var infoNode:InfoNode = new InfoNode();
        if(_gameDesc == null) _gameDesc = new XML(new gameDescription);
        var infoNodeXML:XML = new XML(_gameDesc[VIDEO_SCREEN][keys[0]][keys[1]][keys[2]]);
        infoNode.description        = infoNodeXML.attribute("description");
        infoNode.color           = infoNodeXML.attribute("color");
        return infoNode;
    }

    public static function getColor(key:String):String
    {
        var color:String;
        if(_gameDesc == null) _gameDesc = new XML(new gameDescription);
        color = String(_gameDesc[key].captionColor);
        return color;
    }

    public static function getDesc(key:String):String
    {
        var desc:String;
        if(_gameDesc == null) _gameDesc = new XML(new gameDescription);
        desc = String(_gameDesc[key].description);
        return desc;
    }

    public static function getWarning(key:String):String
    {
        var warn:String;
        if(_gameDesc == null) _gameDesc = new XML(new gameDescription);
        warn = String(_gameDesc[key].warning);
        return warn;
    }


}
}
