%         clear Y
%         clear xY
xY.name = 'aaa';
xY.Ic = 0;
xY.def = 'mask';
xY.spec = 'I:\DataAnalysis\TaskYoung\NoSeg_GlobCorr\PPI\Mask\Resliced\MCC.img';
nsess = 3;
px_spm8_regions(xSPM,SPM,hReg,xY,nsess)