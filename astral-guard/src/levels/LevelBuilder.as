/**
 * Created by Sith on 31.03.14.
 */
package levels
{
import data.DataController;
import data.LevelData;

import flash.display.Sprite;

import xmlParsingTiledLevel.LevelObject;
import xmlParsingTiledLevel.TiledXMLParsing;

/*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/
/*...........LEVEL BUILDER................*/
/*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/
public class LevelBuilder extends  Sprite
    {
        private var _levelXMLParser:TiledXMLParsing;
        private var _levelPart:Sprite;
        private var _levelParts:Vector.<Sprite> = new Vector.<Sprite>();
        private var _startLevel:Function;

        private var _levelObject:LevelObject;


        /* LEVEL BUILDER */
        public function LevelBuilder()
        {
            _levelXMLParser = new TiledXMLParsing();
        }

        /* START BUILD */
        public function startBuild(startLevelCallback:Function):void
        {
            _startLevel = startLevelCallback;
            _levelXMLParser.initTileSet(LevelData.currentLevel, beginParsing);
        }

        /* BEGIN PARSING */
        private function beginParsing():void
        {
            _levelXMLParser.beginParsing(buildLevelPartComplete);
        }

        /* BUILD LEVEL PART COMPLETE */
    private function buildLevelPartComplete():void
        {
            _levelPart = _levelXMLParser.tiledConteiner;
            _levelParts.push(_levelPart);
            _levelObject = _levelXMLParser.levelObject;
            _startLevel.call();
        }

        public function get levelParts():Vector.<Sprite> {return _levelParts;}

    public function get levelObject():LevelObject {return _levelObject;}
}
}
