: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_agt_lc_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_agt_lc_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
replace(replace(t1.bill_no,chr(13),''),chr(10),'') as bill_no
,replace(replace(t1.lc_id,chr(13),''),chr(10),'') as lc_id
,t1.etl_dt as etl_dt
,replace(replace(t1.lc_typ,chr(13),''),chr(10),'') as lc_typ
,replace(replace(t1.issue_lett_mode_cd,chr(13),''),chr(10),'') as issue_lett_mode_cd
,replace(replace(t1.fwd_flg,chr(13),''),chr(10),'') as fwd_flg
,replace(replace(t1.lc_status,chr(13),''),chr(10),'') as lc_status
,t1.lc_issue_lett_dt as lc_issue_lett_dt
,t1.lc_eff_dt as lc_eff_dt
,t1.lc_wrt_off_dt as lc_wrt_off_dt
,t1.lc_due_dt as lc_due_dt
,replace(replace(t1.pty_id,chr(13),''),chr(10),'') as pty_id
,replace(replace(t1.prd_id,chr(13),''),chr(10),'') as prd_id
,replace(replace(t1.issue_org_id,chr(13),''),chr(10),'') as issue_org_id
,replace(replace(t1.mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id
,replace(replace(t1.accting_org_id,chr(13),''),chr(10),'') as accting_org_id
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
,t1.issue_lett_amt as issue_lett_amt
,t1.lc_bal as lc_bal
,t1.lc_highest_lmt as lc_highest_lmt
,t1.fee_fee_rate as fee_fee_rate
,t1.fee_amt as fee_amt
,replace(replace(t1.lc_term_typ_cd,chr(13),''),chr(10),'') as lc_term_typ_cd
,t1.lc_valid_dt as lc_valid_dt
,replace(replace(t1.margin_acct_num,chr(13),''),chr(10),'') as margin_acct_num
,replace(replace(t1.marg_ccy,chr(13),''),chr(10),'') as marg_ccy
,t1.margin_amt as margin_amt
,t1.marg_ratio as marg_ratio
,replace(replace(t1.guar_flg,chr(13),''),chr(10),'') as guar_flg
,replace(replace(t1.adv_flg,chr(13),''),chr(10),'') as adv_flg
,replace(replace(t1.benef_name,chr(13),''),chr(10),'') as benef_name
,replace(replace(t1.benef_acct_num,chr(13),''),chr(10),'') as benef_acct_num
,replace(replace(t1.benef_open_bk_num,chr(13),''),chr(10),'') as benef_open_bk_num
,replace(replace(t1.benef_open_bk_name,chr(13),''),chr(10),'') as benef_open_bk_name
,replace(replace(t1.benef_cty,chr(13),''),chr(10),'') as benef_cty
,replace(replace(t1.crdt_contr_id,chr(13),''),chr(10),'') as crdt_contr_id
,replace(replace(t1.adv_biz_num,chr(13),''),chr(10),'') as adv_biz_num
,t1.adv_dt as adv_dt
,t1.adv_amt as adv_amt
,t1.adv_bal as adv_bal
,replace(replace(t1.repay_mode,chr(13),''),chr(10),'') as repay_mode
,replace(replace(t1.categ5,chr(13),''),chr(10),'') as categ5
,replace(replace(t1.noti_row_nm,chr(13),''),chr(10),'') as noti_row_nm
,replace(replace(t1.biz_breed,chr(13),''),chr(10),'') as biz_breed
,replace(replace(t1.issue_chn,chr(13),''),chr(10),'') as issue_chn
,replace(replace(t1.coa_num,chr(13),''),chr(10),'') as coa_num
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
from ${idl_schema}.hdws_dul_d_rpts_agt_lc_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_agt_lc_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes