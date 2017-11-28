/**
 * Created by Sith on 20.07.14.
 */
package levelStuff.controllers
{
import com.greensock.TweenLite;

import custom.ClipLabel;

import flash.display.Bitmap;

import flash.display.BitmapData;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.geom.ColorTransform;
import flash.geom.Point;
import flash.geom.Rectangle;

import levelStuff.enemies.Fragment;

import levelStuff.enemies.IEnemy;

public class FragmentController
{
    public static const FRAG:String = "frag_";


    private var _fragments:Vector.<Fragment> = new Vector.<Fragment>();
    private var _mainScreen:Sprite;

    /* CONSTRUCTOR */
    public function FragmentController(mainScreen:Sprite)
    {
        _mainScreen = mainScreen;
    }

    public function initFragments(enemy:IEnemy, callback:Function):void
    {
        enemy.view.gotoAndStop(ClipLabel.DEATH);
        for(var i:int = 1; i < enemy.fragmentsAmount; i++)
        {
            var curFrag:Sprite = enemy.view[FRAG+i];
            var curFragPoint:Point = new Point(enemy.view.x, enemy.view.y);
            curFrag.x = enemy.view.x;
            curFrag.y = enemy.view.y;
//            trace("curFrag.x : " + curFragPoint.x);
//            trace("curFrag.y : " + curFragPoint.y);
            _mainScreen.addChild(curFrag);
            var angle : Number = Math.random() * Math.PI * 2;
            var rotation:Number = (Math.random()*5)+5;
            var fragment:Fragment = new Fragment(curFrag as MovieClip, rotation, angle, curFrag.width, curFrag.height, curFragPoint.x, curFragPoint.y);
            _fragments.push(fragment);
            if(i == enemy.fragmentsAmount-1)
            {
                callback(enemy);
            }
        }
    }

    private static function initFragment(curFrag:Sprite):Sprite
    {
        var fragSpr:Sprite = new Sprite();
        var fragBitmapData:BitmapData = new BitmapData(curFrag.width, curFrag.height);
        var rect:Rectangle = new Rectangle(curFrag.x, curFrag.y, curFrag.width, curFrag.height);
//        fragBitmapData.copyPixels(viewBitmapData, rect, new Point(curFrag.x, curFrag.y));
        var bmp:Bitmap = new Bitmap(fragBitmapData);
        fragSpr.addChild(bmp);
        return fragSpr;
    }

    public function fragmentControllerLoop():void
    {
        for each(var frag:Fragment in _fragments)
        {
            if(!frag.isAlreadyMoved)
            {
                frag.isAlreadyMoved = true;
//                tweenAlpha(frag);
            }
            if(frag)
            {
//                frag.move();
            }
        }
    }

    private function tweenAlpha(frag:Fragment):void
    {
       /* TweenLite.to(frag.view, 1, {alpha:0, onComplete:destroyView});
        function destroyView():void
        {
            _mainScreen.removeChild(frag.view);
            _fragments.splice(_fragments.indexOf(frag), 1);
            frag = null;
        }*/
    }
}
}
