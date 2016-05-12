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

error( nargchk(2,2,nargin) );

ref_struct = [ pwd '/' proc_dir '/DR.mat' ];
con_struct = [ pwd '/' proc_dir '/DC.mat' ];

K_file = [ pwd '/' proc_dir '/K.mat' ];
T_file = [ pwd '/' proc_dir '/T.mat' ];
S_file = [ pwd '/' proc_dir '/S.mat' ];

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

load( K_file );
load( T_file );
load( S_file );

F = ( K + S + T )/3;

fid = fopen( [ pwd '/' proc '/' file_name '.csv' ], 'w' );

% --------------------------------------
% Add column for each reference image

for i=1:length(R.D),

    fprintf( fid, ',%s', R.D{i}.img );

end;

% more to come ....


fclose( fid );