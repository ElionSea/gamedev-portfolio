/**
 * Created by GAMES on 20.12.15.
 */
package
{
import flash.geom.Point;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.AssetManager;

/* поле с гексами
* !! Нужно будет разделить на модель и вид
* */
public class Map extends Sprite
{
    private var _mapRadius:int;
    private var _mapType:String;
    private var _startOffsetPoint:Point; // стартовая точка расположения гексов
    private var _hexStorage:Vector.<Hex>;
    private var _layout:Layout;
    private var _assetManager:AssetManager;
    private var _updatingMapHexes:Vector.<Hex>;

    public static const HEXAGONAL_SHAPE:String = "HexagonalShape";

    public function Map(mapRadius:int, mapType:String)
    {
        _mapRadius = mapRadius;
        _mapType = mapType;
    }

    /* BUILD MAP */
    public function buildMap():void
    {
        _hexStorage = new Vector.<Hex>();
        for(var q:int = -_mapRadius; q <= _mapRadius; q++)
        {
            var r1:int = Math.max(-_mapRadius, -q-_mapRadius);
            var r2:int = Math.min(_mapRadius, -q+_mapRadius);
            for(var r:int = r1; r <= r2; r++)
            {
                var newHex:Hex = new Hex(q, r, -q-r);
                _hexStorage.push(newHex);
                //trace("-----------");
                //trace("HEX : x-" + newHex.q + " y-" + newHex.r + " z-" + newHex.s);
            }
        }
    }

    /* UPDATE VIEW */
    public function updateView(assetManager:AssetManager):void
    {
        _assetManager = assetManager;
        var orientation:Orientation = Orientation.pointyLayout();
        _layout = new Layout(orientation, new Point(25, 25), new Point(0, 0));

        for each(var hex in _hexStorage)
        {
            hex.updateState(Hex.STATE_EMPTY);
            var img:Image = new Image(_assetManager.getTexture(EmbeddedAssets.HEX_EMPTY));
            hex.image = null;
            hex.image = img;
            var p:Point = Layout.hexToPixel(_layout, hex);
            img.x = p.x;
            img.y = p.y;
            //trace("-----");
            //trace("X : " + img.x);
            //trace("Y : " + img.y);
            addChild(img);

        }

        /* ADD DEBUG TEXTFIELS */
        for each(var hex in _hexStorage)
        {
            var text:String = hex.q + ", " + hex.r + ", " + hex.s;
            var tf:TextField = new TextField(hex.image.width, hex.image.height, text, "Verdana", 9, 0xffffff, true);
            tf.x = hex.image.x;
            tf.y = hex.image.y;
            addChild(tf);
        }
    }

    /* CHECK FOR ADDING
    * проверка на возможность добавления гексо-элемента на карту */

     public function checkForAdding(hexElement:HexElement, endPoint:Point):Boolean
    {
        _updatingMapHexes = new Vector.<Hex>();
        for each(var hex:Hex in hexElement.hexStorage)
        {

            /* достаём глобальные координаты центра каждого гекса */
            var imgP:Point = new Point(hex.image.x, hex.image.y);
            var globHex:Point = hex.localToGlobal(imgP);
            var globHexEl:Point = hexElement.localToGlobal(globHex);
            var globImgP:Point = stage.localToGlobal(globHexEl);
            //trace("globImgP : " + globImgP);
            //trace("endPoint : " + endPoint);

            /* по этим же координатам проверяем гекс карты */
            var fHex:FractionalHex = Layout.pixelToHex(_layout, new Point(globImgP.x - endPoint.x, globImgP.y - endPoint.y));
            var mapHex:Hex = Layout.hexRound(fHex);

            /* проверяем существует ли такой гекс на карте */
            var gHex:Hex = getHex(mapHex.q, mapHex.r, mapHex.s);
            if(gHex && gHex.state == Hex.STATE_EMPTY) _updatingMapHexes.push(gHex);
            else return false;
        }
        return true;
    }

    /* ADD HEX ELEMENT TO MAP */
    public function addHexElementToMap():void
    {
        /* обновляем карту */
        for each(var hex:Hex in _updatingMapHexes)
        {
            hex.updateState(Hex.STATE_FULL);
            var img:Image = new Image(_assetManager.getTexture(EmbeddedAssets.HEX_FULL));
            hex.image = img;
            var p:Point = Layout.hexToPixel(_layout, hex);
            img.x = p.x;
            img.y = p.y;
            img.alpha = 0.5;
            addChild(img);
        }
    }

    /* CHECK FOR COLLECT */
    public function checkForCollect():void
    {
        var collectLines:Vector.<Vector.<Hex>> = new Vector.<Vector.<Hex>>(); // массив с собранными линиями
        var collectLineQ:Vector.<Hex> = new Vector.<Hex>();
        var collectLineR:Vector.<Hex> = new Vector.<Hex>();
        var collectLineS:Vector.<Hex> = new Vector.<Hex>();

        /* пробегаемся по каждому гексу из вновь добавленных на поле */
        for(var i:int = 0; i < _updatingMapHexes.length; i++)
        {
            var curHex:Hex = _updatingMapHexes[i]; // гекс элемента, от которого будет вестись отсчёт
            var qLine:Vector.<Hex> = getHexLine(curHex.q);
            var rLine:Vector.<Hex> = getHexLine(-100, curHex.r);
            var sLine:Vector.<Hex> = getHexLine(-100, -100, curHex.s);


            if(qLine)
            {
                //trace("Q Line is : " + qLine.length);
                if(qLine.length > 0) collectLineQ = collectLineQ.concat(qLine);
            }
            if(rLine)
            {
                //trace("R Line is : " + rLine.length);
                if(rLine.length > 0) collectLineR = collectLineR.concat(rLine);
            }
            if(sLine)
            {
                //trace("S Line is : " + sLine.length);
                if(sLine.length > 0) collectLineS = collectLineS.concat(sLine);
            }
        }

        /* обновляем собранные линии */
        if(collectLineQ.length > 0)
        {
            collectLines.push(collectLineQ);
            /*for each(var hex:Hex in collectLineQ)
            {
                Hex.debugTraceHex("ADD TO Q :", hex);
            }*/
        }
        if(collectLineR.length > 0)
        {
            collectLines.push(collectLineR);
            /*for each(var hex:Hex in collectLineR)
            {
                Hex.debugTraceHex("ADD TO R :", hex);
            }*/
        }
        if(collectLineS.length > 0)
        {
            collectLines.push(collectLineS);
            /*for each(var hex:Hex in collectLineS)
            {
                Hex.debugTraceHex("ADD TO S :", hex);
            }*/
        }

        /* очищаем ряд */
        for each(var line:Vector.<Hex> in collectLines)
        {
           for each(var hex:Hex in line)
           {
             hex.updateState(Hex.STATE_EMPTY);
             var img:Image = new Image(_assetManager.getTexture(EmbeddedAssets.HEX_EMPTY));
             hex.image = null;
             hex.image = img;
             var p:Point = Layout.hexToPixel(_layout, hex);
             img.x = p.x;
             img.y = p.y;
             //trace("-----");
             //trace("X : " + img.x);
             //trace("Y : " + img.y);
             addChild(img);

               var text:String = hex.q + ", " + hex.r + ", " + hex.s;
               var tf:TextField = new TextField(hex.image.width, hex.image.height, text, "Verdana", 9, 0xffffff, true);
               tf.x = hex.image.x;
               tf.y = hex.image.y;
               addChild(tf);
           }
        }
    }

    /* CHECK FOR POSSIBLE MOVES */
    public function checkForPossibleMoves(hexElements:Vector.<HexElement>, offsetPoint:Point):Boolean
    {
        var canMove:Boolean;
        // достаём из поля все пустые гексы
        var empties:Vector.<Hex> = getEmpties();

        if(empties.length > 0)
        {
            // делаем проверку для каждого пустого гекса
            for each(var emptyHex:Hex in empties)
            {
                // подставляем каждый гекс-элемент
                for each(var hexElement:HexElement in hexElements)
                {
                    canMove = checkEmptyWithElement(emptyHex, hexElement, offsetPoint);
                    if(canMove) return true;
                }
            }
        }
        return false;
    }

    /* CHECK EMPTY WITH ELEMENT */
    private function checkEmptyWithElement(emptyHex:Hex, hexElement:HexElement, offsetPoint:Point):Boolean
    {
        _updatingMapHexes = new Vector.<Hex>();
        trace("|||||||||||||||||||||||| POSSIBLE MOVE ||||||||||||||||||||||");
        Hex.debugTraceHex("EMPTY HEX :", emptyHex);
        trace("ELEMENT THAT YOU CAN PUT : " + hexElement.type);
        var allPoints = getElementPoints(hexElement, emptyHex);
        var possibleHexes:Vector.<Hex> = new Vector.<Hex>();
        for each(var points:Vector.<Hex> in allPoints)
        {
           var possibles:int = 0;
           for each(var point:Hex in points)
           {
               if(point != undefined)
               {
                   possibles += 1;
                   possibleHexes.push(point);
               }
           }
           if(possibles == allPoints.length)
           {
               for each(var p:Hex in possibleHexes)
               {
                   trace("_______________________________");

                   Hex.debugTraceHex("POSSIBLE HEX : ", p);
               }
               return true;
           }
            else
           {
               possibleHexes = new Vector.<Hex>();
           }
        }
        return false;
    }

    /* GET ELEMENT POINTS
    (все варианты приложения гекс-элемента к ячейке поля(пустой))
     * двумерный массив, длина которого зависит от количества гексов в элементе.
      * В каждой ячейке находится также массив с точками элемента, относительно текущего приложенного */
    private function getElementPoints(hexElement:HexElement, emptyHex:Hex):Vector.<Vector.<Hex>>
    {
        var allPoints:Vector.<Vector.<Hex>> = new Vector.<Vector.<Hex>>();
        for (var i:int = 0; i < hexElement.hexStorage.length; i++)
        {
            var centralHex:Hex = hexElement.hexStorage[i];
            var curPoints:Vector.<Hex> = new Vector.<Hex>();
            allPoints[i] = curPoints;
            for (var j:int = 0; j < hexElement.hexStorage.length; j++)
            {
                var curHex:Hex = hexElement.hexStorage[j];
                // вычисляем точку текущего элемента

                var q:int;
                if(centralHex.q > curHex.q) q = -(Math.abs(centralHex.q) + Math.abs(curHex.q));
                else if(centralHex.q < curHex.q) q = Math.abs(centralHex.q) + Math.abs(curHex.q);
                else q = 0;

                var r:int;
                if(centralHex.r > curHex.r) r = -(Math.abs(centralHex.r) + Math.abs(curHex.r));
                else if(centralHex.r < curHex.r) r = Math.abs(centralHex.r) + Math.abs(curHex.r);
                else r = 0;

                var s:int;
                if(centralHex.s > curHex.s) s = -(Math.abs(centralHex.s) + Math.abs(curHex.s));
                else if(centralHex.s < curHex.s) s = Math.abs(centralHex.s) + Math.abs(curHex.s);
                else s = 0;

                var offsetHex:Hex = new Hex(q, r, s);

                /*if(emptyHex.q > offsetHex.q) q = emptyHex.q - offsetHex.q;
                else                      q = emptyHex.q + offsetHex.q;

                if(emptyHex.r > offsetHex.r) r = emptyHex.r - offsetHex.r;
                else                      r = emptyHex.r + offsetHex.r;

                if(emptyHex.s > offsetHex.s) s = emptyHex.s - offsetHex.s;
                else                      s = emptyHex.s + offsetHex.s;*/

                var tempHex:Hex = Hex.hexAdd(emptyHex, offsetHex);
                var mapHex:Hex = getHex(tempHex.q , tempHex.r, tempHex.s);
                // если такой на карте существует
                if(mapHex)
                {
                    // если он пустой
                    if(mapHex.state == Hex.STATE_EMPTY)
                    {
                        // если уже не содержится в собранном массиве
                        if(!checkForAlreadyInArray(mapHex, curPoints))
                        {
                            // только тогда добавляем его в массив
                            curPoints.push(mapHex);
                        }
                    }
                }
            }
        }
        /*for each(var curPs:Vector.<Hex> in allPoints)
        {
            trace("||||||||||||||||||||||||||||||");
            for each(var p:Hex in curPs)
            {
                trace(Hex.debugTraceHex("", p));
                trace("_____________________")
            }
        }*/
        return allPoints;
    }

    /* CHECK FOR ALREADY IN ARRAY */
    private function checkForAlreadyInArray(mapHex:Hex, curPoints:Vector.<Hex>):Boolean
    {
        var equal:Boolean;
        for each(var hex:Hex in curPoints)
        {
            equal = Hex.hexEquals(hex, mapHex);
            if(equal) return true;
        }
        return false;
    }

    /* GET EMPTIES */
    private function getEmpties():Vector.<Hex>
    {
        var empties:Vector.<Hex> = new Vector.<Hex>();
        for each(var hex:Hex in _hexStorage)
        {
            if(hex.state == Hex.STATE_EMPTY)
            {
                empties.push(hex);
                //drawDebugHex(hex);
            }
            else
            {
                //removeDrawDebug(hex);
            }
        }
        return empties;
    }

    private function removeDrawDebug(hex:Hex):void
    {
        if(hex.debugImage) removeChild(hex.debugImage);
    }

    /* DRAW DEBUG HEX */
    private function drawDebugHex(hex:Hex):void
    {
        var img:Image = new Image(_assetManager.getTexture(EmbeddedAssets.HEX_DEBUG));
        hex.debugImage = img;
        var p:Point = Layout.hexToPixel(_layout, hex);
        img.x = p.x;
        img.y = p.y;
        addChild(img);
    }

    /* GET HEX */
    private function
            getHex(q:int=-100, r:int=-100, s:int=-100):Hex
    {
        var param:String = "";
        if      (q == -100 && r == -100) param = "S";
        else if (r == -100 && s == -100) param = "Q";
        else if (s == -100 && q == -100) param = "R";
        for each(var hex:Hex in _hexStorage)
        {
            switch (param)
            {
                case "": if(q == hex.q && r == hex.r && s == hex.s) return hex; break;
                case "S": if(s == hex.s) return hex; break;
                case "Q": if(q == hex.q) return hex; break;
                case "R": if(r == hex.r) return hex; break;
            }
        }
        return null;
    }

    /* GET HEX LINE */
    private function getHexLine(q:int=-100, r:int=-100, s:int=-100, fitParam:int=Hex.STATE_FULL):Vector.<Hex>
    {
        var hexLine:Vector.<Hex> = new Vector.<Hex>();
        var param:String = "";
        if      (q == -100 && r == -100) param = "S";
        else if (r == -100 && s == -100) param = "Q";
        else if (s == -100 && q == -100) param = "R";
        for each(var hex:Hex in _hexStorage)
        {
            var isFit:Boolean = false;
            if(param == "")
            {
                if(q == hex.q && r == hex.r && s == hex.s) isFit = true;
            }
            else if(param == "S")
            {
                if(s == hex.s) isFit = true;
            }
            else if(param == "Q")
            {
                if(q == hex.q) isFit = true;
            }
            else if(param == "R")
            {
                if(r == hex.r) isFit = true;
            }

            if(isFit)
            {
                if(fitParam == hex.state) hexLine.push(hex);
                else return null;// если попадётся хотя бы одна пустая
            }
        }
        return hexLine;
    }

    public function getHexByPoint(p:Point):Hex
    {
        var fractHex:FractionalHex = Layout.pixelToHex(_layout, p);
        var hex:Hex = Layout.hexRound(fractHex);
        trace(hex.q, hex.r, hex.s);
        return hex;
    }

    public function get mapRadius():int {return _mapRadius;}
}
}
