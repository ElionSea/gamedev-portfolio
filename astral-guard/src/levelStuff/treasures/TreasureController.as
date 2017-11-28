/**
 * Created by Sith on 27.06.14.
 */
package levelStuff.treasures
{
import custom.CustomEvent;

import cv.orion.filters.ColorFilter;
import cv.orion.filters.GravityFilter;
import cv.orion.filters.ScaleFilter;
import cv.orion.filters.WanderFilter;
import data.PlayerData;
import flash.display.Sprite;
import flash.geom.Rectangle;
import flash.utils.Timer;
import compositepPattern.ISubController;
import player.PlayerController;
import cv.Orion;
import cv.orion.output.BurstOutput;

public class TreasureController implements ISubController
{
    private var _levelTreasures:Vector.<ITreasure> = new Vector.<ITreasure>();
    private var _mainScreen:Sprite;
    private var _playerController:PlayerController;
    private var _playerData:PlayerData;

    public function TreasureController(levelTreasures:Vector.<ITreasure>, mainScreen:Sprite, playerController:PlayerController, playerData:PlayerData)
    {
        _levelTreasures = levelTreasures;
        _mainScreen = mainScreen;
        _playerController = playerController;
        _playerData = playerData;

        _mainScreen.addEventListener(CustomEvent.TREASURE_FROM_DIED, treasuresFromDiedEnemy, true);

        initTreasureParticles();
    }

    /* INIT TREASURE PARTICLES */
    private function initTreasureParticles():void{}

    /* TREASURES FROM DIED ENEMY */
    private function treasuresFromDiedEnemy(e:CustomEvent):void
    {
        if(e.obj.treasure)
        {
            for (var i:int = 0; i < e.obj.treasure.length; i++)
            {
                var newTreasure:ATreasure = new ATreasure(
                        e.obj.x,
                        e.obj.y,
                        e.obj.treasure[i],
                        TList.treasureList[e.obj.treasure[i]].value,
                        _playerData,
                        _playerController,
                        TList.treasureList[e.obj.treasure[i]].color,
//                        TList.treasureList[e.obj.treasure[i]].isTimeoutHiding,
                        false,
                        destroyTreasure);
                var randomVX:Number = Math.random()*(-10)+5;
                newTreasure.model.vx = randomVX;
                _mainScreen.addChild(newTreasure.view);
                _levelTreasures.push(newTreasure);
            }
        }
    }

    /* INIT TREASURES */
    public function initTreasures():void
    {
        for each(var treasure:ATreasure in _levelTreasures)
        {
            _mainScreen.addChild(treasure.view);
        }
    }

    /* START CHECK END GAME */
    private var _endGameTimer:Timer;
    /*private function startCheckEndGame():void
    {
        _endGameTimer  = new Timer(5000, 1);
        _endGameTimer.addEventListener(TimerEvent.TIMER_COMPLETE, levelCompleted);
        _endGameTimer.start();
    }

    private function levelCompleted():void
    {

    }*/

    /* TREASURE CONTROLLER LOOP */
    public function loop():void
    {
        for each(var treasure:ATreasure in _levelTreasures)
        {
            // move if treasure don't touch the surface
//            if(treasure.model.hitDown)
//            {
//                if(treasure.model.vx != 0 && treasure.model.vy != 0)
//                {
//                    treasure.model.vx = 0;
//                    treasure.model.vy = 0;
//                }
//            }
//            if(!treasure.model.hitDown)
//            {
                treasure.loop();
//            }
            // hit test with player
            if(_playerController.hitBox.hitTestObject(treasure.hitBox))
            {
                if(!treasure.isHitByPlayer)
                {
                    treasure.isHitByPlayer = true;
                    treasure.activate();
                    hitTreasure(treasure);
                }
            }
        }
    }

    /* HIT TREASURE */
    private var _particleSettings:Object = {lifeSpan:500, mass:1, alphaMin:1, alphaMax:0, speedY:1, velocityXMin:-0.5, velocityXMax:0.5, velocityYMin:1, velocityYMax:2, scaleMax:2, scaleMin:1.5};
    private function hitTreasure(treasure:ATreasure):void
    {
        var treasureColor:uint = TList.treasureList[treasure.type].color;
        var particleEffectFilters:Object = [new GravityFilter(-1.3), new ScaleFilter(0.95), new WanderFilter(0.5, 0.5), new ColorFilter(treasureColor)];
        var o:Orion = new Orion(TreasureParticleMc, new BurstOutput(3, false), {settings:_particleSettings, effectFilters:particleEffectFilters, useCacheAsBitmap:true}, true);
        o.canvas = new Rectangle(0, 0, 10, 25);
        o.x = treasure.view.x;
        o.y = treasure.view.y-15;
        o.width = 5;
        o.height = 10;
        _mainScreen.addChild(o);
        destroyTreasure(treasure);
        // TODO: Добавить добавление в счёт игроку.
    }

    /* DESTROY TREASURE */
    private function destroyTreasure(treasure:ATreasure):void
    {
        _levelTreasures.splice(_levelTreasures.indexOf(treasure), 1);
        if(_mainScreen.contains(treasure.view))_mainScreen.removeChild(treasure.view);
        treasure.deactivate();
        treasure = null;
    }

    /* DEACTIVATE */
    public function deactivate():void
    {
        for each(var treasure:ATreasure in _levelTreasures)
        {
            treasure.deactivate();
            if(_mainScreen.contains(treasure.view))_mainScreen.removeChild(treasure.view);
            treasure = null;
        }
        _mainScreen.removeEventListener(CustomEvent.TREASURE_FROM_DIED, treasuresFromDiedEnemy, true);
    }

}
}
