class Power6DoF : PowerFlight
{
    const maxInput = 65536.0;

    override void InitEffect()
    {
        Super.InitEffect();

        if (!owner || !owner.player) return;

        angle = owner.angle;
        pitch = owner.pitch;
        roll = owner.roll;
    }

    override void DoEffect()
    {
        Super.DoEffect();

        if (!owner || !owner.player) return;

        let player = owner.player;
        UserCmd cmd = player.cmd;

        // Cancel out player turning
        owner.A_SetAngle(angle, SPF_Interpolate);
        owner.A_SetPitch(pitch, SPF_Interpolate);
        owner.A_SetRoll(roll, SPF_Interpolate);
    }
}