import time
import random
from datetime import datetime, timedelta, timezone
import psycopg2

DB_URI = "postgresql://postgres:factorypassword@localhost:5432/factory_mes"

print("Connecting to Factory Database...")
conn = psycopg2.connect(DB_URI)
cur = conn.cursor()

MACHINES = ['CNC_01', 'CNC_02', 'ROBOT_01']
DOWNTIME_CODES = ['JAM', 'TOOL_WEAR', 'WAIT_MATERIAL', 'OVERHEAT']

def generate_telemetry_point(ts, machine):
    """Simulates realistic operational states and sensor dynamics."""
    dice = random.random()
    if dice < 0.85:
        # 85% probability: Normal Running Operation
        state = 'RUNNING'
        reason = None
        good_units = random.randint(1, 3)
        scrap_units = 1 if random.random() < 0.04 else 0
        temp = random.uniform(65.0, 78.0)       # Normal operating temperature
        vibration = random.uniform(0.6, 1.8)    # Normal vibration RMS
        power = random.uniform(8.0, 14.5)       # Working load kW
    elif dice < 0.94:
        # 9% probability: Idle (Starved for materials or between batches)
        state = 'IDLE'
        reason = 'WAIT_MATERIAL'
        good_units = 0
        scrap_units = 0
        temp = random.uniform(55.0, 62.0)
        vibration = random.uniform(0.1, 0.4)
        power = random.uniform(1.2, 2.5)        # Baseline standby power
    else:
        # 6% probability: Fault / Breakdown
        state = 'FAULT'
        reason = random.choice(['JAM', 'TOOL_WEAR', 'OVERHEAT'])
        good_units = 0
        scrap_units = random.randint(1, 2)
        temp = random.uniform(86.0, 102.0)      # High temperature alarm
        vibration = random.uniform(3.5, 6.0)    # Severe vibration spike
        power = random.uniform(3.5, 6.5)

    return (
        ts, machine, state, reason, 
        good_units, scrap_units, 
        round(temp, 2), round(vibration, 3), round(power, 2)
    )

insert_sql = """
    INSERT INTO machine_telemetry 
    (recorded_at, machine_id, state, downtime_reason_code, good_units_count, scrap_units_count, temperature_c, vibration_rms, power_kw)
    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
"""

# Phase 1: Seed the last 24 hours of data so our dashboard has rich historical charts
print("1/2: Generating past 24 hours of historical machine telemetry...")
now = datetime.now(timezone.utc)
curr_ts = now - timedelta(hours=24)
batch_buffer = []

while curr_ts < now:
    for m in MACHINES:
        batch_buffer.append(generate_telemetry_point(curr_ts, m))
    curr_ts += timedelta(seconds=20) # 1 sample every 20s for the past 24h

cur.executemany(insert_sql, batch_buffer)
conn.commit()
print(f"✓ Seeded {len(batch_buffer)} historical sensor records successfully!")

# Phase 2: Live real-time streaming mode (pulses every 2 seconds)
print("2/2: Starting live factory stream (press Ctrl+C to stop)...")
try:
    while True:
        live_ts = datetime.now(timezone.utc)
        for m in MACHINES:
            cur.execute(insert_sql, generate_telemetry_point(live_ts, m))
        conn.commit()
        print(f"[{live_ts.strftime('%H:%M:%S')}] Live pulse ingested for {len(MACHINES)} machines")
        time.sleep(2)
except KeyboardInterrupt:
    print("\nSimulator stopped.")
    cur.close()
    conn.close()