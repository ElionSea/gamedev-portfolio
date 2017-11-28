/**
 * Created by GAMES on 20.12.15.
 */
package {
import com.hexagonstar.util.potrace.backend.NullBackend;

import flash.geom.Point;

import starling.display.Image;

import starling.display.Sprite;

/*
Класс представляющий одну гексагональную ячейку сетки
*/
public class Hex extends Sprite
{
    private var _q:int; // столбец (column)
    private var _r:int; // ряд (row)
    private var _s:int; // другой ряд

    private var _state:int;
    public static const STATE_EMPTY:int = 0;
    public static const STATE_FULL:int = 1;

    private var _hexWidth:int;
    private var _hexHeight:int;
    private var _image:Image;
    private var _debugImage:Image;

    public static const DIRECTIONS:Array =[
        /* EAST - 0*/        [1, 0, -1],
        /* NORTH EAST - 1 */ [1, -1, 0],
        /* NORTH WEST - 2 */ [0, -1, 1],
        /* WEST - 3 */       [-1, 0, 1],
        /* SOUTH WEST - 4 */ [-1, 1, 0],
        /* SOUTH EAST - 5 */ [0, 1, -1]
    ];

    public function Hex(q:int, r:int, s:int, size:int = 25)
    {
        _q = q;
        _r = r;
        _s = s;
        var o:Object = hexToCube(_q, _r);
        this.x = o.x;
        this.y = o.y;
        this._hexHeight = size * 2;
        this._hexWidth = Math.sqrt(3)/2 * this._hexHeight;
        _state = Hex.STATE_EMPTY;
    }

    /* UPDATE STATE */
    public function updateState(state:int):void
    {
        _state = state;
    }
    /* HEX CORNER
    * функция возвращающая угловую точку угла гекса */
    private function hexCorner(center:Point, size:Number, i:int):Point
    {
        var angleDeg:Number = 60 * i +30;
        var angleRad:Number = Math.PI / 180 * angleDeg;
        return new Point(
                center.x + size * Math.cos(angleRad),
                center.y + size * Math.sin(angleRad)
        );
    }
    /* ============================ Neighbors ==================================*/
    /* HEX DIRECTION
     * определяет направление */
    public static function hexDirection(dir:int /* 0 to 5 */):int
    {
        return DIRECTIONS[dir];
    }

    /* !!! */
    public static function getHexByDir(dir:int):Hex
    {
        var hex:Hex = new Hex(
                DIRECTIONS[dir][0],
                DIRECTIONS[dir][1],
                DIRECTIONS[dir][2]
        )
        return hex;
    }

    /* DEBUG TRACE HEX */
    public static function debugTraceHex(debugString:String, h:Hex):void
    {
        if(h) trace(debugString + " hex : " + h.q + ", " + h.r + ", " + h.s);
    }

    /* HEX NEIGHBOR
    * определяет соседа */
    public static function hexNeighbor(hex:Hex, dir:int):Hex
    {
        return hexAdd(hex, getHexByDir(dir));
    }

    /*============================= Distance ===================================*/
    /* HEX LENGTH
    * длина*/
    public static function hexLength(hex:Hex):int
    {
        return int((Math.abs(hex.q) + Math.abs(hex.r) + Math.abs(hex.s)) / 2);
    }

    /* HEX DISTANCE
    * расстояние между двумя гексами*/
    public static function hexDistance(a:Hex, b:Hex):int
    {
        return hexLength(hexSubstract(a, b));
    }

    /*============================= Equals =====================================*/
    /* HEX EQUALS
     * сравнивает два гекса */
    public static function hexEquals(a:Hex, b:Hex):Boolean
    {
        return ( (a.q == b.q) && (a.r == b.r) && (a.s == b.s) );
    }

    /*========================== Coordinate arithmetic==============================*/
    /* HEX ADD
    * добавление */
    public static function hexAdd(a:Hex, b:Hex):Hex
    {
       return new Hex(a.q + b.q, a.r + b.r, a.s + b.s);
    }

    /* HEX SUBSTRACT
    * деление*/
    public static function hexSubstract(a:Hex, b:Hex):Hex
    {
        return new Hex(a.q - b.q, a.r - b.r, a.s - b.s);
    }

    /* HEX MULTIPLY
     * умножение */
    public static function hexMultiply(a:Hex, k:int):Hex
    {
        return new Hex(a.q *k, a.r *k, a.s *k);
    }

    /*==================================== Converting ======================================*/
    /* CUBE TO HEX
     * Преобразует кубические координаты в осевые */
    public static function cubeToHex(x:Number, z:Number):Object
    {
        var axial:Object = {};
        axial.q = x;
        axial.r = z;
        return axial;
    }

    /* HEX TO CUBE
     * Преобразует осевые координаты в кубические */
    public static function hexToCube(q:Number, r:Number):Object
    {
        var cube:Object = {};
        cube.x = q;
        cube.z = r;
        cube.y = -cube.x-cube.z;
        return cube;
    }

    /* CUBE TO EVEN-Q OFFSET
    * Преобразует  кубические в "чётный столбец" */
    public static function cubeToEvenQ(x:Number, z:Number):Object
    {
        var evenQ:Object = {};
        evenQ.q = x;
        evenQ.r = z + (x + (x&1)) / 2;
        return evenQ;
    }

    /* EVEN-Q OFFSET TO CUBE
    * Преобразует "чётный столбец" в кубические */
    public static function evenQToCube(q:Number, r:Number):Object
    {
        var cube:Object = {};
        cube.x = q;
        cube.z = r - (q + (q&1)) / 2;
        cube.y = -cube.x-cube.z;
        return cube;
    }

    /* CUBE TO ODD-Q OFFSET
    * Преобразует кубические в "нечётный столбец"*/
    public static function cubeToOddQ(x:Number, z:Number):Object
    {
        var oddQ:Object = {};
        oddQ.q = x;
        oddQ.r = z + (x - (x&1)) / 2;
        return oddQ;
    }

    /* ODD-Q OFFSET TO CUBE
    * Преобразует "нечётный столбец" в кубические */
    public static function oddQToCube(q:Number, r:Number):Object
    {
        var cube:Object = {};
        cube.x = q;
        cube.z = r - (q - (q&1)) / 2;
        cube.y = -cube.x-cube.z;
        return cube;
    }

    /* CUBE TO EVEN-R OFFSET
    * Преобразует кубические в "чётный ряд" */
    public static function cubeToEvenR(x:Number, z:Number):Object
    {
        var evenR:Object = {};
        evenR.q = x + (z + (z&1)) / 2;
        evenR.r = z;
        return evenR;
    }

     /* EVEN-R OFFSET TO CUBE
     * Преобразует "чётный ряд" в кубические */
    public static function evenRToCube(q:Number, r:Number):Object
    {
        var cube:Object = {};
        cube.x = q - (r + (r&1)) / 2;
        cube.z = r;
        cube.y = -cube.x-cube.z;
        return cube;
    }

     /* CUBE TO ODD-R OFFSET
     * Преобразует кубические в "нечётный ряд" */
    public static function cubeToOddR(x:Number, z:Number):Object
    {
        var oddR:Object = {};
        oddR.q = x + (z - (z&1)) / 2;
        oddR.r = z;
        return oddR;
    }

     /* ODD-R OFFSET TO CUBE
     * Преобразует "нечётный ряд" в кубические */
    public static function oddRToCube(q:Number, r:Number):Object
    {
        var cube:Object = {};
        cube.x = q - (r - (r&1)) / 2;
        cube.z = r;
        cube.y = -cube.x-cube.z;
        return cube;
    }

    /*=========================== Getters & Setters ==============================*/
    public function get q():int {
        return _q;
    }

    public function get r():int {
        return _r;
    }

    public function get s():int {
        return _s;
    }

    public function get hexWidth():int {
        return _hexWidth;
    }

    public function get hexHeight():int {
        return _hexHeight;
    }

    public function get image():Image {
        return _image;
    }

    public function set image(value:Image):void {
        _image = value;
    }

    public function get state():int {
        return _state;
    }

    public function get debugImage():Image {
        return _debugImage;
    }

    public function set debugImage(value:Image):void {
        _debugImage = value;
    }
}
}
