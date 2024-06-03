complete -c cargo-shuttle -n "__fish_use_subcommand" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c cargo-shuttle -n "__fish_use_subcommand" -f -a "init" -d 'Create a new shuttle project'
complete -c cargo-shuttle -n "__fish_use_subcommand" -f -a "run" -d 'Run a shuttle service locally'
complete -c cargo-shuttle -n "__fish_use_subcommand" -f -a "deploy" -d 'Deploy a shuttle service'
complete -c cargo-shuttle -n "__fish_use_subcommand" -f -a "deployment" -d 'Manage deployments of a shuttle service'
complete -c cargo-shuttle -n "__fish_use_subcommand" -f -a "status" -d 'View the status of a shuttle service'
complete -c cargo-shuttle -n "__fish_use_subcommand" -f -a "stop" -d 'Stop this shuttle service'
complete -c cargo-shuttle -n "__fish_use_subcommand" -f -a "logs" -d 'View the logs of a deployment in this shuttle service'
complete -c cargo-shuttle -n "__fish_use_subcommand" -f -a "project" -d 'List or manage projects on shuttle'
complete -c cargo-shuttle -n "__fish_use_subcommand" -f -a "resource" -d 'Manage resources of a shuttle project'
complete -c cargo-shuttle -n "__fish_use_subcommand" -f -a "secrets" -d 'Manage secrets for this shuttle service'
complete -c cargo-shuttle -n "__fish_use_subcommand" -f -a "clean" -d 'Remove cargo build artifacts in the shuttle environment'
complete -c cargo-shuttle -n "__fish_use_subcommand" -f -a "login" -d 'Login to the shuttle platform'
complete -c cargo-shuttle -n "__fish_use_subcommand" -f -a "logout" -d 'Log out of the shuttle platform'
complete -c cargo-shuttle -n "__fish_use_subcommand" -f -a "generate" -d 'Generate shell completions'
complete -c cargo-shuttle -n "__fish_use_subcommand" -f -a "feedback" -d 'Open an issue on GitHub and provide feedback'
complete -c cargo-shuttle -n "__fish_use_subcommand" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from init" -s t -l template -d 'Clone a starter template from shuttle\'s official examples' -r -f -a "{actix-web	Actix Web framework,axum	Axum web framework,poem	Poem web framework,poise	Poise Discord framework,rocket	Rocket web framework,salvo	Salvo web framework,serenity	Serenity Discord framework,thruster	Thruster web framework,tide	Tide web framework,tower	Tower web framework,warp	Warp web framework,none	No template - Custom empty service}"
complete -c cargo-shuttle -n "__fish_seen_subcommand_from init" -l from -d 'Clone a template from a git repository or local path using cargo-generate' -r
complete -c cargo-shuttle -n "__fish_seen_subcommand_from init" -l subfolder -d 'Path to the template in the source (used with --from)' -r
complete -c cargo-shuttle -n "__fish_seen_subcommand_from init" -l api-key -d 'API key for the shuttle platform' -r
complete -c cargo-shuttle -n "__fish_seen_subcommand_from init" -l create-env -d 'Whether to create the environment for this project on shuttle'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from init" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from run" -l port -d 'Port to start service on' -r
complete -c cargo-shuttle -n "__fish_seen_subcommand_from run" -l external -d 'Use 0.0.0.0 instead of localhost (for usage with local external devices)'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from run" -s r -l release -d 'Use release mode for building the project'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from run" -s h -l help -d 'Print help'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from deploy" -l allow-dirty -d 'Allow deployment with uncommited files'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from deploy" -l no-test -d 'Don\'t run pre-deploy tests'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from deploy" -s h -l help -d 'Print help'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from deployment; and not __fish_seen_subcommand_from list; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from help" -s h -l help -d 'Print help'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from deployment; and not __fish_seen_subcommand_from list; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from help" -f -a "list" -d 'List all the deployments for a service'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from deployment; and not __fish_seen_subcommand_from list; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from help" -f -a "status" -d 'View status of a deployment'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from deployment; and not __fish_seen_subcommand_from list; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from deployment; and __fish_seen_subcommand_from list" -l page -d 'Which page to display' -r
complete -c cargo-shuttle -n "__fish_seen_subcommand_from deployment; and __fish_seen_subcommand_from list" -l limit -d 'How many projects per page to display' -r
complete -c cargo-shuttle -n "__fish_seen_subcommand_from deployment; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from deployment; and __fish_seen_subcommand_from status" -s h -l help -d 'Print help'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from deployment; and __fish_seen_subcommand_from help; and not __fish_seen_subcommand_from list; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from help" -f -a "list" -d 'List all the deployments for a service'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from deployment; and __fish_seen_subcommand_from help; and not __fish_seen_subcommand_from list; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from help" -f -a "status" -d 'View status of a deployment'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from deployment; and __fish_seen_subcommand_from help; and not __fish_seen_subcommand_from list; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from status" -s h -l help -d 'Print help'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from stop" -s h -l help -d 'Print help'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from logs" -s l -l latest -d 'View logs from the most recent deployment (which is not always the latest running one)'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from logs" -s f -l follow -d 'Follow log output'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from logs" -s h -l help -d 'Print help'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from project; and not __fish_seen_subcommand_from start; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from stop; and not __fish_seen_subcommand_from restart; and not __fish_seen_subcommand_from list; and not __fish_seen_subcommand_from help" -s h -l help -d 'Print help'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from project; and not __fish_seen_subcommand_from start; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from stop; and not __fish_seen_subcommand_from restart; and not __fish_seen_subcommand_from list; and not __fish_seen_subcommand_from help" -f -a "start" -d 'Create an environment for this project on shuttle'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from project; and not __fish_seen_subcommand_from start; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from stop; and not __fish_seen_subcommand_from restart; and not __fish_seen_subcommand_from list; and not __fish_seen_subcommand_from help" -f -a "status" -d 'Check the status of this project\'s environment on shuttle'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from project; and not __fish_seen_subcommand_from start; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from stop; and not __fish_seen_subcommand_from restart; and not __fish_seen_subcommand_from list; and not __fish_seen_subcommand_from help" -f -a "stop" -d 'Destroy this project\'s environment (container) on shuttle'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from project; and not __fish_seen_subcommand_from start; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from stop; and not __fish_seen_subcommand_from restart; and not __fish_seen_subcommand_from list; and not __fish_seen_subcommand_from help" -f -a "restart" -d 'Destroy and create an environment for this project on shuttle'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from project; and not __fish_seen_subcommand_from start; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from stop; and not __fish_seen_subcommand_from restart; and not __fish_seen_subcommand_from list; and not __fish_seen_subcommand_from help" -f -a "list" -d 'List all projects belonging to the calling account'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from project; and not __fish_seen_subcommand_from start; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from stop; and not __fish_seen_subcommand_from restart; and not __fish_seen_subcommand_from list; and not __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from project; and __fish_seen_subcommand_from start" -l idle-minutes -d 'How long to wait before putting the project in an idle state due to inactivity. 0 means the project will never idle' -r
complete -c cargo-shuttle -n "__fish_seen_subcommand_from project; and __fish_seen_subcommand_from start" -s h -l help -d 'Print help'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from project; and __fish_seen_subcommand_from status" -s f -l follow -d 'Follow status of project command'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from project; and __fish_seen_subcommand_from status" -s h -l help -d 'Print help'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from project; and __fish_seen_subcommand_from stop" -s h -l help -d 'Print help'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from project; and __fish_seen_subcommand_from restart" -l idle-minutes -d 'How long to wait before putting the project in an idle state due to inactivity. 0 means the project will never idle' -r
complete -c cargo-shuttle -n "__fish_seen_subcommand_from project; and __fish_seen_subcommand_from restart" -s h -l help -d 'Print help'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from project; and __fish_seen_subcommand_from list" -l page -d 'Which page to display' -r
complete -c cargo-shuttle -n "__fish_seen_subcommand_from project; and __fish_seen_subcommand_from list" -l limit -d 'How many projects per page to display' -r
complete -c cargo-shuttle -n "__fish_seen_subcommand_from project; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from project; and __fish_seen_subcommand_from help; and not __fish_seen_subcommand_from start; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from stop; and not __fish_seen_subcommand_from restart; and not __fish_seen_subcommand_from list; and not __fish_seen_subcommand_from help" -f -a "start" -d 'Create an environment for this project on shuttle'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from project; and __fish_seen_subcommand_from help; and not __fish_seen_subcommand_from start; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from stop; and not __fish_seen_subcommand_from restart; and not __fish_seen_subcommand_from list; and not __fish_seen_subcommand_from help" -f -a "status" -d 'Check the status of this project\'s environment on shuttle'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from project; and __fish_seen_subcommand_from help; and not __fish_seen_subcommand_from start; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from stop; and not __fish_seen_subcommand_from restart; and not __fish_seen_subcommand_from list; and not __fish_seen_subcommand_from help" -f -a "stop" -d 'Destroy this project\'s environment (container) on shuttle'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from project; and __fish_seen_subcommand_from help; and not __fish_seen_subcommand_from start; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from stop; and not __fish_seen_subcommand_from restart; and not __fish_seen_subcommand_from list; and not __fish_seen_subcommand_from help" -f -a "restart" -d 'Destroy and create an environment for this project on shuttle'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from project; and __fish_seen_subcommand_from help; and not __fish_seen_subcommand_from start; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from stop; and not __fish_seen_subcommand_from restart; and not __fish_seen_subcommand_from list; and not __fish_seen_subcommand_from help" -f -a "list" -d 'List all projects belonging to the calling account'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from project; and __fish_seen_subcommand_from help; and not __fish_seen_subcommand_from start; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from stop; and not __fish_seen_subcommand_from restart; and not __fish_seen_subcommand_from list; and not __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from resource; and not __fish_seen_subcommand_from list; and not __fish_seen_subcommand_from help" -s h -l help -d 'Print help'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from resource; and not __fish_seen_subcommand_from list; and not __fish_seen_subcommand_from help" -f -a "list" -d 'List all the resources for a project'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from resource; and not __fish_seen_subcommand_from list; and not __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from resource; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from resource; and __fish_seen_subcommand_from help; and not __fish_seen_subcommand_from list; and not __fish_seen_subcommand_from help" -f -a "list" -d 'List all the resources for a project'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from resource; and __fish_seen_subcommand_from help; and not __fish_seen_subcommand_from list; and not __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from secrets" -s h -l help -d 'Print help'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from clean" -s h -l help -d 'Print help'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from login" -l api-key -d 'API key for the shuttle platform' -r
complete -c cargo-shuttle -n "__fish_seen_subcommand_from login" -s h -l help -d 'Print help'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from logout" -l reset-api-key -d 'Reset the API key before logging out'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from logout" -s h -l help -d 'Print help'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from generate" -s s -l shell -d 'Which shell' -r -f -a "{bash	,elvish	,fish	,powershell	,zsh	}"
complete -c cargo-shuttle -n "__fish_seen_subcommand_from generate" -s o -l output -d 'Output to a file (stdout by default)' -r -F
complete -c cargo-shuttle -n "__fish_seen_subcommand_from generate" -s h -l help -d 'Print help'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from feedback" -s h -l help -d 'Print help'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from init; and not __fish_seen_subcommand_from run; and not __fish_seen_subcommand_from deploy; and not __fish_seen_subcommand_from deployment; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from stop; and not __fish_seen_subcommand_from logs; and not __fish_seen_subcommand_from project; and not __fish_seen_subcommand_from resource; and not __fish_seen_subcommand_from secrets; and not __fish_seen_subcommand_from clean; and not __fish_seen_subcommand_from login; and not __fish_seen_subcommand_from logout; and not __fish_seen_subcommand_from generate; and not __fish_seen_subcommand_from feedback; and not __fish_seen_subcommand_from help" -f -a "init" -d 'Create a new shuttle project'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from init; and not __fish_seen_subcommand_from run; and not __fish_seen_subcommand_from deploy; and not __fish_seen_subcommand_from deployment; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from stop; and not __fish_seen_subcommand_from logs; and not __fish_seen_subcommand_from project; and not __fish_seen_subcommand_from resource; and not __fish_seen_subcommand_from secrets; and not __fish_seen_subcommand_from clean; and not __fish_seen_subcommand_from login; and not __fish_seen_subcommand_from logout; and not __fish_seen_subcommand_from generate; and not __fish_seen_subcommand_from feedback; and not __fish_seen_subcommand_from help" -f -a "run" -d 'Run a shuttle service locally'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from init; and not __fish_seen_subcommand_from run; and not __fish_seen_subcommand_from deploy; and not __fish_seen_subcommand_from deployment; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from stop; and not __fish_seen_subcommand_from logs; and not __fish_seen_subcommand_from project; and not __fish_seen_subcommand_from resource; and not __fish_seen_subcommand_from secrets; and not __fish_seen_subcommand_from clean; and not __fish_seen_subcommand_from login; and not __fish_seen_subcommand_from logout; and not __fish_seen_subcommand_from generate; and not __fish_seen_subcommand_from feedback; and not __fish_seen_subcommand_from help" -f -a "deploy" -d 'Deploy a shuttle service'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from init; and not __fish_seen_subcommand_from run; and not __fish_seen_subcommand_from deploy; and not __fish_seen_subcommand_from deployment; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from stop; and not __fish_seen_subcommand_from logs; and not __fish_seen_subcommand_from project; and not __fish_seen_subcommand_from resource; and not __fish_seen_subcommand_from secrets; and not __fish_seen_subcommand_from clean; and not __fish_seen_subcommand_from login; and not __fish_seen_subcommand_from logout; and not __fish_seen_subcommand_from generate; and not __fish_seen_subcommand_from feedback; and not __fish_seen_subcommand_from help" -f -a "deployment" -d 'Manage deployments of a shuttle service'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from init; and not __fish_seen_subcommand_from run; and not __fish_seen_subcommand_from deploy; and not __fish_seen_subcommand_from deployment; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from stop; and not __fish_seen_subcommand_from logs; and not __fish_seen_subcommand_from project; and not __fish_seen_subcommand_from resource; and not __fish_seen_subcommand_from secrets; and not __fish_seen_subcommand_from clean; and not __fish_seen_subcommand_from login; and not __fish_seen_subcommand_from logout; and not __fish_seen_subcommand_from generate; and not __fish_seen_subcommand_from feedback; and not __fish_seen_subcommand_from help" -f -a "status" -d 'View the status of a shuttle service'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from init; and not __fish_seen_subcommand_from run; and not __fish_seen_subcommand_from deploy; and not __fish_seen_subcommand_from deployment; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from stop; and not __fish_seen_subcommand_from logs; and not __fish_seen_subcommand_from project; and not __fish_seen_subcommand_from resource; and not __fish_seen_subcommand_from secrets; and not __fish_seen_subcommand_from clean; and not __fish_seen_subcommand_from login; and not __fish_seen_subcommand_from logout; and not __fish_seen_subcommand_from generate; and not __fish_seen_subcommand_from feedback; and not __fish_seen_subcommand_from help" -f -a "stop" -d 'Stop this shuttle service'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from init; and not __fish_seen_subcommand_from run; and not __fish_seen_subcommand_from deploy; and not __fish_seen_subcommand_from deployment; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from stop; and not __fish_seen_subcommand_from logs; and not __fish_seen_subcommand_from project; and not __fish_seen_subcommand_from resource; and not __fish_seen_subcommand_from secrets; and not __fish_seen_subcommand_from clean; and not __fish_seen_subcommand_from login; and not __fish_seen_subcommand_from logout; and not __fish_seen_subcommand_from generate; and not __fish_seen_subcommand_from feedback; and not __fish_seen_subcommand_from help" -f -a "logs" -d 'View the logs of a deployment in this shuttle service'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from init; and not __fish_seen_subcommand_from run; and not __fish_seen_subcommand_from deploy; and not __fish_seen_subcommand_from deployment; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from stop; and not __fish_seen_subcommand_from logs; and not __fish_seen_subcommand_from project; and not __fish_seen_subcommand_from resource; and not __fish_seen_subcommand_from secrets; and not __fish_seen_subcommand_from clean; and not __fish_seen_subcommand_from login; and not __fish_seen_subcommand_from logout; and not __fish_seen_subcommand_from generate; and not __fish_seen_subcommand_from feedback; and not __fish_seen_subcommand_from help" -f -a "project" -d 'List or manage projects on shuttle'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from init; and not __fish_seen_subcommand_from run; and not __fish_seen_subcommand_from deploy; and not __fish_seen_subcommand_from deployment; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from stop; and not __fish_seen_subcommand_from logs; and not __fish_seen_subcommand_from project; and not __fish_seen_subcommand_from resource; and not __fish_seen_subcommand_from secrets; and not __fish_seen_subcommand_from clean; and not __fish_seen_subcommand_from login; and not __fish_seen_subcommand_from logout; and not __fish_seen_subcommand_from generate; and not __fish_seen_subcommand_from feedback; and not __fish_seen_subcommand_from help" -f -a "resource" -d 'Manage resources of a shuttle project'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from init; and not __fish_seen_subcommand_from run; and not __fish_seen_subcommand_from deploy; and not __fish_seen_subcommand_from deployment; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from stop; and not __fish_seen_subcommand_from logs; and not __fish_seen_subcommand_from project; and not __fish_seen_subcommand_from resource; and not __fish_seen_subcommand_from secrets; and not __fish_seen_subcommand_from clean; and not __fish_seen_subcommand_from login; and not __fish_seen_subcommand_from logout; and not __fish_seen_subcommand_from generate; and not __fish_seen_subcommand_from feedback; and not __fish_seen_subcommand_from help" -f -a "secrets" -d 'Manage secrets for this shuttle service'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from init; and not __fish_seen_subcommand_from run; and not __fish_seen_subcommand_from deploy; and not __fish_seen_subcommand_from deployment; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from stop; and not __fish_seen_subcommand_from logs; and not __fish_seen_subcommand_from project; and not __fish_seen_subcommand_from resource; and not __fish_seen_subcommand_from secrets; and not __fish_seen_subcommand_from clean; and not __fish_seen_subcommand_from login; and not __fish_seen_subcommand_from logout; and not __fish_seen_subcommand_from generate; and not __fish_seen_subcommand_from feedback; and not __fish_seen_subcommand_from help" -f -a "clean" -d 'Remove cargo build artifacts in the shuttle environment'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from init; and not __fish_seen_subcommand_from run; and not __fish_seen_subcommand_from deploy; and not __fish_seen_subcommand_from deployment; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from stop; and not __fish_seen_subcommand_from logs; and not __fish_seen_subcommand_from project; and not __fish_seen_subcommand_from resource; and not __fish_seen_subcommand_from secrets; and not __fish_seen_subcommand_from clean; and not __fish_seen_subcommand_from login; and not __fish_seen_subcommand_from logout; and not __fish_seen_subcommand_from generate; and not __fish_seen_subcommand_from feedback; and not __fish_seen_subcommand_from help" -f -a "login" -d 'Login to the shuttle platform'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from init; and not __fish_seen_subcommand_from run; and not __fish_seen_subcommand_from deploy; and not __fish_seen_subcommand_from deployment; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from stop; and not __fish_seen_subcommand_from logs; and not __fish_seen_subcommand_from project; and not __fish_seen_subcommand_from resource; and not __fish_seen_subcommand_from secrets; and not __fish_seen_subcommand_from clean; and not __fish_seen_subcommand_from login; and not __fish_seen_subcommand_from logout; and not __fish_seen_subcommand_from generate; and not __fish_seen_subcommand_from feedback; and not __fish_seen_subcommand_from help" -f -a "logout" -d 'Log out of the shuttle platform'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from init; and not __fish_seen_subcommand_from run; and not __fish_seen_subcommand_from deploy; and not __fish_seen_subcommand_from deployment; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from stop; and not __fish_seen_subcommand_from logs; and not __fish_seen_subcommand_from project; and not __fish_seen_subcommand_from resource; and not __fish_seen_subcommand_from secrets; and not __fish_seen_subcommand_from clean; and not __fish_seen_subcommand_from login; and not __fish_seen_subcommand_from logout; and not __fish_seen_subcommand_from generate; and not __fish_seen_subcommand_from feedback; and not __fish_seen_subcommand_from help" -f -a "generate" -d 'Generate shell completions'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from init; and not __fish_seen_subcommand_from run; and not __fish_seen_subcommand_from deploy; and not __fish_seen_subcommand_from deployment; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from stop; and not __fish_seen_subcommand_from logs; and not __fish_seen_subcommand_from project; and not __fish_seen_subcommand_from resource; and not __fish_seen_subcommand_from secrets; and not __fish_seen_subcommand_from clean; and not __fish_seen_subcommand_from login; and not __fish_seen_subcommand_from logout; and not __fish_seen_subcommand_from generate; and not __fish_seen_subcommand_from feedback; and not __fish_seen_subcommand_from help" -f -a "feedback" -d 'Open an issue on GitHub and provide feedback'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from init; and not __fish_seen_subcommand_from run; and not __fish_seen_subcommand_from deploy; and not __fish_seen_subcommand_from deployment; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from stop; and not __fish_seen_subcommand_from logs; and not __fish_seen_subcommand_from project; and not __fish_seen_subcommand_from resource; and not __fish_seen_subcommand_from secrets; and not __fish_seen_subcommand_from clean; and not __fish_seen_subcommand_from login; and not __fish_seen_subcommand_from logout; and not __fish_seen_subcommand_from generate; and not __fish_seen_subcommand_from feedback; and not __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from help; and __fish_seen_subcommand_from deployment; and not __fish_seen_subcommand_from list; and not __fish_seen_subcommand_from status" -f -a "list" -d 'List all the deployments for a service'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from help; and __fish_seen_subcommand_from deployment; and not __fish_seen_subcommand_from list; and not __fish_seen_subcommand_from status" -f -a "status" -d 'View status of a deployment'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from help; and __fish_seen_subcommand_from project; and not __fish_seen_subcommand_from start; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from stop; and not __fish_seen_subcommand_from restart; and not __fish_seen_subcommand_from list" -f -a "start" -d 'Create an environment for this project on shuttle'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from help; and __fish_seen_subcommand_from project; and not __fish_seen_subcommand_from start; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from stop; and not __fish_seen_subcommand_from restart; and not __fish_seen_subcommand_from list" -f -a "status" -d 'Check the status of this project\'s environment on shuttle'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from help; and __fish_seen_subcommand_from project; and not __fish_seen_subcommand_from start; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from stop; and not __fish_seen_subcommand_from restart; and not __fish_seen_subcommand_from list" -f -a "stop" -d 'Destroy this project\'s environment (container) on shuttle'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from help; and __fish_seen_subcommand_from project; and not __fish_seen_subcommand_from start; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from stop; and not __fish_seen_subcommand_from restart; and not __fish_seen_subcommand_from list" -f -a "restart" -d 'Destroy and create an environment for this project on shuttle'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from help; and __fish_seen_subcommand_from project; and not __fish_seen_subcommand_from start; and not __fish_seen_subcommand_from status; and not __fish_seen_subcommand_from stop; and not __fish_seen_subcommand_from restart; and not __fish_seen_subcommand_from list" -f -a "list" -d 'List all projects belonging to the calling account'
complete -c cargo-shuttle -n "__fish_seen_subcommand_from help; and __fish_seen_subcommand_from resource; and not __fish_seen_subcommand_from list" -f -a "list" -d 'List all the resources for a project'