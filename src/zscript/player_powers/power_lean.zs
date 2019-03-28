class PowerLean : Inventory
{
    bool bLeaning;
    Vector3 realPos;

    override void DoEffect()
    {
        Super.DoEffect();
        if (!owner || !owner.player) return;

        let player = owner.player;
        UserCmd cmd = player.cmd;

        double t = cmd.roll * 360.0 / 65536;
        if (owner.roll < t)
        {
            owner.roll = Min(owner.roll + 4, t);
        }
        else if (owner.roll > t)
        {
            owner.roll = Max(owner.roll - 4, t);
        }
    }
}