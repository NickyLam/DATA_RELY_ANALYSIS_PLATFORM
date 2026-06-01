: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_fxd_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_fxd_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select INR,
OWNREF,
NAM,
OPNDAT,
OWNUSR,
FXTYP,
RAT,
MIDRAT,
QUOREF,
FUDREF,
VALDAT,
CNFDAT,
SETDAT,
SETDATFRM,
SETDATTO,
CLSDAT,
VER,
BRANCHINR,
BCHKEYINR,
TRDINT,
TRDOUT,
TRNMAN,
ACC,
ACC2,
USR,
DSP,
DSP2,
BGNREF,
TRNMOD,
POSRTNDAT,
TXCOD,
CTYCOD,
APVNUM,
ZJTYP from ${idl_schema}.odss_FXD where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_fxd_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes