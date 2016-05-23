function generateMR( proc_dir, file_name )
%
%   Usage: generateMR( proc_dir, file_name )
%
%
%
%
%
%
%

error( nargchk( 2, 2, nargin ) );

ref_struct = [ pwd '/' proc_dir '/DR.mat' ];
con_struct = [ pwd '/' proc_dir '/DC.mat' ];

K_file = [ pwd '/' proc_dir '/K1.mat' ];
T_file = [ pwd '/' proc_dir '/T1.mat' ];
S_file = [ pwd '/' proc_dir '/S1.mat' ];

if ~exist( ref_struct, 'file' ),
    error( '(%s) file not found! See help\n', ref_struct );
end;

if ~exist( con_struct, 'file' ),
    error( '(%s) file not found! See help\n', ref_struct );
end;

if ~exist( K_file, 'file' ),
    error( '(%s) file not found! See help\n', K_file );
end;

if ~exist( T_file, 'file' ),
    error( '(%s) file not found! See help\n', T_file );
end;

if ~exist( S_file, 'file' ),
    error( '(%s) file not found! See help\n', S_file );
end;

R = load( ref_struct );
C = load( con_struct );

[hdr,rws]=headerAndRow( proc_dir );

load( K_file );
load( T_file );
load( S_file );

fhndle = [ pwd '/' file_name '.csv' ];

fprintf('Creating CSV MR File (%s)\n', fhndle );

fid = fopen( fhndle, 'w' );

% --------------------------------------
% Add column for each reference image

for i=1:length( hdr ),

    if i ~= length( hdr ),
        fprintf( fid, '%s,', hdr{i} );
    else,
        fprintf( fid, '%s\n', hdr{i} );
    end;

end;

cnt = 1;

N = length(rws)/10;

for i=1:length( rws ),
    
    if mod(i,N) == 0,
        fprintf('%d percent complete\n', (cnt*10) );
        cnt = cnt + 1;
    end;
    
    k_vec = range_enhance( K(i,:) );
    t_vec = range_enhance( T(i,:) );
    s_vec = S(i,:);
    
    f = ( k_vec + t_vec + s_vec ) / 3;
    
    [~,idx]=sort( f, 'descend' );
    rnk(idx) = [ 1:length(f) ];
    
    R=[ rws(i) sprintf('%d,', rnk(1:end-1) ) sprintf('%d\n', rnk(end) ) ];
    
    fprintf( fid, '%s', R{1:end} );
    
end;

fclose( fid );

fprintf('Finished!\n' );

% -------------------------------
% 
%   Helper functions
%
% -------------------------------

function v = range_enhance( v )

mn = min(v) - ( min(v)*.05 );

sx = ( 1 - 0 )/( 1 - mn );

v = v.*sx;


