/* XML Parsing from Tiled based levels
*
*
* Взято из http://gamedevelopment.tutsplus.com/tutorials/parsing-tiled-tmx-format-maps-in-your-own-game-engine--gamedev-3104
*   Модифицировано elionsea
* */
package xmlParsingTiledLevel
{
import data.DataController;
import data.LevelData;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.FullScreenEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.net.URLLoader;

import levelStuff.Portal;
import levelStuff.generators.EnemyGenerator;
import levelStuff.pathTrigger.PathTrigger;
import levelStuff.enemies.EnemyInitializer;
import levelStuff.enemies.EListObject;
import levelStuff.enemies.IEnemy;
import levelStuff.treasures.TreasureParserObject;

import levelStuff.trigger.Trigger;

public class TiledXMLParsing extends Sprite
{
    private var _tileSetXml:XML;                   // файл уровня
    private var xmlLoader:URLLoader;        // загрузчик xml

    private var _levelXml:XML;

    private var _mapWidth:int;              // ширина карты
    private var _mapHeight:int;             // высота карты

    private var _tileWidth:int;             // ширина тайла
    private var _tileHeight:int;            // высота тайла

    private var _tileSetBitmap:Bitmap;

    private var _tileSet:TileSet;           // тайловый сет
    private var _totalTileSets:int;         // общее количество тайловых сетов
    private var _tileSetsLoaded:uint = 0;   // тайловых сетов загружено
    private var _totalParts:int;

    private var _eventLoaders:Array = [];
    private var screenBitmap:Bitmap;
    public var screenBitmapTopLayer:Bitmap;
    public var _collisionTiles:Array = [];  // тайлы

    private var _tiledConteiner:Sprite = new Sprite();

    private var _callback:Function;

    private var _levelObject:LevelObject;

    /* CONSTRUCTOR */
    public function TiledXMLParsing()
    {
//        initTileSet();
    }

    /* INIT TILESET */
    public function initTileSet(curLevel:int, endCallback:Function):void
    {
        _tileSetXml = LevelData.getLevelXML(curLevel);
        _mapWidth   = _tileSetXml.attribute("width");
        _mapHeight  = _tileSetXml.attribute("height");
        _tileWidth  = _tileSetXml.attribute("tilewidth");
        _tileHeight = _tileSetXml.attribute("tileheight");
        _totalParts = int(_tileSetXml.totalParts);

        _tileSetBitmap = new LevelData.tilesetBitmap;

        var imageWidth:uint         =  _tileSetXml.tileset.image.attribute("width");
        var imageHeight:uint        = _tileSetXml.tileset.image.attribute("height");
        var firstGid:uint           = _tileSetXml.tileset.attribute("firstgid");
        var tileSetName:String      = _tileSetXml.tileset.attribute("name");
        var tileSetTileWidth:uint   = _tileSetXml.tileset.attribute("tilewidth");
        var tileSetTileHeight:uint  = _tileSetXml.tileset.attribute("tileheight");

        _tileSet = new TileSet(firstGid, tileSetName, tileSetTileWidth, tileSetTileHeight, imageWidth, imageHeight);
        _tileSet.bitmapData = _tileSetBitmap.bitmapData;

        screenBitmap = new Bitmap(new BitmapData(_mapWidth * _tileWidth, _mapHeight * _tileHeight, false, 0x000000));
        screenBitmapTopLayer = new Bitmap(new BitmapData(_mapWidth*_tileWidth,_mapHeight*_tileHeight,true,0));

        endCallback.call();
    }

    /* BEGIN PARSING */
    public function beginParsing(buildLevelPartComplete:Function):void
    {
        _callback = buildLevelPartComplete;
        addTileBitmapData();
    }

    /* ADD TILE BITMAP DATA */
    private function addTileBitmapData():void
    {
        // упаковуем все объекты в один-единственный объект
        _levelObject = new LevelObject();
        var tempObstaclesArray:Vector.< Vector.<ArrayTile>> = new Vector.<Vector.<ArrayTile>>();
        var tileCounter:int = 0;

//        var currentLevel:int = LevelData.currentLevel;
//        var currentAmbience:int = DataController.gameData.currentAmbience;
        _levelXml = LevelData.getLevelXML(LevelData.currentLevel);
        // загрузка каждого слоя
//        var needPart:XML = new XML(_levelXml["map"]);
//        trace("needPart" + needPart);
        for each(var layer:XML in _levelXml.layer)
        {
            var tiles:Array = [];
            var tileLength:uint = 0;
            // assign the gid to each location in the layer
            for each(var tile:XML in layer.data.tile)
            {
                var gid:Number = tile.attribute("gid");
                if(gid > 0)
                {
                    tiles[tileLength] = gid;
                }
                tileLength++;
            }
            var layerName:String = layer.attribute("name");
            // decide where we're going to put hte layer
            var layerMap:int;
            switch (layerName)
            {
                case "background_1":
                    layerMap = 0;
                    break;
                case "background_2":
                    layerMap = 0;
                    break;
                case "background_3":
                    layerMap = 0;
                    break;
                case "background_4":
                    layerMap = 0;
                    break;
                case "obstacles":
                    layerMap = 1;
                    break;
                default :
                    trace("using base layer");
            }
            // store the gid into a 2d array
            var tileCoordinates:Array = [];
            for (var tileX:int = 0; tileX < _mapWidth; tileX++)
            {
                tileCoordinates[tileX] = [];
                for (var tileY:int = 0; tileY < _mapHeight; tileY++)
                {
                    tileCoordinates[tileX][tileY] = tiles[(tileX+(tileY*_mapWidth))];
                }
            }



            for (var spriteForX:int = 0; spriteForX < _mapWidth; spriteForX++)
            {
                for (var spriteForY:int = 0; spriteForY < _mapHeight; spriteForY++)
                {
                    var tileGid:int = int(tileCoordinates[spriteForX][spriteForY]);

                    var destY:int = spriteForY * _tileWidth;
                    var destX:int = spriteForX * _tileWidth;
                    // basic math to find out where the tile is coming from on the source image
                    tileGid -= _tileSet.firstGid-1 ;
                    var sourceY:int = Math.ceil(tileGid/_tileSet.tileAmountWidth)-1;
                    var sourceX:int = tileGid - (_tileSet.tileAmountWidth * sourceY) - 1;
                    // copy the tile from the tileset onto our bitmap
                    if(layerMap == 0)
                    {
                        screenBitmap.bitmapData.copyPixels
                                (_tileSet.bitmapData,
                                        new Rectangle(sourceX * _tileSet.tileWidth,
                                                sourceY * _tileSet.tileHeight,
                                                _tileSet.tileWidth,
                                                _tileSet.tileHeight),
                                        new Point(destX, destY), null, null, true);
                    }
                    else if (layerMap == 1)
                    {
                        if(tempObstaclesArray.length < spriteForY+1)
                        {
                            var newVector:Vector.<ArrayTile> =  new Vector.<ArrayTile>();
                            tempObstaclesArray.push(newVector);
                        }
                        tileCounter++;
                        tempObstaclesArray[spriteForY][spriteForX] = new ArrayTile(tileCounter, destX, destY, false, spriteForX, spriteForY);
                        if(tileGid != 0)
                        {
                            tempObstaclesArray[spriteForY][spriteForX].isObstacle = true;
                            var spr:Sprite = new Sprite();
                            spr.graphics.beginFill(0xFF00FF,.5);
                            spr.graphics.drawRect(0, 0, _tileSet.tileWidth, _tileSet.tileHeight);
                            spr.graphics.endFill();
                            spr.x = destX;
                            spr.y = destY;
                            _levelObject.levelObstacles.push(spr);
                        }
                    }
                }
            }
        }

        for each (var objectgroup:XML in _tileSetXml.objectgroup)
        {
            var objectGroupName:String = objectgroup.attribute("name");
            if(objectGroupName == "objects")
            {
                for each (var levelObject:XML in objectgroup.object)
                {
                    var levelObjectName:String = levelObject.attribute("name");
                    switch (levelObjectName)
                    {
                        // стартовая позиция игрока в начале уровня
                        case "playerStartPoint":
                            var playerStartPoint:XMLList = objectgroup.object;
                            _levelObject.playerStartPoint = new Point(
                                    playerStartPoint.attribute("x"),
                                    playerStartPoint.attribute("y"));
                            break;
                    }
                }
            }
            // INIT PATH TRIGGERS
            else if(objectGroupName == "pathTriggers")
            {
                for each (var pathTriggerObject:XML in objectgroup.object)
                {
                    var pathTriggerObjectName:String = pathTriggerObject.attribute("name");

                    var pathTriggerProperties:XMLList = pathTriggerObject.properties;
                    var pathTriggerCount:int;
                    for each(var pathTriggerProp:XML in pathTriggerProperties.property)
                    {
                        var pathTriggerPropName:String = pathTriggerProp.attribute("name");
                        if(pathTriggerPropName == "count")
                        {
                            pathTriggerCount = pathTriggerProp.attribute("value");
                        }
                    }
                    if(pathTriggerObjectName == "pathTrigger")
                    {
                        var newPathTrigger:PathTrigger = new PathTrigger(
                                pathTriggerCount,
                                pathTriggerObject.attribute("x"),
                                pathTriggerObject.attribute("y"),
                                pathTriggerObject.attribute("width"),
                                pathTriggerObject.attribute("height"));
                        _levelObject.levelPathTriggers.push(newPathTrigger);
                    }
                }
            }
            // INIT GENERATORS
            else if(objectGroupName == "generators")
            {
                for each (var generatorObject:XML in objectgroup.object)
                {
                    var generatorObjectName:String = generatorObject.attribute("name");

                    var generatorProperties:XMLList = generatorObject.properties;
                    var count:int;
                    for each(var generatorProp:XML in generatorProperties.property)
                    {
                        var generatorPropName:String = generatorProp.attribute("name");
                        if(generatorPropName == "count")
                        {
                            count = generatorProp.attribute("value");
                        }
                    }
                    if(generatorObjectName == "generator")
                    {
                        var generator:EnemyGenerator = new EnemyGenerator(
                                count,
                                generatorObject.attribute("x"),
                                generatorObject.attribute("y"),
                                generatorObject.attribute("width"),
                                generatorObject.attribute("height"));
                        _levelObject.levelGenerators.push(generator);
                    }
                }
            }
            // INIT PORTALS
            else if(objectGroupName == "portals")
            {
                for each (var portalObject:XML in objectgroup.object)
                {
                    var portalObjectName:String = portalObject.attribute("name");

                    var portalProperties:XMLList = portalObject.properties;
                    var count2:int;
                    var id:int;
                    for each(var portalProp:XML in portalProperties.property)
                    {
                        var portalPropName:String = portalProp.attribute("name");
                        if(portalPropName == "count")
                        {
                            count2 = portalProp.attribute("value");
                        }
                        else if(portalPropName == "id")
                        {
                            id = portalProp.attribute("value");
                        }
                    }
                    if(portalObjectName == "portal")
                    {
                        var portal:Portal = new Portal(
                                id,
                                count2,
                                portalObject.attribute("x"),
                                portalObject.attribute("y"),
                                portalObject.attribute("width"),
                                portalObject.attribute("height"));
                        _levelObject.levelPortals.push(portal);
                    }
                }
            }
            // INIT TRIGGERS
            else if(objectGroupName == "triggers")
            {
                for each (var triggerObject:XML in objectgroup.object)
                {
                    var triggerObjectName:String = triggerObject.attribute("name");

                    var triggerProperties:XMLList = triggerObject.properties;
                    var eventCount:int;
                    for each(var triggerProp:XML in triggerProperties.property)
                    {
                        var triggerPropName:String = triggerProp.attribute("name");
                        if(triggerPropName == "eventCount")
                        {
                            eventCount = triggerProp.attribute("value");
                        }
                    }
                    if(triggerObjectName == "trigger")
                    {
                        var newTrigger:Trigger = new Trigger(
                                eventCount,
                                triggerObject.attribute("x"),
                                triggerObject.attribute("y"),
                                triggerObject.attribute("width"),
                                triggerObject.attribute("height"));
                        _levelObject.levelTriggers.push(newTrigger);
                    }
                }
            }
            // INIT TREASURES
            else if(objectGroupName == "treasures")
            {
                for each (var treasureObj:XML in objectgroup.object)
                {
                    var treasureObjectName:String = treasureObj.attribute("name");
                    if(treasureObjectName == "treasure")
                    {
                        var treasureProperties:XMLList = treasureObj.properties;
                        var treasureType:String;
                        for each(var treasureProp:XML in treasureProperties.property)
                        {
                            var treasurePropName:String = treasureProp.attribute("name");
                            if(treasurePropName == "type")
                            {
                                treasureType = treasureProp.attribute("value");
                            }
                        }
                        var treasureObject:TreasureParserObject = new TreasureParserObject();
                        treasureObject.x = Number(treasureObj.attribute("x"));
                        treasureObject.y = Number(treasureObj.attribute("y"));
                        treasureObject.width = Number(treasureObj.attribute("width"));
                        treasureObject.height = Number(treasureObj.attribute("height"));
                        treasureObject.type = treasureType;
//                        var treasureClass:ITreasure = TreasureInitializer.classByType(treasureObject);
//                        _levelObject.levelTreasures.push(treasureClass);
                    }
                }
            }
            // INIT ENEMIES
            else if(objectGroupName == "enemies")
            {
                for each (var objectEnemy:XML in objectgroup.object)
                {
                    var objectEnemyName:String = objectEnemy.attribute("name");
                    if(objectEnemyName == "enemy")
                    {
                        var properties:XMLList = objectEnemy.properties;
                        var eventId:int;
                        var trajectory:String;
                        var orientation:int;
                        var path:String;
                        var movementType:String;

                        for each(var prop:XML in properties.property)
                        {
                            var propName:String = prop.attribute("name");
                            switch (propName)
                            {
                                case "eventId":
                                        eventId = prop.attribute("value");
                                    break;
                                case "trajectory":
                                    trajectory = prop.attribute("value");
                                    break;
                                case "orientation":
                                    orientation = prop.attribute("value");
                                    break;
                                case "path":
                                    path = prop.attribute("value");
                                    break;
                                case "movementType":
                                    movementType = prop.attribute("value");
                                    break;
                            }
                        }
//                        var o:EListObject = new EListObject();
//                        o.x = objectEnemy.attribute("x");
//                        o.y = objectEnemy.attribute("y");
//                        o.width = objectEnemy.attribute("width");
//                        o.height = objectEnemy.attribute("height");
//                        o.type = objectEnemy.attribute("type");
//                        o.eventId = eventId;
//                        o.trajectory = trajectory;
//                        o.orientation = orientation;
//                        o.path = path;
//                        o.movementType = movementType;
//                        var enemyClass:IEnemy = EnemyInitializer.classByType(objectEnemy.attribute("type"), o);
//                        _levelObject.levelEnemies.push(enemyClass);
                    }
                }
            }
        }
        LevelObject.levelObstaclesArray = tempObstaclesArray;
        displayMap();
    }


    /* DISPLAY MAP */
    private function displayMap():void
    {
        _tiledConteiner = new Sprite();
        _tiledConteiner.addChild(screenBitmap);
        _callback.call();
    }

    public function get tiledConteiner():Sprite {return _tiledConteiner;}

    public function get levelObject():LevelObject {return _levelObject;}
}
}
