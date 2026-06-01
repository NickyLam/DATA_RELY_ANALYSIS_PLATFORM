: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_loan_distr_flow_i
CreateDate: 20230607
FileName:   ${iel_data_path}/evt_loan_distr_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,distr_dt
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id
,exp_dt
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,distr_amt
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.loan_num,chr(13),''),chr(10),'') as loan_num
,replace(replace(t1.seq_num,chr(13),''),chr(10),'') as seq_num
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.distr_flow_num,chr(13),''),chr(10),'') as distr_flow_num
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.distr_way_cd,chr(13),''),chr(10),'') as distr_way_cd
,discnt_int
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,tran_dt
,replace(replace(t1.tran_ref_no,chr(13),''),chr(10),'') as tran_ref_no
,replace(replace(t1.evt_cate_id,chr(13),''),chr(10),'') as evt_cate_id
,replace(replace(t1.bus_tran_cate_cd,chr(13),''),chr(10),'') as bus_tran_cate_cd
,replace(replace(t1.revs_flg,chr(13),''),chr(10),'') as revs_flg
,replace(replace(t1.tran_revs_rs,chr(13),''),chr(10),'') as tran_revs_rs
,replace(replace(t1.revs_teller_id,chr(13),''),chr(10),'') as revs_teller_id
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,tran_tm
,replace(replace(t1.once_open_distr_flg,chr(13),''),chr(10),'') as once_open_distr_flg
,replace(replace(t1.contrior_id,chr(13),''),chr(10),'') as contrior_id

from ${iml_schema}.evt_loan_distr_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_loan_distr_flow.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
