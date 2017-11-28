/**
 * Created by ElionSea on 28.11.14.
 */
package popup {
import custom.CustomEvent;

import flash.display.Sprite;
import flash.events.MouseEvent;

import screens.IScaled;

import screens.ScreenManager;

public class PopupController
{
    private static var _mainScreen:Sprite;
    private static var _popupMask:Sprite;
    private static var _currentPopup:IPopup;

    private static var _notEnoughMoneyPopup:IPopup;
    private static var _tabStorePopup:IPopup;
    private static var _tabAcademyPopup:IPopup;
    private static var _tabStaffPopup:IPopup;
    private static var _controlsPopup:IPopup;
    private static var _spellPopup:IPopup;
    private static var _chestPopup:IPopup;

    public static const NOT_ENOUGH_MONEY_POPUP:String = "NotEnoughMoneyPopup";
    public static const TAB_STORE_POPUP:String = "TabStorePopup";
    public static const TAB_ACADEMY_POPUP:String = "TabAcademyPopup";
    public static const TAB_STAFF_POPUP:String = "TabStaffPopup";
    public static const CONTROLS_POPUP:String = "controlsPopup";
    public static const SPELL_POPUP:String = "spellPopup";
    public static const CHEST_POPUP:String = "chestPopup";

    /*CONSTRUCTOR*/
    public function PopupController(){}

    /* INIT */
    public static function init(totalScreen:Sprite):void
    {
        _mainScreen = totalScreen;

        _popupMask = new McPopupMask();
        _popupMask.alpha = 0.5;

        _popupMask.scaleX = Platformer.SCALE_FACTOR;
        _popupMask.scaleY = Platformer.SCALE_FACTOR;

    }

    /* SHOW POPUP */
    public static function showPopup(popupName:String):void
    {
        ScreenManager.pause();
        _mainScreen.addChild(_popupMask);
        switch (popupName)
        {
            case NOT_ENOUGH_MONEY_POPUP:
                    if(_notEnoughMoneyPopup == null) _notEnoughMoneyPopup = new APopup(_mainScreen, new McNotEnoughMoneyPopup());
                    _currentPopup = _notEnoughMoneyPopup;
                break;
            case TAB_STORE_POPUP:
                    if(_tabStorePopup == null) _tabStorePopup = new APopup(_mainScreen, new McTabStorePopup());
                    _currentPopup = _tabStorePopup;
                break;
            case TAB_ACADEMY_POPUP:
                    if(_tabAcademyPopup == null) _tabAcademyPopup = new APopup(_mainScreen, new McTabAcademyPopup());
                    _currentPopup = _tabAcademyPopup;
                break;
            case TAB_STAFF_POPUP:
                    if(_tabStaffPopup == null) _tabStaffPopup = new APopup(_mainScreen, new McTabStaffPopup());
                    _currentPopup = _tabStaffPopup;
                break;
            case CONTROLS_POPUP:
                    if(_controlsPopup == null) _controlsPopup = new APopup(_mainScreen, new McControlsPopup(), 0, 0);
                    _currentPopup = _controlsPopup;
                break;
            case SPELL_POPUP:
                    if(_spellPopup == null) _spellPopup = new APopup(_mainScreen, new McSpellPopup(), 0, 0);
                    _currentPopup = _spellPopup;
                break;
            case CHEST_POPUP:
                    if(_chestPopup == null) _chestPopup = new APopup(_mainScreen, new McChestPopup(), 0, 0);
                    _currentPopup = _chestPopup;
                break;
        }
        _mainScreen.addChild(_currentPopup.view);
//        _popupMask.addEventListener(MouseEvent.CLICK, hidePopup);
        _currentPopup.skipArea.addEventListener(MouseEvent.CLICK, hidePopup);
    }

    /* HIDE POPUP */
    public static function hidePopup(e:MouseEvent):void
    {
//        _popupMask.removeEventListener(MouseEvent.CLICK, hidePopup);
        _currentPopup.skipArea.removeEventListener(MouseEvent.CLICK, hidePopup);
        ScreenManager.resume();
        _mainScreen.removeChild(_currentPopup.view);
        _mainScreen.removeChild(_popupMask);
    }
}
}
