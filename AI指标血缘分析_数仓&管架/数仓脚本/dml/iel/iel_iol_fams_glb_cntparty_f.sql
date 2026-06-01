: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_glb_cntparty_f
CreateDate: 20180529
FileName:   ${iel_data_path}/fams_glb_cntparty.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
replace(replace(t1.glcpuuid,chr(13),''),chr(10),'') as glcpuuid
,replace(replace(t1.partyname,chr(13),''),chr(10),'') as partyname
,replace(replace(t1.industry,chr(13),''),chr(10),'') as industry
,replace(replace(t1.abbrname,chr(13),''),chr(10),'') as abbrname
,replace(replace(t1.basepartyid,chr(13),''),chr(10),'') as basepartyid
,replace(replace(t1.effectflag,chr(13),''),chr(10),'') as effectflag
,replace(replace(t1.lstmntuser,chr(13),''),chr(10),'') as lstmntuser
,t1.lstmntdate as lstmntdate
,replace(replace(t1.comlevel,chr(13),''),chr(10),'') as comlevel
,replace(replace(t1.paytygroup,chr(13),''),chr(10),'') as paytygroup
,replace(replace(t1.financedetail,chr(13),''),chr(10),'') as financedetail
,replace(replace(t1.resourcerepaycode,chr(13),''),chr(10),'') as resourcerepaycode
,replace(replace(t1.province,chr(13),''),chr(10),'') as province
,replace(replace(t1.city,chr(13),''),chr(10),'') as city
,replace(replace(t1.checktype,chr(13),''),chr(10),'') as checktype
,replace(replace(t1.orgname,chr(13),''),chr(10),'') as orgname
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,t1.etl_timestamp as etl_timestamp
from iol.fams_glb_cntparty t1
where t1.start_dt<=TO_DATE('${batch_date}','yyyymmdd') and t1.end_dt>TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_glb_cntparty.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes