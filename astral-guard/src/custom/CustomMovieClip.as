/**
 * Created by Sith on 20.06.14.
 */
package custom {
import com.greensock.TweenLite;
import com.greensock.TweenMax;
import com.greensock.easing.Sine;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.TimerEvent;
import flash.filters.DropShadowFilter;
import flash.utils.Timer;
import player.MovableModel;

public class CustomMovieClip extends MovieClip implements ICustomMovieClip
{

    public static const LEFT_ORI:int = 1;
    public static const RIGHT_ORI:int = 2;

    protected var _view:MovieClip;
    private var _model:MovableModel;
    private var _currentFrameLabel:ClipLabel;
    private var _clipLabels:Vector.<ClipLabel>;
    private var _hitBox:Sprite;
    private var _controlledObject:Object;

//    private var _speedX:Number;
    protected var _speedY:Number;
    protected var _isStartOrientationRight:Boolean; // если клип нарисован изначально смотрящим в левую сторону - нужно будет его повернуть.

    private var _orientation:int;

    private var _isScalableX:Boolean;


    /* CONSTRUCTOR */
    public function CustomMovieClip(controlledClass:Object, model:MovableModel, view:MovieClip, x:Number=0, y:Number=0, height:Number=0, width:Number=0, isScalableX:Boolean=true)
    {
        _controlledObject = controlledClass;
        _view = view;

        _model = model;

        _isScalableX = isScalableX;
        initView(x, y, height, width);
        _view.stop();
    }

    /* INIT VIEW */
    private var _shadowFilter:DropShadowFilter = new DropShadowFilter();
    public function initView(x:Number, y:Number, height:Number, width:Number):void
    {
        _view.stop();
        _view.cacheAsBitmap = true;
        if(!_hitBox)
        {
            _hitBox = _view["hitBox"];
        }
        else
        {
            _hitBox.alpha = 0;
        }
        _view.x = x/* + width/2*/;
        _view.y = y/* + height/2*/;
        _view.mouseEnabled = false;
        _view.mouseChildren =  false;
        this.mouseChildren = false;
        this.mouseEnabled = false;

//        _view.filters = [_shadowFilter];
    }

    /***************************** PLAY ANIMATION *******************************************************/

    // Глобальный вызов анимации
    /* PLAY STATE */
    private var _frameTimer:Timer;
    private var _delay:Number;
    public function playState(labelName:String, callback:Function=null, nextLabel:String=null):void
    {
        if(!checkCurrentFrameLabel(labelName))
        {
            loopState(labelName, callback, nextLabel);
        }
    }
    // локальный вызов анимации
    /* LOOP STATE */
    private function loopState(labelName:String, callback:Function=null, nextLabel:String=null):void
    {
        if(_frameTimer) _frameTimer.stop();
        _currentFrameLabel = getLabelByName(labelName);
        if(nextLabel) _currentFrameLabel.nextLabel = nextLabel;
        if(callback) _currentFrameLabel.callbackFunction = callback;
        _delay = _currentFrameLabel.animationSpeed/(_currentFrameLabel.labelTotalFrames);
        _view.gotoAndStop(_currentFrameLabel.name);
        if(_frameTimer == null)
        {
            if(_currentFrameLabel.labelTotalFrames > 1)
            {
                _frameTimer = new Timer(_delay*1000, _currentFrameLabel.labelTotalFrames);
                _frameTimer.addEventListener(TimerEvent.TIMER, timerCount);
                _frameTimer.addEventListener(TimerEvent.TIMER_COMPLETE, gotoLabelStart);
                _frameTimer.start();
            }
        }
        else
        {
            _frameTimer.reset();
            _frameTimer.delay = _delay*1000;
            _frameTimer.repeatCount  = _currentFrameLabel.labelTotalFrames;
            _frameTimer.start();
        }
    }

    /* TIMER COUNT */
    private function timerCount(e:TimerEvent):void
    {
        _view.nextFrame();
    }

    /* PAUSE */
    public function pause():void
    {
        if(_frameTimer)
        {
            _frameTimer.stop();
        }
    }

    /* REMOVE TIMER */
    private function removeTimer():void
    {
        if(_frameTimer)
        {
            _frameTimer.stop();
            _frameTimer.removeEventListener(TimerEvent.TIMER, timerCount);
            _frameTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, gotoLabelStart);
            _frameTimer = null;
        }
    }

    /* RESUME */
    public function resume():void
    {
        if(_frameTimer) _frameTimer.start();
    }

    /* GOTO START LABEL */
    private function gotoLabelStart(e:TimerEvent=null):void
    {
        if(!_currentFrameLabel.callbackFunction)
        {
            if(_currentFrameLabel.nextLabel)
            {
                loopState(_currentFrameLabel.nextLabel);
            }
            else
            {
                loopState(_currentFrameLabel.name);
            }
        }
        else
        {
            _currentFrameLabel.callbackFunction(controlledObject);
        }
    }
    /*****************************************************************************************************/


    /* SET ORIENTATION */
    public function setOrientation(value:int, withoutTouchSpeedX:Boolean = false):void
    {
        //если стартовая позиция клипа повёрнута вправо - нужно предварительно проскейлить клип.
        var startOri:int;
        if(_isStartOrientationRight)  startOri = -1;
        else                          startOri = 1;

        if(value == LEFT_ORI)
        {
            if(!withoutTouchSpeedX) _model.speedX = Math.abs(_model.speedX) * -1;
            if(_isScalableX) _view.scaleX = (-1 * startOri);
        }
        else if(value == RIGHT_ORI)
        {
            if(!withoutTouchSpeedX) _model.speedX = Math.abs(_model.speedX);
            if(_isScalableX) _view.scaleX = (1 * startOri);
        }
        _orientation = value;
    }

    override public function gotoAndStop(frame:Object,scene:String = null):void
    {
        _view.gotoAndStop(frame);
    }

    /* GET LABEL BY NAME */
    private function getLabelByName(labelName:String):ClipLabel
    {
        for each(var label:ClipLabel in _clipLabels)
        {
            if(label.name == labelName)
            {
                return label;
            }
        }
        return null;
    }

    /* DAMAGED */
    public function damaged(damage:int=0):void
    {
        // TODO: Добавить уникальный цвет повреждения для каждого снаряда (?)
        TweenLite.to(_view, 0.1,
                {
            tint:0xFFFFFF,
            ease:Sine.easeIn,
            onComplete:lightingOff
        });
    }

    /* COLORED */
    public function colored(color:uint, tintAmount:Number, duration:Number=0.5):void
    {
        TweenLite.to(_view, duration,
                {
                    tint:color,
                    colorTransform:{tint:color, tintAmount:tintAmount},
                    ease:Sine.easeIn
                });
    }

    /* UNCOLORED */
    public function uncolored():void
    {
        TweenLite.to(_view, 0.5, {removeTint:true, ease:Sine.easeOut});
    }

    /* COLORED FLASHING */
    private var _color:uint;
    private var _duration:Number;
    private var _repeatCount:int;
    public function colorFlashingIn(color:uint=0, duration:Number=0, repeatCount:int=1):void
    {
        if(color > 0) _color = color;
        if(duration > 0) _duration = duration;
        if(repeatCount > 1) _repeatCount = repeatCount;
        alphaFlash();
    }
    private function alphaFlash():void
    {
        if(_repeatCount > 0)
        {
            TweenMax.to(_view, _duration,
                    {
                        colorTransform:{tint:_color, tintAmount:0.2},
                        ease:Sine.easeIn,
                        onComplete:colorFlashingOut
                    });

        }
        else
        {
            endColorFlashing();
        }
    }
    public function colorFlashingOut(duration:Number=0.5):void
    {
        _repeatCount--;
        TweenMax.to(_view, duration,
                {
                    removeTint:true,
                    ease:Sine.easeIn,
                    onComplete:colorFlashingIn
                });
    }
    public function endColorFlashing(duration:Number=0.5):void
    {
        TweenMax.to(_view, duration,
                {
                    removeTint:true,
                    ease:Sine.easeIn
                });
    }



    private function lightingOff():void
    {
        TweenMax.to(_view, 0.1, {removeTint:true, ease:Sine.easeOut});
    }

    /* ALPHA FLASHING */
    // мигание прозрачностью
    public function alphaFlashing(duration:Number=1, $repeatCount:int=1, callback:Function=null):void
    {
        var repeatCount:int = $repeatCount;
        alphaFlash();
        function alphaFlash():void
        {
            if(repeatCount > 0)
            {
                TweenLite.to(_view, (duration/$repeatCount)/2,
                        {
                            alpha:0.1,
                            ease:Sine.easeIn,
                            onComplete:returnAlphaFlash
                        });

            }
            else
            {
                _view.alpha = 1;
                if(callback) callback();
            }
        }
        function returnAlphaFlash():void
        {
            repeatCount--;
            TweenLite.to(_view, (duration/$repeatCount)/2,
                    {
                        alpha:1,
                        ease:Sine.easeIn,
                        onComplete:alphaFlash
                    });
        }
    }

    /* DEACTIVATE */
    public function deactivate():void
    {
        removeTimer();
    }

    protected function removeHitBox():void
    {
        removeTimer();
//        view.removeChild(_hitBox);
    }


    /* CHECK CURRENT FRAME LABEL */
    public function checkCurrentFrameLabel(label:String):Boolean
    {
        if(_currentFrameLabel) return (label == _currentFrameLabel.name);
        else return false;
    }

    public function get view():MovieClip {return _view;}

    public function get clipLabels():Vector.<ClipLabel> {return _clipLabels;}

    public function set clipLabels(value:Vector.<ClipLabel>):void {_clipLabels = value;}

    public function get orientation():int {return _orientation;}

    public function get speedX():Number {return _model.speedX;}

    public function set speedX(value:Number):void {_model.speedX = value;}

    public function get hitBox():Sprite {return _hitBox;}

    public function get controlledObject():Object {return _controlledObject;}

    public function set hitBox(value:Sprite):void {_hitBox = value;}
}
}
