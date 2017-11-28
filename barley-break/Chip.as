package   
{
	
	import fl.transitions.Tween;
	import fl.transitions.easing.Strong;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	public class Chip extends MovieClip 
	{
		private var _chipInterface:ChipInterface;        
		public static var chipArray:Array;
		private static var isChipSelectable:Boolean = true;// возможность кликать по фишке
		public static const CHIP_SIZE:uint = 82;	// ширина фишки
		private var _state:Boolean;					// если пятнашка на месте 
		private var _trueCol:uint;					//истинный столбик пятнашки 
		private var _trueRow:uint;					//истинный ряд пятнашки 
		private var _IDname:String;					// номер пятнашки 
		private var _col:uint;						// столбик пятнашки
		private var _row:uint;						// ряд пятнашки

		private var myTween:Tween;
		
		// CONSTRUCTOR
		public function Chip(chipInterface:ChipInterface):void  
		{
			// ссылка на интерфейс
			_chipInterface = chipInterface;
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		private function addedToStage(e:Event):void
		{
			addEventListener(MouseEvent.CLICK, chipListener);
			stage.addEventListener(Event.ENTER_FRAME, checkForTweening);
			//
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
//.........................CHECKING FOR TWINING..................	
		private function checkForTweening (event:Event):void
		{
			/* Функция предотвращает перемещение фишек в ошибочные координаты
			   когда игрок слишком быстро щёлкает по фишкам. 
			   Пока анимация действительна - кликнуть нельзя */
			
			// если экземпляр анимации действителен
			if (myTween != null) 
			{
				// если анимация проигрывается в данный момент...
				if (myTween.isPlaying) 
				{
					//...запрещаем кликабельность мышкой на сцене
					isChipSelectable = false;
				}
				// иначе разрешаем кликнуть по фишке
				else 
				{
					isChipSelectable = true;
				}
			}
		}
//.......................CHECKING STATE.....................		
		private function checkingState(curChip:Chip):Boolean
		{
			// проверяет истинное положение фишки
			if (curChip.row == curChip.trueRow 
				&& curChip.col == curChip.trueCol)
			{
				state = true;
			}
			else
			{
				state = false;
			}
			return state;
		}
//.......................ANIMATE CHIPS..............................................		
		private function animateChips (chip:Chip, changingProp:String, startPos:uint, 
									   endPos:uint):void
		{
				myTween = new Tween(chip, changingProp, Strong.easeOut, 
					startPos, endPos, 0.1, true);	
				// добавляем один ход к счётчику
				_chipInterface.plusMove();
				// воспроизводим звук
				_chipInterface.playClick();
				// проверяем на выигрыш
				chekingWin();
				// включаем таймер если не включён
				if (_chipInterface.timer != null)
				{
					_chipInterface.timerStart();
				}
		}
//.......................CHIP LISTENER........................................		
		private function chipListener(e:MouseEvent):void
		{
			// временные хранилища для координат
			var startX:uint;
			var endX:uint;
			var startY:uint;
			var endY:uint;
			// меняемые фишки
			var emptyChip:Chip
			var clickedChip:Chip
			
			// если поле кликабельно и кликнутая фишка не является "пустышкой"
			if (isChipSelectable && e.target.IDname != "16")
			{
				//...итерация по двумерному массиву.
				for (var i:uint = 0; i < 4; i++)
				{
					for (var j:uint = 0; j < 4; j++) 
					{
						// Ищем "пустышку" 
						if (chipArray[i][j].IDname == "16")
						{
							// обозначаем обе фишки.
							emptyChip = chipArray[i][j];
							clickedChip = Chip(e.target);
								
							// Eсли кликнутая фишка <ВЫШЕ> "пустышки"
							if (emptyChip.col == clickedChip.col 
									&& clickedChip.row == emptyChip.row - 1) 
							{
								// меняем ряды
								emptyChip.row --;
								clickedChip.row ++;
								// анимируем по Y
								startY = clickedChip.y;
								endY = emptyChip.y;
								animateChips(clickedChip, "y", startY, endY);
								//пустышку просто передвигаем без анимации
								emptyChip.y = startY;
								
							}
							// Eсли кликнутая фишка <НИЖЕ> "пустышки"
							else if (emptyChip.col == clickedChip.col 
								&& clickedChip.row == emptyChip.row + 1)
							{
								// меняем ряды
								emptyChip.row ++;
								clickedChip.row --;
								// анимируем по Y
								startY = clickedChip.y;
								endY = emptyChip.y;
								animateChips(clickedChip, "y", startY, endY);
								//пустышку просто передвигаем без анимации
								emptyChip.y = startY;
							}
							// Eсли кликнутая фишка <СЛЕВА> "пустышки"
							else if (emptyChip.col - 1 == clickedChip.col 
								&& clickedChip.row == emptyChip.row)
							{
								// меняем столбики
								emptyChip.col --;
								clickedChip.col ++;
								// анимируем по X
								startX = clickedChip.x;
								endX = emptyChip.x;
								animateChips(clickedChip, "x", startX, endX);
								//пустышку просто передвигаем без анимации
								emptyChip.x = startX;
							}
							// Eсли кликнутая фишка <СПРАВА> "пустышки"
							else if (emptyChip.col + 1 == clickedChip.col 
								&& clickedChip.row == emptyChip.row)
							{
								// меняем столбики
								emptyChip.col ++;
								clickedChip.col --;
								// анимируем по X
								startX = clickedChip.x;
								endX = emptyChip.x;
								animateChips(clickedChip, "x", startX, endX);
								//пустышку просто передвигаем без анимации
								emptyChip.x = startX;
							}
						}
					}
				}
			}
		}
		
//..............MIX CHIPS................................................................
		public static function mixChips():void
		{
			/* Функция перемешивания */
			
			// временные контейнеры для хранения координат, рядов и стобцов
			var tmpX:uint;
			var tmpY:uint;
			var tmpCol:uint;
			var tmpRow:uint;
			
			for (var i:uint = 0; i < 4; i++)
			{
				for (var j:uint = 0; j < 4; j++) 
				{
					// два числа выбирающих из массива случайный элемент от 0 до 3
					var rand1:uint = Math.floor(Math.random()*3);
					var rand2:uint = Math.floor(Math.random()*3);
					
					var currentChip:Chip = chipArray[i][j];
					var randomChip:Chip = chipArray[rand1][rand2];
					// по X
					tmpX = currentChip.x; 
					currentChip.x = randomChip.x;
					randomChip.x = tmpX;
					// по Y
					tmpY = currentChip.y;
					currentChip.y = randomChip.y;
					randomChip.y = tmpY;
					// col
					tmpCol = currentChip.col;
					currentChip.col = randomChip.col;
					randomChip.col = tmpCol;
					// row
					tmpRow = currentChip.row;
					currentChip.row = randomChip.row;
					randomChip.row = tmpRow;
				}
			}
		}
		
//.......................CHEKING WIN.....................................
		public function chekingWin():void 
		{
			var functionAvalaible:Boolean = true;
			// проверка на выигрыш
			for (var i:uint = 0;i < 4; i++)
			{
				for (var j:int = 0; j < 4; j++) 
				{
					var curChip:Chip = Chip.chipArray[i][j];
					// проверка на истинное значение ряда и столбца фишки
					// если хотя бы одна фишка не соответствует истинной позиции
					// функция выигрыша не доступна
					if (!curChip.checkingState(curChip))
					{
						functionAvalaible = false;
					}
				}
			}
			if (functionAvalaible)
			{
				_chipInterface.youWin();
				functionAvalaible = false;
			}
		}
		
//......................GETTERS & SETTERS.......
		
		// col
		public function set col(newCol:uint):void
		{
			_col = newCol;
		}
		
		public function get col():uint
		{
			return _col;
		}
		// row
		public function set row(newRow:uint):void
		{
			_row = newRow;
		}
		
		public function get row():uint
		{
			return _row;
		}
		// true col
		public function set trueCol(newTrueCol:uint):void
		{
			_trueCol = newTrueCol;
		}
		
		public function get trueCol():uint
		{ 
			return _trueCol;
		}
		// true row
		public function set trueRow(newTrueRow:uint):void
		{
			_trueRow = newTrueRow;
		}
		
		public function get trueRow():uint
		{
			return _trueRow;
		}
		// ID name
		public function set IDname(newIDname:String):void
		{
			_IDname = newIDname;
		}
		
		public function get IDname():String
		{
			return _IDname;
		}
		// state
		public function get state():Boolean
		{
			return _state;
		}

		public function set state(value:Boolean):void
		{
			_state = value;
		}
	}
}
