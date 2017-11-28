/**
 * Created by Sith on 26.09.14.
 */
package custom
{
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.text.TextField;

public class CustomSimpleButton {
    /*CONSTRUCTOR*/
    public function CustomSimpleButton()
    {
    }

    /* UPDATE BUTTON WEIGHT */
    public static function updateButtonWeight(updateButton:SimpleButton, newWeight:int):void
    {
        var upCont:Sprite = Sprite(updateButton.upState);
        var overCont:Sprite = Sprite(updateButton.overState);
//        var downCont:MovieClip = DisplayObjectContainer(updateButton.downState).getChildAt(2) as MovieClip;

        var upContTF:TextField = upCont.getChildAt(2) as TextField;
        var overContTF:TextField = overCont.getChildAt(2) as TextField;
//        var downContTF:TextField = downCont["tf"] as TextField;

        if(newWeight <= 0)
        {
            upContTF.text = "";
            overContTF.text = "";
//            downContTF.text = "";
        }
        else
        {
            upContTF.text = String(newWeight);
            overContTF.text = String(newWeight);
//            downContTF.text = String(newWeight);
        }
    }
}
}
