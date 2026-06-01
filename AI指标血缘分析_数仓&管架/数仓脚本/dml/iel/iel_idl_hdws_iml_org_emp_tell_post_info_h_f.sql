: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_org_emp_tell_post_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_org_emp_tell_post_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
NVL2(t1.data_src_cd,'ORG_EMP_TELL_POST_INFO_H'||'_'||DECODE(T1.DATA_SRC_CD,'LHWD',UPPER(SUBSTR(T1.JOB_CD,1,4)),T1.DATA_SRC_CD),'ORG_EMP_TELL_POST_INFO_H') as etl_task_name 
,t1.etl_dt as st_dt
,t1.etl_dt+1 as end_dt
,replace(replace(t1.post_id,chr(13),''),chr(10),'') as post_id
,t1.etl_dt as etl_dt
,replace(replace(t1.tell_post_status_cd,chr(13),''),chr(10),'') as tell_post_status_cd
,replace(replace(t1.tell_post_type_cd,chr(13),''),chr(10),'') as tell_post_type_cd
,replace(replace(t1.blng_org_id,chr(13),''),chr(10),'') as blng_org_id
,replace(replace(t1.post_name,chr(13),''),chr(10),'') as post_name
,replace(replace(t1.post_comm,chr(13),''),chr(10),'') as post_comm
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
from ${idl_schema}.hdws_iml_org_emp_tell_post_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')
  and del_flg <> '1';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_org_emp_tell_post_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes