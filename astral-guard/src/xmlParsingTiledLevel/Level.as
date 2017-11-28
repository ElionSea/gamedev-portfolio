/**
 * Created by Sith on 14.08.14.
 */
package xmlParsingTiledLevel
{
public class Level
{
    private var _levelClass:Class;
    private var _levelWave:int;
    private var _enemies:Array;
    private var _paths:Array;
    private var _generatorPaths:Array;
    private var _isBoss:Boolean;
    private var _isBonus:Boolean;
    private var _bossClass:Class;
    private var _bossName:String;
    private var _levelName:String;
    private var _bgClass:Class;
    private var _genDurations:Array;
    private var _levelNumber:int;
    private var _levelCompleted:Boolean;

    /*CONSTRUCTOR*/
    public function Level
            (
                    levelNumber:int,
                    level:Class,
                    levelName:String,
                    bgClass:Class,
                    levelWave:int,
                    level_enemies:Array,
                    level_paths:Array,
                    level_generatorPaths:Array,
                    isBoss:Boolean=false,
                    bossClass:Class=null,
                    isBonus:Boolean=false,
                    genDurations:Array=null
                    )
    {
        _levelNumber = levelNumber;
        _levelClass = level;
        _levelName = levelName;
        _levelWave = levelWave;
        _bgClass = bgClass;
        _enemies = level_enemies;
        _paths = level_paths;
        _generatorPaths = level_generatorPaths;
        _isBoss = isBoss;
        _bossClass = bossClass;
        _isBonus = isBonus;
        _genDurations = genDurations;
    }

    public function get enemies():Array {return _enemies;}

    public function get paths():Array {return _paths;}

    public function get generatorPaths():Array {return _generatorPaths;}

    public function get levelClass():Class {return _levelClass;}

    public function get isBoss():Boolean {return _isBoss;}

    public function get bossClass():Class {return _bossClass;}

    public function get levelWave():int {return _levelWave;}

    public function get levelName():String {return _levelName;}

    public function get bgClass():Class {return _bgClass;}

    public function get isBonus():Boolean {return _isBonus;}

    public function get genDurations():Array {return _genDurations;}

    public function get levelNumber():int {return _levelNumber;}

    public function get bossName():String {return _bossName;}
    public function set bossName(value:String):void {_bossName = value;}

    public function get levelCompleted():Boolean {return _levelCompleted;}
    public function set levelCompleted(value:Boolean):void {_levelCompleted = value;}
}
}
