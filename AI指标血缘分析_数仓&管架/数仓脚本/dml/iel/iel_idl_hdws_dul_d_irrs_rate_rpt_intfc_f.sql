: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_irrs_rate_rpt_intfc_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_irrs_rate_rpt_intfc.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_char(etl_dt,'YYYY-MM-DD') as etl_dt
,replace(replace(t1.org_num,chr(13),''),chr(10),'') as org_num
,replace(replace(t1.biz_major,chr(13),''),chr(10),'') as biz_major
,replace(replace(t1.biz_detial,chr(13),''),chr(10),'') as biz_detial
,replace(replace(t1.corp_size,chr(13),''),chr(10),'') as corp_size
,replace(replace(t1.rate_float_regn,chr(13),''),chr(10),'') as rate_float_regn
,t1.amt as amt
,t1.balance as balance
,replace(replace(t1.orgi_term_cd,chr(13),''),chr(10),'') as orgi_term_cd
,replace(replace(t1.rate_typ,chr(13),''),chr(10),'') as rate_typ
,replace(replace(t1.fin_instt_typ_cd,chr(13),''),chr(10),'') as fin_instt_typ_cd
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
,replace(replace(t1.major_beps_dpst_ind,chr(13),''),chr(10),'') as major_beps_dpst_ind
,t1.highest_rate as highest_rate
,t1.lowt_rate as lowt_rate
,t1.weht_rate as weht_rate
,t1.highest_rate_amt_bal as highest_rate_amt_bal
,t1.lowt_rate_amt_bal as lowt_rate_amt_bal
,replace(replace(t1.net_dn_trans_flg,chr(13),''),chr(10),'') as net_dn_trans_flg
,replace(replace(t1.pty_typ_cd,chr(13),''),chr(10),'') as pty_typ_cd
,replace(replace(t1.agt_dpstr_categ,chr(13),''),chr(10),'') as agt_dpstr_categ
,replace(replace(t1.src_sys_cd,chr(13),''),chr(10),'') as src_sys_cd
,replace(replace(t1.fac_typ,chr(13),''),chr(10),'') as fac_typ
,replace(replace(t1.operate_cust_type,chr(13),''),chr(10),'') as operate_cust_type
,replace(replace(t1.rate_base_typ_cd,chr(13),''),chr(10),'') as rate_base_typ_cd
from ${idl_schema}.hdws_dul_d_irrs_rate_rpt_intfc t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_irrs_rate_rpt_intfc.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes