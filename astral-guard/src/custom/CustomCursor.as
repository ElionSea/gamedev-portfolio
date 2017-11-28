/**
 * Created by Sith on 26.03.14.
 */
package custom
{
import cv.OrionMouse;
import cv.orion.filters.FadeFilter;
import cv.orion.filters.GravityFilter;
import cv.orion.filters.ScaleFilter;
import cv.orion.filters.WanderFilter;
import cv.orion.output.BurstOutput;

import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.ui.Mouse;
import flash.ui.MouseCursorData;

public class CustomCursor extends Sprite
{
    private static var _arrowData:Vector.<BitmapData> = Vector.<BitmapData>([new ImgArrowCursor()]);
    private static var _shootData1:Vector.<BitmapData> = Vector.<BitmapData>([new ImgShootCursor1()]);
    private static var _shootData2:Vector.<BitmapData> = Vector.<BitmapData>([new ImgShootCursor2()]);
    private static var _shootData3:Vector.<BitmapData> = Vector.<BitmapData>([new ImgShootCursor3()]);
    private static var _shootData4:Vector.<BitmapData> = Vector.<BitmapData>([new ImgShootCursor4()]);
    private static var _shootData5:Vector.<BitmapData> = Vector.<BitmapData>([new ImgShootCursor5()]);
    private static var _shootData6:Vector.<BitmapData> = Vector.<BitmapData>([new ImgShootCursor6()]);
    private static var _shootData7:Vector.<BitmapData> = Vector.<BitmapData>([new ImgShootCursor7()]);
    private static var _handData:Vector.<BitmapData> = Vector.<BitmapData>([new ImgHandCursor()]);
    private static var _customCursor:MouseCursorData = new MouseCursorData();
    private static var _shootCursor1:MouseCursorData = new MouseCursorData();
    private static var _shootCursor2:MouseCursorData = new MouseCursorData();
    private static var _shootCursor3:MouseCursorData = new MouseCursorData();
    private static var _shootCursor4:MouseCursorData = new MouseCursorData();
    private static var _shootCursor5:MouseCursorData = new MouseCursorData();
    private static var _shootCursor6:MouseCursorData = new MouseCursorData();
    private static var _shootCursor7:MouseCursorData = new MouseCursorData();
    private static var _handCursor:MouseCursorData = new MouseCursorData();

    public static const ARROW_CURSOR:String = "customArrow";
    public static const SHOOT_CURSOR_1:String = "shootCursor_1";
    public static const SHOOT_CURSOR_2:String = "shootCursor_2";
    public static const SHOOT_CURSOR_3:String = "shootCursor_3";
    public static const SHOOT_CURSOR_4:String = "shootCursor_4";
    public static const SHOOT_CURSOR_5:String = "shootCursor_5";
    public static const SHOOT_CURSOR_6:String = "shootCursor_6";
    public static const SHOOT_CURSOR_7:String = "shootCursor_7";
    public static const HAND_CURSOR:String = "handCursor";

    public static var shootCursors:Array = [SHOOT_CURSOR_1, SHOOT_CURSOR_2, SHOOT_CURSOR_3, SHOOT_CURSOR_4, SHOOT_CURSOR_5, SHOOT_CURSOR_6, SHOOT_CURSOR_7];

    private var _totalScreen:Sprite;

    public static var _currentShootCursor:String = SHOOT_CURSOR_1;

    /* CONSTRUCTOR */
    public function CustomCursor(totalScreen:Sprite)
    {
        _totalScreen = totalScreen;

        _customCursor.data = _arrowData;
        _customCursor.hotSpot = new Point();
        Mouse.registerCursor(ARROW_CURSOR, _customCursor);

        _shootCursor1.data = _shootData1;
        _shootCursor2.data = _shootData2;
        _shootCursor3.data = _shootData3;
        _shootCursor4.data = _shootData4;
        _shootCursor5.data = _shootData5;
        _shootCursor6.data = _shootData6;
        _shootCursor7.data = _shootData7;
        _shootCursor1.hotSpot = new Point();
        _shootCursor2.hotSpot = new Point();
        _shootCursor3.hotSpot = new Point();
        _shootCursor4.hotSpot = new Point();
        _shootCursor5.hotSpot = new Point();
        _shootCursor6.hotSpot = new Point();
        _shootCursor7.hotSpot = new Point();
        Mouse.registerCursor(SHOOT_CURSOR_1, _shootCursor1);
        Mouse.registerCursor(SHOOT_CURSOR_2, _shootCursor2);
        Mouse.registerCursor(SHOOT_CURSOR_3, _shootCursor3);
        Mouse.registerCursor(SHOOT_CURSOR_4, _shootCursor4);
        Mouse.registerCursor(SHOOT_CURSOR_5, _shootCursor5);
        Mouse.registerCursor(SHOOT_CURSOR_6, _shootCursor6);
        Mouse.registerCursor(SHOOT_CURSOR_7, _shootCursor7);

        _handCursor.data = _handData;
        _handCursor.hotSpot = new Point();
        Mouse.registerCursor(HAND_CURSOR, _handCursor);

        Mouse.cursor = ARROW_CURSOR;
        emitParticles();
    }

    /* CHANGE CURSOR */
    public static function changeCursor(cursorName:String):void
    {
        Mouse.cursor = cursorName;
    }

    public static function changeCustomShootCursor(cursorName:String):void
    {
        _currentShootCursor = cursorName;
    }

    /* EMIT PARTICLES */
    private function emitParticles():void
    {
        /*var o:OrionMouse = new OrionMouse(TreasureParticleMc, null, null, false);
        o.canvas = new Rectangle(100, 100, 200, 200);
        o.effectFilters = [new FadeFilter(0.95), new GravityFilter(0.3),new ScaleFilter(0.95), new WanderFilter(0.5, 0.95)];
        o.settings.lifeSpan = 10000;
        o.settings.mass = 100;
        o.settings.alpha = 0.8;
        o.settings.velocityXMin = -0.5;
        o.settings.velocityXMax = 0.5;
        o.settings.velocityYMin = 1;
        o.settings.velocityYMax = 2;
        o.settings.color = "0x00D026";
        o.useCacheAsBitmap = true;
        o.onlyOnMouseMove = false;
        o.x = 150;
        o.y = 150;
        o.width = 200;
        o.height = 200;
        this.addChild(o);

        o = new OrionMouse(Mouse, new BurstOutput(50));
        o.onlyOnMouseMove = true;
        _totalScreen.addChild(o);*/
    }


}
}
