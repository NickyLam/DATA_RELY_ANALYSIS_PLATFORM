: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_fin_am_prod_intnal_subj_bal_i
CreateDate: 20240118
FileName:   ${iel_data_path}/fin_am_prod_intnal_subj_bal.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.acct_pkg_id,chr(13),''),chr(10),'') as acct_pkg_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,bal_dt
,replace(replace(t1.subj_id,chr(13),''),chr(10),'') as subj_id
,replace(replace(t1.super_subj_id,chr(13),''),chr(10),'') as super_subj_id
,replace(replace(t1.subj_level_cd,chr(13),''),chr(10),'') as subj_level_cd
,replace(replace(t1.bal_dir_cd,chr(13),''),chr(10),'') as bal_dir_cd
,replace(replace(t1.carr_bal_dir_cd,chr(13),''),chr(10),'') as carr_bal_dir_cd
,replace(replace(t1.oc_curr_cd,chr(13),''),chr(10),'') as oc_curr_cd
,oc_bal
,oc_cr_bal
,oc_dr_bal
,oc_carr_bal
,oc_cr_carr_bal
,oc_dr_carr_bal
,replace(replace(t1.dc_curr_cd,chr(13),''),chr(10),'') as dc_curr_cd
,dc_bal
,dc_cr_bal
,dc_dr_bal
,dc_carr_bal
,dc_cr_carr_bal
,dc_dr_carr_bal
,td_oc_amt
,td_oc_cr_amt
,td_oc_dr_amt
,td_oc_carr_amt
,td_oc_cr_carr_amt
,td_oc_dr_carr_amt
,td_dc_amt
,td_dc_cr_amt
,td_dc_dr_amt
,td_dc_carr_amt
,td_dc_cr_carr_amt
,td_dc_dr_carr_amt
,replace(replace(t1.noth_subor_subj_flg,chr(13),''),chr(10),'') as noth_subor_subj_flg
,lot
,replace(replace(t1.td_amt_dir_cd,chr(13),''),chr(10),'') as td_amt_dir_cd
,replace(replace(t1.td_carr_amt_dir_cd,chr(13),''),chr(10),'') as td_carr_amt_dir_cd
,oc_dr_purch_unrliz_gain
,oc_dr_redem_unrliz_gain
,oc_cr_purch_unrliz_gain
,oc_cr_redem_unrliz_gain
,dc_dr_purch_unrliz_gain
,dc_dr_redem_unrliz_gain
,dc_cr_purch_unrliz_gain
,dc_cr_redem_unrliz_gain
,replace(replace(t1.ear_d_oc_bal_dir_cd,chr(13),''),chr(10),'') as ear_d_oc_bal_dir_cd
,ear_d_oc_bal
,replace(replace(t1.end_d_oc_bal_dir_cd,chr(13),''),chr(10),'') as end_d_oc_bal_dir_cd
,end_d_oc_bal
,replace(replace(t1.ear_d_dc_bal_dir_cd,chr(13),''),chr(10),'') as ear_d_dc_bal_dir_cd
,ear_d_dc_bal
,replace(replace(t1.end_d_dc_bal_dir_cd,chr(13),''),chr(10),'') as end_d_dc_bal_dir_cd
,end_d_dc_bal
,replace(replace(t1.sob_name,chr(13),''),chr(10),'') as sob_name
,replace(replace(t1.subj_name,chr(13),''),chr(10),'') as subj_name

from ${iml_schema}.fin_am_prod_intnal_subj_bal t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fin_am_prod_intnal_subj_bal.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
