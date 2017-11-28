/**
 * Created with IntelliJ IDEA.
 * User: work-04
 * Date: 04.06.14
 * Time: 12:57
 * To change this template use File | Settings | File Templates.
 */
package utils
{
import flash.events.TimerEvent;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.utils.Timer;

public class ShiftingTextField extends TextField
{
    private var _tf:TextField;
    private var _isShowZero:Boolean;  // отображение "" вместо 0
    private var _isDecimal:Boolean;   // десятичное ли число

    public function ShiftingTextField(tf:TextField, isShowZero:Boolean=true, isDecimal:Boolean=false)
    {
        _tf = tf;
        _isShowZero = isShowZero;
        _isDecimal = isDecimal;
    }

    /* TWEEN NUMBERS */
    // анимация текстового поля с цифрами
    // tf - текстовое поле, которое будет отображать измениния
    // startCount - начальное число анимации
    // finishCount - конечное число анимации
    // apartCount - количество частей, на которое разбивается число
    private var _updateTimer:Timer;
    public function tweenNumbers(finishCount:Number, apartCount:int = 1):void
    {
        var part:Number;
        var firstCount:Number = Number(_tf.text); // стартовое число с которого начинаются изменения   v
        var startCount:Number = Number(_tf.text);
        if(startCount < finishCount)
        {
            if(!_isDecimal)   part = Math.floor(finishCount/apartCount);
            else              part = (((finishCount/apartCount)*10)/10);
        }
        else if(startCount > finishCount)
        {
            if(!_isDecimal)   part = Math.floor(startCount/apartCount);
            else               part = (((startCount/apartCount)*10)/10);
        }

        if(_updateTimer)
        {
            _updateTimer.removeEventListener(TimerEvent.TIMER, updateText);
            _updateTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, removeTimer);
            _updateTimer = null;

        }

        _updateTimer = new Timer(25, apartCount);
        _updateTimer.addEventListener(TimerEvent.TIMER, updateText);
        _updateTimer.addEventListener(TimerEvent.TIMER_COMPLETE, removeTimer);
        _updateTimer.start();

        function updateText(e:TimerEvent):void
        {
            // увеличение
//            trace("startCount : " + startCount);
//            trace("finishCount : " + finishCount);
            if(startCount < finishCount)
             {
                startCount += part;

                 if(startCount > firstCount)
                 {
                     updateFormat(String(startCount));
                 }
             }
             // уменьшение
             if(startCount > finishCount)
             {
                startCount -= part;
                 updateFormat(String(startCount));
             }
        }

        function removeTimer (e:TimerEvent):void
        {
            var fc:String = finishCount.toString();
            if(!_isShowZero)
            {
                if(finishCount == 0)
                {
                    fc = "";
                }
            }
            updateFormat(fc);
        }
    }

    /* SET TEXT */
    private var _tfFormat:TextFormat;
    private const MIN_SIZE:int = 5;
    private var curSize:int = 12;
    private function updateFormat(txt:String):void
    {
        _tfFormat = new TextFormat();
        while(_tf.numLines > 1)
        {
            curSize--;

            if(curSize <= MIN_SIZE)
            {
                curSize = MIN_SIZE;
            }
            _tfFormat.size = curSize;
            _tf.setTextFormat(_tfFormat);
            _tf.text = txt;
//            trace("_tf.numLines : " + _tf.numLines);
//            trace("curSize : " + curSize);
        }
        _tf.text = txt;
    }
}
}
