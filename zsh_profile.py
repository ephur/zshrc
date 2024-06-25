import re
import sys
from datetime import datetime
from collections import defaultdict
from dataclasses import dataclass, field

@dataclass
class LogEntry:
    time: datetime
    source: str
    line_number: str
    command: str
    elapsed_time: float = 0

@dataclass
class LogEntries:
    entries: list[LogEntry] = field(default_factory=list)

def parse_log_line(line):
    line_tokens = line.split(' ')
    if len(line_tokens) < 3:
        return None
    time_format = '%H:%M:%S.%f'
    try:
        datetime.strptime(line_tokens[0], time_format)
    except ValueError:
        return None
    return LogEntry(
        time=datetime.strptime(line_tokens[0], time_format),
        source=line_tokens[1],
        line_number=line_tokens[2],
        command=' '.join(line_tokens[3:])
    )

def parse_log_file(file_path):
    """Parses the entire log file and returns a list of parsed log lines."""
    logs = LogEntries()
    with open(file_path, 'r') as file:
        for line in file:
            entry = parse_log_line(line)
            if entry:
                if logs.entries:
                    # print(logs.entries[-1].time)
                    # print(entry.time)
                    delta = entry.time - logs.entries[-1].time
                    logs.entries[-1].elapsed_time = delta.total_seconds() * 1000
                logs.entries.append(entry)
    logs.entries[-1].elapsed_time = 0
    return logs

def find_long_sections(log_entries, threshold_ms):
    # Group log entries by source
    source_entries = defaultdict(list)
    for entry in log_entries.entries:
        source_entries[entry.source].append(entry)

    # Find long sections
    for source, entries in source_entries.items():
        long_sections = []
        current_section = []
        for entry in entries:
            if entry.elapsed_time > threshold_ms:
                if current_section:
                    long_sections.append(current_section)
                current_section = [entry]
            else:
                current_section.append(entry)
        if current_section:
            long_sections.append(current_section)

        # Print long sections
        for section in long_sections:
            print(f"Long section in {source}:")
            for entry in section:
                print(f"{entry.time} {entry.command} {entry.elapsed_time:.2f} ms")
            print()


def setup():
    message = """
# AT THE TOP OF THE ZSHRC FILE
# thanks to: https://www.dribin.org/dave/blog/archives/2024/01/01/zsh-performance/
: "${PROFILE_STARTUP:=false}"
: "${PROFILE_ALL:=false}"
# Run this to get a profile trace and exit: time zsh -i -c echo
# Or: time PROFILE_STARTUP=true /bin/zsh -i --login -c echo
if [[ "$PROFILE_STARTUP" == true || "$PROFILE_ALL" == true ]]; then
    # http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
    PS4=$'%D{%H:%M:%S.%.} %N:%i> '
    #zmodload zsh/datetime
    #PS4='+$EPOCHREALTIME %N:%i> '
    exec 3>&2 2>/tmp/zsh_profile.$$
    setopt xtrace prompt_subst
fi


AT THE BOTTOM OF THE ZSHRC FILE
unsetopt xtrace prompt_subst
"""
    print(message)
    sys.exit(0)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python script.py <log_file_path>")
        sys.exit(1)

    log_file_path = sys.argv[1]
    threshold_ms = 7  # Update with your desired threshold in milliseconds
    log_entries = parse_log_file(log_file_path)
    # find_long_sections(log_entries, threshold_ms)
    for entry in log_entries.entries:
        if entry.elapsed_time > threshold_ms:
            print(f"{entry.elapsed_time} {entry.source}:{entry.line_number} {entry.command}")
