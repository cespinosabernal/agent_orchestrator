#!/usr/bin/env python3
"""
check_environment.py
Detect available CPU, GPU, and RAM resources.
Standalone version of the get-available-resources skill logic.

Usage:
    python scripts/check_environment.py            # full report (JSON)
    python scripts/check_environment.py --quick    # lightweight check (text summary)
    python scripts/check_environment.py --json     # full report as JSON
"""

import argparse
import json
import os
import sys


def get_cpu_info() -> dict:
    cpu_count = os.cpu_count() or 1
    try:
        import psutil
        freq = psutil.cpu_freq()
        freq_mhz = round(freq.current) if freq else None
    except ImportError:
        freq_mhz = None
    return {"logical_cores": cpu_count, "freq_mhz": freq_mhz}


def get_ram_info() -> dict:
    try:
        import psutil
        vm = psutil.virtual_memory()
        return {
            "total_gb": round(vm.total / 1e9, 1),
            "available_gb": round(vm.available / 1e9, 1),
            "used_pct": vm.percent,
        }
    except ImportError:
        # Fallback: read /proc/meminfo on Linux
        try:
            with open("/proc/meminfo") as f:
                lines = {k.strip(":"): v.strip() for k, v in (l.split(":", 1) for l in f)}
            total_kb = int(lines.get("MemTotal", "0 kB").split()[0])
            avail_kb = int(lines.get("MemAvailable", "0 kB").split()[0])
            return {
                "total_gb": round(total_kb / 1e6, 1),
                "available_gb": round(avail_kb / 1e6, 1),
                "used_pct": round((1 - avail_kb / total_kb) * 100, 1) if total_kb else None,
            }
        except Exception:
            return {"total_gb": None, "available_gb": None, "used_pct": None}


def get_gpu_info() -> list[dict]:
    gpus = []
    # Try torch first
    try:
        import torch
        if torch.cuda.is_available():
            for i in range(torch.cuda.device_count()):
                props = torch.cuda.get_device_properties(i)
                free, total = torch.cuda.mem_get_info(i)
                gpus.append({
                    "index": i,
                    "name": props.name,
                    "vram_total_gb": round(props.total_memory / 1e9, 1),
                    "vram_free_gb": round(free / 1e9, 1),
                    "backend": "cuda",
                })
        elif hasattr(torch.backends, "mps") and torch.backends.mps.is_available():
            gpus.append({"index": 0, "name": "Apple MPS", "vram_total_gb": None, "vram_free_gb": None, "backend": "mps"})
        return gpus
    except ImportError:
        pass
    # Try nvidia-smi
    try:
        import subprocess
        result = subprocess.run(
            ["nvidia-smi", "--query-gpu=index,name,memory.total,memory.free", "--format=csv,noheader,nounits"],
            capture_output=True, text=True, timeout=5
        )
        if result.returncode == 0:
            for line in result.stdout.strip().splitlines():
                idx, name, total, free = [x.strip() for x in line.split(",")]
                gpus.append({
                    "index": int(idx),
                    "name": name,
                    "vram_total_gb": round(int(total) / 1024, 1),
                    "vram_free_gb": round(int(free) / 1024, 1),
                    "backend": "cuda",
                })
    except Exception:
        pass
    return gpus


def get_disk_info(path: str = ".") -> dict:
    try:
        import shutil
        total, used, free = shutil.disk_usage(path)
        return {
            "total_gb": round(total / 1e9, 1),
            "free_gb": round(free / 1e9, 1),
        }
    except Exception:
        return {"total_gb": None, "free_gb": None}


def full_report() -> dict:
    return {
        "cpu": get_cpu_info(),
        "ram": get_ram_info(),
        "gpu": get_gpu_info(),
        "disk": get_disk_info(),
    }


def quick_summary(report: dict) -> str:
    ram = report["ram"]
    gpu = report["gpu"]
    cpu = report["cpu"]
    lines = [
        f"CPU: {cpu['logical_cores']} cores",
        f"RAM: {ram.get('available_gb', '?')} GB free / {ram.get('total_gb', '?')} GB total",
    ]
    if gpu:
        for g in gpu:
            vram = f"{g.get('vram_free_gb', '?')} GB free" if g.get("vram_free_gb") is not None else "VRAM unknown"
            lines.append(f"GPU[{g['index']}]: {g['name']} — {vram} ({g['backend']})")
    else:
        lines.append("GPU: none detected")
    disk = report["disk"]
    lines.append(f"Disk: {disk.get('free_gb', '?')} GB free")
    return "\n".join(lines)


def main() -> None:
    parser = argparse.ArgumentParser(description="Check available compute resources.")
    parser.add_argument("--quick", action="store_true", help="Print a short text summary")
    parser.add_argument("--json", action="store_true", help="Print full JSON report")
    args = parser.parse_args()

    report = full_report()

    if args.quick:
        print(quick_summary(report))
    else:
        print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
