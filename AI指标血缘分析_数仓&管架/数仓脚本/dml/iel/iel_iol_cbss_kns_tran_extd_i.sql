: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cbss_kns_tran_extd_i
CreateDate: 20180529
FileName:   ${iel_data_path}/cbss_kns_tran_extd.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.trandt,chr(13),''),chr(10),'') as trandt
,replace(replace(t.transq,chr(13),''),chr(10),'') as transq
,replace(replace(t.agcuna,chr(13),''),chr(10),'') as agcuna
,replace(replace(t.agidtp,chr(13),''),chr(10),'') as agidtp
,replace(replace(t.agidno,chr(13),''),chr(10),'') as agidno
,replace(replace(t.smrytx,chr(13),''),chr(10),'') as smrytx
,replace(replace(t.pstspt,chr(13),''),chr(10),'') as pstspt
,replace(replace(t.extdc1,chr(13),''),chr(10),'') as extdc1
,replace(replace(t.extdc2,chr(13),''),chr(10),'') as extdc2
,replace(replace(t.extdc3,chr(13),''),chr(10),'') as extdc3
,replace(replace(t.extdc4,chr(13),''),chr(10),'') as extdc4
,replace(replace(t.extdc5,chr(13),''),chr(10),'') as extdc5
,replace(replace(t.extdc6,chr(13),''),chr(10),'') as extdc6
,replace(replace(t.extdc7,chr(13),''),chr(10),'') as extdc7
,replace(replace(t.extdc8,chr(13),''),chr(10),'') as extdc8
,replace(replace(t.agendr,chr(13),''),chr(10),'') as agendr
,replace(replace(t.agidmt,chr(13),''),chr(10),'') as agidmt
,replace(replace(t.agtele,chr(13),''),chr(10),'') as agtele
,replace(replace(t.agadrs,chr(13),''),chr(10),'') as agadrs
,replace(replace(t.agdesc,chr(13),''),chr(10),'') as agdesc
,replace(replace(t.agtype,chr(13),''),chr(10),'') as agtype
,replace(replace(t.opidtp,chr(13),''),chr(10),'') as opidtp
,replace(replace(t.opidno,chr(13),''),chr(10),'') as opidno
,replace(replace(t.opcuna,chr(13),''),chr(10),'') as opcuna
,replace(replace(t.ntlycd,chr(13),''),chr(10),'') as ntlycd
from iol.cbss_kns_tran_extd t
where to_char(t.trandt)= '${batch_date}'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cbss_kns_tran_extd.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes