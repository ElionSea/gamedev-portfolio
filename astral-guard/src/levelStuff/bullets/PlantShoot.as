/**
 * Created by ElionSea on 20.11.14.
 */
package levelStuff.bullets
{

    import custom.ClipLabel;
    import flash.display.MovieClip;
    import levelStuff.enemies.Trajectory;

    public class PlantShoot extends ABullet implements IBullet
    {
        /*CONSTRUCTOR*/
        public function PlantShoot(startX:Number, startY:Number, endX:Number, endY:Number, isEnemyBullet:Boolean=false, enemyView:MovieClip=null)
        {
            clipLabels = new Vector.<ClipLabel>();
            clipLabels.push(new ClipLabel(ClipLabel.RUN, 5, 0.15));
            var view:McPlantShoot = new McPlantShoot();
            var trajectory:Trajectory = new Trajectory(view, startX, startY, 0, Trajectory.FLY_BY_ANGLE, 0, 0);
            super(view, startX, startY, 1.9, 50, endX, endY, isEnemyBullet, trajectory, null, false, false);
        }
    }
}
