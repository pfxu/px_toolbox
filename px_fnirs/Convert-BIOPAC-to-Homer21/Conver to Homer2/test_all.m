clear all
close all
clc

load test4
file = 'TEST_homer_test_07011313.nir';
filename = 'TEST_homer_test_07011313.mrk';

[t d aux] = create_d (file);

triggers = gettriggers (filename);
[s] = create_s (triggers, t);

clear file; clear filename; clear triggers;

save 'TEST_homer_test_07011313.nirs', '-MAT'
