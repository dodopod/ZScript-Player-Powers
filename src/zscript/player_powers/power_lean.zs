class PowerLean : Inventory
{
    override void DoEffect()
    {
        Super.DoEffect();
        if (!owner || !owner.player) return;

        let player = owner.player;
        UserCmd cmd = player.cmd;

        if (cmd.roll)
        {
            double right = AngleToVector(owner.angle - 90);
        }
    }
}