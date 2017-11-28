/**
 * Created by GAMES on 12.12.15.
 */
package
{
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.utils.Dictionary;

import starling.textures.Texture;
import starling.textures.TextureAtlas;

/* ---EMBEDDED ASSETS---
 *
 * Здесь расположены все включённые файлы.
 *
 */
public class EmbeddedAssets
{
    public static var gameTextures:Dictionary = new Dictionary();
    public static var gameTextureAtlas:TextureAtlas;


    /* ATLAS LIST */

    [Embed(source="assets/atlases/mainAtlas.png")]
    public static const mainAtlas:Class;

    [Embed(source="assets/atlases/mainAtlas.xml", mimeType="application/octet-stream")]
    public static const mainAtlas_xml:Class;

    /* TEXTURE LIST */
    public static const HEX_EMPTY:String = "hexEmpty";
    public static const HEX_FULL:String = "hexFull";
    public static const HEX_DEBUG:String = "hexDebug";

    /* CONSTRUCTOR */
    public function EmbeddedAssets(){}

    /* GET ATLAS */
    public static function getAtlas():TextureAtlas
    {
        if (gameTextureAtlas == null)
        {
            var texture:Texture = getTexture("mainAtlas");
            var xml:XML = XML(new mainAtlas_xml());
            gameTextureAtlas=new TextureAtlas(texture, xml);
        }

        return gameTextureAtlas;
    }

    /* GET TEXTURE */
    public static function getTexture(name:String):Texture
    {
        if (gameTextures[name] == undefined)
        {
            var bitmapData:BitmapData = EmbeddedAssets[name];
            gameTextures[name]=Texture.fromBitmapData(bitmapData);
        }

        return gameTextures[name];
    }
}
}
