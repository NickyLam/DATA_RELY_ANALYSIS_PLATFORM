: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_tru_schedule_f
CreateDate: 20180529
FileName:   ${iel_data_path}/fams_tru_schedule.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
replace(replace(t1.trisuuid,chr(13),''),chr(10),'') as trisuuid
,replace(replace(t1.trustuuid,chr(13),''),chr(10),'') as trustuuid
,t1.vdate as vdate
,t1.mdate as mdate
,t1.paydate as paydate
,t1.payorder as payorder
,replace(replace(t1.effectflag,chr(13),''),chr(10),'') as effectflag
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.tipstatus,chr(13),''),chr(10),'') as tipstatus
,replace(replace(t1.createuser,chr(13),''),chr(10),'') as createuser
,t1.createtime as createtime
,replace(replace(t1.updateuser,chr(13),''),chr(10),'') as updateuser
,t1.updatetime as updatetime
,t1.rate as rate
,t1.assetinitamt as assetinitamt
,t1.idebtamt as idebtamt
,t1.mdebtamt as mdebtamt
,t1.drawamt as drawamt
,t1.interestamt as interestamt
,t1.cashamt as cashamt
,t1.paydrawamt as paydrawamt
,t1.interest as interest
,t1.lsteffdate as lsteffdate
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,t1.etl_timestamp as etl_timestamp
from iol.fams_tru_schedule t1
where t1.start_dt<=TO_DATE('${batch_date}','yyyymmdd') and t1.end_dt>TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_tru_schedule.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes