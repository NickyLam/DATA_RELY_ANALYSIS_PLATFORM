: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_intstl_fee_h_f
CreateDate: 20251111
FileName:   ${iel_data_path}/agt_intstl_fee_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.fee_id,chr(13),''),chr(10),'') as fee_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.fee_cd,chr(13),''),chr(10),'') as fee_cd
,replace(replace(t1.bus_table_name,chr(13),''),chr(10),'') as bus_table_name
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.src_agt_id,chr(13),''),chr(10),'') as src_agt_id
,replace(replace(t1.fee_comnt,chr(13),''),chr(10),'') as fee_comnt
,fee_coll_begin_dt
,fee_coll_closing_dt
,fee_coll_shares
,avg_fee
,replace(replace(t1.fee_curr_cd,chr(13),''),chr(10),'') as fee_curr_cd
,fee_amt
,replace(replace(t1.fee_convt_curr_cd,chr(13),''),chr(10),'') as fee_convt_curr_cd
,fee_convt_amt
,replace(replace(t1.fee_enter_id,chr(13),''),chr(10),'') as fee_enter_id
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t1.init_tran_flow_num,chr(13),''),chr(10),'') as init_tran_flow_num
,tran_dt
,replace(replace(t1.stl_tran_flow_num,chr(13),''),chr(10),'') as stl_tran_flow_num
,stl_dt
,replace(replace(t1.role_type_cd,chr(13),''),chr(10),'') as role_type_cd
,recvbl_amt
,prefr_amt
,replace(replace(t1.provi_amort_type_cd,chr(13),''),chr(10),'') as provi_amort_type_cd

from ${iml_schema}.agt_intstl_fee_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_intstl_fee_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
