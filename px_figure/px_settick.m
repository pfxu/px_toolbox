function px_settick(axis,ticks)
%axisΪ'x'��'y'���ֱ��ʾ����x��y�̶�
%ticks���ַ�cell
% example 1. x=0:0.1:4*pi;plot(x,sin(x));ticks={'G_1'  'G_2'  'G_3'  'G_4'  'G_5'};settick('x',ticks)
%example 2. x=0:0.1:4*pi;plot(x,sin(x));ticks={'G_1'  'G_2'  'G_3'  'G_4'  'G_5'};settick('y',ticks)
 n=length(ticks);
 tkx=get(gca,'XTick');tky=get(gca,'YTick');
 switch axis
     case 'x'
         w=linspace(tkx(1),tkx(end),n);
         set(gca, 'XTick', w, 'XTickLabel', []);%ˢ�¿̶ȣ�ȥ���̶�ֵ
         yh=(14*w(1)-w(end))/13;%����������������̶�������λ��
         for i=1:n
             text('Interpreter','tex','String',ticks(i),'Position',[w(i),yh],'horizontalAlignment', 'center');
         end
     case 'y'
         w=linspace(tky(1),tky(end),n);
         set(gca, 'YTick', w, 'YTickLabel', []);
         xh=(11*w(1)-w(end))/10;
         for i=1:n
             text('Interpreter','tex','String',ticks(i),'Position',[xh,w(i)],'horizontalAlignment', 'center');
         end
 end