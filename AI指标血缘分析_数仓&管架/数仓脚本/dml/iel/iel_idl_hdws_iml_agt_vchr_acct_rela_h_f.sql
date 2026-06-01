: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_agt_vchr_acct_rela_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_agt_vchr_acct_rela_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.vchr_id,chr(13),''),chr(10),'') as vchr_id
,replace(replace(t1.vchr_type_cd,chr(13),''),chr(10),'') as vchr_type_cd
,t1.etl_dt as st_dt
,replace(replace(t1.dpst_acct_id,chr(13),''),chr(10),'') as dpst_acct_id
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,t1.etl_dt+1 as end_dt
,NVL2(t1.data_src_cd,'AGT_VCHR_ACCT_RELA_H'||'_'||DECODE(T1.DATA_SRC_CD,'LHWD',UPPER(SUBSTR(T1.JOB_CD,1,4)),T1.DATA_SRC_CD),'AGT_VCHR_ACCT_RELA_H') as etl_task_name 
from ${idl_schema}.hdws_iml_agt_vchr_acct_rela t1
where etl_dt = to_date('${batch_date}','yyyymmdd')
  and del_flg <> '1';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_agt_vchr_acct_rela_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes