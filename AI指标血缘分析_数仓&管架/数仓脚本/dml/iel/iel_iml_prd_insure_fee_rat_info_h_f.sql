: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_prd_insure_fee_rat_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/prd_insure_fee_rat_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.corp_cd,chr(13),''),chr(10),'') as corp_cd
,replace(replace(t.tran_type_cd,chr(13),''),chr(10),'') as tran_type_cd
,replace(replace(t.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t.insure_mode_pay_cd,chr(13),''),chr(10),'') as insure_mode_pay_cd
,replace(replace(t.pay_year_term,chr(13),''),chr(10),'') as pay_year_term
,replace(replace(t.fee_mode_cd,chr(13),''),chr(10),'') as fee_mode_cd
,t.calc_para as calc_para
,replace(replace(t.up_lolmi_ctrl_flg,chr(13),''),chr(10),'') as up_lolmi_ctrl_flg
,t.sig_max_amt as sig_max_amt
,t.sig_min_amt as sig_min_amt
,t.iss_fee as iss_fee
,replace(replace(t.tran_chn_cd,chr(13),''),chr(10),'') as tran_chn_cd
,replace(replace(t.guar_term_type_cd,chr(13),''),chr(10),'') as guar_term_type_cd
,replace(replace(t.guar_year_term,chr(13),''),chr(10),'') as guar_year_term
,t.sig_lowt_permium as sig_lowt_permium
,t.sig_higt_permium as sig_higt_permium
,t.insure_year as insure_year
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.prd_insure_fee_rat_info_h t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/prd_insure_fee_rat_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes