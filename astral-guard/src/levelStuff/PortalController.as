/**
 * Created by Sith on 17.08.14.
 */
package levelStuff
{
import flash.display.MovieClip;
import flash.display.Sprite;

import levelStuff.enemies.IEnemy;

import player.PlayerController;
/* парные - входы, непарные - выходы
* прослушивают только входы
* */
public class PortalController
{
    private var _activeEnemies:Vector.<IEnemy>;
    private var _playerView:MovieClip;
    private var _gameScreen:Sprite;
    private var _portals:Vector.<Portal>;
    private var _inputPortals:Vector.<Portal> = new Vector.<Portal>();
    private var _outputPortals:Vector.<Portal> = new Vector.<Portal>();

    /*CONSTRUCTOR*/
    public function PortalController()
    {

    }

    /* PORTAL CONTROLLER LOOP */
    public function portalControllerLoop():void
    {
        for each(var input:Portal in _inputPortals)
        {
            // hit test with player
            if(input.view.hitTestObject(_playerView))
            {
                _playerView.x = input.output.view.x;
                _playerView.y = input.output.view.y;
            }
            // hit test with enemies
            for each(var enemy:IEnemy in _activeEnemies)
            {
                if(input.view.hitTestObject(enemy.view))
                {
                    enemy.view.x = input.output.view.x;
                    enemy.view.y = input.output.view.y;
                }
            }
        }

    }

    /* INIT PORTALS */
    public function initPortals(playerView:MovieClip, activeEnemies:Vector.<IEnemy>, gameScreen:Sprite, portals:Vector.<Portal>):void
    {
        _playerView = playerView;
        _activeEnemies = activeEnemies;
        _gameScreen = gameScreen;
        _portals = portals;
        initInputsOutputs();
    }

    /* INIT INPUTS & OUTPUTS */
    private function initInputsOutputs():void
    {
        for (var i:int = 0; i < _portals.length; i++)
        {
            var portal:Portal = _portals[i];
            _gameScreen.addChild(portal.view);
            // если парный - значит вход
            if(i % 2 == 0 && i != 0)
            {
                portal.output = _portals[i-1];
                _inputPortals.push(portal);
                _outputPortals.push(_portals[i-1]);
            }
            else if(i == 0)
            {
                _outputPortals.push(_portals[0]);
            }
            else if (i == 1)
            {
                portal.output = _portals[0];
                _inputPortals.push(portal);
            }

        }
    }
}
}
