package 
{
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class TrashCan extends Sprite 
	{
		private var layerTrash: Sprite;
		
		public function TrashCan(xPos: Number) 
		{
			//addChild(new Quad(45, 75, 0x146312));
			addChild(Assets.getImage("trashcan_withshadow"));
			addChild(layerTrash = new Sprite());
			addChild(Assets.getImage("trashcan"));
			alignPivot(HAlign.CENTER, VAlign.BOTTOM);
			x = xPos;
			y = Game.FLOOR_Y - 5;
			
			GameEvents.subscribe(GameEvents.TRASH_TO_CAN, onTrashToCan);
		}
		
		private function onTrashToCan(e: Event/*, t: Trash*/): void 
		{
			var t: Trash = new Trash();
			// x0 = 8 +-2,  x1 = 36 +-2, dx = 12 +-1
			// y0 = 38 +-1, y1 = 0-
			//t.x = 15 + 15 * (layerTrash.numChildren % 2) + Math.random() * 4 - 2;
			//t.x = 17 + 11 * (layerTrash.numChildren % 3) + Math.random() * 2 - 1;
			t.x = 11 + Math.random() * 20;
			//t.y = height - 10 - 8 * (layerTrash.numChildren >> 1)  + Math.random() * 6 - 3;
			t.y = 38 - 8 * int(layerTrash.numChildren / 4)  + Math.random() * 4 - 2;
			layerTrash.addChild(t);
		}
	}
}
