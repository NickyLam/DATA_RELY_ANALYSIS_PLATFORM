: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_fft_tran_dtl_f
CreateDate: 20250213
FileName:   ${iel_data_path}/agt_fft_tran_dtl.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.flow_num,chr(13),''),chr(10),'') as flow_num
,replace(replace(t1.tot_flow_num,chr(13),''),chr(10),'') as tot_flow_num
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id
,sell_int_rat
,tran_sell_recvbl_amt
,abmt_comm_fee_amt
,tran_sell_exp_dt
,amorted_amt
,inter_bus_inco_amt
,replace(replace(t1.issue_bank_bank_no,chr(13),''),chr(10),'') as issue_bank_bank_no
,replace(replace(t1.acpt_bank_bank_no,chr(13),''),chr(10),'') as acpt_bank_bank_no
,replace(replace(t1.lc_benefc_indus_type_cd,chr(13),''),chr(10),'') as lc_benefc_indus_type_cd

from ${iml_schema}.agt_fft_tran_dtl t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_fft_tran_dtl.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
