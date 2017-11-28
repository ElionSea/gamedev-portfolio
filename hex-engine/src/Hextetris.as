package {

import flash.display.Sprite;
import flash.display.Stage;
import flash.display.StageAlign;
import flash.display.StageDisplayState;
import flash.display.StageScaleMode;
import flash.geom.Rectangle;
import flash.text.TextField;

import starling.core.Starling;
import starling.display.Image;
import starling.events.Event;
import starling.textures.Texture;
import starling.textures.TextureAtlas;
import starling.utils.AssetManager;

[SWF(frameRate=60, backgroundColor="#000000")]
public class Hextetris extends Sprite {

    private var _starling:Starling;
    private var _assetManager:AssetManager;


    public function Hextetris() {
        stage.align=StageAlign.TOP_LEFT;
        stage.scaleMode=StageScaleMode.SHOW_ALL;
        stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;

        _starling = new Starling(Game, this.stage);

        _starling.addEventListener(Event.ROOT_CREATED, onRootCreated);
        _starling.start();
    }

    /* ON ROOT CREATED */
    private function onRootCreated(e:Event):void
    {
        _assetManager = new AssetManager();
        _assetManager.enqueue(EmbeddedAssets);
        _assetManager.verbose = true;
        _assetManager.loadQueue(onProgress);
    }

    /* ON PROGRESS */
    private function onProgress(e:Number):void
    {
        if(e >= 1) Game(_starling.root).init(_assetManager, stage);
    }
}
}
