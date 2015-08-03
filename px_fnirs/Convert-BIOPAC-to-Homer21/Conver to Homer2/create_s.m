function [s] = create_s(triggers, t)

[rows,columns] = size(triggers);
rows_triggers = rows;

[rows,columns] = size(t);
rows_t = rows;

w = [];

m_index = 1;
t_index = 1;
markers_added = 0; % track number of markers added (for managing inconsistent sample rate)

time_frame = 1.0;

%scan only for the range of markers

while m_index <= rows_triggers

    if t(t_index,1) > triggers(m_index, 1) 
       
        diff = t(t_index,1) - triggers(m_index,1);
        
        if diff < time_frame & triggers(m_index, 2) == 1
            w = [w; t(t_index,1) 1 0];
            t_index = t_index + 1;
        elseif diff < time_frame & triggers(m_index, 2) == 4
            w = [w; t(t_index,1) 0 2];
            t_index = t_index + 1;  
        end;
        
        %tracks disregarded markers as well
        markers_added = markers_added + 1;
        
        m_index = m_index + 1;
        
     elseif t(t_index, 1) == triggers(m_index, 1) & triggers(m_index, 1) == 1
         w = [w; t(t_index,1) 1 0];
         
         t_index = t_index + 1;
         m_index = m_index + 1;
         markers_added = markers_added + 1;
         
     elseif t(t_index, 1) == triggers(m_index, 1) & triggers(m_index, 1) == 4
         w = [w; t(t_index,1) 0 2];
         
         t_index = t_index + 1;
         m_index = m_index + 1;
         markers_added = markers_added + 1;
     
    else
         w = [w; t(t_index, 1) 0 0];
         t_index = t_index + 1;  
    end
end

while t_index <= rows_t
    w = [w; t((t_index),1) 0 0];
    t_index = t_index + 1;
end

%size of time series, size of w

%add in remaining time series
 
s = w(:,2);

if markers_added ~= rows_triggers
     disp('Error: Could not assign all markers.');
end

end

