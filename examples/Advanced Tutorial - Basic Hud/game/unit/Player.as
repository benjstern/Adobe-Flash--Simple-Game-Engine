package game.unit 
{
	import engine.GameObject;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import game.environment.Single;
	import game.environment.Wall;
	import game.interactable.Coin;
	import game.unit.enemy.EnemyBase;
	import game.unit.projectile.Bullet;
	import game.unit.projectile.BulletType;
	import utils.Input;
	import utils.Key;
	
	/**
	 * ...
	 * @author bnns
	 */
	public final class Player extends GameObject 
	{
		private var gravity:Number = 1;
		private var jump:Number = -15;
		private var speed:Number = 5;
		
		private var hasJumped:Boolean = false;
		
		private var velocity:Point = new Point();
		
		
		private var currentWeapon:int = 1;
		private var weaponList:Vector.<BulletType> = Vector.<BulletType>([
													new BulletType(BulletType1,5,300),
													new BulletType(BulletType2,1,100)
													]);
		
		public var coinsCollected:int;
		
		private var _health:int = 3;
		
		public function Player() 
		{
			super();
			hitbox = hitbox_mc;
			hitbox.visible = false;
		}
		
		override public function update():void 
		{
			velocity.x = 0;
			if (Key.isKeyPressed(Keyboard.A))
			{
				velocity.x += -speed;
			}
			if (Key.isKeyPressed(Keyboard.D))
			{
				velocity.x += speed;
			}
			
			if (Key.isKeyDown(Keyboard.W) && !hasJumped)
			{
				velocity.y = jump;
				hasJumped = true;
				trace("jumping");
			}
			
			
			var $isInSingle:Boolean = collide([Single])!=null;
			
			var $coin:GameObject = collide([Coin]);
			if ($coin)
			{
				coinsCollected++;
				$coin.destroy();
			}
			
			var $enemy:GameObject = collide([EnemyBase]);
			if ($enemy)
			{
				_health--;
				$enemy.destroy();
				if(_health<0)
					destroy();
			}
			
			
			if (Input.isMouseDown)
			{
				var $currentType:BulletType = weaponList[currentWeapon],
					$deltaX:Number = mouseX,
					$deltaY:Number = mouseY,
					$angle:Number = Math.atan2($deltaY, $deltaX),
					$bullet:Bullet = new Bullet($currentType.image, $angle, $currentType.speed, $currentType.distance);
				
				if (parent)
				{
					$bullet.x = x;
					$bullet.y = y;
					parent.addChild($bullet);
				}
			}
			
			
			velocity.y += gravity;
			
			var $moveCollision:Array = [Wall];
			
			if (velocity.y > 0 && !$isInSingle)
				$moveCollision.push(Single);
			
			moveBy(velocity.x, velocity.y, $moveCollision);
			
		}
		
		override public function onCollideY($collision:GameObject):void 
		{
			if (velocity.y > 0)
			{
				hasJumped = false;
			}
			
			velocity.y = 0;
		}
		
		public function get health():int 
		{
			return _health;
		}
	}

}