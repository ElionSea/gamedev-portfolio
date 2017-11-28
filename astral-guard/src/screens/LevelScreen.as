/**
 * Created by Sith on 31.03.14.
 */
package screens
{
import custom.CustomCursor;
import custom.CustomEvent;
import custom.CustomStats;

import data.LevelData;

import flash.display.Bitmap;
import flash.display.MovieClip;
import flash.display.MovieClip;
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.ui.Mouse;

import levels.LevelManager;

import net.hires.debug.Stats;

import sound.SoundManager;

public class LevelScreen extends AScreen
    {
        private var _levelManager:LevelManager;

        private var _stage:Stage;
        private var _totalScreen:Sprite;
//        private var _shadowMaskBD:LevelMaskGrey;
//        private var _shadowMaskSpr:Sprite;
        private var _scrGameOver:GameOverScreen;

        private var _stats:Stats;

        /* CONSTRUCTOR */
        public function LevelScreen(screenName:String, view:MovieClip, isShowingMouseCursor:Boolean, stage:Stage, totalScreen:Sprite)
        {
            super(screenName, view, null, isShowingMouseCursor);
            _isShowingMouseCursor = isShowingMouseCursor;
            _stage = stage;
            _totalScreen = totalScreen;
            _view.addEventListener(Event.ADDED_TO_STAGE, addedHandler);
        }

        /* ADDED HANDLER */
        private function addedHandler(e:Event):void
        {
//            _view.removeEventListener(Event.ADDED_TO_STAGE, addedHandler);
            _stage.addEventListener(MouseEvent.MOUSE_MOVE, update);
            _stage.addEventListener(MouseEvent.CLICK, update);

            _levelManager = new LevelManager(_stage, _totalScreen);
            _view.addChild(_levelManager);

//            addStats();

//            addShootCursor();
//            addShadowMask();
            _levelManager.initLevelManager();

            _stage.addEventListener(CustomEvent.LEVEL_COMPLETED, gameOver, true);
        }

    /* UPDATE INFO PANEL */
    private function update(e:MouseEvent):void
    {
        // update mouse cursor
        if(e.target is SimpleButton || e.target.name == "btnMusic" || e.target.name == "btnSound")
        {
            if(Mouse.cursor != CustomCursor.HAND_CURSOR)
            {
                CustomCursor.changeCursor(CustomCursor.HAND_CURSOR);
            }
        }
        else
        {
            CustomCursor.changeCursor(CustomCursor._currentShootCursor);
        }
    }

    /* PAUSE */
    public override function pause():void
    {
        _levelManager.loopPause();
    }

    /* RESUME */
    public override function resume():void
    {
        _levelManager.loopResume();
    }

    /* GAME OVER */
    private function gameOver(e:CustomEvent):void
    {
        if(LevelData.currentLevel == 20 && e.obj.isLevelCompleted)
        {
            LevelData.currentLevel++;
            ScreenManager.show(ScreenManager.END_GAME_SCREEN);
        }
        else
        {
            _scrGameOver = new GameOverScreen(new ScrGameOverMc(), e, _levelManager.gameScreen);
            _totalScreen.addChild(_scrGameOver.view);
            Mouse.show();

        }
    }

    /* ADD SHADOW MASK */
    private function addShadowMask():void
    {
//        _shadowMaskBD = new LevelMaskGrey();
//        var bm:Bitmap = new Bitmap(_shadowMaskBD);
//        _shadowMaskSpr = new Sprite();
//        _shadowMaskSpr.addChild(bm);
//        _shadowMaskSpr.scaleX = _shadowMaskSpr.scaleY = Platformer.SCALE_FACTOR;
//        _totalScreen.addChild(_shadowMaskSpr);
    }

    /* ADD STATS */
    private function addStats():void
    {
        _stats = new Stats();
        _stats.x = 0;
        _stats.y = 100;
        _totalScreen.addChild(_stats);
    }

    /* DEACTIVATE */
    public override function deactivate():void
    {
        trace("level screen deactivate");
//            _totalScreen.removeChild(_stats);
//            _stats = null;

//            _totalScreen.removeChild(_shadowMaskSpr);
//            _shadowMaskSpr = null;

        _stage.removeEventListener(MouseEvent.MOUSE_MOVE, update);
        _stage.removeEventListener(MouseEvent.CLICK, update);
        _stage.removeEventListener(CustomEvent.LEVEL_COMPLETED, gameOver, true);

        if(_scrGameOver)
        {
            _scrGameOver.deactivate();
            _totalScreen.removeChild(_scrGameOver.view);
            _scrGameOver = null;
        }

        _view.removeChild(_levelManager);
        _levelManager = null;

        SoundManager.stopAllSounds();
    }

}
}
