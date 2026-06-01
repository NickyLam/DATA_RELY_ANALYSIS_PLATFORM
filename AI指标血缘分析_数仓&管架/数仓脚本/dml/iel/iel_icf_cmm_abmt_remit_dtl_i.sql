: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_abmt_remit_dtl_i
CreateDate: 20231117
FileName:   ${iel_data_path}/cmm_abmt_remit_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.tran_flow_id,chr(13),''),chr(10),'') as tran_flow_id
,replace(replace(t1.tran_bank_swiftcode,chr(13),''),chr(10),'') as tran_bank_swiftcode
,replace(replace(t1.decl_num,chr(13),''),chr(10),'') as decl_num
,replace(replace(t1.remit_id,chr(13),''),chr(10),'') as remit_id
,replace(replace(t1.remiter_name,chr(13),''),chr(10),'') as remiter_name
,remit_cmplt_dt
,replace(replace(t1.remit_char,chr(13),''),chr(10),'') as remit_char
,replace(replace(t1.recver_cust_type_cd,chr(13),''),chr(10),'') as recver_cust_type_cd
,replace(replace(t1.recver_name,chr(13),''),chr(10),'') as recver_name
,replace(replace(t1.recver_cn_name,chr(13),''),chr(10),'') as recver_cn_name
,replace(replace(t1.recver_cty_cd,chr(13),''),chr(10),'') as recver_cty_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,remit_amt
,replace(replace(t1.tran_cd,chr(13),''),chr(10),'') as tran_cd
,replace(replace(t1.tran_postsc,chr(13),''),chr(10),'') as tran_postsc
,replace(replace(t1.tran_dtl_cd,chr(13),''),chr(10),'') as tran_dtl_cd
,replace(replace(t1.tran_dtl_postsc,chr(13),''),chr(10),'') as tran_dtl_postsc
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,replace(replace(t1.tran_org_name,chr(13),''),chr(10),'') as tran_org_name
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.tran_chn_descb,chr(13),''),chr(10),'') as tran_chn_descb
,replace(replace(t1.msg_info,chr(13),''),chr(10),'') as msg_info
,fee_amt
,usd_fee_amt
,replace(replace(t1.remiter_cty_cd,chr(13),''),chr(10),'') as remiter_cty_cd
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,usd_tran_amt
,replace(replace(t1.remiter_cn_name,chr(13),''),chr(10),'') as remiter_cn_name
,replace(replace(t1.clear_bk_bic,chr(13),''),chr(10),'') as clear_bk_bic
,replace(replace(t1.inter_bank_bic,chr(13),''),chr(10),'') as inter_bank_bic
,replace(replace(t1.recv_bank_bic,chr(13),''),chr(10),'') as recv_bank_bic
,replace(replace(t1.core_tran_flow_num,chr(13),''),chr(10),'') as core_tran_flow_num
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id

from ${icl_schema}.cmm_abmt_remit_dtl t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_abmt_remit_dtl.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
