class PowerMantle : Inventory
{
    const climbReach = 8;
    const thrustSpeed = 4;

    bool climbing;

    double maxLedgeHeight;
    double climbSpeed;

    property MaxLedgeHeight: maxLedgeHeight;
    property ClimbSpeed: climbSpeed;

    Default
    {
        PowerMantle.MaxLedgeHeight 48;
        PowerMantle.ClimbSpeed 2;
    }

    override void Tick()
    {
        Super.Tick();

        if (!owner || !owner.player) return;

        let player = owner.player;
        let mo = player.mo;

        double ledgeHeight, clearance;
        {
            double z = mo.pos.z;

            mo.SetZ(z + maxLedgeHeight);   // Account for thin 3D floors
            ledgeHeight = mo.GetZAt(mo.radius + climbReach, 0);
            clearance = mo.GetZAt(mo.radius + climbReach, 0, 0, GZF_Ceiling) - ledgeHeight;
            ledgeHeight -= z;
            mo.SetZ(z);
        }

        // Start/stop climbing
        if (!climbing)
        {
            if (IsPressed(BT_Jump) && ledgeHeight > mo.maxStepHeight && ledgeHeight <= maxLedgeHeight)
            {
                climbing = true;
                A_PlaySound("*climb", CHAN_BODY);
                mo.viewBob = 0.0;
                player.SetPsprite(PSP_WEAPON, player.readyWeapon.GetDownState());
            }
        }
        else
        {
            if (!IsPressed(BT_Jump) || ledgeHeight > maxLedgeHeight)  // Drop down/get knocked down from ledge
            {
                climbing = false;
            }
            else if (ledgeHeight <= mo.maxStepHeight && clearance >= 0.5 * mo.height)    // Reach top of ledge
            {
                climbing = false;

                // Crouch, so player can fit into small spaces
                player.crouchFactor = 0.5;
                mo.SetOrigin(mo.pos + (0, 0, 0.5 * mo.fullHeight), false);   // Keep view from jerking
                player.viewHeight *= 0.5;

                mo.VelFromAngle(thrustSpeed, mo.angle);  // Thrust player onto ledge
            }

            if (!climbing)  // Exit climbing state
            {
                mo.viewBob = 1.0;
                player.jumpTics = -1;

                let psp = player.GetPsprite(PSP_WEAPON);
                psp.y = weaponBottom;
                player.SetPsprite(PSP_WEAPON, player.readyWeapon.GetUpState());
            }
        }

        if (climbing)
        {
            // Weapon will reset to Ready state, so we need to keep it down
            let psp = player.GetPsprite(PSP_WEAPON);
            if (player.readyWeapon.InStateSequence(psp.curState, player.readyWeapon.GetReadyState()))
            {
                psp.y = weaponBottom;
            }

            if (ledgeHeight <= mo.maxStepHeight) // Hold onto ledge at top, if player can't get on it
            {
                mo.vel = (0, 0, 0);
            }
            else    // Climb ledge
            {
                mo.vel = (0, 0, climbSpeed);
            }
        }
    }

    bool IsPressed(int bt)
    {
        return owner && owner.player && owner.player.cmd.buttons & bt;
    }
}