/**
 * Created by Sith on 18.03.14.
 */
package screens
{
import com.greensock.TweenMax;

import custom.CustomCursor;

import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.display.Stage;
import flash.ui.Mouse;

import inputControllers.screens.ScreenChooseController;

import popup.AchievementController;

import popup.PopupController;

import sound.SoundManager;

public class ScreenManager extends Sprite
{
    private var _prevScreen:IScreen;
    private var _screenCounter:int = 0;
    private var _totalScreen:Sprite;
    private var _stage:Stage;

    public var  mainMenuScreen:MainMenuScreen;
    public var  myLogoScreen:LogoScreen;
    public var  sponsorLogoScreen:LogoScreen;
    public var  levelScreen:LevelScreen;
    public var  videoScreen:VideoScreen;
    public var  chooseControllerScreen:ScreenChooseController;
    public var  guildScreen:GuildScreen;
    public var  tempScreen:TempScreen;
    public var  blockScreen:BlockScreen;
    public var  mapScreen:MapScreen;
    public var  creditsScreen:CreditsScreen;
    public var  achievementsScreen:AchievementsScreen;
    public var  endGameScreen:VideoScreen;

    public static const MAIN_MENU:String = "mainMenu";
    public static const MY_LOGO:String = "myLogo";
    public static const SPONSOR_LOGO:String = "sponsorLogo";
    public static const LEVEL_SCREEN:String = "levelScreen";
    public static const VIDEO_SCREEN:String = "videoScreen";
    public static const CHOOSE_CONTROLLER_SCREEN:String = "chooseControllerScreen";
    public static const GUILD_SCREEN:String = "guildScreen";
    public static const TEMP_SCREEN:String = "tempScreen";
//    public static const BLOCK_SCREEN:String = "blockScreen";
    public static const MAP_SCREEN:String = "mapScreen";
    public static const END_GAME_SCREEN:String = "endGameScreen";
    public static const CREDITS_SCREEN:String = "creditsScreen";
    public static const ACHIEVEMENTS_SCREEN:String = "achievementsScreen";

    private var _customCursor:CustomCursor;

    /* SINGLETON */
    private static var _instance:ScreenManager;
    public static function get instance():ScreenManager
    {
        if(_instance == null) _instance = new ScreenManager();
        return _instance;
    }

    /* CONSTRUCTOR */
    public function ScreenManager()
    {

    }

    /* STATIC INIT */
    public static function init(stage:Stage, checkForInit:Function):void
    {
        instance._stage = stage;
        instance._totalScreen = new Sprite();
        instance._stage.addChild(instance._totalScreen);

        instance.init();
        PopupController.init(instance._totalScreen);
        AchievementController.init(instance._totalScreen);
        checkForInit();
    }

    /* PAUSE */
    public static function pause():void
    {
        instance._currentScreen.pause();
    }

    /* RESUME */
    public static function resume():void
    {
        instance._currentScreen.resume();
    }

    /* INIT */
    private function init():void
    {
        mainMenuScreen          = new MainMenuScreen(MAIN_MENU, new ScrMainMenuMc(), true);
        sponsorLogoScreen       = new LogoScreen(SPONSOR_LOGO, new McSponsorLogoScreen(), mainMenuScreen, false, 3);
        myLogoScreen            = new LogoScreen(MY_LOGO, new McMyLogoScreen(), mainMenuScreen, false, 3);
        levelScreen             = new LevelScreen(LEVEL_SCREEN, new MovieClip(), true, _stage, _totalScreen);
        videoScreen             = new VideoScreen(VIDEO_SCREEN, new ScrVideoScreenMc(), levelScreen, true, "startGame");
//        chooseControllerScreen  = new ScreenChooseController(CHOOSE_CONTROLLER_SCREEN, new ScreenChooseControllerMc(), true);
        guildScreen             = new GuildScreen(GUILD_SCREEN, new ScrGuildMc(), true);
        tempScreen              = new TempScreen(TEMP_SCREEN, new ScrTemp(), false, levelScreen);
        mapScreen              = new MapScreen(MAP_SCREEN, new ScrMapMc(), true);
        creditsScreen          = new CreditsScreen(CREDITS_SCREEN, new ScrCreditsMc(), true);
        achievementsScreen     = new AchievementsScreen(ACHIEVEMENTS_SCREEN, new ScrAchievementsMc(), true);
        endGameScreen          = new VideoScreen(END_GAME_SCREEN, new ScrEndVideoScreen(), mapScreen, true, "endGame", 25, SoundManager.MUSIC_MARKET);
//        blockScreen              = new BlockScreen(BLOCK_SCREEN, new McEndBlock(), false, null);

        _customCursor = new CustomCursor(mainMenuScreen);
    }

    public static function show(screenName:String):void
    {
        switch (screenName)
        {
            case MAIN_MENU:                 instance.show(instance.mainMenuScreen);break;
            case MY_LOGO:                   instance.show(instance.myLogoScreen);break;
            case SPONSOR_LOGO:              instance.show(instance.sponsorLogoScreen);break;
            case LEVEL_SCREEN:              instance.show(instance.levelScreen);break;
            case VIDEO_SCREEN:              instance.show(instance.videoScreen);break;
//            case CHOOSE_CONTROLLER_SCREEN:  instance.show(instance.chooseControllerScreen);break;
            case GUILD_SCREEN:              instance.show(instance.guildScreen);break;
            case TEMP_SCREEN:              instance.show(instance.tempScreen);break;
            case MAP_SCREEN:                instance.show(instance.mapScreen);break;
            case CREDITS_SCREEN:            instance.show(instance.creditsScreen);break;
            case ACHIEVEMENTS_SCREEN:       instance.show(instance.achievementsScreen);break;
            case END_GAME_SCREEN:       instance.show(instance.endGameScreen);break;
//            case BLOCK_SCREEN:              instance.show(instance.blockScreen);break;
        }
    }

    /* SHOW */
    public function show(screen:IScreen):void
    {
        // если это первый скрин игры
        if(_screenCounter == 0)
        {
            _prevScreen = screen;
            _screenCounter++;
//            hideCurrentScreen(null, screen);
            firstLaunch(screen);
        }
        else
        {
            _prevScreen.deactivate();
            // прячем предыдущий скрин
            hideCurrentScreen(_prevScreen, screen);
        }
        if(screen.isShowingMouseCursor)
        {
            Mouse.show();
        }
        else Mouse.hide();
    }

    /* HIDE */
    private var _darkMask:McDarkMask;
    /* HIDE CUR SCREEN */
    private function hideCurrentScreen(screen:IScreen, newScreen:IScreen):void
    {
//        trace("hideCurrentScreen !");
        _darkMask = new McDarkMask();
        _darkMask.scaleX = _darkMask.scaleY = Platformer.SCALE_FACTOR;
        _darkMask.alpha = 0;
        _totalScreen.addChild(_darkMask);
        TweenMax.to(_darkMask, 1.5, {alpha:1, onComplete:removePrevScreen});
        function removePrevScreen():void
        {
            if(screen) _totalScreen.removeChild(screen.view);
            showNextScreen(newScreen);
        }
    }

    private function firstLaunch(newScreen:IScreen):void
    {
//        newScreen.gotoStartPos();
        _totalScreen.addChild(newScreen.view);
    }

    /* SHOW NEXT SCREEN */
    private var _currentScreen:IScreen;
    private function showNextScreen(newScreen:IScreen):void
    {
//        trace("showNextScreen !");
        _currentScreen = newScreen;
        _prevScreen = newScreen;
//        trace("_darkMask : " + _darkMask);
        _totalScreen.addChildAt(newScreen.view, _totalScreen.getChildIndex(_darkMask));
        TweenMax.to(_darkMask, 1.5, {alpha:0, onComplete:showN});
        function showN():void
        {
            _totalScreen.removeChild(_darkMask);
            _darkMask = null;
            newScreen.gotoStartPos();
        }
    }

//    public function set stage(value:Stage):void {_stage = value;}
}


}
