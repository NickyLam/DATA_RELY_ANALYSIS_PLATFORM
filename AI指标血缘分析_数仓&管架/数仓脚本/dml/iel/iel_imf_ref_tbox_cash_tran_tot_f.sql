: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_ref_tbox_cash_tran_tot_f
CreateDate: 20251202
FileName:   ${iel_data_path}/ref_tbox_cash_tran_tot.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.mutil_curr_flg,chr(13),''),chr(10),'') as mutil_curr_flg
,tot_amt

from ${iml_schema}.ref_tbox_cash_tran_tot t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_tbox_cash_tran_tot.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
