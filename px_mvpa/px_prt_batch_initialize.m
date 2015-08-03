function px_prt_batch_initialize

persistent batch_initialize;

if isempty(batch_initialize) || ~batch_initialize
    % PRoNTo config tree
    prt_gui = prt_cfg_batch;
    % Adding PRoNTo config tree to the SPM tools
    cfg_util('addapp', prt_gui)
    % No need to do it again for this session
    batch_initialize = 1;
end

return
