: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_ccrm_fin_gl_info_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_ccrm_fin_gl_info.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       replace(replace(org_id,chr(10),''),chr(13),'') as org_id
      ,replace(replace(accting_coa_id,chr(10),''),chr(13),'') as accting_coa_id
      ,replace(replace(ccy_cd,chr(10),''),chr(13),'') as ccy_cd
      ,etl_dt
      ,acct_dt
      ,replace(replace(stl_cali_cd,chr(10),''),chr(13),'') as stl_cali_cd
      ,replace(replace(carr_ind_cd,chr(10),''),chr(13),'') as carr_ind_cd
      ,debit_bal
      ,cr_bal
      ,daily_debit_mavg
      ,daily_debit_qavg
      ,daily_debit_yavg
      ,daily_cr_mavg
      ,daily_cr_qavg
      ,daily_cr_yavg
      ,daily_debit_mon_accum
      ,daily_debit_qtr_accum
      ,daily_debit_annl_accum
      ,daily_cr_mon_accum
      ,daily_cr_qtr_accum
      ,daily_cr_annl_accum
      ,debit_bal_ratio_last
      ,debit_bal_ratio_last_mon
      ,debit_bal_ratio_last_qtr
      ,debit_bal_ratio_ly
      ,debit_mavg_ratio_last_day
      ,debit_mavg_ratio_last_mon
      ,debit_mavg_ratio_last_qtr
      ,debit_mavg_ratio_ly
      ,debit_qavg_ratio_last_day
      ,debit_qavg_ratio_last_mon
      ,debit_qavg_ratio_last_qtr
      ,debit_qavg_ratio_ly
      ,debit_yavg_ratio_last_day
      ,debit_yavg_ratio_last_mon
      ,debit_yavg_ratio_last_qtr
      ,debit_yavg_ratio_ly
      ,cr_bal_ratio_last_day
      ,cr_bal_ratio_last_mon
      ,cr_bal_ratio_last_qtr
      ,cr_bal_ratio_ly
      ,cr_mavg_ratio_last_day
      ,cr_mavg_ratio_last_mon
      ,cr_mavg_ratio_last_qtr
      ,cr_mavg_ratio_ly
      ,cr_qavg_ratio_last_day
      ,cr_qavg_ratio_last_mon
      ,cr_qavg_ratio_last_qtr
      ,cr_qavg_ratio_ly
      ,cr_yavg_ratio_last_day
      ,cr_yavg_ratio_last_mon
      ,cr_yavg_ratio_last_qtr
      ,cr_yavg_ratio_ly
      ,debit_amt
      ,cr_amt
      ,d_rpt_d_bal
      ,d_rpt_c_bal
      ,yestd_d_bal
      ,yestd_c_bal
      ,yestd_rpt_d_bal
      ,yestd_rpt_c_bal
      ,ten_days_begin_d_bal
      ,ten_days_begin_c_bal
      ,m_begin_d_bal
      ,m_begin_c_bal
      ,m_begin_d_rpt_bal
      ,m_begin_c_rpt_bal
      ,m_amt_debit
      ,m_amt_cr
      ,q_begin_d_bal
      ,q_begin_c_bal
      ,q_begin_d_rpt_bal
      ,q_begin_c_rpt_bal
      ,q_amt_debit
      ,q_amt_cr
      ,hy_begin_d_bal
      ,hy_begin_c_bal
      ,hy_begin_d_rpt_bal
      ,hy_begin_c_rpt_bal
      ,hy_amt_d
      ,hy_amt_c
      ,y_begin_d_bal
      ,y_begin_c_bal
      ,y_begin_d_rpt_bal
      ,y_begin_c_rpt_bal
      ,y_amt_d
      ,y_amt_c
      ,replace(replace(src_sys_name,chr(10),''),chr(13),'') as src_sys_name
      ,replace(replace(data_src_cd,chr(10),''),chr(13),'') as data_src_cd
      ,replace(replace(del_flg,chr(10),''),chr(13),'') as del_flg 
from idl.hdws_dul_d_ccrm_fin_gl_info 
where to_char(etl_dt,'yyyymmdd') = '${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_ccrm_fin_gl_info.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes