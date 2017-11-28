/**
 * Created by Sith on 31.03.14.
 */
package data
{
import data.PlayerData;

/* Game Data Controller */
    public class DataController
    {
        private static var _gameData:GameData;
        private static var _levelData:LevelData;
        private static var _playerData:PlayerData;
        private static var _inputData:InputData;
        private static var _achievementsData:AchievementsData;

        /* CONTROLLER */
        public function DataController(){}

        /* GET GAME DATA */
        public static function get gameData():GameData
        {
            if(_gameData == null) _gameData = new GameData();
            return _gameData;
        }

        /* GET LEVEL DATA */
        public static function get levelData():LevelData
        {
            if(_levelData == null) _levelData = new LevelData();
            return _levelData;
        }

        /* GET ACHIEVEMENTS DATA */
        public static function get achievementsData():AchievementsData
        {
            if(_achievementsData == null) _achievementsData = new AchievementsData();
            return _achievementsData;
        }

        /* GET PLAYER DATA */
        public static function get playerData():PlayerData
        {
            if(_playerData == null) _playerData = new PlayerData();
            return _playerData;
        }

        /* GET INPUT DATA */
        public static function get inputData():InputData
        {
            if(_inputData == null)  _inputData = new InputData();
            return _inputData;
        }

        /* COPY DATA */
        public static function copyData(copiedData:PlayerData, inputData:PlayerData):PlayerData
        {
            for each(var key:String in copiedData)
            {
                inputData[key] = copiedData[key];
            }
            return inputData;
        }
    }
}
