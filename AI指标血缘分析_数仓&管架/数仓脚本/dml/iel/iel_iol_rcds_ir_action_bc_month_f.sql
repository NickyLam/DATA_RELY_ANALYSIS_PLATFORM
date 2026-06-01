: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcds_ir_action_bc_month_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcds_ir_action_bc_month.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.loan_no,chr(13),''),chr(10),'') as loan_no
    ,replace(replace(t.data_dt,chr(13),''),chr(10),'') as data_dt
    ,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
    ,replace(replace(t.cust_name,chr(13),''),chr(10),'') as cust_name
    ,replace(replace(t.cont_no,chr(13),''),chr(10),'') as cont_no
    ,replace(replace(t.loan_biz_type_cd,chr(13),''),chr(10),'') as loan_biz_type_cd
    ,t.overduedays_month as overduedays_month
    ,t.ovdue_princp_amt as ovdue_princp_amt
    ,t.rcva_owe_int as rcva_owe_int
    ,t.dun_owe_int as dun_owe_int
    ,t.rcva_acr_intr as rcva_acr_intr
    ,t.dun_acr_intr as dun_acr_intr
    ,t.rcva_pnlt as rcva_pnlt
    ,t.dun_pnlt as dun_pnlt
    ,t.rcva_accr_pnlt as rcva_accr_pnlt
    ,t.dun_accr_pnlt as dun_accr_pnlt
    ,t.rcva_cmpd_intr as rcva_cmpd_intr
    ,t.accr_cmpd_intr as accr_cmpd_intr
    ,t.loan_total_bal as loan_total_bal
    ,t.repayment as repayment
    ,replace(replace(t.adv_repay_flg,chr(13),''),chr(10),'') as adv_repay_flg
    ,t.adv_repay_amt as adv_repay_amt
    ,replace(replace(t.agt_status_cd,chr(13),''),chr(10),'') as agt_status_cd
    ,replace(replace(t.risk_rat_categ_cd,chr(13),''),chr(10),'') as risk_rat_categ_cd
    ,replace(replace(t.risk_rat_resu_cd,chr(13),''),chr(10),'') as risk_rat_resu_cd
    ,t.v_dyyhje as v_dyyhje
    ,t.v_dysjhkl as v_dysjhkl
    ,t.v_dyyqje as v_dyyqje
    ,t.v_dyyqqs as v_dyyqqs
    ,t.v_ye as v_ye
    ,t.v_yelxzjys as v_yelxzjys
    ,t.v_hkllxzjys as v_hkllxzjys
    ,t.v_hkllxjsys as v_hkllxjsys
    ,t.v_lxwyqys as v_lxwyqys
    ,t.v_lxqyys as v_lxqyys
    ,t.v_yqbyqqslxzjys as v_yqbyqqslxzjys
    ,t.v_yqjelxzjys as v_yqjelxzjys
    ,t.v_lxyqys as v_lxyqys
    ,replace(replace(t.write_off_flg,chr(13),''),chr(10),'') as write_off_flg
    ,replace(replace(t.bout_liqdt_flg,chr(13),''),chr(10),'') as bout_liqdt_flg
    ,replace(replace(t.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
    ,replace(replace(t.serno,chr(13),''),chr(10),'') as serno
    ,replace(replace(t.blng_org_id,chr(13),''),chr(10),'') as blng_org_id
    ,replace(replace(t.iden_num,chr(13),''),chr(10),'') as iden_num
    ,replace(replace(t.grade_key_id,chr(13),''),chr(10),'') as grade_key_id
from iol.rcds_ir_action_bc_month t    
  where t.etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcds_ir_action_bc_month.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes