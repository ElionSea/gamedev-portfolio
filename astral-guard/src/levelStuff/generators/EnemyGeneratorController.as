/**
 * Created by Sith on 12.07.14.
 */
package levelStuff.generators
{
import custom.CustomEvent;

import flash.display.Sprite;
import levelStuff.bullets.BulletController;
import levelStuff.controllers.EnemyController;
import compositepPattern.ISubController;
import levelStuff.enemies.IEnemy;
import levelStuff.pathTrigger.PathTrigger;
import player.PlayerController;
import xmlParsingTiledLevel.Level;
import xmlParsingTiledLevel.LevelObject;

public class EnemyGeneratorController implements ISubController
{
    private var _levelGenerators:Vector.<EnemyGenerator>;
    private var _levelPathTriggers:Vector.<PathTrigger>;
    private var _enemyController:EnemyController;
    private var _bulletController:BulletController;
    private var _currentLevel:Level;
    private var _gameScreen:Sprite;
    private var _boss:IEnemy;
    private var _totalEnemiesAmount:int;
    private var _genDurations:Array;

    /* CONSTRUCTOR */
    public function EnemyGeneratorController
            (
                levelGenerators:Vector.<EnemyGenerator>,
                levelPathTriggers:Vector.<PathTrigger>,
                enemyController:EnemyController,
                bulletController:BulletController,
                level:Level,
                player:PlayerController,
                levelObject:LevelObject,
                gameScreen:Sprite,
                genDurations:Array
            )
    {
        _levelGenerators = levelGenerators;
        _levelPathTriggers = levelPathTriggers;
        _enemyController = enemyController;
        _currentLevel = level;
        _bulletController = bulletController;
        _gameScreen = gameScreen;
        _genDurations = genDurations;



        if(_currentLevel.isBoss)
        {
            _boss = new level.bossClass(levelObject, player, _bulletController, _gameScreen, enemyController);
            _boss.init();
            _totalEnemiesAmount++;
        }
        initGenerators(level.enemies, level.paths, level.generatorPaths, player);

        _gameScreen.addEventListener(CustomEvent.STOP_GENERATE, stopGenerate, true);
    }

    /* STOP GENERATE */
    private function stopGenerate(e:CustomEvent):void
    {
        _gameScreen.removeEventListener(CustomEvent.STOP_GENERATE, stopGenerate, true);
        for each(var lg:EnemyGenerator in _levelGenerators)
        {
            lg.stopGenerate();
        }
    }

    /* INIT GENERATORS */
    private function initGenerators(levelEnemies:Array, levelPaths:Array, generatorAvaliablePaths:Array, player:PlayerController):void
    {
        for(var i:int = 0; i < _levelGenerators.length; i++)
        {
            var levelGenerator:EnemyGenerator = initGeneratorByCount(i);
            levelGenerator.initGenerator(levelEnemies[i], _enemyController, generatorAvaliablePaths[i], _levelPathTriggers, player, _genDurations[i]);
            _totalEnemiesAmount += levelEnemies[i].length;
        }
    }

    /* INIT GENERATOR BY COUNT */
    private function initGeneratorByCount(i:int):EnemyGenerator
    {
        for each(var lg:EnemyGenerator in _levelGenerators)
        {
            if(lg.count == i+1)
            {
                return lg;
            }
        }
//        trace("Sorry, no generator by this count");
        return null;
    }

    /* START */
    public function start():void
    {
        if(_currentLevel.isBoss) _enemyController.updateEnemy(_boss);
        for each(var enemyGenerator:EnemyGenerator in _levelGenerators)
        {
            enemyGenerator.startGenerate(_enemyController.activeEnemies);
        }
    }

    /* LOOP */
    public function loop():void{}

    /* PAUSE */
    public function pause():void
    {
        for each(var eg:EnemyGenerator in _levelGenerators)
        {
            eg.pause();
        }
    }

    /* RESUME */
    public function resume():void
    {
        for each(var eg:EnemyGenerator in _levelGenerators)
        {
            eg.resume();
        }
    }

    /* DEACTIVATE */
    public function deactivate():void
    {
        for each(var enemyGenerator:EnemyGenerator in _levelGenerators)
        {
            enemyGenerator.deactivate();
        }
    }

    public function set totalEnemiesAmount(value:int):void {
        _totalEnemiesAmount = value;
    }
}
}
