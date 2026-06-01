: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_wl_crdt_appl_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_wl_crdt_appl.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.appl_id,chr(13),''),chr(10),'') as appl_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.init_crdt_appl_id,chr(13),''),chr(10),'') as init_crdt_appl_id
    ,replace(replace(t.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
    ,replace(replace(t.prod_id,chr(13),''),chr(10),'') as prod_id
    ,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
    ,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
    ,t.crdt_lmt as crdt_lmt
    ,t.expos_lmt as expos_lmt
    ,t.surp_lmt as surp_lmt
    ,t.exec_int_rat as exec_int_rat
    ,t.tenor as tenor
    ,t.appl_tm as appl_tm
    ,t.apved_tm as apved_tm
    ,t.appl_start_tm as appl_start_tm
    ,t.crdt_exp_tm as crdt_exp_tm
    ,replace(replace(t.tenor_type_cd,chr(13),''),chr(10),'') as tenor_type_cd
    ,replace(replace(t.manu_proc_flg,chr(13),''),chr(10),'') as manu_proc_flg
    ,replace(replace(t.circl_flg,chr(13),''),chr(10),'') as circl_flg
    ,replace(replace(t.share_crdt_lmt_flg,chr(13),''),chr(10),'') as share_crdt_lmt_flg
    ,replace(replace(t.appl_status_cd,chr(13),''),chr(10),'') as appl_status_cd
    ,replace(replace(t.user_group_id,chr(13),''),chr(10),'') as user_group_id
    ,replace(replace(t.org_id,chr(13),''),chr(10),'') as org_id
    ,replace(replace(t.co_proj_id,chr(13),''),chr(10),'') as co_proj_id
    ,replace(replace(t.coprator_acct_id,chr(13),''),chr(10),'') as coprator_acct_id
    ,replace(replace(t.taxpayer_idtfy_num,chr(13),''),chr(10),'') as taxpayer_idtfy_num
    ,replace(replace(t.equip_id,chr(13),''),chr(10),'') as equip_id
    ,replace(replace(t.co_org_id,chr(13),''),chr(10),'') as co_org_id
    ,replace(replace(t.apv_rest_descb,chr(13),''),chr(10),'') as apv_rest_descb
    ,replace(replace(t.refer_emply_id,chr(13),''),chr(10),'') as refer_emply_id
    ,replace(replace(t.applit_id_card_num,chr(13),''),chr(10),'') as applit_id_card_num
    ,replace(replace(t.applit_mobile_no,chr(13),''),chr(10),'') as applit_mobile_no
    ,replace(replace(t.chn_id,chr(13),''),chr(10),'') as chn_id
    ,t.create_dt as create_dt
    ,t.update_dt as update_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.agt_wl_crdt_appl t
  where t.create_dt <= to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_wl_crdt_appl.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes