package 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import mochi.as3.*;

	public class ChipInterface extends MovieClip
	{
		// ТАЙМЕР.....................
		private var _timer:Timer;
		// ЧАСЫ.....................
		public var clocks_mc:Clocks;							
		private var secCount:uint = 0;
		private var minCount:uint = 0;
		// СЧЁТЧИК ХОДОВ......................
		public var moveCounter_mc:MoveCounter;				
		public static var movesCount:uint = 0;
		// КНОПКИ.......................
		public var sound_btn:Sound_btn;					// вкл-выкл звуки
		public var restart_btn:Restart_btn;				// кнопка рестарта
		// ЗВУКОВЫЕ КАНАЛЫ...................
		private var soundChannel:SoundChannel;
		private var track:Sound;
		// ДОСКА ВЫИГРЫША..........
		private var winMask:WinMask;					// маска при выигрыше
		private var winBoard:WinBoard;					// выигрышная доска
		public var _time:uint;

//......................CONSTRUCTOR..........................................
		public function ChipInterface():void
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}

//.......................INIT...............................................
		private function init (e:Event):void
		{
			// инициализация звуковых каналов
			initSoundChannel();
			
			// инициализация таймера
			initTimer();
			
			// добавление слушателей событий для кнопок 
			sound_btn.addEventListener(MouseEvent.CLICK, clickedSoundBtn);
			restart_btn.addEventListener(MouseEvent.CLICK, clickedRestartBtn);
			
			//
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		/*

//.......................MOCHI SCORE BOARD ENABLED...............
		private function mochiScoreboardEnabled():void
		{
			var o:Object = { n: [3, 5, 13, 10, 5, 8, 4, 0, 8, 1, 7, 10, 8, 11, 2, 2], f: function (i:Number,s:String):String { if (s.length == 16) return s; return this.f(i+1,s + this.n[i].toString(16));}};
			var boardID:String = o.f(0,"35da5840817a8b22");
			MochiScores.showLeaderboard({boardID: boardID, score: time, res:"450x340"});
		}*/
		
//..............INIT SOUND CHANNEL................................		
		private function initSoundChannel():void
		{
			soundChannel = new SoundChannel();
		}	
		
//..............INIT TIMER......................................	
		private function initTimer():void
		{
				_timer = new Timer(1000);
				_timer.addEventListener(TimerEvent.TIMER, timerLoop);
			
		}
		
//.......................TIMER LOOP.............
		private function timerLoop(e:Event):void 
		{
			secCount += 1;
			if (secCount == 60) 
			{
				minCount += 1;
				secCount = 0;
			}
			
			// обновление часов
			updateClocks();
		}
		

//...............CLICKED SOUND BUTTON.......................
		private function clickedSoundBtn (e:MouseEvent):void 
		{
			// если кнопка не нажата
			if (sound_btn.currentFrame == 1) 
			{
				sound_btn.gotoAndStop(2);
				trace("sounds stop");
			}
			// если нажата
			else
			{
				sound_btn.gotoAndStop(1);
				trace("sounds play");
			}
		}
		
//...............CLICKED RESTART BUTTON......................
		private function clickedRestartBtn(e:MouseEvent):void 
		{
			// обнуление всех счётчиков
			secCount = 0;
			minCount = 0;
			movesCount = 0;
			//обновление счётчиков и часов
			updateMoveCounter();
			updateClocks();
			// остановка таймера
			_timer.stop();
			// перемешивание пятнашек
			Chip.mixChips();
		}
		
//.......................PLUS MOVE........................	
		public function plusMove():void
		{
			movesCount++;
			// обновляем счётчик
			updateMoveCounter();
		}
		
//.......................UPDATE MOVE COUNTER.....................		
		private function updateMoveCounter():void
		{
			// обновление счётчика ходов
			moveCounter_mc.moves_txt.text = movesCount.toString();
		}

//.......................UPDATE CLOCKS.....................................		
		private function updateClocks():void		
		{
			// обновление часов
			// секунды
			if (secCount < 10) 
			{
				clocks_mc.timeSeconds_txt.text = "0" + secCount.toString();
			}
			else 
			{
				clocks_mc.timeSeconds_txt.text = secCount.toString();
			}
			
			// минуты
			if (minCount < 10)
			{
				clocks_mc.timeMinutes_txt.text = "0" + minCount.toString();
			}
			else
			{
				clocks_mc.timeMinutes_txt.text = minCount.toString();
			}
		}
		
//......................PLAY CLICK.............................................		
		public function playClick ()
		{
			if (sound_btn.currentFrame == 1) 
			{
				var click:Click1 = new Click1();
				soundChannel = click.play();
			}
			
		}
		
//......................YOU WIN...........................................
		public function youWin():void 
		{
			_timer.stop();
			//mochiScoreboardEnabled();
			// накладываем полупрозрачную маску
			winMask = new WinMask();
			winMask.alpha = 0.3;
			stage.addChild(winMask);
			
			//доска выигрыша
			winBoard = new WinBoard();
			stage.addChild(winBoard);
			winBoard.x = 50;
			winBoard.y = 50;
			// отображаем на ней результаты игры
			winBoard.resultMoves_txt.text = movesCount.toString();
			winBoard.resultTime_txt.text = clocks_mc.timeMinutes_txt.text
				+ ":" + clocks_mc.timeSeconds_txt.text;
			// обнуляем счётчики
			secCount = 0;
			minCount = 0;
			movesCount = 0;
			_timer.removeEventListener(TimerEvent.TIMER, timerLoop);
			
			// добавляем слушатель события кнопки рестарт
			winBoard.winRestart_btn.addEventListener(MouseEvent.CLICK, 
				clickedWinToRestartBtn);
			
		}
		
//.......................CLICKED WIN-RESTART BUTTON...............		
		private function clickedWinToRestartBtn(e:MouseEvent):void 
		{
			trace("refresh");
			
			stage.removeChild(winMask);
			stage.removeChild(winBoard);
		
			// перемешиваем
			Chip.mixChips();
			
			secCount = 0;
			minCount = 0;
			movesCount = 0;
			
			updateClocks();
			updateMoveCounter();
			
			_timer.addEventListener(TimerEvent.TIMER, timerLoop);
			winBoard.winRestart_btn.removeEventListener(MouseEvent.CLICK, 
				clickedWinToRestartBtn);
			
			
		}
//...................GETTERS & SETTERS.....................
		// get timer
		public function get timer():Timer
		{
			return _timer;
		}
		
		// set timer start
		public function timerStart():void
		{
			_timer.start();
		}

		public function get time():uint
		{
			var sec:uint = secCount * 1000;
			var min:uint = minCount * 1000 * 60;
			_time = sec + min;
			return _time;
		}

		public function set time(value:uint):void
		{
			_time = value;
		}

	}
}






