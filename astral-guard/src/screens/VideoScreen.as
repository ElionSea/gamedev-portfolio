/**
 * Created by Sith on 31.03.14.
 */
package screens {
import com.greensock.TweenMax;

import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.text.TextField;
import flash.utils.Timer;

import locale.InfoNode;
import locale.Locale;

import sound.SoundManager;

public class VideoScreen extends AScreen
{
    private var _btnSkip:SimpleButton;
    private var _sceneView:MovieClip;
    private var _tfMask:MovieClip;
    private var _tfDesc:TextField;

    private var _oneFrameShowDuration:int;
    private var _remainFrames:int;
    private var _curFrame:int;
    private var _allText:Vector.<InfoNode> = new Vector.<InfoNode>();
    private var _xmlKey:String;
    private var _music:String;

    /* CONSTRUCTOR */
    public function VideoScreen(screenName:String, view:MovieClip, nextScreen:IScreen, isShowingMouseCursor:Boolean, xmlKey:String, oneFrameShowDuration:int=15, music:String=SoundManager.MUSIC_INTRO)
    {
        super(screenName, view, nextScreen, isShowingMouseCursor);
        _oneFrameShowDuration = oneFrameShowDuration;
        _xmlKey = xmlKey;
        _sceneView = _view["sceneView"];
        _tfDesc = _view["tfDesc"];
        _tfMask = _view["tfMask"];
        _sceneView.stop();
        _remainFrames = _sceneView.totalFrames;
        _music = music;
        _curFrame = 1;
        _btnSkip = _view["btn_skip"];
        _btnSkip.addEventListener(MouseEvent.CLICK, showNextScreen);
    }

    /* ADDED TO STAGE */
    protected override function addedToStageHandler(e:Event):void
    {
        super.scale();
        _view.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
        playVideo();
    }

    /* PLAY VIDEO */
    private function playVideo():void
    {
        SoundManager.playSound(_music, 1.5);
        loadText();
        startShow();
    }

    /* START SHOW */
    private var _showTimer:Timer;
    private function startShow(e:TimerEvent=null):void
    {

        if(_showTimer == null)
        {
            _showTimer = new Timer(_oneFrameShowDuration*1000, 1);
            _showTimer.addEventListener(TimerEvent.TIMER_COMPLETE, startShow);
        }

        if(_curFrame != _sceneView.totalFrames+1)
        {
            _showTimer.reset();
            showDescText();
            _showTimer.start();

            _curFrame++;
        }
        else
        {
            showNextScreen();
        }
    }

    /* SHOW TEXT */
    private function showDescText():void
    {
//        _tfMask.y = _tfDesc.y - _tfMask.height;
        _tfDesc.mask = _tfMask;
        _tfDesc.visible = false;
        TweenMax.fromTo(_tfMask, _oneFrameShowDuration,{y:_tfDesc.y - _tfMask.height},  {y:_tfDesc.y});
        _tfDesc.text = _allText[_curFrame-1].description;
        _tfDesc.textColor = uint(_allText[_curFrame-1].color);
        _sceneView.alpha =  0;
        _sceneView.gotoAndStop(_curFrame);
        _tfDesc.visible = true;
        TweenMax.to(_sceneView, _oneFrameShowDuration/2, {alpha:1, onComplete:hideAll});
        function hideAll():void
        {
            TweenMax.to(_sceneView, _oneFrameShowDuration/2, {alpha:0});
        }
    }

    /* LOAD TEXT */
    private function loadText():void
    {
        for(var i:int = 1; i <= _sceneView.totalFrames; i++)
        {
            var getInfo:InfoNode;
            var keys:Array = [_xmlKey, "videoFrames", "frame_"+i];
            getInfo = Locale.getVideoScreenInfo(keys);
            _allText.push(getInfo);
        }
    }

    /* SHOW NEXT */
    private function showNextScreen(e:MouseEvent = null):void
    {
//        _btnSkip.removeEventListener(MouseEvent.CLICK, showNext);
//        _view.removeEventListener(Event.ENTER_FRAME, exitFrameListener);
        ScreenManager.show(_nextScreen.screenName);
    }

    /* DEACTIVATE */
    public override function deactivate():void
    {
        SoundManager.fadeSound(_music, 0, 1.5);
        if(_showTimer)
        {
            _showTimer.stop();
            _showTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, startShow);
            _showTimer = null;
        }
        _btnSkip.removeEventListener(MouseEvent.CLICK, showNextScreen);
    }
}
}
