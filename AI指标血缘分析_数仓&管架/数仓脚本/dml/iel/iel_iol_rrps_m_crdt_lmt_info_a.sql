: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rrps_m_crdt_lmt_info_a
CreateDate: 20240805
FileName:   ${iel_data_path}/rrps_m_crdt_lmt_info.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt
,replace(replace(t1.data_dt,chr(13),''),chr(10),'') as data_dt
,replace(replace(t1.lgl_rep_id,chr(13),''),chr(10),'') as lgl_rep_id
,replace(replace(t1.prim_crdt_cont_id,chr(13),''),chr(10),'') as prim_crdt_cont_id
,replace(replace(t1.prim_crdt_cont_nm,chr(13),''),chr(10),'') as prim_crdt_cont_nm
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.cur,chr(13),''),chr(10),'') as cur
,crdt_total_lmt
,aldy_use_lmt
,exp_crdt_lmt
,exp_aldy_use_lmt
,opr_crdt_tot_amt
,opr_aldy_use_crdt_tot_amt
,hse_crdt_lmt
,hse_aldy_use_crdt_lmt
,car_loan_crdt_lmt
,car_loan_aldy_use_crdt_lmt
,sl_crdt_lmt
,sl_aldy_use_crdt_lmt
,oth_cnsmp_crdt_lmt
,oth_cnsmp_aldy_use_crdt_lmt
,replace(replace(t1.crdt_stat,chr(13),''),chr(10),'') as crdt_stat
,replace(replace(t1.first_crdt_dt,chr(13),''),chr(10),'') as first_crdt_dt
,replace(replace(t1.dept_line,chr(13),''),chr(10),'') as dept_line
,replace(replace(t1.data_src,chr(13),''),chr(10),'') as data_src
,oth_in_crdt_amt
,out_crdt_amt
,bill_acpt_crdt_amt
,replace(replace(t1.crdt_app_dt,chr(13),''),chr(10),'') as crdt_app_dt
,replace(replace(t1.crdt_start_dt,chr(13),''),chr(10),'') as crdt_start_dt
,replace(replace(t1.crdt_exp_dt,chr(13),''),chr(10),'') as crdt_exp_dt

from ${iol_schema}.rrps_m_crdt_lmt_info t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rrps_m_crdt_lmt_info.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
