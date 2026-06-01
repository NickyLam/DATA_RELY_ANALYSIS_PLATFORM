: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_corp_stl_card_tran_flow_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_corp_stl_card_tran_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.glob_tran_flow_num,chr(13),''),chr(10),'') as glob_tran_flow_num
,replace(replace(t1.card_no,chr(13),''),chr(10),'') as card_no
,replace(replace(t1.card_prod_id,chr(13),''),chr(10),'') as card_prod_id
,replace(replace(t1.cust_acct_num,chr(13),''),chr(10),'') as cust_acct_num
,replace(replace(t1.acct_sub_acct_num,chr(13),''),chr(10),'') as acct_sub_acct_num
,replace(replace(t1.acct_curr_cd,chr(13),''),chr(10),'') as acct_curr_cd
,replace(replace(t1.acct_prod_id,chr(13),''),chr(10),'') as acct_prod_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,t1.tran_dt as tran_dt
,replace(replace(t1.tran_cd,chr(13),''),chr(10),'') as tran_cd
,replace(replace(t1.evt_cate_id,chr(13),''),chr(10),'') as evt_cate_id
,t1.tran_amt as tran_amt
,replace(replace(t1.tran_ref_no,chr(13),''),chr(10),'') as tran_ref_no
,replace(replace(t1.cntpty_card_no,chr(13),''),chr(10),'') as cntpty_card_no
,replace(replace(t1.cntpty_card_prod_id,chr(13),''),chr(10),'') as cntpty_card_prod_id
,replace(replace(t1.cntpty_cust_acct_num,chr(13),''),chr(10),'') as cntpty_cust_acct_num
,replace(replace(t1.sign_cntpty_curr_cd,chr(13),''),chr(10),'') as sign_cntpty_curr_cd
,replace(replace(t1.cntpty_acct_sub_acct_num,chr(13),''),chr(10),'') as cntpty_acct_sub_acct_num
,replace(replace(t1.cntpty_acct_prod_id,chr(13),''),chr(10),'') as cntpty_acct_prod_id
,t1.tran_tm as tran_tm
from ${iml_schema}.evt_corp_stl_card_tran_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_corp_stl_card_tran_flow.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes