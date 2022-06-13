      --------------------
--- AOP vote edited by Kymshay ---
      --------------------

voteOptions = {}
voteNames = {}
voteInProgress = false
prefix = '^6[^5Badger-Voting^6]^r '
numChoices = 0;
RegisterCommand('startVote', function(source, args, rawCommand)
	if IsPlayerAceAllowed(source, "BadgerVoting.Commands.startVote") then 
		-- Can start one 
		if not voteInProgress then 
			voteOptions = {}
			voteNames = {}
			numChoices = 0;
			votedAlready = {}
			-- No current vote in progress, they can start one 
			-- /startVote <seconds> <options>
			-- /startVote 30 Los-Santos Sandy-Shores Grapeseed
			if #args > 2 then 
				if tonumber(args[1]) ~= nil then 
					-- It's a number of seconds for voting 
					local secs = tonumber(args[1]);
					voteInProgress = true;
					TriggerClientEvent('chatMessage', -1, prefix .. '^3Una votacion para cambiar de AOP empezo... Tienes ^1' 
						.. args[1] .. ' ^3Para votar por el nuevo AOP')
					for i=2, #args do 
						TriggerClientEvent('chatMessage', -1, '^6[^7' .. args[i] .. '^6]^3: /vote ' .. (i - 1))
						numChoices = numChoices + 1;
						voteOptions[(i - 1)] = 0;
						voteNames[(i - 1)] = args[i];
					end
					Wait(secs * 1000);
					local highestVoteCount = voteOptions[1]
					local highestVoteName = voteNames[1]
					for i=1, numChoices do 
						if voteOptions[i] > highestVoteCount then 
							highestVoteCount = voteOptions[i]
							highestVoteName = voteNames[i]
						end
					end
					TriggerClientEvent('chatMessage', -1, prefix .. 
						'^3El AOP cambio a ^1' .. highestVoteName .. ' ^3con un total de ^1' .. highestVoteCount .. ' ^3votos')
					voteInProgress = false;
				else 
					-- Not a valid number supplied
					sendMsg(source, '^1ERROR: Eso no es un numero valido...')
				end
			else 
				-- Not enough arguments, need at least 2 choices
				sendMsg(source, '^1ERROR: Necesitas al menos dos opciones... /vote <seconds> Los-Santos Sandy-Shores')
			end
		end
	end
end)

function sendMsg(src, msg) 
	TriggerClientEvent('chatMessage', src, prefix .. msg);
end
function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end
votedAlready = {}
RegisterCommand('vote', function(source, args, rawCommand)
	if voteInProgress then 
		if not has_value(votedAlready, source) then 
			if #args > 0 then 
				if tonumber(args[1]) ~= nil then 
					-- It's a number 
					voteOptions[tonumber(args[1])] = voteOptions[tonumber(args[1])] + 1;
					sendMsg(source, '^3Tu voto fue guardado :)')
					table.insert(votedAlready, source);
				else 
					-- It's not a number 
					sendMsg(source, '^1ERROR: Eses no es un numero valido...')
				end
			else
				-- They did not supply enough arguments 
				sendMsg(source, '^1ERROR: Necesitas hacer esto /vote <id>')
			end
		else 
			-- Already voted 
			sendMsg(source, '^1ERROR: Tu ya habias votado antes ;)')
		end
	else 
		-- There is no vote in progress 
		sendMsg(source, '^1ERROR: No hay ningun voto en progreso :(')
	end
end)
