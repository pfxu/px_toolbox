function px_acq2mat(fdp,para)
% FORMAT px_acq2mat(fdp,para)
% fdp.acq
% para
% para.op
% para.on
%==========================================================================
for nf = 1:length(fdp.acq)
    % load
    acq          = load_acq(fdp.acq{nf},0);
    data         = acq.data;
    isi          = acq.hdr.graph.sample_time;
    % isi_units    = 'ms';
    labels       = strvcat(acq.hdr.per_chan_data.comment_text);
    start_sample = acq.hdr.graph.first_time_offset;
    units        = cat(1,acq.hdr.per_chan_data.units_text);
    % save
    [op, on] = fileparts(fdp.acq{nf});
    if nargin == 2 && isfield(para,'op'); op = para.op; end
    if nargin == 2 && isfield(para,'on'); on = para.on; end
    fop = [op,filesep,on,'.mat'];
    save(fop,'data','isi','labels','start_sample','units');%,'isi_units'
end