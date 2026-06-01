: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_prod_and_subj_map_rela_f
CreateDate: 20221122
FileName:   ${iel_data_path}/cmm_prod_and_subj_map_rela.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.sellbl_prod_id,chr(13),''),chr(10),'') as sellbl_prod_id
,replace(replace(t1.sellbl_prod_name,chr(13),''),chr(10),'') as sellbl_prod_name
,replace(replace(t1.accti_prod_attr_cd1,chr(13),''),chr(10),'') as accti_prod_attr_cd1
,replace(replace(t1.accti_prod_id,chr(13),''),chr(10),'') as accti_prod_id
,replace(replace(t1.accti_prod_name,chr(13),''),chr(10),'') as accti_prod_name
,replace(replace(t1.accti_prod_hibchy,chr(13),''),chr(10),'') as accti_prod_hibchy
,replace(replace(t1.base_prod_flg,chr(13),''),chr(10),'') as base_prod_flg
,replace(replace(t1.bus_type_cd,chr(13),''),chr(10),'') as bus_type_cd
,replace(replace(t1.pric_subj_id,chr(13),''),chr(10),'') as pric_subj_id
,replace(replace(t1.intnal_acct_pric_subj_id,chr(13),''),chr(10),'') as intnal_acct_pric_subj_id
,replace(replace(t1.recvbl_int_paybl_subj_id,chr(13),''),chr(10),'') as recvbl_int_paybl_subj_id
,replace(replace(t1.recvbl_int_paybl_adj_subj_id,chr(13),''),chr(10),'') as recvbl_int_paybl_adj_subj_id
,replace(replace(t1.recvbl_uncol_int_subj_id,chr(13),''),chr(10),'') as recvbl_uncol_int_subj_id
,replace(replace(t1.int_bal_pay_subj_id,chr(13),''),chr(10),'') as int_bal_pay_subj_id
,replace(replace(t1.spd_pl_subj_id,chr(13),''),chr(10),'') as spd_pl_subj_id
,replace(replace(t1.acru_aldy_impam_int_subj_id,chr(13),''),chr(10),'') as acru_aldy_impam_int_subj_id
,replace(replace(t1.non_acru_int_recvbl_subj_id,chr(13),''),chr(10),'') as non_acru_int_recvbl_subj_id
,replace(replace(t1.wrtn_off_pric_subj_id,chr(13),''),chr(10),'') as wrtn_off_pric_subj_id
,replace(replace(t1.wrtn_off_int_subj_id,chr(13),''),chr(10),'') as wrtn_off_int_subj_id
,replace(replace(t1.impam_loss_subj_id,chr(13),''),chr(10),'') as impam_loss_subj_id
,replace(replace(t1.impam_prep_subj_id,chr(13),''),chr(10),'') as impam_prep_subj_id
,replace(replace(t1.other_acct_recvbl_impam_prep_subj_id,chr(13),''),chr(10),'') as other_acct_recvbl_impam_prep_subj_id
,replace(replace(t1.output_tax_lmt_subj_id,chr(13),''),chr(10),'') as output_tax_lmt_subj_id

from ${icl_schema}.cmm_prod_and_subj_map_rela t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_prod_and_subj_map_rela.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
