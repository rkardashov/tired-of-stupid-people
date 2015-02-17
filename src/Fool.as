package 
{
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class Fool extends Dude 
	{
		public function Fool() 
		{
			super();
			//trace("oh hi");
		}
		
		override public function prepare(): void 
		{
			var moveRight: Boolean = Math.random() > 0.5;
			var tgtX: Number;
			if (moveRight)
				tgtX = Game.TRASH_CAN_X + Math.random() * 200
			else
				tgtX = Game.DOOR_X - 100 - Math.random() * 50;
			actions.push(new Action(Action.MOVE, tgtX));
			
			actions.push(new Action(Action.STAY, 2.0));
			actions.push(new Action(Action.STAY, 1.5, Action.TRASH_LITTER));
			
			tgtX = moveRight ? (-200) : (640 + 200);
			actions.push(new Action(Action.MOVE, tgtX));
			
			super.prepare();
		}
		
		override protected function onRelease():void 
		{
			super.onRelease();
			
			if (littered && trash)
				pickLitter();
		}
		
		protected function pickLitter(): void
		{
			littered = false;
			GameEvents.dispatch(GameEvents.STATS_PLUS_REFORMED);
			var sequence: Vector.<Action> = new Vector.<Action>();
			
			// trash pick animation is to the right
			var dx: Number = trash.x - x;
			var sign: Number = Utils.sign(trash.x - x);
			if (Math.abs(dx) < 50)
				sequence.push(new Action(Action.MOVE, trash.x - 52 * sign));
			sequence.push(new Action(Action.MOVE, trash.x - 50 * sign));
			sequence.push(new Action(Action.STAY, 1.5, Action.TRASH_PICK));
			
			var nextX: Number = trash.x - 50 * sign;
			
			// trash drop animation is to the left
			dx = Game.TRASH_CAN_X - nextX;
			sign = Utils.sign(Game.TRASH_CAN_X - nextX);
			if (Math.abs(dx) > 50)
				sequence.push(new Action(Action.MOVE, Game.TRASH_CAN_X - 48 * sign));
			sequence.push(new Action(Action.MOVE, Game.TRASH_CAN_X - 50 * sign));
			sequence.push(new Action(Action.STAY, 0.8, Action.TRASH_TO_CAN));
			sequence.push(action);
			
			actions = sequence.concat(actions);
		}
	}
}
