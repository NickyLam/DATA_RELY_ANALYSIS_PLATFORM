: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_adr_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_adr_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select INR,
EXTKEY,
NAM,
BIC,
BICAUT,
BID,
BLZ,
CLC,
DPT,
EML,
FAX1,
FAX2,
NAM1,
NAM2,
NAM3,
STR1,
STR2,
LOCZIP,
LOCTXT,
LOC2,
LOCCTY,
CORTYP,
POB,
POBZIP,
POBTXT,
TEL1,
TEL2,
TID,
TLX,
TLXAUT,
UIL,
VER,
MANMOD,
RTGFLG,
TARFLG,
DTACID,
DTECID,
ETGEXTKEY,
ADR1,
ADR2,
ADR3,
ADR4 from ${idl_schema}.odss_ADR where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_adr_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes