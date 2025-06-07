#!/bin/zsh

total_real=0.0
total_user=0.0
total_sys=0.0
runs=100

echo "Benchmarking zsh startup over $runs runs..."

for i in {1..100}; do
  output=$( gtime -f "real %e\nuser %U\nsys %S" zsh -i --login -c echo 2>&1 )
  real_time=$(echo "$output" | grep '^real' | awk '{print $2}')
  user_time=$(echo "$output" | grep '^user' | awk '{print $2}')
  sys_time=$(echo "$output" | grep '^sys'  | awk '{print $2}')

  total_real=$(awk -v t=$total_real -v r=$real_time 'BEGIN{printf "%.6f", t + r}')
  total_user=$(awk -v t=$total_user -v r=$user_time 'BEGIN{printf "%.6f", t + r}')
  total_sys=$(awk -v t=$total_sys -v r=$sys_time 'BEGIN{printf "%.6f", t + r}')
done

echo "\n== Average Time Over $runs Runs =="
echo "Real: $(awk -v t=$total_real -v r=$runs 'BEGIN{printf "%.3f", t/r}') s"
echo "User: $(awk -v t=$total_user -v r=$runs 'BEGIN{printf "%.3f", t/r}') s"
echo "Sys : $(awk -v t=$total_sys -v r=$runs 'BEGIN{printf "%.3f", t/r}') s"
