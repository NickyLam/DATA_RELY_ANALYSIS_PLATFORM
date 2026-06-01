: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_tmrs_hdws_iml_agt_dacct_rela_f
CreateDate: 20180529
FileName:   ${iel_data_path}/tmrs_hdws_iml_agt_dacct_rela.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.acct_num,chr(13),''),chr(10),'') as acct_num
,replace(replace(t1.bind_acct_id,chr(13),''),chr(10),'') as bind_acct_id
,replace(replace(t1.acct_rela_typ_cd,chr(13),''),chr(10),'') as acct_rela_typ_cd
,t1.etl_dt as etl_dt
,replace(replace(t1.ghb_flg,chr(13),''),chr(10),'') as ghb_flg
,replace(replace(t1.bind_acct_typ_cd,chr(13),''),chr(10),'') as bind_acct_typ_cd
,replace(replace(t1.bind_acct_name,chr(13),''),chr(10),'') as bind_acct_name
,replace(replace(t1.bind_acct_open_bk,chr(13),''),chr(10),'') as bind_acct_open_bk
,replace(replace(t1.bind_acct_open_bk_name,chr(13),''),chr(10),'') as bind_acct_open_bk_name
,replace(replace(t1.bind_acct_ceph_num,chr(13),''),chr(10),'') as bind_acct_ceph_num
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
,t1.last_update_dt as last_update_dt
,NVL2(t1.data_src_cd,'AGT_DACCT_RELA'||'_'||DECODE(T1.DATA_SRC_CD,'LHWD',UPPER(SUBSTR(T1.JOB_CD,1,4)),T1.DATA_SRC_CD),'AGT_DACCT_RELA') as etl_task_name
,replace(replace(t1.people_bank_fin_org_id,chr(13),''),chr(10),'') as people_bank_fin_org_id
from ${idl_schema}.hdws_iml_agt_dacct_rela t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/tmrs_hdws_iml_agt_dacct_rela.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes