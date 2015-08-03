 function px_log
 %%%
 %this folder is to put log files which were generated during you running px_toolbox.
 cd(px_toolbox_root);
 cd ..
 if ~exist('px_log','dir')
     mkdir('px_log');
 end
 cd ('px_log');