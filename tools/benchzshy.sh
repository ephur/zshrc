#!/bin/zsh

# Benchmark zsh startup time.
# Uses GNU time (gtime, from `brew install gnu-time`) when available,
# otherwise falls back to BSD /usr/bin/time -p (macOS built-in) — both
# produce parseable real/user/sys lines.

runs=${1:-100}
total_real=0.0
total_user=0.0
total_sys=0.0
min_real=
max_real=

if command -v gtime >/dev/null 2>&1; then
  time_cmd=(gtime -f $'real %e\nuser %U\nsys %S')
else
  time_cmd=(/usr/bin/time -p)
fi

echo "Benchmarking zsh startup over $runs runs (using ${time_cmd[1]})..."

for i in {1..$runs}; do
  output=$( "${time_cmd[@]}" zsh -i --login -c echo 2>&1 )
  real_time=$(echo "$output" | grep '^real' | awk '{print $2}')
  user_time=$(echo "$output" | grep '^user' | awk '{print $2}')
  sys_time=$(echo "$output" | grep '^sys'  | awk '{print $2}')

  if [[ -z "$real_time" ]]; then
    echo "WARNING: could not parse timing output on run $i:" >&2
    echo "$output" | head -5 >&2
    exit 1
  fi

  total_real=$(awk -v t=$total_real -v r=$real_time 'BEGIN{printf "%.6f", t + r}')
  total_user=$(awk -v t=$total_user -v r=$user_time 'BEGIN{printf "%.6f", t + r}')
  total_sys=$(awk -v t=$total_sys -v r=$sys_time 'BEGIN{printf "%.6f", t + r}')
  [[ -z "$min_real" ]] || awk -v a=$real_time -v b=$min_real 'BEGIN{exit !(a<b)}' && min_real=$real_time
  [[ -z "$max_real" ]] || awk -v a=$real_time -v b=$max_real 'BEGIN{exit !(a>b)}' && max_real=$real_time
done

echo "\n== Average Time Over $runs Runs =="
echo "Real: $(awk -v t=$total_real -v r=$runs 'BEGIN{printf "%.3f", t/r}') s  (min $min_real, max $max_real)"
echo "User: $(awk -v t=$total_user -v r=$runs 'BEGIN{printf "%.3f", t/r}') s"
echo "Sys : $(awk -v t=$total_sys -v r=$runs 'BEGIN{printf "%.3f", t/r}') s"
