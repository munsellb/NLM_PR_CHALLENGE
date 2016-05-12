function [ S, K, T ] = classify( proc_dir, ref, con )
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

error( nargchk(3,3,nargin) );
    
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

fprintf('size of scoring matrix (%d,%d)\n', size(S,1), size(S,2) );

for i=1:length( C.D ),
    
    tt = cputime;
    
    for j=1:length( R.D ),
        
        if S(i,j) == 0,
            
            if debug, jt = cputime; end;
            
            [ d, ang ]=jaccardCoeff( R.D{i}, C.D{j} );
            
            if debug, 
                fprintf('Jaccard (%d,%d) in %.3f sec\n', i, j, (cputime - jt) );
            end;
            
            S( i, j ) = d;
            S( j, i ) = S( i, j );

            d = compareColors( R.D{i}, C.D{j} );
            
            if debug,
                fprintf('Color (%d,%d) in %.3f sec\n', i, j, (cputime - jt) );
            end;

            K( i, j ) = d;
            K( j, i ) = K( i, j );
            
            d = textCompare2( R.D{i}, C.D{j}, ang );
            
            T( i, j ) = d;
            T( j, i ) = T( i, j );
            
            if debug,
            
                fprintf('Text (%d,%d) in %.3f sec\n', i, j, (cputime - jt) );
                fprintf('Total (%d,%d) in %.4f sec\n', i, j, (cputime - tt) );
                fprintf('-------------------------------\n');
                
            end;
            
        end;
        
    end;
    
    fprintf('Total time for (%d) = %.4f sec\n', i, (cputime - tt) );
    
    save( [proc_dir '/S.mat'], 'S' );
    save( [proc_dir '/K.mat'], 'K' );
    save( [proc_dir '/T.mat'], 'T' );
    
end;
