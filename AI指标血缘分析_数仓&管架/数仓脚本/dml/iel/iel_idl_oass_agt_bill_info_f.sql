: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_bill_info_f
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_agt_bill_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.lp_id as lp_id
,t1.bill_num as bill_num
,t1.role_src_cd as role_src_cd
,t1.discnt_batch_id as discnt_batch_id
,t1.pbc_tranbl_flg as pbc_tranbl_flg
,t1.hxb_acpt_flg as hxb_acpt_flg
,t1.bill_med_cd as bill_med_cd
,t1.bill_type_cd as bill_type_cd
,t1.draw_dt as draw_dt
,t1.fac_val_exp_dt as fac_val_exp_dt
,t1.drawer_cate_cd as drawer_cate_cd
,t1.drawer_orgnz_cd as drawer_orgnz_cd
,t1.drawer_name as drawer_name
,t1.drawer_acct_num as drawer_acct_num
,t1.drawer_open_bank_num as drawer_open_bank_num
,t1.accptor_open_bank_name as accptor_open_bank_name
,t1.drawer_open_bank_name as drawer_open_bank_name
,t1.accptor_cate_cd as accptor_cate_cd
,t1.accptor_name as accptor_name
,t1.accptor_open_bank_num as accptor_open_bank_num
,t1.accptor_acct_num as accptor_acct_num
,t1.recver_name as recver_name
,t1.recver_acct_num as recver_acct_num
,t1.recver_open_bank_num as recver_open_bank_num
,t1.recver_open_bank_name as recver_open_bank_name
,t1.bill_amt as bill_amt
,t1.bill_belong_org_id as bill_belong_org_id
,t1.bill_status_cd as bill_status_cd
,t1.loss_flg as loss_flg
,t1.final_modif_operr_id as final_modif_operr_id
,t1.final_modif_tm as final_modif_tm
,t1.receipt_flg as receipt_flg
,t1.redcst_flg as redcst_flg
,t1.h_data_flg as h_data_flg
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,t1.id_mark as id_mark
,t1.vouch_id as vouch_id
,t1.bill_id as bill_id

from ${idl_schema}.oass_agt_bill_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_bill_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
