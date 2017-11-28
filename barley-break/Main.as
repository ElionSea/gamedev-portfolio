package   
{
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.events.MouseEvent;
	import flash.media.*;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	import flash.text.*;
	import flash.utils.Timer;
	
	import mochi.as3.*;
	
	
	public class Main extends MovieClip 
	{
		private var chipInterface:ChipInterface;			// интерфейс с кнопками, счётчиками						// фишка
		private var mainSprite:MainSprite;
		//private var chip:Chip;
		private var percent:Number;                     // процент загрузки
		private var menu:mc_Menu;
		
//......CONSTRUCTOR....................................................................
		public function Main():void  
		{ 
			// add menu
			menu = new mc_Menu();
			menu.addEventListener(MouseEvent.MOUSE_DOWN, startGameClick);
			addChild(menu);
		}
		
		// start Game Click
		protected function startGameClick(event:MouseEvent):void
		{
			MovieClip(root).gotoAndStop(4);
			removeChild(menu);
			//
			placeGameBoard();
			//
			menu.removeEventListener(MouseEvent.CLICK, startGameClick);
		}
		
		private function placeGameBoard():void
		{
			// add main gameboard & interface
			mainSprite = new MainSprite()
			addChild(mainSprite);
			mainSprite.x += 32;
			mainSprite.y += 32;
			chipInterface = new ChipInterface();
			addChild(chipInterface);
			chipInterface.x += mainSprite.width;
			// 
			placeField();				// расставляем поле с фишками
			Chip.mixChips();			// перемешиваем
		}
		
//....................PLACE FIELD......................................................		
		private function placeField():void
		{
			trace("placeField");
			Chip.chipArray = new Array();
			var curIDnameIndex:uint = 1;
			
			for (var i:uint = 0; i<4; i++) 
			{
				Chip.chipArray[i] = new Array();
				
				for (var j:uint = 0; j<4; j++)
				{
					var chip:Chip = new Chip(chipInterface);
					Chip.chipArray[i][j] = chip;
					chip.IDname = curIDnameIndex.toString();
					chip.gotoAndStop(curIDnameIndex);
					curIDnameIndex++;
										
					chip.x = Chip.CHIP_SIZE * j;
					chip.y = Chip.CHIP_SIZE * i;
					chip.col = j;
					chip.row = i;
					chip.trueCol = j;
					chip.trueRow = i;
					
					mainSprite.addChildAt(chip, 1);
					// если последняя фишка, делаем её невидимой
					if (chip.IDname == "16") 
					{
						chip.visible = false;
					}
				}
			}
		}
		
	}
}
