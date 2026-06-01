: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_credit_contract_info_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_credit_contract_info_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(crdt_lmt_agt_id,chr(10),''),chr(13),'') as crdt_lmt_agt_id
,replace(replace(cust_id,chr(10),''),chr(13),'') as cust_id
,replace(replace(cust_type_cd,chr(10),''),chr(13),'') as cust_type_cd
,replace(replace(manu_cont_id,chr(10),''),chr(13),'') as manu_cont_id
,replace(replace(crdt_apv_id,chr(10),''),chr(13),'') as crdt_apv_id
,replace(replace(crdt_appl_id,chr(10),''),chr(13),'') as crdt_appl_id
,replace(replace(crdt_kind_cd,chr(10),''),chr(13),'') as crdt_kind_cd
,replace(replace(crdt_bus_kind_cd,chr(10),''),chr(13),'') as crdt_bus_kind_cd
,replace(replace(open_dt,chr(10),''),chr(13),'') as open_dt
,replace(replace(apv_dt,chr(10),''),chr(13),'') as apv_dt
,replace(replace(crdt_start_dt,chr(10),''),chr(13),'') as crdt_start_dt
,replace(replace(crdt_exp_dt,chr(10),''),chr(13),'') as crdt_exp_dt
,replace(replace(crdt_termnt_dt,chr(10),''),chr(13),'') as crdt_termnt_dt
,replace(replace(crdt_cont_status_cd,chr(10),''),chr(13),'') as crdt_cont_status_cd
,replace(replace(crdt_lmt_wrtoff_effect_dt,chr(10),''),chr(13),'') as crdt_lmt_wrtoff_effect_dt
,replace(replace(crdt_lmt_wrtoff_reason,chr(10),''),chr(13),'') as crdt_lmt_wrtoff_reason
,replace(replace(crdt_lmt_froz_flg,chr(10),''),chr(13),'') as crdt_lmt_froz_flg
,replace(replace(circl_flg,chr(10),''),chr(13),'') as circl_flg
,replace(replace(crdt_valid_flg,chr(10),''),chr(13),'') as crdt_valid_flg
,replace(replace(com_group_crdt_lmt_flg,chr(10),''),chr(13),'') as com_group_crdt_lmt_flg
,replace(replace(happ_type_cd,chr(10),''),chr(13),'') as happ_type_cd
,replace(replace(curr_cd,chr(10),''),chr(13),'') as curr_cd
,replace(replace(crdt_lmt,chr(10),''),chr(13),'') as crdt_lmt
,replace(replace(used_crdt_lmt,chr(10),''),chr(13),'') as used_crdt_lmt
,replace(replace(crdt_bal,chr(10),''),chr(13),'') as crdt_bal
,replace(replace(aval_crdt_lmt,chr(10),''),chr(13),'') as aval_crdt_lmt
,replace(replace(open_lmt,chr(10),''),chr(13),'') as open_lmt
,replace(replace(open_bal,chr(10),''),chr(13),'') as open_bal
,replace(replace(aval_open_lmt,chr(10),''),chr(13),'') as aval_open_lmt
,replace(replace(onl_lmt,chr(10),''),chr(13),'') as onl_lmt
,replace(replace(onl_bal,chr(10),''),chr(13),'') as onl_bal
,replace(replace(apv_crdt_lmt,chr(10),''),chr(13),'') as apv_crdt_lmt
,replace(replace(apv_open_lmt,chr(10),''),chr(13),'') as apv_open_lmt
,replace(replace(group_corp_crdt_lmt,chr(10),''),chr(13),'') as group_corp_crdt_lmt
,replace(replace(group_corp_open_lmt,chr(10),''),chr(13),'') as group_corp_open_lmt
,replace(replace(group_ibank_crdt_lmt,chr(10),''),chr(13),'') as group_ibank_crdt_lmt
,replace(replace(group_ibank_open_lmt,chr(10),''),chr(13),'') as group_ibank_open_lmt
,replace(replace(guar_val,chr(10),''),chr(13),'') as guar_val
,replace(replace(guar_ratio,chr(10),''),chr(13),'') as guar_ratio
,replace(replace(guar_way_cd,chr(10),''),chr(13),'') as guar_way_cd
,replace(replace(open_org_id,chr(10),''),chr(13),'') as open_org_id
,replace(replace(crdt_mgmt_org_id,chr(10),''),chr(13),'') as crdt_mgmt_org_id
,replace(replace(crdt_acct_instit_id,chr(10),''),chr(13),'') as crdt_acct_instit_id
,replace(replace(crdt_user_id,chr(10),''),chr(13),'') as crdt_user_id
,replace(replace(init_crdt_lmt_agt_id,chr(10),''),chr(13),'') as init_crdt_lmt_agt_id
,replace(replace(data_src_cd,chr(10),''),chr(13),'') as data_src_cd
,replace(replace(etl_dt_ora,chr(10),''),chr(13),'') as etl_dt_ora
,start_dt
,end_dt
,id_mark
,etl_timestamp
 from iol.crss_credit_contract_info 
 where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_credit_contract_info_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes