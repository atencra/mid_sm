function mid_deafened_sm_move_files

mkdir ripple_noise
mkdir dynamic_moving_ripple

movefile *rn1*.* ripple_noise/
movefile *dmr1*.* dynamic_moving_ripple/

movefile *_160*.* ripple_noise/
movefile *_110*.* dynamic_moving_ripple

return;


