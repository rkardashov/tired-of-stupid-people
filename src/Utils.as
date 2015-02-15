package 
{
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class Utils 
	{
		public function Utils() 
		{
			
		}
		
		static public function sign(x: Number): Number
		{
			if (x > 0)
				return 1;
			//if (x < 0)
				return -1;
			//return 0;
		}
		
		static public function pickRnd(a: Array): Object
		{
			return a[int(Math.random() * a.length)];
		}
	}
}