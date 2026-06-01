: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_long_hang_acct_oper_info_h_f
CreateDate: 20221228
FileName:   ${iel_data_path}/agt_long_hang_acct_oper_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.bus_batch_no,chr(13),''),chr(10),'') as bus_batch_no
,replace(replace(t1.turn_long_hang_oper_type_cd,chr(13),''),chr(10),'') as turn_long_hang_oper_type_cd
,replace(replace(t1.manual_imp_flg,chr(13),''),chr(10),'') as manual_imp_flg
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_acct_num,chr(13),''),chr(10),'') as cust_acct_num
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.sub_acct_num,chr(13),''),chr(10),'') as sub_acct_num
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.amt_type_cd,chr(13),''),chr(10),'') as amt_type_cd
,bal
,int_amt
,acct_pric_int_sum
,acct_int_tax
,replace(replace(t1.prep_turn_long_hang_org_id,chr(13),''),chr(10),'') as prep_turn_long_hang_org_id
,replace(replace(t1.prep_turn_long_hang_oper_teller_id,chr(13),''),chr(10),'') as prep_turn_long_hang_oper_teller_id
,prep_turn_long_hang_dt
,prep_turn_out_bus_dt
,replace(replace(t1.prep_turn_out_bus_oper_teller_id,chr(13),''),chr(10),'') as prep_turn_out_bus_oper_teller_id
,long_hang_clean_dt
,replace(replace(t1.long_hang_clean_org_id,chr(13),''),chr(10),'') as long_hang_clean_org_id
,replace(replace(t1.tran_out_teller_id,chr(13),''),chr(10),'') as tran_out_teller_id
,replace(replace(t1.tran_out_long_hang_rs,chr(13),''),chr(10),'') as tran_out_long_hang_rs
,replace(replace(t1.long_hang_status_cd,chr(13),''),chr(10),'') as long_hang_status_cd
,turn_long_hang_dt
,replace(replace(t1.turn_long_hang_org_id,chr(13),''),chr(10),'') as turn_long_hang_org_id
,replace(replace(t1.turn_long_hang_teller_id,chr(13),''),chr(10),'') as turn_long_hang_teller_id
,replace(replace(t1.tran_in_long_hang_rs,chr(13),''),chr(10),'') as tran_in_long_hang_rs
,acct_actv_dt
,replace(replace(t1.actv_org_id,chr(13),''),chr(10),'') as actv_org_id
,replace(replace(t1.actv_teller_id,chr(13),''),chr(10),'') as actv_teller_id
,turn_out_bus_dt
,replace(replace(t1.turn_out_bus_oper_teller_id,chr(13),''),chr(10),'') as turn_out_bus_oper_teller_id
,replace(replace(t1.priv_flg,chr(13),''),chr(10),'') as priv_flg
,replace(replace(t1.tran_out_acct_num_obank_flg,chr(13),''),chr(10),'') as tran_out_acct_num_obank_flg
,replace(replace(t1.tran_out_acct_id,chr(13),''),chr(10),'') as tran_out_acct_id
,replace(replace(t1.aim_curr_cd,chr(13),''),chr(10),'') as aim_curr_cd
,replace(replace(t1.tran_out_acct_sub_acct_num,chr(13),''),chr(10),'') as tran_out_acct_sub_acct_num
,replace(replace(t1.tran_out_acct_name,chr(13),''),chr(10),'') as tran_out_acct_name
,replace(replace(t1.tran_in_acct_type_cd,chr(13),''),chr(10),'') as tran_in_acct_type_cd
,replace(replace(t1.addit_remark,chr(13),''),chr(10),'') as addit_remark
,tran_tm
,actl_enter_acct_amt
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,tran_dt
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,tran_amt
,replace(replace(t1.tran_ref_no,chr(13),''),chr(10),'') as tran_ref_no
,replace(replace(t1.auth_teller_id,chr(13),''),chr(10),'') as auth_teller_id
,replace(replace(t1.chn_id,chr(13),''),chr(10),'') as chn_id
,replace(replace(t1.edit_id,chr(13),''),chr(10),'') as edit_id

from ${iml_schema}.agt_long_hang_acct_oper_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_long_hang_acct_oper_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
