: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_ccrm_corp_pty_iden_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_ccrm_corp_pty_iden_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t1.etl_dt as etl_dt
,replace(replace(t1.pty_id,chr(13),''),chr(10),'') as pty_id
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.org_org_cd,chr(13),''),chr(10),'') as org_org_cd
,replace(replace(t1.oper_licence_num,chr(13),''),chr(10),'') as oper_licence_num
,t1.oper_licence_reg_dt as oper_licence_reg_dt
,t1.oper_licence_due_dt as oper_licence_due_dt
,replace(replace(t1.nation_tax_reg_cert_num,chr(13),''),chr(10),'') as nation_tax_reg_cert_num
,replace(replace(t1.local_tax_reg_cert_num,chr(13),''),chr(10),'') as local_tax_reg_cert_num
,replace(replace(t1.open_lice_num,chr(13),''),chr(10),'') as open_lice_num
,replace(replace(t1.org_crdt_cd,chr(13),''),chr(10),'') as org_crdt_cd
,replace(replace(t1.loan_card_num,chr(13),''),chr(10),'') as loan_card_num
,replace(replace(t1.pay_biz_lice_num,chr(13),''),chr(10),'') as pay_biz_lice_num
,replace(replace(t1.forgn_invt_reg_cert_num,chr(13),''),chr(10),'') as forgn_invt_reg_cert_num
,replace(replace(t1.im_ex_opr_rit_lice_num,chr(13),''),chr(10),'') as im_ex_opr_rit_lice_num
,replace(replace(t1.chrg_lice_num,chr(13),''),chr(10),'') as chrg_lice_num
,replace(replace(t1.fin_org_ind_num,chr(13),''),chr(10),'') as fin_org_ind_num
,replace(replace(t1.fin_biz_lice_num,chr(13),''),chr(10),'') as fin_biz_lice_num
,replace(replace(t1.insur_biz_lice_num,chr(13),''),chr(10),'') as insur_biz_lice_num
,replace(replace(t1.secu_biz_lice_num,chr(13),''),chr(10),'') as secu_biz_lice_num
,replace(replace(t1.peop_bank_fin_org_encd,chr(13),''),chr(10),'') as peop_bank_fin_org_encd
from ${idl_schema}.hdws_dul_d_ccrm_corp_pty_iden_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_ccrm_corp_pty_iden_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes