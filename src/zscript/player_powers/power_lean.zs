class PowerLean : Inventory
{
    bool bLeaning;
    Vector3 offset;
    double offsetZ;
    double theta;

    override void DoEffect()
    {
        Super.DoEffect();
        if (!owner || !owner.player) return;

        let player = owner.player;
        let mo = player.mo;
        UserCmd cmd = player.cmd;

        double target = cmd.roll * 360.0 / 65536;
        if (theta < target)
        {
            theta = Min(theta + 4, target);
        }
        else if (theta > target)
        {
            theta = Max(theta - 4, target);
        }

        owner.roll = theta;

        Vector3 right = (AngleToVector(owner.angle - 90), 0);
        Vector3 newOffset = right * 16 * Sin(theta);
        owner.SetOrigin(owner.pos - offset + newOffset, true);
        offset = newOffset;

        double dz = player.viewHeight - mo.Default.viewHeight;
        player.viewHeight = mo.Default.viewHeight + 16 * (Cos(theta) - 1);
    }
}