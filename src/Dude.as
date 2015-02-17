package 
{
	import flash.geom.Point;
	import flash.utils.setTimeout;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.BlurFilter;
	import starling.filters.ColorMatrixFilter;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class Dude extends Draggable
	{
		static public const SPD_X: Number = 100;
		static public const SPD_Y: Number = 15;
		static public const MAX_CLICKS: int = 7;
		
		static public const STATE_MOVING:String = "moving";
		
		//private var speed: Number;
		private var speed: Point = new Point();
		private var dx: Number = 0;
		private var dt: Number = 0;
		private var clicks: int = 0;
		protected var actions: Vector.<Action> = new Vector.<Action>;
		protected var action: Action;
		protected var littered: Boolean = false;
		private var anim: MovieClip;
		private var anims: Object;
		protected var shadow: Image;
		protected var isAlive: Boolean = true;
		public var trash: Trash;// = new Trash();
		
		public function Dude() 
		{
			super();
			
			createGraphics();
			
			prepare();
			
			/*shadow = Assets.getImage("dude_shadow");
			shadow.alignPivot(HAlign.CENTER, VAlign.BOTTOM);
			*/
			
			/*anims = { };
			for each (var s: String in [
				"stay_simple", "stay_hit", "hit", "drag", "die", "run",
				"pick_trash", "trash_simple", "trash_hit",
				"walk_simple", "walk_hit", "walk_with_trash"
				]) 
			{
				anims[s] = Assets.getAnim("dude_" + s + "_");
				Starling.juggler.add(anims[s]);
			}
			
			for each (s in ["hit", "die", "pick_trash",
				"trash_simple", "trash_hit"]) 
			{
				(anims[s] as MovieClip).loop = false;
			}
			*/
		}
		
		private function createGraphics(): void 
		{
			shadow = Assets.getImage("dude_shadow");
			shadow.alignPivot(HAlign.CENTER, VAlign.BOTTOM);
			
			anims = { };
			for each (var s: String in [
				"stay_simple", "stay_hit", "hit", "drag", "die", "run",
				"pick_trash", "trash_simple", "trash_hit",
				"walk_simple", "walk_hit", "walk_with_trash"
				]) 
			{
				anims[s] = Assets.getAnim("dude_" + s + "_");
				Starling.juggler.add(anims[s]);
			}
			
			for each (s in ["hit", "die", "pick_trash",
				"trash_simple", "trash_hit"]) 
			{
				(anims[s] as MovieClip).loop = false;
			}
			
			//var filter: ColorMatrixFilter = new ColorMatrixFilter();
			//filter = new ColorMatrixFilter();
			//(filter as ColorMatrixFilter).tint(Math.random() * 0xFFFFFF);
		}
		
		public function prepare():void 
		{
			isAlive = true;
			littered = false;
			clicks = 0;
			
			x = 300;
			y = Game.FLOOR_Y + Math.random() * 10 - 5;
			
			scaleX = 0.9 + Math.random() * 0.2;
			scaleY = 0.9 + Math.random() * 0.2;
			
			speed.x = SPD_X;
			if (Math.random() > 0.5)
				speed.x = - SPD_X;
			speed.x *= (0.8 + Math.random() * 0.4);
			setYSpeed();
			isDraggable = false;
			
			setAnim("stay_simple");
			
			trash = new Trash();
			
			addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
			GameEvents.subscribe(GameEvents.PAUSE, onPause);
			GameEvents.subscribe(GameEvents.RESUME, onResume);
			GameEvents.subscribe(GameEvents.GAME_OVER, onGameOver);
			
			GameEvents.dispatch(GameEvents.DUDE_NEW_SHADOW, shadow);
			
			nextAction();
		}
		
		private function onPause(e: Event):void 
		{
			removeEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
			if (anim)
				anim.pause();
		}
		private function onResume(e: Event):void 
		{
			addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
			if (anim)
				anim.play();
		}
		
		private function onGameOver():void 
		{
			remove();
		}
		
		override protected function onRelease(): void
		{
			if (!isAlive)
				return;
			if (++clicks > MAX_CLICKS)
			{
				isAlive = false;
				setAnim("die");
				action = null;
				actions.splice(0, actions.length);
				GameEvents.dispatch(GameEvents.STATS_PLUS_ELIMINATED);
				setTimeout(remove, 1000);
				return;
			}
			actions.unshift(action);
			//actions.unshift(new Action(Action.STAY, 2.0));
			//nextAction();
			action = new Action(Action.STAY, 0.5);
			Assets.playSound("hit");
			setAnim("hit");
		}
		
		private function onEnterFrame(e: EnterFrameEvent): void 
		{
			if (isDragging || !action)
				return;
				
			if (action.type == Action.MOVE)
			{
				dx = action.target - x;
				//if (Math.abs(dx) <= 1)
				if (Utils.sign(dx) !== Utils.sign(action.target - action.start))
				{
					nextAction();
					return;
				}
				//speed = SPEED * (dx) / Math.abs(dx);
				speed.x = Math.abs(speed.x) * Utils.sign(dx);
				x += speed.x * e.passedTime;
				y += speed.y * e.passedTime;
				shadow.x = x;
				shadow.y = y;
				scaleX = Utils.sign(dx) * Math.abs(scaleX);// (dx) / Math.abs(dx);
				if (x > 800 || x < -width)
					remove();
			}
			if (action.type == Action.STAY)
			{
				dt += e.passedTime;
				if (dt >= action.target)
				{
					dt = 0;
					//action = actions.shift();
					
					if (action.trash == Action.TRASH_PICK)
					{
						trash.removeFromParent();
						GameEvents.dispatch(GameEvents.TRASH_PICK);
						Assets.playSound("pick_trash");
					}
					
					if (action.trash == Action.TRASH_LITTER)
					{
						trash.x = x - 50 * scaleX;
						trash.y = y;
						GameEvents.dispatch(GameEvents.LITTER, trash);
						Assets.playSound("litter");
						littered = true;
					}
					if (action.trash == Action.TRASH_TO_CAN)
					{
						GameEvents.dispatch(GameEvents.TRASH_TO_CAN, trash);
						Assets.playSound("litter");
					}
					action.trash = "";
					
					nextAction();
					return;
				}
			}
		}
		
		protected function setAnim(animID: String): void 
		{
			if (anim)
			{
				anim.stop();
				anim.removeFromParent();
			}
			anim = anims[animID];
			//anim.alignPivot(HAlign.CENTER, VAlign.BOTTOM);
			addChild(anim);
			//anim.y = -160;
			//if (animID.indexOf("walk") >= 0)
				//anim.fps = 12 * speed.x / SPD_X;
			//trace(animID + " fps: " + anim.fps);
			anim.stop();
			//anim.currentFrame = 0;
			anim.play();
			alignPivot(HAlign.CENTER, VAlign.BOTTOM);
			//alignPivot(HAlign.CENTER, VAlign.TOP);
		}
		
		private function remove(): void 
		{
			//trace("removing dude");
			isAlive = false;
			removeEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
			GameEvents.unsubscribe(GameEvents.PAUSE, onPause);
			GameEvents.unsubscribe(GameEvents.RESUME, onResume);
			GameEvents.unsubscribe(GameEvents.GAME_OVER, onGameOver);
			removeFromParent();
			trash = null;
			DudePool.recycle(this);
		}
		
		protected function nextAction(): void 
		{
			action = actions.shift();
			dt = 0;
			
			if (!action)
				return;
				
			if (action.type == Action.MOVE)
			{
				action.start = x;
				setYSpeed();
			}
			
			chooseActionAnim();
		}
		
		private function setYSpeed():void 
		{
			speed.y = Math.random() * SPD_Y - SPD_Y * 0.25;
			if (y < Game.FLOOR_Y)
				speed.y = Math.abs(speed.y);
		}
		
		protected function chooseActionAnim():void 
		{
			if (!action)
				return;
			switch (action.type)
			{
				case Action.STAY:
					switch (action.trash)
					{
						case Action.TRASH_PICK:
							setAnim("pick_trash");
							break;
						case Action.TRASH_TO_CAN:
						case Action.TRASH_LITTER:
							if (clicks > 0)
								setAnim("trash_hit")
							else
								setAnim("trash_simple");
							break;
						case "":
							if (clicks > 0)
								setAnim("stay_hit")
							else
								setAnim("stay_simple");
							break;
					}
					break;
					
				case Action.MOVE:
					if (clicks > 0)
						setAnim("walk_hit")
					else
						setAnim("walk_simple");
					break;
			}
		}
	}
}
