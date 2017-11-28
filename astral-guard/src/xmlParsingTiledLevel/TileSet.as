/**
 * Created by Sith on 13.03.14.
 *
 *
 * Взято из http://gamedevelopment.tutsplus.com/tutorials/parsing-tiled-tmx-format-maps-in-your-own-game-engine--gamedev-3104
 */
package xmlParsingTiledLevel
{
import flash.display.BitmapData;

public class TileSet
{
    private var _name            :String;

    private var _firstGid       :uint;
    private var _lastGid        :uint;
    private var _tileWidth      :uint;
    private var _tileHeight     :uint;
    private var _imageWidth     :uint;
    private var _imageHeight    :uint;
    private var _tileAmountWidth:uint;
    private var _bitmapData:BitmapData;

    public function TileSet(arg_firstGid:uint, arg_tilesetName:String, arg_tilesetTileWidth:uint, arg_tilesetTileHeight:uint, arg_imageWidth:uint, arg_imageHeight:uint)
    {
        _firstGid = arg_firstGid;
        _name = arg_tilesetName;
        _tileWidth = arg_tilesetTileWidth;
        _tileHeight = arg_tilesetTileHeight;
        _imageWidth = arg_imageWidth;
        _imageHeight = arg_imageHeight;
        _tileAmountWidth = Math.floor(arg_imageWidth / arg_tilesetTileWidth);
        _lastGid = _tileAmountWidth * Math.floor(arg_imageHeight / arg_tilesetTileHeight) + arg_firstGid - 1;
    }

public function get bitmapData():BitmapData {return _bitmapData;}

public function set bitmapData(value:BitmapData):void {_bitmapData = value;}

public function get firstGid():uint {return _firstGid;}

public function get lastGid():uint {return _lastGid;}

public function get tileAmountWidth():uint {return _tileAmountWidth;}

public function get tileWidth():uint {return _tileWidth;}

public function get tileHeight():uint {return _tileHeight;}

    public function set tileAmountWidth(value:uint):void {
        _tileAmountWidth = value;
    }

    public function set imageHeight(value:uint):void {
        _imageHeight = value;
    }

    public function get imageWidth():uint {
        return _imageWidth;
    }

    public function set imageWidth(value:uint):void {
        _imageWidth = value;
    }

    public function set tileHeight(value:uint):void {
        _tileHeight = value;
    }

    public function set tileWidth(value:uint):void {
        _tileWidth = value;
    }

    public function set lastGid(value:uint):void {
        _lastGid = value;
    }

    public function set firstGid(value:uint):void {
        _firstGid = value;
    }

    public function get name():String {
        return _name;
    }

    public function set name(value:String):void {
        _name = value;
    }
}
}
