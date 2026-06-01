: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_forgn_pay_acpt_base_info_h_f
CreateDate: 20231110
FileName:   ${iel_data_path}/agt_forgn_pay_acpt_base_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.decl_id,chr(13),''),chr(10),'') as decl_id
,replace(replace(t1.temp_decl_flow_id,chr(13),''),chr(10),'') as temp_decl_flow_id
,replace(replace(t1.init_enty_id,chr(13),''),chr(10),'') as init_enty_id
,replace(replace(t1.oper_type_cd,chr(13),''),chr(10),'') as oper_type_cd
,replace(replace(t1.modif_rs_comnt,chr(13),''),chr(10),'') as modif_rs_comnt
,replace(replace(t1.decl_num,chr(13),''),chr(10),'') as decl_num
,replace(replace(t1.payer_type_cd,chr(13),''),chr(10),'') as payer_type_cd
,replace(replace(t1.id_card_piece_no_code,chr(13),''),chr(10),'') as id_card_piece_no_code
,replace(replace(t1.orgnz_cd,chr(13),''),chr(10),'') as orgnz_cd
,replace(replace(t1.payer_name,chr(13),''),chr(10),'') as payer_name
,replace(replace(t1.recver_name,chr(13),''),chr(10),'') as recver_name
,replace(replace(t1.pay_curr_cd,chr(13),''),chr(10),'') as pay_curr_cd
,pay_amt
,remit_out_exch_rat
,remit_out_amt
,replace(replace(t1.cny_acct_id,chr(13),''),chr(10),'') as cny_acct_id
,spot_exch_amt
,replace(replace(t1.fx_acct_id,chr(13),''),chr(10),'') as fx_acct_id
,other_amt
,replace(replace(t1.other_acct_id,chr(13),''),chr(10),'') as other_acct_id
,replace(replace(t1.stl_way_cd,chr(13),''),chr(10),'') as stl_way_cd
,replace(replace(t1.bank_bus_id,chr(13),''),chr(10),'') as bank_bus_id
,replace(replace(t1.actl_pay_curr_cd,chr(13),''),chr(10),'') as actl_pay_curr_cd
,actl_pay_amt
,replace(replace(t1.deduct_curr_cd,chr(13),''),chr(10),'') as deduct_curr_cd
,deduct_amt
,replace(replace(t1.lc_id,chr(13),''),chr(10),'') as lc_id
,issue_dt
,tenor

from ${iml_schema}.agt_forgn_pay_acpt_base_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_forgn_pay_acpt_base_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
