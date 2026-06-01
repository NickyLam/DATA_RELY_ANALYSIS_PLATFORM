: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_bill_info_f
CreateDate: 20221021
FileName:   ${iel_data_path}/agt_bill_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
     to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.vouch_id,chr(13),''),chr(10),'') as vouch_id
    ,replace(replace(t.bill_id,chr(13),''),chr(10),'') as bill_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.bill_num,chr(13),''),chr(10),'') as bill_num
    ,replace(replace(t.role_src_cd,chr(13),''),chr(10),'') as role_src_cd
    ,replace(replace(t.discnt_batch_id,chr(13),''),chr(10),'') as discnt_batch_id
    ,replace(replace(t.pbc_tranbl_flg,chr(13),''),chr(10),'') as pbc_tranbl_flg
    ,replace(replace(t.hxb_acpt_flg,chr(13),''),chr(10),'') as hxb_acpt_flg
    ,replace(replace(t.bill_med_cd,chr(13),''),chr(10),'') as bill_med_cd
    ,replace(replace(t.bill_type_cd,chr(13),''),chr(10),'') as bill_type_cd
    ,t.draw_dt as draw_dt
    ,t.fac_val_exp_dt as fac_val_exp_dt
    ,replace(replace(t.drawer_cate_cd,chr(13),''),chr(10),'') as drawer_cate_cd
    ,replace(replace(t.drawer_orgnz_cd,chr(13),''),chr(10),'') as drawer_orgnz_cd
    ,replace(replace(t.drawer_name,chr(13),''),chr(10),'') as drawer_name
    ,replace(replace(t.drawer_acct_num,chr(13),''),chr(10),'') as drawer_acct_num
    ,replace(replace(t.drawer_open_bank_num,chr(13),''),chr(10),'') as drawer_open_bank_num
    ,replace(replace(t.accptor_open_bank_name,chr(13),''),chr(10),'') as accptor_open_bank_name
    ,replace(replace(t.drawer_open_bank_name,chr(13),''),chr(10),'') as drawer_open_bank_name
    ,replace(replace(t.accptor_cate_cd,chr(13),''),chr(10),'') as accptor_cate_cd
    ,replace(replace(t.accptor_name,chr(13),''),chr(10),'') as accptor_name
    ,replace(replace(t.accptor_open_bank_num,chr(13),''),chr(10),'') as accptor_open_bank_num
    ,replace(replace(t.accptor_acct_num,chr(13),''),chr(10),'') as accptor_acct_num
    ,replace(replace(t.recver_name,chr(13),''),chr(10),'') as recver_name
    ,replace(replace(t.recver_acct_num,chr(13),''),chr(10),'') as recver_acct_num
    ,replace(replace(t.recver_open_bank_num,chr(13),''),chr(10),'') as recver_open_bank_num
    ,replace(replace(t.recver_open_bank_name,chr(13),''),chr(10),'') as recver_open_bank_name
    ,t.bill_amt as bill_amt
    ,replace(replace(t.bill_belong_org_id,chr(13),''),chr(10),'') as bill_belong_org_id
    ,replace(replace(t.bill_status_cd,chr(13),''),chr(10),'') as bill_status_cd
    ,replace(replace(t.loss_flg,chr(13),''),chr(10),'') as loss_flg
    ,replace(replace(t.final_modif_operr_id,chr(13),''),chr(10),'') as final_modif_operr_id
    ,t.final_modif_tm as final_modif_tm
    ,replace(replace(t.receipt_flg,chr(13),''),chr(10),'') as receipt_flg
    ,replace(replace(t.redcst_flg,chr(13),''),chr(10),'') as redcst_flg
    ,replace(replace(t.h_data_flg,chr(13),''),chr(10),'') as h_data_flg
    ,t.create_dt as create_dt
    ,t.update_dt as update_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
    ,replace(replace(t.src_table_name,chr(13),''),chr(10),'') as src_table_name
    ,replace(replace(t.job_cd,chr(13),''),chr(10),'') as job_cd
from ${iml_schema}.agt_bill_info t
where etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_bill_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
