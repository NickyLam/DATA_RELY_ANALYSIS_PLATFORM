: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cbss_kdb_slep_f
CreateDate: 20220414
FileName:   ${iel_data_path}/cbss_kdb_slep.f.${batch_date}.dat
IF_mark:    f
Logs:
   sundexin
' \
        query="select
     to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.slepno,chr(13),''),chr(10),'') as slepno
    ,replace(replace(t.acctno,chr(13),''),chr(10),'') as acctno
    ,replace(replace(t.subsac,chr(13),''),chr(10),'') as subsac
    ,replace(replace(t.acctna,chr(13),''),chr(10),'') as acctna
    ,replace(replace(t.brchno,chr(13),''),chr(10),'') as brchno
    ,replace(replace(t.status,chr(13),''),chr(10),'') as status
    ,replace(replace(t.noactg,chr(13),''),chr(10),'') as noactg
    ,replace(replace(t.crcycd,chr(13),''),chr(10),'') as crcycd
    ,replace(replace(t.regsdt,chr(13),''),chr(10),'') as regsdt
    ,replace(replace(t.incmdt,chr(13),''),chr(10),'') as incmdt
    ,replace(replace(t.backdt,chr(13),''),chr(10),'') as backdt
    ,t.onlnbl as onlnbl
    ,t.instam as instam
    ,t.afteam as afteam
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.cbss_kdb_slep t
  where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cbss_kdb_slep.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes