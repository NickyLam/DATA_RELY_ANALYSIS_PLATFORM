: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_agt_eacct_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_agt_eacct_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.agt_modf,chr(13),''),chr(10),'') as agt_modf
,t1.etl_dt as st_dt
,t1.etl_dt+1 as end_dt
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.acct_desc,chr(13),''),chr(10),'') as acct_desc
,replace(replace(t1.card_num,chr(13),''),chr(10),'') as card_num
,replace(replace(t1.blng_pty_id,chr(13),''),chr(10),'') as blng_pty_id
,replace(replace(t1.open_org_id,chr(13),''),chr(10),'') as open_org_id
,replace(replace(t1.mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id
,replace(replace(t1.accting_org_id,chr(13),''),chr(10),'') as accting_org_id
,replace(replace(t1.pty_mgr_id,chr(13),''),chr(10),'') as pty_mgr_id
,t1.eff_dt as eff_dt
,t1.expire_dt as expire_dt
,replace(replace(t1.frozen_flg,chr(13),''),chr(10),'') as frozen_flg
,t1.frozen_dt as frozen_dt
,t1.unfrozen_dt as unfrozen_dt
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
,t1.acct_lmt as acct_lmt
,replace(replace(t1.auth_rank_cd,chr(13),''),chr(10),'') as auth_rank_cd
,replace(replace(t1.agt_status_cd,chr(13),''),chr(10),'') as agt_status_cd
,replace(replace(t1.camp_actvy_id,chr(13),''),chr(10),'') as camp_actvy_id
,replace(replace(t1.refe_typ_cd,chr(13),''),chr(10),'') as refe_typ_cd
,replace(replace(t1.refe_num,chr(13),''),chr(10),'') as refe_num
,replace(replace(t1.reg_chn_cd,chr(13),''),chr(10),'') as reg_chn_cd
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,NVL2(t1.data_src_cd,'AGT_EACCT_H'||'_'||DECODE(T1.DATA_SRC_CD,'LHWD',UPPER(SUBSTR(T1.JOB_CD,1,4)),T1.DATA_SRC_CD),'AGT_EACCT_H') as etl_task_name 
,replace(replace(t1.open_tm,chr(13),''),chr(10),'') as open_tm
from ${idl_schema}.hdws_iml_agt_eacct_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')
  and del_flg <> '1';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_agt_eacct_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes