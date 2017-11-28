/**
 * Created by Sith on 18.03.14.
 */
package levels
{
import camera.MapMover;

import com.greensock.TweenMax;

import custom.ClipLabel;

import custom.CustomEvent;
import custom.CustomMovieClip;

import data.DataController;
import data.GameData;
import data.IData;
import data.InputData;
import data.LevelData;
import data.LevelData;
import data.PlayerData;

import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.Timer;
import flash.utils.setTimeout;

import gui.GameInterfaceController;
import gui.ComboController;

import inputControllers.IInputController;

import inputControllers.JoypadController;

import inputControllers.KeyboardController;

import levelStuff.PortalController;

import levelStuff.bullets.ABullet;

import levelStuff.bullets.BulletController;
import levelStuff.bullets.GgBullet;
import compositepPattern.AMainController;
import levelStuff.controllers.ChestController;
import levelStuff.controllers.FragmentController;
import levelStuff.controllers.SpellController;
import levelStuff.effects.EffectContoller;

import levelStuff.controllers.EnemyController;
import levelStuff.generators.EnemyGeneratorController;
import levelStuff.pathTrigger.PathTriggerController;
import levelStuff.preanimation.StackAnimation;
import levelStuff.preanimation.StartPortal;
import levelStuff.treasures.TreasureController;

import levelStuff.trigger.TriggerController;
import levelStuff.trigger.TriggerEvent;

import levels.bg.BgCastle;

import levels.bg.BgDesert;

import levels.bg.BgSwamp;
import levels.bg.BgUnreal;
import levels.bg.BgVolcano;
import levels.bg.BgWinter;

import player.PlayerController;

import player.PlayerController;
import player.MovableModel;

import popup.PopupController;

import sound.SoundManager;

import xmlParsingTiledLevel.Level;

import xmlParsingTiledLevel.LevelObject;

/*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/
/*...........LEVEL MANAGER................*/
/*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/
public class LevelManager extends AMainController
{
    private var _levelBuilder:LevelBuilder;
    private var _levelParts:Vector.<LevelPart>;
    private var _needPart:int = 1;

    private var _gameScreen:Sprite;

    private var _levelObject:LevelObject;
    private var _totalScreen:Sprite;
    private var _stage:Stage;

    private var _playerModel:MovableModel;
    private var _currentLevel:Level;

    private var _camera:MapMover;

    // controllers
    private var _enemyController            :EnemyController;
    private var _player                     :PlayerController;
    private var _bulletController           :BulletController;
    private var _treasureController         :TreasureController;
    private var _enemyGeneratorController   :EnemyGeneratorController;
    private var _effectsController          :EffectContoller;
    private var _gameController             :GameInterfaceController;
    private var _chestController            :ChestController;
    private var _comboController            :ComboController;
    private var _spellController            :SpellController;
    private var _levelObjectsController     :LevelObjectsController;
    private var _keyboardController         :IInputController;
    private var _joypadController           :IInputController;
    private var _pathTriggerController      :PathTriggerController;

    private var _playerStartPoint:Point;

    /* CONSTRUCTOR */
    public function LevelManager(stage:Stage, totalScreen:Sprite)
    {
        _totalScreen = totalScreen;
        _stage = stage;
    }

    /* INIT */
    public function initLevelManager():void
    {
        trace("LEVEL MANAGER : init");
        // intro point
        _gameScreen = new Sprite();
        addChild(_gameScreen);

        _currentLevel = LevelData.getLevel(LevelData.currentLevel);

        _levelParts = new Vector.<LevelPart>();
        _levelBuilder = new LevelBuilder();
        _levelBuilder.startBuild(addLevelPart);
    }

    /* INIT PLAYER DATA */
    private function initPlayerData():void
    {
        DataController.playerData.initController(_gameController);
    }

    /* INIT PLAYER */
    public function initPlayer(obj:Class=null):void
    {
        DataController.playerData.currentHealth = DataController.playerData.totalHealth;
        DataController.playerData.currentMana = DataController.playerData.totalMana;
        DataController.playerData.spellPoints = 0;

        _playerModel = new MovableModel();
        // особенное условие для ICEWORLD, где игрок будет скользить по льду
        var movingMode:String = PlayerController.NORMAL;
        if(LevelData.currentLevel == 15 || LevelData.currentLevel == 16 || LevelData.currentLevel == 17) movingMode = PlayerController.SLIDING;
        _player = new PlayerController(_playerModel, _gameScreen, _stage, _playerStartPoint, _levelObject, true, true, true, DataController.playerData, movingMode);
        addSub(_player);

        _stackAnimation.initPlayer(_player);
        _playerModel.initView(_player.view);
        _gameScreen.addChild(_player.view);
        _player.colored(0xFFFFFF, 1, 0);
        _player.colorFlashingOut(.5);
    }

    /* ADD LEVEL PART */
    public function addLevelPart():void
    {
        trace("LEVEL MANAGER : part added : " + _needPart);
        var newLevelPart:LevelPart = new LevelPart(_levelBuilder.levelParts[_needPart-1]);
        _levelParts.push(newLevelPart);
        _levelObject = _levelBuilder.levelObject;
        _gameScreen.x = -5 * Platformer.TILE_SIZE;
        _gameScreen.addChild(newLevelPart);

        addBackground();

        addObstacles();

//        startLevel();
        preanimation();
    }

    /* PREANIMATION */
    private var _stackAnimation:StackAnimation;
    private function preanimation():void
    {
        // если первое появление игрока в текущем мире, то есть первая волна
        _stackAnimation = new StackAnimation(_bg, _gameScreen, startLevel, _currentLevel, this);
        _stackAnimation.start();
        initMainLoop();
    }

    /* ADD BACKGROUND */
    private var _bg:CustomMovieClip;
    private function addBackground():void
    {
        _bg = new _currentLevel.bgClass(5 * Platformer.TILE_SIZE,  0, 0, 0);
        _gameScreen.addChild(_bg);
    }

    /* ADD OBSTACLES */
    private function addObstacles():void
    {
//        trace("obstacles lenght : " + _levelObject.levelObstacles.length);
        for each(var obstacle:Sprite in _levelObject.levelObstacles)
        {
            _gameScreen.addChild(obstacle);
            obstacle.alpha = 0;
            obstacle.mouseEnabled = false;
        }
    }

    /* START LEVEL */
    private function startLevel():void
    {
        _gameController = new GameInterfaceController(new IF_GameInterface(), _gameScreen);
        addSub(_gameController);
        initPlayerData();
        addChild(_gameController.view);

//        initPlayer();
        chooseInputControl();
        initCamera();
        initControllers();

        SoundManager.playSound(SoundManager.MUSIC_LEVEL_BATTLE, 0.4, 0, 3);

        if(_levelObjectsController) _levelObjectsController.startLevel();

        // if this is first level & controls tutorial is not showing - show controls tutorial
        if(LevelData.currentLevel == 1 && DataController.playerData.isNeedToShowControlsTutPopupOnLevel)
        {
            DataController.playerData.isNeedToShowControlsTutPopupOnLevel = false;
            PopupController.showPopup(PopupController.CONTROLS_POPUP)
        }
        else if(DataController.playerData.isNeedToShowSpellTutPopupOnLevel && DataController.playerData.isUpdateAnySpell)
        {
            DataController.playerData.isNeedToShowSpellTutPopupOnLevel = false;
            PopupController.showPopup(PopupController.SPELL_POPUP)
        }
    }

    /* CHOOSE INPUT CONTROL */
    private function chooseInputControl():void
    {
        if (DataController.inputData.currentInput == InputData.INPUT_KEYBOARD)
        {
            _keyboardController = new KeyboardController(_playerModel, _stage);
//            DataController.inputData.currentInput = InputData.INPUT_KEYBOARD;
            addSub(_keyboardController);
            _joypadController = null;
        }
        else if(DataController.inputData.currentInput == InputData.INPUT_JOYPAD)
        {
//            _joypadController = new JoypadController(_playerModel, _stage);
            _keyboardController = null;
        }
    }

    /* INIT MAIN LOOP */
    private function initMainLoop():void
    {
        addEventListener(Event.ENTER_FRAME, mainLoop);
        addEventListener(CustomEvent.PLAYER_DEATH, playerDeath, true);
    }

    /* INIT CONTROLLERS */
    private function initControllers():void
    {
        _pathTriggerController = new PathTriggerController(_levelObject.levelPathTriggers, _gameScreen);
        _pathTriggerController.initTriggers();

        _chestController = new ChestController(_gameScreen, _currentLevel.isBonus, endGame);

        // бонусный уровень
        if(_currentLevel.isBonus)
        {
            _bulletController = new BulletController
            (
                    null,
                    _chestController.chests,
                    _gameScreen,
                    _player,
                    _stage,
                    DataController.playerData,
                    new Rectangle(_stage.x+(5 * Platformer.TILE_SIZE), _stage.y, _stage.x + Platformer.WIDTH + (5 * Platformer.TILE_SIZE), _stage.y+Platformer.HEIGHT
                    ));
        }
        // небонусный уровень
        else
        {
            _enemyController = new EnemyController(_levelObject.levelEnemies, _gameScreen, _player, endGame);
            _enemyController.initEnemies();
            addSub(_enemyController);

            _bulletController = new BulletController
            (
                    _enemyController.activeEnemies,
                    _chestController.chests,
                    _gameScreen,
                    _player,
                    _stage,
                    DataController.playerData,
                    new Rectangle(_stage.x+(5 * Platformer.TILE_SIZE), _stage.y, _stage.x + Platformer.WIDTH + (5 * Platformer.TILE_SIZE), _stage.y+Platformer.HEIGHT
                    ));

            _enemyGeneratorController = new EnemyGeneratorController
            (
                    _levelObject.levelGenerators,
                    _levelObject.levelPathTriggers,
                    _enemyController,
                    _bulletController,
                    _currentLevel,
                    _player,
                    _levelObject,
                    _gameScreen,
                    _currentLevel.genDurations

            );
            _enemyGeneratorController.start();
            addSub(_enemyGeneratorController);

            _comboController = new ComboController(_gameScreen, _gameController.view);
            addSub(_comboController);

            _levelObjectsController = new LevelObjectsController(_player, _gameScreen);
            addSub(_levelObjectsController);
        }

        _spellController = new SpellController(this, _gameScreen, _bulletController, _player, DataController.playerData, _enemyController);
        addSub(_spellController);

        _treasureController = new TreasureController(_levelObject.levelTreasures, _gameScreen, _player,  DataController.playerData);
        _treasureController.initTreasures();

        _effectsController = new EffectContoller(_player, _gameScreen, _camera, _stage);
        _gameScreen.addChild(_effectsController);


        addSub(_chestController);
        addSub(_bulletController);
        addSub(_treasureController);
        addSub(_effectsController);
    }

    /* INIT CAMERA */
    private function initCamera():void
    {
        var cameraTargetPoint:Point = new Point(_player.playerCont.x, _player.playerCont.y);
        _camera = new MapMover(_stage, _player.playerCont, new Rectangle(_gameScreen.x + (5 * Platformer.TILE_SIZE), 0, _gameScreen.width-(10 * Platformer.TILE_SIZE), _gameScreen.height), cameraTargetPoint, 0.10);
    }

    /* MAIN LOOP */
    private function mainLoop(e:Event=null):void
    {
        loop();
    }

    /* END GAME */
    private function endGame(isLevelCompleted:Boolean):void
    {
        SoundManager.fadeSound(SoundManager.MUSIC_LEVEL_BATTLE, 0, 1);
        loopPause();
        deactivate();
        sendLevelStat(isLevelCompleted);
    }

    /* PLAYER DEATH */
    private function playerDeath(e:CustomEvent):void
    {
        SoundManager.fadeSound(SoundManager.MUSIC_LEVEL_BATTLE, 0, 1);
        loopPause();
        deactivate();
        _stackAnimation.playPlayerDeath(sendLevelStat);
//        sendLevelStat(false);
    }

    /* DEACTIVATE */
    public override function deactivate():void
    {
//        _gameScreen.removeChild(_player.view);
        super.deactivate();
    }

    /* SEND LEVEL STAT */
    private var _isAlreadySended:Boolean = false;
    private function sendLevelStat(isLevelCompleted:Boolean=false):void
    {
        if(!_isAlreadySended)
        {
            _isAlreadySended = true;
            trace("SEND LEVEL STAT");
            var gamePoints:int = 0;
            var gamePointsBonus:int = 0;
            var totalPoints:int = 0;

            // bonus factor
            var accuracy:int = int((_bulletController.accuracyHitted/(_bulletController.accuracyHitted+_bulletController.accuracyMissed))*100);
            var bonusFactor:Number = accuracy/10;

            if(isLevelCompleted)
            {
                gamePoints = DataController.playerData.tempGamePoints;
                gamePointsBonus = Math.ceil((DataController.playerData.tempGamePoints/100)*bonusFactor);
                DataController.playerData.gamePoints += gamePoints;
                DataController.playerData.gamePoints += gamePointsBonus;
                totalPoints = DataController.playerData.gamePoints;
            }

            var coinsScored:int = DataController.playerData.currentTempCoinsAmount;
            var coinsBonus:int = Math.ceil((DataController.playerData.currentTempCoinsAmount/100)*bonusFactor);
            DataController.playerData.currentCoinsAmount += coinsScored;
            DataController.playerData.currentCoinsAmount += coinsBonus;
            var coinsTotal:int = DataController.playerData.currentCoinsAmount;
            DataController.playerData.currentTempCoinsAmount = 0;
            DataController.playerData.tempGamePoints = 0;

            _gameScreen.dispatchEvent(new CustomEvent(CustomEvent.LEVEL_COMPLETED, null, true, false,
                    {
                        isLevelCompleted:isLevelCompleted,
                        accuracy:accuracy,
                        bonusFactor:bonusFactor,
                        coinsScored:coinsScored,
                        coinsBonus:coinsBonus,
                        coinsTotal:coinsTotal,
                        gamePoints:gamePoints,
                        gamePointsBonus:gamePointsBonus,
                        totalGamePoints:totalPoints
                    }));
        }
    }

    /* STOP */
    public function loopPause():void
    {
        _player.pause();
        if(_enemyController) _enemyController.pause();
        if(_enemyGeneratorController) _enemyGeneratorController.pause();
        _bulletController.pause();
        _chestController.pause();
        removeEventListener(Event.ENTER_FRAME, mainLoop);
    }

    /* LOOP RESUME */
    public function loopResume():void
    {
        _player.resume();
        if(_enemyController) _enemyController.resume();
        if(_enemyGeneratorController) _enemyGeneratorController.resume();
        _chestController.resume();
        addEventListener(Event.ENTER_FRAME, mainLoop);
    }


    public function get gameScreen():Sprite {
        return _gameScreen;
    }

    public function get playerStartPoint():Point {
        return _playerStartPoint;
    }

    public function set playerStartPoint(value:Point):void {
        _playerStartPoint = value;
    }
}
}
