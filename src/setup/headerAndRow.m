function [HH,RW]=headerAndRow( proc_dir )
%
%   Usage: [HH,RW]=headerAndRow( proc_dir )
%
%
%
%
%
%
%
%
%

error( nargchk( 1, 1, nargin ) );

ref_struct = [ pwd '/' proc_dir '/DR.mat' ];
con_struct = [ pwd '/' proc_dir '/DC.mat' ];

if ~exist( ref_struct, 'file' ),
    error( '%s file does not exist!\n', ref_struct );
end;

if ~exist( con_struct, 'file' ),
    error( '%s file does not exist!\n', cont_struct );
end;

DR = load( ref_struct );
DC = load( con_struct );

HH = cell(1, length( DR.D ) );
RW = cell(1, length( DC.D ) );

for i=1:length( HH ),
%     [~,nm,~]=fileparts( DR.D{i}.img );
    HH{i} = DR.D{i}.img;
end;

for i=1:length( RW ),
%     [~,nm,~]=fileparts( DC.D{i}.img );
    RW{i} = DC.D{i}.img;
end;


