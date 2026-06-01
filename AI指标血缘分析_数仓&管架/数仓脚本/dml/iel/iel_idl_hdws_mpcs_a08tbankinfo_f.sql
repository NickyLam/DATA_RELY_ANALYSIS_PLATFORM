: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_mpcs_a08tbankinfo_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_mpcs_a08tbankinfo.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.bkcd
,t1.bkstatus
,t1.banktype
,t1.bkctgycd
,t1.drctbkcd
,t1.bkname
,t1.bksname
,t1.lglprsn
,t1.hghptcpt
,t1.brbkcd
,t1.chrgbkcd
,t1.ndcd
,t1.citycd
,t1.sgn
,t1.tel
,t1.chngnb
,t1.fctvdt
,t1.ifctvdt
,t1.acctbkcdinf
,t1.start_dt
,t1.end_dt
,t1.id_mark
from ${idl_schema}.hdws_mpcs_a08tbankinfo t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_mpcs_a08tbankinfo.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes