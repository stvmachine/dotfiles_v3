function killport -d "kill -9 the processes using the given port"
	set -l pids (lsof -ti :$argv[1])
	or return 1
	kill -9 $pids
end
