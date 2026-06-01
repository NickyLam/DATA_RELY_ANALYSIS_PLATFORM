: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rsts_rcd_ir_action_bc_month_i
CreateDate: 20241012
FileName:   ${iel_data_path}/rsts_rcd_ir_action_bc_month.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.loan_no,chr(13),''),chr(10),'') as loan_no
,replace(replace(t1.data_dt,chr(13),''),chr(10),'') as data_dt
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.cont_no,chr(13),''),chr(10),'') as cont_no
,replace(replace(t1.loan_biz_type_cd,chr(13),''),chr(10),'') as loan_biz_type_cd
,overduedays_month
,ovdue_princp_amt
,rcva_owe_int
,dun_owe_int
,rcva_acr_intr
,dun_acr_intr
,rcva_pnlt
,dun_pnlt
,rcva_accr_pnlt
,dun_accr_pnlt
,rcva_cmpd_intr
,accr_cmpd_intr
,loan_total_bal
,repayment
,replace(replace(t1.adv_repay_flg,chr(13),''),chr(10),'') as adv_repay_flg
,adv_repay_amt
,replace(replace(t1.agt_status_cd,chr(13),''),chr(10),'') as agt_status_cd
,replace(replace(t1.risk_rat_categ_cd,chr(13),''),chr(10),'') as risk_rat_categ_cd
,replace(replace(t1.risk_rat_resu_cd,chr(13),''),chr(10),'') as risk_rat_resu_cd
,v_dyyhje
,v_dysjhkl
,v_dyyqje
,v_dyyqqs
,v_ye
,v_yelxzjys
,v_hkllxzjys
,v_hkllxjsys
,v_lxwyqys
,v_lxqyys
,v_yqbyqqslxzjys
,v_yqjelxzjys
,v_lxyqys
,replace(replace(t1.write_off_flg,chr(13),''),chr(10),'') as write_off_flg
,replace(replace(t1.bout_liqdt_flg,chr(13),''),chr(10),'') as bout_liqdt_flg
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.serno,chr(13),''),chr(10),'') as serno
,replace(replace(t1.blng_org_id,chr(13),''),chr(10),'') as blng_org_id
,replace(replace(t1.iden_num,chr(13),''),chr(10),'') as iden_num
,replace(replace(t1.grade_key_id,chr(13),''),chr(10),'') as grade_key_id

from ${iol_schema}.rsts_rcd_ir_action_bc_month t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rsts_rcd_ir_action_bc_month.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
