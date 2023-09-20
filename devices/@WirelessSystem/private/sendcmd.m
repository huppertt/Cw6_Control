function sendcmd(nirs,cmd)

cmd=[cmd '\r\n'];
fprintf(nirs,'%s',cmd);
% 
% str='A';
% while(str~=double('$'))
%     str=fread(nirs,1);
% end
% fread(nirs,84);
