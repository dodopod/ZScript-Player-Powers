class PowerLean : Inventory
{
    bool bLeaning;
    Vector3 offset;
    double theta;

    override void DoEffect()
    {
        Super.DoEffect();
        if (!owner || !owner.player) return;

        let player = owner.player;
        let mo = player.mo;
        UserCmd cmd = player.cmd;

        int mode = CVar.FindCVar("G_LeanMode").GetInt();

        if (mode <= 0) return;

        double leanAngle = CVar.FindCVar("G_LeanAngle").GetFloat();
        double target = cmd.roll * 360.0 * leanAngle / (65536 * 4);
        double newTheta = Clamp(target, theta - 4, theta + 4);

        Vector3 right = (AngleToVector(owner.angle - 90), 0);
        Vector3 newOffset = right * 48 * Sin(theta);

        if (!owner.CheckBlock(0, AAPTR_Default, 0, newOffset.Length()))
        {
            owner.SetOrigin(owner.pos - offset + newOffset, true);
            theta = newTheta;
            offset = newOffset;
        }

        if (mode == 1) return;

        double dz = player.viewHeight - mo.Default.viewHeight;
        player.viewHeight = mo.Default.viewHeight + 16 * (Cos(theta) - 1);

        if (mode == 2) return;

        owner.A_SetRoll(theta, SPF_Interpolate);
    }
}