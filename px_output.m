function px_output(ModeName)
N = px_varname(ModeName);
function [strname] = px_varname(varname)
strname = input(varname,'s');
strname = varname;
strname = who;