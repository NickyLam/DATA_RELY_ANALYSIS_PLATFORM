: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_bill_discnt_batch_f
CreateDate: 20221021
FileName:   ${iel_data_path}/agt_bill_discnt_batch.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(batch_id,chr(13),''),chr(10),'')
,replace(replace(lp_id,chr(13),''),chr(10),'')
,replace(replace(org_id,chr(13),''),chr(10),'')
,replace(replace(enter_acct_org_id,chr(13),''),chr(10),'')
,replace(replace(buy_prod_cd,chr(13),''),chr(10),'')
,replace(replace(buy_type_cd,chr(13),''),chr(10),'')
,replace(replace(discnt_bus_type_cd,chr(13),''),chr(10),'')
,replace(replace(bus_id,chr(13),''),chr(10),'')
,replace(replace(bill_type_cd,chr(13),''),chr(10),'')
,replace(replace(bill_med_cd,chr(13),''),chr(10),'')
,replace(replace(cust_id,chr(13),''),chr(10),'')
,replace(replace(cust_name,chr(13),''),chr(10),'')
,replace(replace(cust_open_bank_no,chr(13),''),chr(10),'')
,replace(replace(cust_open_acct_num,chr(13),''),chr(10),'')
,int_rat
,replace(replace(int_rat_type_cd,chr(13),''),chr(10),'')
,redem_int_rat
,replace(replace(redem_int_rat_type_cd,chr(13),''),chr(10),'')
,buy_dt
,replace(replace(onl_clear_flg,chr(13),''),chr(10),'')
,redem_open_dt
,redem_closing_dt
,replace(replace(sys_in_flg,chr(13),''),chr(10),'')
,replace(replace(pay_int_way_cd,chr(13),''),chr(10),'')
,replace(replace(int_payer_name,chr(13),''),chr(10),'')
,replace(replace(int_payer_acct_num,chr(13),''),chr(10),'')
,pay_int_ratio
,replace(replace(agent_name,chr(13),''),chr(10),'')
,replace(replace(cust_mgr_id,chr(13),''),chr(10),'')
,replace(replace(dept_id,chr(13),''),chr(10),'')
,replace(replace(discnt_bf_revw_flg,chr(13),''),chr(10),'')
,replace(replace(cont_matrl_backup_flg,chr(13),''),chr(10),'')
,backup_closing_dt
,replace(replace(operr_id,chr(13),''),chr(10),'')
,tran_dt
,replace(replace(bus_logic_check_status_cd,chr(13),''),chr(10),'')
,replace(replace(crdt_check_status_cd,chr(13),''),chr(10),'')
,replace(replace(check_status_cd,chr(13),''),chr(10),'')
,replace(replace(int_accr_check_status_cd,chr(13),''),chr(10),'')
,replace(replace(entry_status_cd,chr(13),''),chr(10),'')
,replace(replace(intnal_stl_flg,chr(13),''),chr(10),'')
,replace(replace(intnal_stl_acct,chr(13),''),chr(10),'')
,agt_exp_dt
,crdt_valid_amt
,apprved_use_crdt_open_amt
,distr_post_acm_use_open_amt
,replace(replace(cert_type_cd,chr(13),''),chr(10),'')
,replace(replace(cert_no,chr(13),''),chr(10),'')
,replace(replace(asset_thd_cls_cd,chr(13),''),chr(10),'')
,replace(replace(rela_party_que_rest_cd,chr(13),''),chr(10),'')
,crdt_cont_used_amt
,crdt_cont_tot_amt
,lmt_cont_used_tot_amt
,replace(replace(midgrod_bus_flow_num,chr(13),''),chr(10),'')
,replace(replace(h_data_flg,chr(13),''),chr(10),'')
,replace(replace(int_calc_defer_way_cd,chr(13),''),chr(10),'')
,create_dt
,update_dt
,replace(replace(id_mark,chr(13),''),chr(10),'')
,replace(replace(src_table_name,chr(13),''),chr(10),'')

from ${iml_schema}.agt_bill_discnt_batch t1
where 1=1" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_bill_discnt_batch.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
