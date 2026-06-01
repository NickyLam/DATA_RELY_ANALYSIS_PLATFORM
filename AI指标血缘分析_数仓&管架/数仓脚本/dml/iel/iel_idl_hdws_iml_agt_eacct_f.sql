: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_agt_eacct_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_agt_eacctf.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
t.agt_id
,t.agt_modf
,t.etl_dt
,t.last_update_dt
,t.acct_name
,t.acct_desc
,t.card_num
,t.blng_pty_id
,t.open_org_id
,t.mgmt_org_id
,t.accting_org_id
,t.pty_mgr_id
,t.eff_dt
,t.expire_dt
,t.frozen_flg
,t.frozen_dt
,t.unfrozen_dt
,t.ccy_cd
,t.acct_lmt
,t.auth_rank_cd
,t.agt_status_cd
,t.camp_actvy_id
,t.refe_typ_cd
,t.refe_num
,t.reg_chn_cd
,t.data_src_cd
,t.etl_task_name
,t.open_tm
from idl.hdws_iml_agt_eacct_info t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_agt_eacct.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes