: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_overs_remit_appl_base_info_h_f
CreateDate: 20231102
FileName:   ${iel_data_path}/agt_overs_remit_appl_base_info_h.f.${batch_date}.dat
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
,replace(replace(t1.edit_id,chr(13),''),chr(10),'') as edit_id
,replace(replace(t1.oper_type_cd,chr(13),''),chr(10),'') as oper_type_cd
,replace(replace(t1.modif_rs_descb,chr(13),''),chr(10),'') as modif_rs_descb
,replace(replace(t1.decl_num,chr(13),''),chr(10),'') as decl_num
,replace(replace(t1.remiter_type_cd,chr(13),''),chr(10),'') as remiter_type_cd
,replace(replace(t1.indv_id_card_piece_no_code,chr(13),''),chr(10),'') as indv_id_card_piece_no_code
,replace(replace(t1.orgnz_id,chr(13),''),chr(10),'') as orgnz_id
,replace(replace(t1.remiter_name,chr(13),''),chr(10),'') as remiter_name
,replace(replace(t1.recver_name,chr(13),''),chr(10),'') as recver_name
,replace(replace(t1.remit_curr_cd,chr(13),''),chr(10),'') as remit_curr_cd
,remit_amt
,exch_rat
,foreign_exch_pur_amt
,replace(replace(t1.cny_acct_id,chr(13),''),chr(10),'') as cny_acct_id
,spot_exch_amt
,replace(replace(t1.fx_acct_id,chr(13),''),chr(10),'') as fx_acct_id
,other_amt
,replace(replace(t1.other_acct_id,chr(13),''),chr(10),'') as other_acct_id
,replace(replace(t1.stl_way_cd,chr(13),''),chr(10),'') as stl_way_cd
,replace(replace(t1.bank_bus_id,chr(13),''),chr(10),'') as bank_bus_id

from ${iml_schema}.agt_overs_remit_appl_base_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_overs_remit_appl_base_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
