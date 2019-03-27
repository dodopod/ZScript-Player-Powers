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

        if (cmd.roll)
        {
            if (!bLeaning)
            {
                bLeaning = true;
                realPos = owner.pos;
                Console.Printf("Lean");
            }

            Vector3 right = (AngleToVector(owner.angle - 90), 0);
            double t = cmd.roll;
        }
        else if (bLeaning)
        {
            bLeaning = false;
            Console.Printf("Stop leaning");
        }
    }
}