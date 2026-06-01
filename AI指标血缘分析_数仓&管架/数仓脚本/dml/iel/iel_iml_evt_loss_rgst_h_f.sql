: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_loss_rgst_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_loss_rgst_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.seq_num,chr(13),''),chr(10),'') as seq_num
    ,t.loss_dt as loss_dt
    ,replace(replace(t.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
    ,replace(replace(t.vouch_no,chr(13),''),chr(10),'') as vouch_no
    ,replace(replace(t.vouch_type_cd,chr(13),''),chr(10),'') as vouch_type_cd
    ,replace(replace(t.loss_kind_cd,chr(13),''),chr(10),'') as loss_kind_cd
    ,replace(replace(t.loss_way_cd,chr(13),''),chr(10),'') as loss_way_cd
    ,replace(replace(t.pay_status_cd,chr(13),''),chr(10),'') as pay_status_cd
    ,replace(replace(t.loss_status_cd,chr(13),''),chr(10),'') as loss_status_cd
    ,replace(replace(t.acct_id,chr(13),''),chr(10),'') as acct_id
    ,replace(replace(t.vouch_mgmt_id,chr(13),''),chr(10),'') as vouch_mgmt_id
    ,replace(replace(t.wdraw_way_cd,chr(13),''),chr(10),'') as wdraw_way_cd
    ,replace(replace(t.init_vouch_status_cd,chr(13),''),chr(10),'') as init_vouch_status_cd
    ,replace(replace(t.vouch_status_cd,chr(13),''),chr(10),'') as vouch_status_cd
    ,replace(replace(t.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd
    ,replace(replace(t.cert_no,chr(13),''),chr(10),'') as cert_no
    ,replace(replace(t.oper_teller_id,chr(13),''),chr(10),'') as oper_teller_id
    ,replace(replace(t.org_id,chr(13),''),chr(10),'') as org_id
    ,replace(replace(t.agent_name,chr(13),''),chr(10),'') as agent_name
    ,replace(replace(t.agent_cert_type_cd,chr(13),''),chr(10),'') as agent_cert_type_cd
    ,replace(replace(t.agent_cert_no,chr(13),''),chr(10),'') as agent_cert_no
    ,replace(replace(t.earliest_unloss_dt,chr(13),''),chr(10),'') as earliest_unloss_dt
    ,replace(replace(t.rela_vouch_loss_flg,chr(13),''),chr(10),'') as rela_vouch_loss_flg
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.evt_loss_rgst_h t
  where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_loss_rgst_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes