function [ S, K, T ] = classify( proc_dir, ref, con, varargin )
%
%   Usage: [ S, K, T ] = classify( proc_dir, ref, con )
%
%   Description: Compute the feature matrices for Shape (S),
%   Color (K), and Text (T). At completion of the script 
%   the three feature matrices will be stored in the proc_dir
%   with the following names: S.mat, T.mat, and K.mat.
%
%   Arguments (All Strings): 
%       (1) proc_dir = location of process directory
%       (2) ref = reference data set. Value can only be DR or DC
%       (3) con = consumer data set. Value can only be DR or DC
%
%   Return:
%       Feature matrices for shape, color and text. For each 
%       matrix the number of rows = number of consumer images
%       and the number of columns = number of reference images.
%       ( note: to combine: F = ( S + K + T )/3 )
%
%   Example:
%       [S,K,T] = classify( 'proc', 'DR', 'DC' );
%
%
%   

debug = false;
save_files = false;
href = 0;

error( nargchk( 3, 4, nargin ) );

range = [1 5000];

if length(varargin) == 1,
    
    opts = varargin{1};
    
    if isfield( opts, 'range'),
        range = opts.range;
    end;
    
    if isfield( opts, 'save_files'),
        save_files = opts.save_files;
    end;

    if isfield( opts, 'href'),
        href = opts.href;
    end;
    
end;
    
if ~strcmpi( ref, 'DR' ) && ~strcmpi( ref, 'DC' ),
    error('type argument not valid, see help');
end;

if ~strcmpi( con, 'DC' ) && ~strcmpi( con, 'DR' ),
    error('type argument not valid, see help');
end;

ref_struct = [ pwd '/' proc_dir '/' upper( ref ) '.mat' ];

con_struct = [ pwd '/' proc_dir '/' upper( con ) '.mat' ];

if ~exist( ref_struct, 'file' ),
    error( '(%s) file not found! See help\n', ref_struct );
end;

if ~exist( con_struct, 'file' ),
    error( '(%s) file not found! See help\n', con_struct );
end;

R = load( ref_struct );
C = load( con_struct );

S = zeros( length( C.D ), length( R.D ) );
K = zeros( length( C.D ), length( R.D ) );
T = zeros( length( C.D ), length( R.D ) ); 

fprintf('-----------------------------------------------------\n');
fprintf('Size of scoring matrix (%d,%d)\n', size(S,1), size(S,2) );
fprintf('Range = [ %d %d ]\n', range(1), range(2) );

for i=range(1):range(2),
    
    tt = cputime;
    
    for j=1:length( R.D ),

	try,
            
            if debug, jt = cputime; end;
            
            [ d, ang ]=jaccardCoeff( R.D{j}, C.D{i} );
            
            if debug, 
                fprintf('Jaccard (%d,%d) in %.3f sec\n', i, j, (cputime - jt) );
            end;
            
            S( i, j ) = d;

            d = compareColors( R.D{j}, C.D{i} );
            
            if debug,
                fprintf('Color (%d,%d) in %.3f sec\n', i, j, (cputime - jt) );
            end;

            K( i, j ) = d;
            
            d = textCompare2( R.D{j}, C.D{i}, ang );
            
            T( i, j ) = d;
            
            if debug,
            
                fprintf('Text (%d,%d) in %.3f sec\n', i, j, (cputime - jt) );
                fprintf('Total (%d,%d) in %.4f sec\n', i, j, (cputime - tt) );
                fprintf('-------------------------------\n');
                
            end;

	catch,
		fprintf('failed DR=%d and DC=%d\n', j, i );
	end;
            
      end;
        
%     end;
    
    fprintf('Total time for (%d) = %.4f sec\n', i, (cputime - tt) );
    
    if save_files,
        save( [proc_dir '/S_' num2str( href ) '.mat'], 'S' );
        save( [proc_dir '/K_' num2str( href ) '.mat'], 'K' );
        save( [proc_dir '/T_' num2str( href ) '.mat'], 'T' );
    end;
    
end;
