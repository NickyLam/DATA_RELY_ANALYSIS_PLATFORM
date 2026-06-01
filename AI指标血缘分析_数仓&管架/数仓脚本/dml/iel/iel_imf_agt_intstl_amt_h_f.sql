: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_intstl_amt_h_f
CreateDate: 20240809
FileName:   ${iel_data_path}/agt_intstl_amt_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.amt_id,chr(13),''),chr(10),'') as amt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.src_agt_id,chr(13),''),chr(10),'') as src_agt_id
,replace(replace(t1.agt_type_cd,chr(13),''),chr(10),'') as agt_type_cd
,replace(replace(t1.bus_table_name,chr(13),''),chr(10),'') as bus_table_name
,replace(replace(t1.ext_amt_type,chr(13),''),chr(10),'') as ext_amt_type
,replace(replace(t1.amt_type_cd,chr(13),''),chr(10),'') as amt_type_cd
,replace(replace(t1.tran_evt_type,chr(13),''),chr(10),'') as tran_evt_type
,replace(replace(t1.tran_evt_id,chr(13),''),chr(10),'') as tran_evt_id
,tran_evt_dt
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,amt
,replace(replace(t1.auth_flg_cd,chr(13),''),chr(10),'') as auth_flg_cd
,replace(replace(t1.convt_curr_cd,chr(13),''),chr(10),'') as convt_curr_cd
,convt_amt
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.off_bs_amt_acct_id,chr(13),''),chr(10),'') as off_bs_amt_acct_id

from ${iml_schema}.agt_intstl_amt_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_intstl_amt_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
