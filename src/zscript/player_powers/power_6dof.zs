class Power6DoF : PowerFlight
{
    const maxInput = 65536.0;

    Quaternion targetRotation;

    override void InitEffect()
    {
        Super.InitEffect();

        if (!owner || !owner.player) return;

        angle = owner.angle;
        pitch = owner.pitch;
        roll = owner.roll;

        targetRotation.FromEulerAngle(angle, pitch, roll);
    }

    override void DoEffect()
    {
        Super.DoEffect();

        if (!owner || !owner.player) return;

        let player = owner.player;
        UserCmd cmd = player.cmd;

        // Find target rotation
        double cmdYaw = cmd.yaw * 360 / maxInput;
        double cmdPitch = -cmd.pitch * 360 / maxInput;
        double cmdRoll = cmd.roll * 360 / maxInput;

        Quaternion input;
        input.FromEulerAngle(cmdYaw, cmdPitch, cmdRoll);
        Quaternion.Multiply(targetRotation, targetRotation, input);

        // Interpolate to it
        Quaternion r;
        r.FromEulerAngle(angle, pitch, roll);

        Quaternion.Slerp(r, r, targetRotation, 0.2);
        [angle, pitch, roll] = r.ToEulerAngle();

        owner.A_SetAngle(angle, SPF_Interpolate);
        owner.A_SetPitch(pitch, SPF_Interpolate);
        owner.A_SetRoll(roll, SPF_Interpolate);
    }
}