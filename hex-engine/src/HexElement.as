/**
 * Created by GAMES on 28.12.15.
 */
package {
import flash.events.Event;
import flash.geom.Point;

import starling.display.Image;
import starling.display.Quad;

import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.utils.AssetManager;

public class HexElement extends Sprite
{
    private var _hexStorage:Vector.<Hex>;
    private var _startPoint:Point;
    private var _layout:Layout;
    private var _moduleCount:int; // номер модуля, из которого тянется элемент
    private var _type:int;

    public function HexElement(moduleCount:int=0)
    {
        _moduleCount = moduleCount;
        _hexStorage = buildHexElement();
    }

    /* BUILD HEX ELEMENT */
    private function buildHexElement(type:int=1):Vector.<Hex>
    {
        var random:int = Math.floor(Math.random()*25)+1;
        type = random;
        //trace("hex element type : " + type);
        var hexElement:Vector.<Hex> = new Vector.<Hex>();


        /* DEBUG RANDOM
        для одиночного элемента ======== */
        var randomForElement12 = Math.random();
        if(randomForElement12 < 0.15) type = 12;
        /* ======================== */

        var hexCash:Array = getElementCash(type);

        /* update hex element */
        for(var i:int=0; i < hexCash.length; i++)
        {
            hexElement.push(new Hex(hexCash[i][0], hexCash[i][1], hexCash[i][2]));
        }
        _type = type;
        return hexElement;
    }

    /* GET ELEMENT CASH */
    public static function getElementCash(type:int):Array
    {
        var hexCash:Array;
        switch (type)
        {
            case 1: hexCash = [[-1, 0, 1], [0, 0, 0], [1, 0, -1], [0, 1, -1]]; break;
            case 2: hexCash = [[-1, 0, 1], [0, 0, 0], [1, 0, -1], [1, -1, 0]]; break;
            case 3: hexCash = [[0, 0, 0], [1, -1, 0], [1, 0, -1], [0, 1, -1]]; break;
            case 4: hexCash = [[-1, 0, 1], [0, 0, 0], [1, 0, -1], [-1, 1, 0]]; break;
            case 5: hexCash = [[0, -1, 1], [0, 0, 0], [0, 1, -1], [0, 2, -2]]; break;
            case 6: hexCash = [[-1, 1, 0], [0, 0, 0], [1, -1, 0], [1, 0, -1]]; break;
            case 7: hexCash = [[0, -1, 1], [0, 0, 0], [0, 1, -1], [-1, 1, 0]]; break;
            case 8: hexCash = [[0, -1, 1], [1, -1, 0], [0, 0, 0], [1, 0, -1]]; break;
            case 9: hexCash = [[-1, 0, 1], [0, -1, 1], [0, 0, 0], [0, 1, -1]]; break;
            case 10: hexCash = [[0, -1, 1], [1, -1, 0], [0, 0, 0], [-1, 1, 0]]; break;
            case 11: hexCash = [[-1, 0, 1], [0, 0, 0], [1, 0, -1], [2, 0, -2]]; break;
            case 12: hexCash = [[0, 0, 0]]; break;
            case 13: hexCash = [[0, -1, 1], [-1, 0, 1], [0, 0, 0], [1, 0, -1]]; break;
            case 14: hexCash = [[0, -1, 1], [-1, 0, 1], [-1, 1, 0], [0, 1, -1]]; break;
            case 15: hexCash = [[2, -2, 0], [1, -1, 0], [0, 0, 0], [-1, 1, 0]]; break;
            case 16: hexCash = [[1, -1, 0], [0, 0, 0], [-1, 1, 0], [-1, 0, 1]]; break;
            case 17: hexCash = [[1, -1, 0], [0, 0, 0], [-1, 1, 0], [0, 1, -1]]; break;
            case 18: hexCash = [[0, -1, 1], [1, -1, 0], [1, 0, -1], [0, 1, -1]]; break;
            case 19: hexCash = [[1, -1, 0], [1, 0, -1], [0, 1, -1], [-1, 1, 0]]; break;
            case 20: hexCash = [[1, -1, 0], [0, -1, 1], [0, 0, 0], [0, 1, -1]]; break;
            case 21: hexCash = [[0, -1, 1], [0, 0, 0], [0, 1, -1], [1, 0, -1]]; break;
            case 22: hexCash = [[0, -1, 1], [1, -1, 0], [0, 0, 0], [-1, 0, 1]]; break;
            case 23: hexCash = [[-1, 0, 1], [0, -1, 1], [1, -1, 0], [1, 0, -1]]; break;
            case 24: hexCash = [[1, -1, 0], [0, -1, 1], [-1, 0, 1], [-1, 1, 0]]; break;
            case 25: hexCash = [[-1, 0, 1], [-1, 1, 0], [0, 1, -1], [1, 0, -1]]; break;
        }
        return hexCash;
    }

    /* UPDATE VIEW */
    public function updateView(assetManager:AssetManager, startOffsetPoint:Point):void
    {
        var orientation:Orientation = Orientation.pointyLayout();
        _layout = new Layout(orientation, new Point(25, 25), startOffsetPoint);

        for each(var hex in _hexStorage)
        {
            hex.updateState(Hex.STATE_EMPTY);
            var img:Image = new Image(assetManager.getTexture(EmbeddedAssets.HEX_FULL));
            hex.image = img;
            var p:Point = Layout.hexToPixel(_layout, hex);
            img.x = p.x;
            img.y = p.y;
            //trace("-----");
            //trace("X : " + img.x);
            //trace("Y : " + img.y);
            addChild(img);
        }
    }

    public function getHexByPoint(p:Point):Hex
    {
        var fractHex:FractionalHex = Layout.pixelToHex(_layout, p);
        var hex:Hex = Layout.hexRound(fractHex);
        trace(hex.q, hex.r, hex.s);
        return hex;
    }

    /* UPDATE START POINT */
    public function updateStartPoint(p:Point):void
    {
        _startPoint = new Point(p.x, p.y);
        this.x = _startPoint.x;
        this.y = _startPoint.y;
    }

    public function get startPoint():Point {return _startPoint;}

    public function get hexStorage():Vector.<Hex> {
        return _hexStorage;
    }

    public function get moduleCount():int {
        return _moduleCount;
    }

    public function get type():int {
        return _type;
    }

    public function set type(value:int):void {
        _type = value;
    }

    public function get layout():Layout {
        return _layout;
    }
}
}
