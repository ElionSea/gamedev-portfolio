/**
 * Created by Sith on 30.08.14.
 */
package locale
{
public class InfoNode
{
    private var _caption:String;
    private var _description:String;
    private var _cost:String;
    private var _color:String;
    private var _bossName:String;

    /*CONSTRUCTOR*/
    public function InfoNode()
    {

    }

    public function get caption():String {return _caption;}
    public function set caption(value:String):void {_caption = value;}

    public function get description():String {return _description;}
    public function set description(value:String):void {_description = value;}

    public function get cost():String {return _cost;}
    public function set cost(value:String):void {_cost = value;}

    public function get color():String {return _color;}
    public function set color(value:String):void {_color = value;}

    public function get bossName():String {return _bossName;}
    public function set bossName(value:String):void {_bossName = value;}
}
}
