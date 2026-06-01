: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_mercht_clear_batch_dtl_i
CreateDate: 20230928
FileName:   ${iel_data_path}/evt_mercht_clear_batch_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.batch_id,chr(13),''),chr(10),'') as batch_id
,replace(replace(t1.init_tran_flow_num,chr(13),''),chr(10),'') as init_tran_flow_num
,rgst_dt
,rgst_tm
,replace(replace(t1.dtl_status_cd,chr(13),''),chr(10),'') as dtl_status_cd
,replace(replace(t1.upp_flow_num,chr(13),''),chr(10),'') as upp_flow_num
,amt
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.pay_acct_id,chr(13),''),chr(10),'') as pay_acct_id
,replace(replace(t1.pay_acct_name,chr(13),''),chr(10),'') as pay_acct_name
,replace(replace(t1.pay_sub_acct_num,chr(13),''),chr(10),'') as pay_sub_acct_num
,replace(replace(t1.pay_pt_type_cd,chr(13),''),chr(10),'') as pay_pt_type_cd
,replace(replace(t1.recvbl_acct_id,chr(13),''),chr(10),'') as recvbl_acct_id
,replace(replace(t1.recvbl_acct_name,chr(13),''),chr(10),'') as recvbl_acct_name
,replace(replace(t1.recvbl_sub_acct_num,chr(13),''),chr(10),'') as recvbl_sub_acct_num
,replace(replace(t1.recvbl_pt_type_cd,chr(13),''),chr(10),'') as recvbl_pt_type_cd
,replace(replace(t1.bank_postsc,chr(13),''),chr(10),'') as bank_postsc
,replace(replace(t1.cust_postsc,chr(13),''),chr(10),'') as cust_postsc
,replace(replace(t1.err_descb,chr(13),''),chr(10),'') as err_descb
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.core_flow_num,chr(13),''),chr(10),'') as core_flow_num
,core_dt
,final_modif_tm

from ${iml_schema}.evt_mercht_clear_batch_dtl t1
where etl_dt <= to_date('${batch_date}','yyyymmdd') and etl_dt > to_date('${batch_date}','yyyymmdd')-15" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_mercht_clear_batch_dtl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
