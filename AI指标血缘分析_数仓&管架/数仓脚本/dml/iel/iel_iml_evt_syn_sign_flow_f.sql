: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_syn_sign_flow_f
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_syn_sign_flow.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.sign_flow_num,chr(13),''),chr(10),'') as sign_flow_num
,replace(replace(t.chn_cd,chr(13),''),chr(10),'') as chn_cd
,replace(replace(t.chn_flow_num,chr(13),''),chr(10),'') as chn_flow_num
,replace(replace(t.trdpty_flow_num,chr(13),''),chr(10),'') as trdpty_flow_num
,replace(replace(t.core_flow_num,chr(13),''),chr(10),'') as core_flow_num
,replace(replace(t.tran_type_cd,chr(13),''),chr(10),'') as tran_type_cd
,replace(replace(t.cont_id,chr(13),''),chr(10),'') as cont_id
,replace(replace(t.agt_cd,chr(13),''),chr(10),'') as agt_cd
,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t.acct_id,chr(13),''),chr(10),'') as acct_id
,t.sign_dt as sign_dt
,t.sign_tm as sign_tm
,replace(replace(t.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t.sign_teller_id,chr(13),''),chr(10),'') as sign_teller_id
,replace(replace(t.auth_teller_id,chr(13),''),chr(10),'') as auth_teller_id
,replace(replace(t.trdpty_sys_tran_code,chr(13),''),chr(10),'') as trdpty_sys_tran_code
,replace(replace(t.trdpty_tran_name,chr(13),''),chr(10),'') as trdpty_tran_name
,replace(replace(t.tran_rest_cd,chr(13),''),chr(10),'') as tran_rest_cd
,replace(replace(t.vouch_print_flg,chr(13),''),chr(10),'') as vouch_print_flg
,replace(replace(t.print_opera_id,chr(13),''),chr(10),'') as print_opera_id
,replace(replace(t.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t.tran_comnt,chr(13),''),chr(10),'') as tran_comnt
from iml.evt_syn_sign_flow t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_syn_sign_flow.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes