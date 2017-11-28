/**
 * Created by GAMES on 09.12.15.
 */

package
{

import com.hexagonstar.structures.grids.Grid2D;
import com.hexagonstar.util.display.StageReference;

import flash.display.Stage;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.ui.Keyboard;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.utils.AssetManager;

public class Game extends Sprite
    {
        /* CONSTRUCTOR */
        public function Game(){}

        private var _map:Map;
        private var _stageCenter:Point;
        private var _hexElementsAmount:int = 3;
        private var _hexElements:Vector.<HexElement>;
        private var _viewPart:Number;
        private var _assetManager:AssetManager;

        /* INIT */
        public function init(assetManager:AssetManager, stage:Stage)
        {
            _assetManager = assetManager;
            _stageCenter = new Point(stage.stageWidth/2, stage.stageHeight/4);
            _viewPart = stage.stageWidth/_hexElementsAmount;
            startGame();

            stage.addEventListener(KeyboardEvent.KEY_DOWN, keybordHandler);
        }

        /* KEYBOARD HANDLER */
        private function keybordHandler(e:KeyboardEvent):void
        {
            if(e.keyCode == Keyboard.R)
            {
                clearGame();
                startGame();
            }
        }

        /* START GAME */
        private function startGame():void
        {
            /* add map */
            var map:Map = new Map(4, Map.HEXAGONAL_SHAPE);
            _map = map;
            _map.buildMap();
            _map.x += _stageCenter.x;
            _map.y += _stageCenter.y;
            _map.updateView(_assetManager);
            addChild(_map);

            /* add  hex elements */
            _hexElements = new Vector.<HexElement>();
            for(var i:int = 0; i<_hexElementsAmount; i++)
            {
                generateElement(i);
            }
        }

        /* CLEAR GAME */
        private function clearGame():void
        {
            // очищаем вид
            removeChild(_map);
            if(_hexElements.length > 0)
            {
                for(var i:int = _hexElements.length-1; i >= 0; i--)
                {
                    trace(i);
                    var curHexElement:HexElement = _hexElements[i];
                    curHexElement.removeEventListener(TouchEvent.TOUCH, touchHandler);
                    removeChild(curHexElement);
                    curHexElement = null;
                }
            }
            // обнуляем переменные
            _map = null;
            _hexElements = null;
        }

        /* GENERATE ELEMENT */
        private function generateElement(moduleCount:int):void
        {
            var hexElement:HexElement = new HexElement(moduleCount);
            _hexElements.push(hexElement);
            var p:Point = new Point(_viewPart/2 + ((_viewPart)*moduleCount), _stageCenter.y + _map.height);
            hexElement.updateStartPoint(p);
            hexElement.updateView(_assetManager, new Point(0, 0));
            hexElement.addEventListener(TouchEvent.TOUCH, touchHandler);
            addChild(hexElement);
        }

        /* DELETE ELEMENT */
        private function deleteElement(hexElement:HexElement):void
        {
            _hexElements.splice(_hexElements.indexOf(hexElement), 1);
            hexElement.removeEventListener(TouchEvent.TOUCH, touchHandler);
            removeChild(hexElement);
            hexElement = null;
        }

        /* TOUCH HANDLER */
        private function touchHandler(e:TouchEvent):void
        {
            var touch:Touch = e.getTouch(stage);
            if(touch)
            {
                var position:Point = touch.getLocation(stage);
                if(e.target is Image)
                {
                    var target:Image = e.target as Image;
                    if(target.parent)
                    {
                        if(target.parent is HexElement)
                        {
                            var hexElement:HexElement = target.parent as HexElement;
                        }
                    }

                    if(touch.phase == TouchPhase.MOVED)
                    {
                        hexElement.x = position.x - target.width/2;
                        hexElement.y = position.y - target.height/2;
                    }
                    else if(touch.phase == TouchPhase.ENDED)
                    {
                        var endPoint:Point = new Point(_stageCenter.x, _stageCenter.y);
                        var canAdd:Boolean = _map.checkForAdding(hexElement, endPoint);
                        /* удаляется и добавляется новый */
                        if(canAdd)
                        {
                            /* добавляем элемент на карту */
                            _map.addHexElementToMap();
                            /* проверка на сбор ряда */
                            _map.checkForCollect();

                            var moduleCount:int = hexElement.moduleCount;
                            deleteElement(hexElement);
                            generateElement(moduleCount);
                        }
                        /* возвращается на место */
                        else
                        {
                            hexElement.x = hexElement.startPoint.x;
                            hexElement.y = hexElement.startPoint.y;
                        }
                        /* проверка на возможность ходов */
                        var canMove:Boolean;
                        canMove =_map.checkForPossibleMoves(_hexElements, endPoint);

                        if(canMove) trace("#################### YES YOU CAN  ###########################");
                        else        trace("********************  SORRY, NO MOVES  ********************  !!");
                    }
                }
            }
        }
    }
}
