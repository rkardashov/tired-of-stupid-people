package 
{
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class DebugLog extends Sprite 
	{
		static private var _obj: DebugLog = null;
		
		private var t: TextField;
		
		public function DebugLog() 
		{
			super();
			addChild(t = new TextField(200, 100, ""));
			t.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
		}
		
		static public function print(str: String): void
		{
			if (!_obj)
				_obj = new DebugLog();
			if (_obj.parent == null)
				(Starling.current.root as Sprite).addChild(_obj);
			_obj.t.text += str + "\n";
		}
	}
}
