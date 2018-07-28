function fioparamscell = sm_fioparams_struct_array_to_cell(fioparams)


fioparamscell.sprfile = {};
fioparamscell.iskfile = {};
fioparamscell.experiment = {};
fioparamscell.time = {};
fioparamscell.time = {};
fioparamscell.site = {};
fioparamscell.unit = {};
fioparamscell.sta_asi = {};
fioparamscell.mid1_asi = {};
fioparamscell.mid2_asi = {};
fioparamscell.mid12_si = {};


for i = 1:length(fioparams)

    fioparamscell.sprfile{length(fioparamscell.sprfile)+1} = fioparams(i).sprfile;
    fioparamscell.iskfile{length(fioparamscell.iskfile)+1} = fioparams(i).iskfile;
    fioparamscell.experiment{length(fioparamscell.experiment)+1} = fioparams(i).exp;
    fioparamscell.time{length(fioparamscell.time)+1} = fioparams(i).time;
    fioparamscell.site{length(fioparamscell.site)+1} = fioparams(i).site;
    fioparamscell.unit{length(fioparamscell.unit)+1} = fioparams(i).unit;
    fioparamscell.sta_asi{length(fioparamscell.sta_asi)+1} = fioparams(i).sta_asi;
    fioparamscell.mid1_asi{length(fioparamscell.mid1_asi)+1} = fioparams(i).mid1_asi;
    fioparamscell.mid2_asi{length(fioparamscell.mid2_asi)+1} = fioparams(i).mid2_asi;
    fioparamscell.mid12_si{length(fioparamscell.mid12_si)+1} = fioparams(i).mid12_si;

end % (for i)

return;
