/**
 * Created by Sith on 25.06.14.
 */
package levelStuff.enemies
{
import custom.ClipLabel;

import flash.display.MovieClip;
import flash.geom.Point;

public class EListObject
{
    private var _x:Number;
    private var _y:Number;
    private var _width:Number;
    private var _height:Number;
    private var _type:String;
    private var _eventId:int;
    private var _trajectory:String;
    private var _trajectoryType:String;
    private var _orientation:int;
    private var _path:Vector.<Point>;
    private var _movementType:String;
    private var _clipLabels:Vector.<ClipLabel>;
    private var _view:Class;
    private var _speedX:Number;
    private var _speedY:Number;
    private var _health:int;
    private var _treasure:Array;
    private var _isContainEnemies:Boolean;
    private var _internalEnemies:Array;
    private var _isShooting:Boolean;
    private var _shootingBullet:Class;
    private var _shootDuration:Number;
    private var _hitDamageAmount:int;
    private var _classOfBulletOfShootAfterDeath:Class;
    private var _isShootAfterDeath:Boolean;


    private var _isOrientationRight:Boolean;
    private var _isGravityObject:Boolean;
    private var _isHittingObstacles:Boolean;

    private var _key:int;

    public function EListObject(
            key:int,
            trajectoryType:String,
            view:Class,
            isGravityObject:Boolean,
            isHittingObstacles:Boolean,
            speedX:Number,
            speedY:Number,
            hitDamageAmount:int,
            clipLabels:Vector.<ClipLabel>,
            health:int,
            isOrientationRight:Boolean,
            treasure:Array,
            isContainEnemies:Boolean,
            internalEnemies:Array = null,
            isShooting:Boolean=false,
            shootingBullet:Class=null,
            shootingDuration:Number=500,
            isShootAfterDeath:Boolean=false,
            classOfBulletOfShootAfterDeath:Class=null
            )
    {
        _key = key;
        _trajectoryType = trajectoryType;
        _view = view;
        _isGravityObject = isGravityObject;
        _isHittingObstacles = isHittingObstacles;
        _speedX = speedX;
        _speedY = speedY;
        _clipLabels = clipLabels;
        _health = health;
        _isOrientationRight = isOrientationRight;
        _treasure = treasure;
        _isContainEnemies = isContainEnemies;
        _internalEnemies = internalEnemies;
        _isShooting = isShooting;
        _shootingBullet = shootingBullet;
        _shootDuration = shootingDuration;
        _hitDamageAmount = hitDamageAmount;
        _isShootAfterDeath = isShootAfterDeath;
        _classOfBulletOfShootAfterDeath = classOfBulletOfShootAfterDeath;
    }

    public function get x():Number {return _x;}

    public function get y():Number {return _y;}

    public function get width():Number {return _width;}

    public function get height():Number {return _height;}

    public function get type():String {return _type;}

    public function get eventId():int {return _eventId;}

    public function get trajectory():String {return _trajectory;}

    public function get orientation():int {return _orientation;}

    public function get path():Vector.<Point> {return _path;}
    public function set path(value:Vector.<Point>):void {_path = value;}

    public function get movementType():String {return _movementType;}

    public function get clipLabels():Vector.<ClipLabel> {return _clipLabels;}

    public function get view():Class {return _view;}

    public function get trajectoryType():String {return _trajectoryType;}

    public function get speedX():Number {return _speedX;}

    public function get speedY():Number {return _speedY;}

    public function get health():int {return _health;}

    public function get isGravityObject():Boolean {return _isGravityObject;}

    public function get isHittingObstacles():Boolean {return _isHittingObstacles;}

    public function get isOrientationRight():Boolean {return _isOrientationRight;}

    public function get treasure():Array {return _treasure;}

    public function get isContainEnemies():Boolean {return _isContainEnemies;}

    public function get internalEnemies():Array {return _internalEnemies;}

    public function get isShooting():Boolean {return _isShooting;}

    public function get shootingBullet():Class {return _shootingBullet;}

    public function get shootDuration():Number {return _shootDuration;}

    public function get hitDamageAmount():int {return _hitDamageAmount;}

    public function get classOfBulletOfShootAfterDeath():Class {return _classOfBulletOfShootAfterDeath;}

    public function get isShootAfterDeath():Boolean {return _isShootAfterDeath;}
}
}
