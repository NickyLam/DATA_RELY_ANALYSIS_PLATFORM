: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_loan_bal_chg_info_a
CreateDate: 20250804
FileName:   ${iel_data_path}/cmm_loan_bal_chg_info.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t1.bus_line_cd,chr(13),''),chr(10),'') as bus_line_cd
,replace(replace(t1.disp_type_cd,chr(13),''),chr(10),'') as disp_type_cd
,replace(replace(t1.disp_way_cd,chr(13),''),chr(10),'') as disp_way_cd
,replace(replace(t1.tran_type_cd,chr(13),''),chr(10),'') as tran_type_cd
,bal_chag_date
,replace(replace(t1.bal_tm_ear_lvl5_cls_cd,chr(13),''),chr(10),'') as bal_tm_ear_lvl5_cls_cd
,replace(replace(t1.bal_tm_lvl5_cls_cd,chr(13),''),chr(10),'') as bal_tm_lvl5_cls_cd
,tran_dt
,wrt_off_dt
,prob_loan_dt
,ear_y_pric_bal
,pric_amt
,int_amt
,pnlt_amt
,comp_int_amt
,fee_amt
,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id
,replace(replace(t1.mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id
,replace(replace(t1.acct_instit_id,chr(13),''),chr(10),'') as acct_instit_id

from ${icl_schema}.cmm_loan_bal_chg_info t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_loan_bal_chg_info.a.${batch_date}.dat" \
        charset=utf8
        safe=yes
