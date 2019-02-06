function h=plot_brain(vertex,face,ax)

face_vertex_color = zeros(size(vertex,1),1);
if size(face_vertex_color,1)==size(vertex,1)
    shading_type = 'interp';
else
    shading_type = 'flat';
end

h = patch('vertices',vertex,'faces',face,'FaceVertexCData',face_vertex_color, 'FaceColor',shading_type,'parent',ax);

lighting(ax,'phong');
% camlight infinite; 
camproj(ax,'perspective');
axis(ax,'square'); 
axis(ax,'off');
axis(ax,'tight');
axis(ax,'equal');
shading(ax,'interp');
%camlight(ax);
light('parent',ax);