function px_spm8_anonymize(fdp,para)

hdr = spm_dicom_headers(P, essentials);
V = spm_write_vol(V,Y);

% directory_data = textread('DATA_path.txt','%s');
% 
% n = length(directory_data);
% Filefilter = 'f';
% 
% 
% for i = 1:n
%     cd([directory_data{i} '\run1'])
%     File_name = spm_select('list',pwd,['^' Filefilter '.*\.img$']);
%     [pathstr, name, ext, versn] = fileparts(directory_data{i});  
%     
%     folder_name = ['D:\Data\data_sort\FunImg\Subject' name '\'];
%     mkdir(folder_name);  
%     
%     hdr = spm_vol(File_name);
%     [data xyz]  = spm_read_vols(hdr);
%     cd(folder_name)
%     for j=1:length(File_name)  
%         if j<10
%         hdr(j).fname = ['s00' num2str(j) '.img'];
%         else if j>=10 && j<100
%                 hdr(j).fname = ['s0' num2str(j) '.img'];
%             else if j>=100
%                     hdr(j).fname = ['s' num2str(j) '.img'];
%                 end
%             end
%         end
%         spm_write_vol(hdr(j),data(:,:,:,j));
%     end
%    
% end
%     clear File_name
% 
% 
% Filefilter = 's';
% for i = 1:n
%     cd([directory_data{i} '\t2_image'])
%     File_name = spm_select('list',pwd,['^' Filefilter '.*\.img$']);
%     [pathstr, name, ext, versn] = fileparts(directory_data{i});       
%     folder_name = ['D:\Data\data_sort\T1Img\Subject' name '\'];
%     mkdir(folder_name);    
%     hdr = spm_vol(File_name);
%     [data xyz]  = spm_read_vols(hdr);
%     hdr.fname = ['co_T2_orig.img'];
%     cd(folder_name)
%     spm_write_vol(hdr,data);
%     clear File_name
% end