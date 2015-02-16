package 
{
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.SoundChannel;
	import flash.ui.Keyboard;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	import flash.utils.Timer;
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.events.TouchEvent;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class Game extends Sprite 
	{
		/*private var scoreCounter: ScoreCounter;
		
		private var score: int;
		*/
		static public const TRASH_CAN_X:Number = 400;// 80;// 400 -640/2
		static public const FLOOR_Y: Number = 320;// 80;// 320 -480/2
		static public const DOOR_X: Number = 240;// -80;// 240 -640/2
		
		static private const MAX_TRASH: int = 0;// 5;// 3;
		static private const DUDE_INTERVAL:Number = 10;// 3;
		static private const DUDE_CLASSES: Array = [GoodBoy, Fool, RudeBoy];
		//static private const DUDE_CLASSES: Array = [GoodBoy];
		
		private var gameOver: Boolean;
		private var layerObjects: Sprite;
		private var door: MovieClip;
		private var nextDudeTime: Number;
		private var dt: Number;
		private var layerUI: Sprite;
		private var pauseScreen: Image;
		private var layerTrash: Sprite;
		private var gameOverView: GameOverView;
		private var music: SoundController;
		private var musicMuffle: SoundController;
		private var doggy: Doggy;
		
		public function Game(): void 
		{
			Assets.init(onAssetsLoaded);
		}
		
		private function onAssetsLoaded():void 
		{
			//alignPivot();
			x = stage.stageWidth / 2 - 320;
			y = stage.stageHeight / 2 - 240;
			//Assets.playSound("music_bg");// Assets.SOUND_SUPERMARKET);
			music = new SoundController("music_bg");
			musicMuffle = new SoundController("music_bg_muffle");
			musicMuffle.volume = 0;
			
			music.volume = 0;
			
			//Assets.getSound("music_bg").play();// Assets.SOUND_SUPERMARKET);
			
			var bg: Image;
			addChild(bg = Assets.getImage("bg"));
			bg.alignPivot(HAlign.LEFT, VAlign.CENTER);
			bg.x = globalToLocal(new Point()).x;
			bg.y = globalToLocal(new Point(0, stage.stageHeight / 2)).y;
			//bg.x = stage.stageWidth / 2;
			//bg.y = stage.stageHeight / 2;
			//clipRect = new Rectangle(0, 0, 640, 480);
			
			addChild(door = Assets.getAnim("door_"));
			door.alignPivot(HAlign.CENTER, VAlign.BOTTOM);
			door.x = DOOR_X;
			door.y = FLOOR_Y;
			door.currentFrame = 0;
			
			addChild(layerObjects = new Sprite());
			//layerObjects.alignPivot();
			layerObjects.addChild(new TrashCan(TRASH_CAN_X));
			
			addChild(layerTrash = new Sprite());
			//layerTrash.alignPivot();
			
			layerObjects.addChild(doggy = new Doggy());
			//addChild(doggy = new Doggy());
			
			addChild(pauseScreen = Assets.getImage("pause_screen"));
			//pauseScreen.alignPivot();
			pauseScreen.x = globalToLocal(new Point()).x;
			pauseScreen.y = globalToLocal(new Point()).y;
			pauseScreen.width = stage.stageWidth;
			pauseScreen.height = stage.stageHeight;
			pauseScreen.visible = false;
			
			addChild(layerUI = new Sprite());
			//layerUI.alignPivot();
			layerUI.addChild(new PauseButton());
			layerUI.addChild(new TimeCounter());
			
			addChild(gameOverView = new GameOverView());
			
			/*layerUI.*/addChild(new SoundButton());
			
			addChild(new TitleScreen());
			
			var vignette: Image = Assets.getImage("vignette");
			//vignette.alignPivot();
			vignette.alpha = 0.8;
			vignette.touchable = false;
			vignette.x = globalToLocal(new Point()).x;
			vignette.y = globalToLocal(new Point()).y;
			vignette.width = stage.stageWidth;
			vignette.height = stage.stageHeight;
			addChild(vignette);
			
			GameEvents.subscribe(GameEvents.GAME_START, onGameStart);
			GameEvents.subscribe(GameEvents.GAME_OVER, onGameOver);
			
			GameEvents.subscribe(GameEvents.PAUSE, onPause);
			GameEvents.subscribe(GameEvents.RESUME, onResume);
			
			GameEvents.subscribe(GameEvents.LITTER, onLitter);
			GameEvents.subscribe(GameEvents.TRASH_PICK, onTrashPick);
			
			//alignPivot();
		}
		
		private function onGameStart():void 
		{
			reset();
			Starling.juggler.tween(music, 1,
			{
				volume: 1,
				transition: Transitions.LINEAR
			});
			GameEvents.dispatch(GameEvents.RESUME);
		}
		
		private function onPause(e: Event):void 
		{
			pauseScreen.visible = true;
			music.volume = 0;
			musicMuffle.volume = 1;
			removeEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
		}
		private function onResume(e: Event):void 
		{
			pauseScreen.visible = false;
			music.volume = 1;
			musicMuffle.volume = 0;
			addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:EnterFrameEvent):void 
		{
			if (gameOver)
				return;
			dt += e.passedTime;
			if (dt >= nextDudeTime)
			{
				dt = 0;
				//nextDudeTime = DUDE_INTERVAL_MIN + Math.random() * 2;
				nextDudeTime = DUDE_INTERVAL * (0.8 + Math.random() * 0.4);
				var dudeClass: Class = Utils.pickRnd(DUDE_CLASSES) as Class;
				layerObjects.addChild(new dudeClass());
				door.currentFrame = 1;
				setTimeout(function(): void
					{
						door.currentFrame = 0;
					},
					1000);
			}
		}
		
		private function reset(): void 
		{
			gameOver = false;
			layerTrash.removeChildren();
			layerUI.y = 0;
			dt = 0;
			nextDudeTime = 2;
		}
		
		private function onLitter(e: Event, trash: Trash): void 
		{
			//var t: Trash = new Trash();
			//t.x = litterX;
			//t.y = 450;
			trash.removeFromParent();
			layerTrash.addChild(trash);
			if (layerTrash.numChildren > MAX_TRASH)
				GameEvents.dispatch(GameEvents.GAME_OVER);
		}
		
		private function onTrashPick():void 
		{
			if (layerTrash.numChildren > MAX_TRASH)
				GameEvents.dispatch(GameEvents.GAME_OVER);
		}
		
		private function onGameOver():void 
		{
			gameOver = true;
			Starling.juggler.tween(layerUI, 1,
			{
				y: -100,
				transition: Transitions.EASE_OUT
			});
			/*music.soundTransform.volume = 0.2;
			music.soundTransform = music.soundTransform;*/
			Starling.juggler.tween(music, 1,
			{
				volume: 0,
				transition: Transitions.LINEAR
			});
			removeEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
		}
	}
}