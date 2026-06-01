: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_cust_tran_lmt_modif_h_f
CreateDate: 20251110
FileName:   ${iel_data_path}/agt_cust_tran_lmt_modif_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_acct_num,chr(13),''),chr(10),'') as cust_acct_num
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.sub_acct_num,chr(13),''),chr(10),'') as sub_acct_num
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.chn_id,chr(13),''),chr(10),'') as chn_id
,replace(replace(t1.lmt_cate_cd,chr(13),''),chr(10),'') as lmt_cate_cd
,replace(replace(t1.lmt_set_rs_cd,chr(13),''),chr(10),'') as lmt_set_rs_cd
,single_day_lmt
,init_single_day_lmt
,single_day_lmt_cnt
,init_single_day_lmt_cnt
,sig_lmt
,init_sig_lmt
,year_lmt
,init_year_lmt
,tran_lmt_valid_dt
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,replace(replace(t1.tran_ref_no,chr(13),''),chr(10),'') as tran_ref_no
,tran_dt

from ${iml_schema}.agt_cust_tran_lmt_modif_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_cust_tran_lmt_modif_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
