package {
import com.greensock.plugins.ColorTransformPlugin;
import com.greensock.plugins.FramePlugin;
import com.greensock.plugins.RemoveTintPlugin;
import com.greensock.plugins.TintPlugin;
import com.greensock.plugins.TweenPlugin;

import data.DataController;
import data.InputData;

import data.LevelData;

import flash.display.MovieClip;

import flash.display.Sprite;
import flash.display.Stage;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;

import levelStuff.ScreenActors;

import popup.AchievementController;

import popup.PopupController;

import preloader.Preloader;

import screens.ScreenManager;

import sound.SoundManager;


// TODO: сделать опции меню выдвижными.

[Frame(factoryClass="preloader.Preloader")]
[SWF(width="480", height="640", backgroundColor="#000000", frameRate="60")]
public class Platformer extends MovieClip
{

    public static const SCALE_FACTOR:Number = /*2.5*/2.5;
    public static const HEIGHT:int = 640/*768*/ / SCALE_FACTOR;
    public static const WIDTH:int = 480/*576*/  / SCALE_FACTOR;
    public static const TILE_SIZE:int = 16;

    private var _stage:Stage;

    private var _sitelocks:Array = ["http://www.flashgamelicense.com", "https://www.flashgamelicense.com"];

//    private var _stage:Stage;

    TweenPlugin.activate([TintPlugin, RemoveTintPlugin, FramePlugin, ColorTransformPlugin]);

    /* CONSTRUCTOR */
    public function Platformer()
    {
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    /* ADDED TO STAGE */
    private function onAddedToStage(e:Event):void
    {
        _stage = e.currentTarget.stage;
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

        init();
    }

    /* INIT */
    private function init():void
    {
        trace("AppMain : INIT");
        DataController.inputData.currentInput = InputData.INPUT_KEYBOARD;

        ScreenManager.init(_stage, checkForInit);
        SoundManager.initSounds(checkForInit);
        LevelData.initLevels(checkForInit);
        ScreenActors.init(checkForInit);
    }

    private static var _initCounter:int = 0; // счётчик инициализированных контроллеров. Как только станет 4- покажется меню
    private static function checkForInit():void
    {
        _initCounter++;
        if(_initCounter == 4)
        {
//            ScreenManager.show(ScreenManager.MAIN_MENU);
            ScreenManager.show(ScreenManager.MY_LOGO);
        }
    }

}
}
