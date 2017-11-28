/**
 * Created by Sith on 16.07.14.
 */
package levelStuff.effects
{
import camera.MapMover;

import com.greensock.TweenLite;
import com.greensock.TweenMax;
import com.greensock.easing.Expo;

import custom.ClipLabel;
import custom.CustomEvent;
import custom.CustomEvent;
import custom.CustomEvent;

import flash.display.MovieClip;

import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.filters.GlowFilter;
import flash.geom.Point;

import compositepPattern.ISubController;

import player.PlayerController;

import sound.SoundManager;

public class EffectContoller extends Sprite implements ISubController
{
    private var _player:PlayerController;
    private var _mainScreen:Sprite;
    private var _camera:MapMover;
    private var _stage:Stage;
    private var _hitEffect:Effect;
    private var _dustEffect:Effect;
    private var _enemyDustEffect:Effect;
    private var _shootEffect:Effect;

    public function EffectContoller(player:PlayerController, mainScreen:Sprite, camera:MapMover, stage:Stage)
    {
        _player = player;
        _mainScreen = mainScreen;
        _camera = camera;
        _stage = stage;
        initEffects();
//        _mainScreen.addEventListener(CustomEvent.JUMP, jumpPlayerUp, true);
        _mainScreen.addEventListener(CustomEvent.HIT, hitEffect, true);
        _mainScreen.addEventListener(CustomEvent.DUST, dustEffect, true);
        _mainScreen.addEventListener(CustomEvent.DIED, enemyDied, true);
        _stage.addEventListener(CustomEvent.PLAYER_SHOOT, playerShoot, false);
        _stage.addEventListener(CustomEvent.SHAKE_GAMESCREEN, shakeTween, true);
        _mainScreen.addEventListener(CustomEvent.SHOW_DAMAGE, showDamage, true);
        _mainScreen.addEventListener(CustomEvent.HIT_POTION, hitPotion, true);
        _mainScreen.addEventListener(CustomEvent.SHOW_POWER_INCREASED, showPowerIncreasing);
        _mainScreen.addEventListener(CustomEvent.SHOW_PARALIZED, showParalized);
    }

    /* SHOW POWER INCREASING  */
    private function showPowerIncreasing(e:CustomEvent):void
    {
        var message:McPowerIncreasedInfo = new McPowerIncreasedInfo();
        message.x = e.obj.x;
        message.y = e.obj.y;
        _mainScreen.addChild(message);
        TweenMax.to(message, 2, {y:message.y-13/*, alpha:0.2*/, onComplete:hideMessage});
        function hideMessage():void
        {
            _mainScreen.removeChild(message);
            message = null;
        }
    }

    /* SHOW PARALYZED */
    private function showParalized(e:CustomEvent):void
    {
        var message:McParalizedInfo = new McParalizedInfo();
        message.x = e.obj.x;
        message.y = e.obj.y;
        _mainScreen.addChild(message);
        TweenMax.to(message, 2, {y:message.y-13, onComplete:hideMessage});
        function hideMessage():void
        {
            _mainScreen.removeChild(message);
            message = null;
        }
    }

    /* HIT POTION */
    private function hitPotion(e:CustomEvent):void
    {
//        trace("HIT POTION !");
        SoundManager.playSound(SoundManager.TAKE_POTION);
        var hitPotionView:MovieClip;
        if(e.obj.potionType == "red") hitPotionView = new McHitPotionRed();
        else                          hitPotionView = new McHitPotionBlue();
        var hitPotionEffect:Effect = new Effect(hitPotionView, _player.playerCont.x, _player.playerCont.y-(_player.playerCont.height/2));
        hitPotionEffect.clipLabels = new Vector.<ClipLabel>();
        hitPotionEffect.clipLabels.push(new ClipLabel(ClipLabel.WALK, 5, 0.4));
        _mainScreen.addChild(hitPotionEffect.view);
        hitPotionEffect.playState(ClipLabel.WALK, destroyEffect);
    }

    /* SHOW DAMAGE */
    private function showDamage(e:CustomEvent):void
    {
        if(e.controllerClass == PlayerController) showRedScreen();
        var tf:McShowDamageTf = new McShowDamageTf();
        tf.tf.text = e.obj.value.toString();
        tf.tf.textColor = e.obj.color;
        tf.x = e.obj.x;
        tf.y = e.obj.y;
        _mainScreen.addChild(tf);
        TweenMax.to(tf, 1.2, {y:tf.y-13/*, alpha:0.2*/, onComplete:hideDamage});
        function hideDamage():void
        {
            _mainScreen.removeChild(tf);
            tf = null;
        }
    }

    /* RED SCREEN */
    private var _redScreen:McRedScreen;
    private function showRedScreen():void
    {
        _redScreen.visible = true;
        _redScreen.alpha = 0.5;
        _mainScreen.addChild(_redScreen);
        TweenLite.to(_redScreen, 0.2, {alpha:0, onComplete:removeRedScreen});
    }
    private function removeRedScreen():void
    {
        _redScreen.visible = false;
        if(_mainScreen.contains(_redScreen))  _mainScreen.removeChild(_redScreen);
    }

    /* WHITE SCREEN */
    private var _whiteScreen:McWhiteScreen;
    private function whiteScreen():void
    {
        _whiteScreen.visible = true;
        _whiteScreen.alpha = 0.5;
        _mainScreen.addChild(_whiteScreen);
        TweenLite.to(_whiteScreen, 0.2, {alpha:0, onComplete:removeWhiteScreen});
    }
    private function removeWhiteScreen():void
    {
        _whiteScreen.visible = false;
        if(_mainScreen.contains(_whiteScreen)) _mainScreen.removeChild(_whiteScreen);
    }

    /* PLAYER SHOOT */
    private function playerShoot(e:CustomEvent):void
    {
        var shootBox:Sprite = _player.shootBox;
       _shootEffect = new Effect(new McGgShootApearing(), shootBox.x+_player.view.x, shootBox.y+_player.view.y);
        _shootEffect.clipLabels = new Vector.<ClipLabel>();
        _shootEffect.clipLabels.push(new ClipLabel(ClipLabel.WALK, 7, 0.3));
//        _shootEffect.filters = [new GlowFilter(0xFFFFFF, 0.5, 15, 15, 3, 1)];
        _mainScreen.addChild(_shootEffect.view);
//        TweenLite.to(_shootEffect.view, 0.4, {alpha:0});
        _shootEffect.playState(ClipLabel.WALK, destroyEffect);
    }

    /* ENEMY DIED */
    private function enemyDied(e:CustomEvent):void
    {
        // add sound
        SoundManager.playSound(SoundManager.ENEMY_DUST_3, 0.9);
        whiteScreen();
        // add enemy dust
        _enemyDustEffect = new Effect(new Fx_Explosive_25x25(), e.obj.x, e.obj.y);
        _enemyDustEffect.clipLabels = new Vector.<ClipLabel>();
        _enemyDustEffect.clipLabels.push(new ClipLabel(ClipLabel.WALK, 6, 0.4));
        _mainScreen.addChild(_enemyDustEffect.view);
//        TweenLite.to(_enemyDustEffect.view, 0.4, {alpha:0});
        _enemyDustEffect.playState(ClipLabel.WALK, destroyEffect);
        // camera shake
        if(e.obj.isShakeScreen == null)
        {
            var duration:Number = 0.1;
            var shakeAmount:int = 3;
//         _camera.pause(shakeAmount * (duration*1000));
            shakeTween(null, _mainScreen, shakeAmount, duration, 7);
        }
    }




    /* INIT EFFECTS */
    private function initEffects():void
    {
        _whiteScreen = new McWhiteScreen();
        _whiteScreen.x = 80;

        _redScreen = new McRedScreen();
        _redScreen.x = 80;
    }

    /* DUST EFFECT */
    private function dustEffect(e:CustomEvent):void
    {
        _dustEffect = new Effect(new WalkDustEffectMc(), _player.playerCont.x, _player.playerCont.y+(_player.hitBox.height/2));
        _dustEffect.clipLabels = new Vector.<ClipLabel>();
        _dustEffect.clipLabels.push(new ClipLabel(ClipLabel.WALK, 5, 0.4));
        _dustEffect.view.rotation = Math.random() * 360;
//        _dustEffect.view.filters = [_glowFilter];
        _mainScreen.addChild(_dustEffect.view);
        TweenLite.to(_dustEffect.view, 0.4, {alpha:0});
        _dustEffect.playState(ClipLabel.WALK, destroyEffect);
    }

    /* HIT EFFECT */
    private var _glowFilter:GlowFilter = new GlowFilter(0xFFFFFF, 0.5, 15, 15, 3, 1);
    private function hitEffect(e:CustomEvent):void
    {
        _hitEffect = new Effect(new Explosive_2_Mc(), e.obj.bulletX, e.obj.bulletY);
        _hitEffect.clipLabels = new Vector.<ClipLabel>();
        _hitEffect.clipLabels.push(new ClipLabel(ClipLabel.WALK, 7, 0.2));
        _hitEffect.view.rotation = Math.random() * 360;
//        _hitEffect.view.filters = [_glowFilter];
//        shakeMainScreen(15);
//        shakeTween(_hitEffect.view, 15);
        _mainScreen.addChild(_hitEffect.view);
        _hitEffect.playState(ClipLabel.WALK, destroyEffect);
    }

    /* SHAKE TWEEN */
    private var tempX:Number = -80;
    private function shakeTween(e:CustomEvent=null, item:Sprite=null, repeatCount:int=0, duration:Number=0, randomRange:int=0):void
    {
        if(e)
        {
            var duration:Number = e.obj.duration;
            var repeatCount:int = e.obj.repeatCount;
            var randomRange:int = e.obj.randomRange;
//            _camera.pause(repeatCount * (duration*1000));
            TweenMax.to(_mainScreen, duration,{repeat:repeatCount-1, y:_mainScreen.y+(1+Math.random()*randomRange), x:_mainScreen.x+(1+Math.random()*randomRange), delay:duration, ease:Expo.easeInOut});
            TweenMax.to(_mainScreen, duration,{x:tempX, y:0, delay:(repeatCount+1) * .1, ease:Expo.easeInOut});
        }
        else
        {
            TweenMax.to(item,duration,{repeat:repeatCount-1, y:item.y+(1+Math.random()*randomRange), x:item.x+(1+Math.random()*randomRange), delay:duration, ease:Expo.easeInOut});
            TweenMax.to(item,duration,{x:tempX, y:0, delay:(repeatCount+1) * .1, ease:Expo.easeInOut});
        }
    }

    /* DESTROY EFFECT */
    private function destroyEffect(o:Object):void
    {
        if(o is Effect)
        {
            _mainScreen.removeChild(o.view);
            o = null;
        }
    }

    /* LOOP */
    public function loop():void{}

    /* DEACTIVATE */
    public function deactivate():void
    {
//        _mainScreen.removeEventListener(CustomEvent.JUMP, jumpPlayerUp, true);
        _mainScreen.removeEventListener(CustomEvent.HIT, hitEffect);
        _mainScreen.removeEventListener(CustomEvent.DUST, dustEffect);
        _mainScreen.removeEventListener(CustomEvent.DIED, enemyDied);
        _stage.removeEventListener(CustomEvent.PLAYER_SHOOT, playerShoot);
        _mainScreen.removeEventListener(CustomEvent.SHAKE_GAMESCREEN, shakeTween);
        _mainScreen.removeEventListener(CustomEvent.SHOW_DAMAGE, showDamage);
        _mainScreen.removeEventListener(CustomEvent.HIT_POTION, hitPotion);
        _mainScreen.removeEventListener(CustomEvent.SHOW_POWER_INCREASED, showPowerIncreasing);
        _mainScreen.removeEventListener(CustomEvent.SHOW_PARALIZED, showParalized);
    }
}
}
