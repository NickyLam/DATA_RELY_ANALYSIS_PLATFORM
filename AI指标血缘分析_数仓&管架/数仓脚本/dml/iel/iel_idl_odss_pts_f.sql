: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_pts_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_pts_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select INR,
OBJTYP,
OBJINR,
ROL,
PTAINR,
PTYINR,
EXTKEY,
ADRBLK,
REF,
NAM,
OWNREF,
DFTCUR,
DFTDSP,
DFTACT,
DFTFEECUR,
DFTACTPTAINR,
GLGGRPFLG,
EXTACT,
VER,
BANKNO,
ISSBANINF from ${idl_schema}.odss_PTS where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_pts_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes