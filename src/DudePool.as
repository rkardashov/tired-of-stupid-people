package 
{
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class DudePool 
	{
		static private const GROW_CHUNK: int = 4;
		
		static private var _pools: Object = {};
		
		public function DudePool() 
		{
		}
		
		static public function init(): void 
		{
			for each (var dudeClass: Class in [GoodBoy, Fool, RudeBoy]) 
			{
				_pools[dudeClass] = [];
				grow(dudeClass, GROW_CHUNK * 2);
			}
		}
		
		static private function grow(dudeClass: Class, amount: int = GROW_CHUNK):void 
		{
			for (var i:int = 0; i < amount; i++) 
				_pools[dudeClass].push(new dudeClass());
		}
		
		static public function get(dudeClass: Class): Dude
		{
			var dude: Dude = _pools[dudeClass].pop();
			if (dude)
			{
				dude.prepare();
				return dude;
			}
			grow(dudeClass);
			return get(dudeClass);
		}
		
		static public function recycle(dude: *): void
		{
			for each (var dudeClass: Class in [GoodBoy, Fool, RudeBoy]) 
				if (dude as dudeClass)
					_pools[dudeClass].push(dude);
		}
	}
}
