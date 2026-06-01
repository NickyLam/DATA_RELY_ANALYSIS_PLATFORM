: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_fin_gl_bal_h_i
CreateDate: 20221122
FileName:   ${iel_data_path}/fin_gl_bal_h.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.sob_id,chr(13),''),chr(10),'') as sob_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.sys_cd,chr(13),''),chr(10),'') as sys_cd
,acct_dt
,replace(replace(t1.gl_org_id,chr(13),''),chr(10),'') as gl_org_id
,replace(replace(t1.subj_id,chr(13),''),chr(10),'') as subj_id
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.gl_type_cd,chr(13),''),chr(10),'') as gl_type_cd
,replace(replace(t1.chn_id,chr(13),''),chr(10),'') as chn_id
,replace(replace(t1.sellbl_prod_id,chr(13),''),chr(10),'') as sellbl_prod_id
,dr_ld_bal
,cr_ld_bal
,dr_td_amt
,dr_td_happ_cnt
,cr_td_amt
,cr_td_happ_cnt
,dr_bal
,cr_bal
,replace(replace(t1.curr_bal_dir_cd,chr(13),''),chr(10),'') as curr_bal_dir_cd
,curr_bal
,replace(replace(t1.l_ped_bal_dir_cd,chr(13),''),chr(10),'') as l_ped_bal_dir_cd
,l_ped_bal
,replace(replace(t1.end_level_subj_flg,chr(13),''),chr(10),'') as end_level_subj_flg
,dr_fcurr_convt_adj_val
,cr_fcurr_convt_adj_val
,stand_mony_tm_bg_dr_bal
,stand_mony_tm_bg_cr_bal
,dc_dr_amt
,dc_cr_amt
,stand_mony_term_end_dr_bal
,stand_mony_term_end_cr_bal
,replace(replace(t1.src_table_name,chr(13),''),chr(10),'') as src_table_name

from ${iml_schema}.fin_gl_bal_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fin_gl_bal_h.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
