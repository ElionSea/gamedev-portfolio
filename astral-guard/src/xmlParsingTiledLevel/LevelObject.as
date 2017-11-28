/**
 * Created by Sith on 11.06.14.
 */
package xmlParsingTiledLevel
{
import flash.display.Sprite;
import flash.geom.Point;
import flash.geom.Point;

import levelStuff.Portal;

import levelStuff.generators.EnemyGenerator;

import levelStuff.pathTrigger.PathTrigger;

import levelStuff.enemies.AEnemy;
import levelStuff.enemies.IEnemy;
import levelStuff.treasures.ITreasure;

import levelStuff.trigger.Trigger;

public class LevelObject
{
    private var _playerStartPoint:Point;
    private var _levelObstacles:Vector.<Sprite> = new Vector.<Sprite>();
    public static var _levelObstaclesArray:Vector.<Vector.<ArrayTile>> = new Vector.<Vector.<ArrayTile>>();
    private var _levelTriggers:Vector.<Trigger> = new Vector.<Trigger>();
    private var _levelEnemies:Vector.<IEnemy> = new Vector.<IEnemy>();
    private var _levelTreasures:Vector.<ITreasure> = new Vector.<ITreasure>();
    private var _levelPathTriggers:Vector.<PathTrigger> = new Vector.<PathTrigger>();
    private var _levelGenerators:Vector.<EnemyGenerator> = new Vector.<EnemyGenerator>();
    private var _levelPortals:Vector.<Portal> = new Vector.<Portal>();

    public function LevelObject()
    {

    }

    /* GET TILE BY INDEXES */
    public static function getTilePointByIndexes(rowIndex:int, colIndex:int):Point
    {
        var p:Point = new Point(_levelObstaclesArray[colIndex][rowIndex].x, _levelObstaclesArray[colIndex][rowIndex].y);
        return p;
    }

    /* GET PATH TRIGGER */
    public function getPathTriggerCenter(count:int):Point
    {
        var pnt:Point;
        for each(var pathTrigger:PathTrigger in _levelPathTriggers)
        {
            if(pathTrigger.count == count)
            {
                pnt = pathTrigger.center;
                return pnt;
            }
        }
       return null;
    }

    /* GET TILE BY POINT */
    public static function getTileByPoint(xs:Number,ys:Number):ArrayTile
    {
        const TILE_SIZE:int = Platformer.TILE_SIZE;
        if(ys>0 && xs>0 && (_levelObstaclesArray[0].length)*TILE_SIZE>xs && (_levelObstaclesArray.length)*TILE_SIZE>ys)
        {
            return _levelObstaclesArray[Math.floor(ys/TILE_SIZE)][Math.floor(xs/TILE_SIZE)];
        }
        else
        {
            return null;	//плитки, которые выходят за границы, трактуются как сплошная земля
        }
    }

    public function get playerStartPoint():Point {return _playerStartPoint;}
    public function set playerStartPoint(value:Point):void {_playerStartPoint = value;}

    public function get levelObstacles():Vector.<Sprite> {return _levelObstacles;}

    public static function get levelObstaclesArray():Vector.< Vector.<ArrayTile>> {return _levelObstaclesArray;}

    public static function set levelObstaclesArray(value:Vector.<Vector.<ArrayTile>>):void {_levelObstaclesArray = value;}

    public function get levelTriggers():Vector.<Trigger> {return _levelTriggers;}

    public function get levelEnemies():Vector.<IEnemy> {return _levelEnemies;}

    public function get levelTreasures():Vector.<ITreasure> {return _levelTreasures;}

    public function get levelPathTriggers():Vector.<PathTrigger> {return _levelPathTriggers;}

    public function get levelGenerators():Vector.<EnemyGenerator> {return _levelGenerators;}

    public function set levelObstacles(value:Vector.<Sprite>):void {
        _levelObstacles = value;
    }

    public function get levelPortals():Vector.<Portal> {return _levelPortals;}
    public function set levelPortals(value:Vector.<Portal>):void {_levelPortals = value;}
}
}
