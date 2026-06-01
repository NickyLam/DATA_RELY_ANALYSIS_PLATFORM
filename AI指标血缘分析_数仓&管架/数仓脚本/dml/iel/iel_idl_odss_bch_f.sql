: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_bch_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_bch_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select INR,
ETYEXKEY,
BRANCH,
BCHKEY,
BCHNAME,
LEV,
UPBRANCH,
BCHTYP,
BCHFLG,
DECNUM,
TEL,
FAX,
ADR,
SWFCOD,
ADR2,
VER,
NAMEN,
ADREN,
ADREN2,
YDJCOD,
TID,
UPBCHKEY,
ACCBCH,
BCHREF,
BCHUSR,
BCHLST,
STA,
PTYINR,
STPFLG,
RMBRPT from ${idl_schema}.odss_BCH where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_bch_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes