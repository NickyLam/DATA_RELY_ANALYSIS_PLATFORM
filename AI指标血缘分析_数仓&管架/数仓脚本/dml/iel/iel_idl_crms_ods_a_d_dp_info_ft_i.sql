: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_ods_a_d_dp_info_ft_i
CreateDate: 20180529
FileName:   ${iel_data_path}/crms_ods_a_d_dp_info_ft_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
date_id
,acct_no
,subs_ac
,acct_id
,acct_na
,branch_code
,curr_code
,acc_code
,csex_tg
,cust_no
,cust_na
,cust_tp
,debt_tp
,cuin_me
,daab_tg
,bgin_dt
,open_dt
,clos_dt
,matu_dt
,acml_dt
,acml_bal
,acct_st
,zfcs_st
,lwst_bl
,cntr_ir
,inrt_ir
,lsat_dt
,lstr_dt
,lstr_sq
,acct_tp
,slep_tg
,acus_tg
,base_tg
,prod_code
,acpd_code
,draw_md
,drmd_st
,mlbl_tg
,acck_dt
,asse_tell_er
,sutp_mk
,sutd_tp
,autd_tg
,term_code
,note_tp
,serv_tp
,agre_mk
,agre_amt
,agre_bgin_dt
,agre_matu_dt
,agre_crin_ir
,ic_dep_mk
,ic_attr_amt
,ic_save_amt
,ic_draw_amt
,ic_open_br
,ic_acct_st
,dp_lef_tm
,dp_bal
,dp_inst_amt
,dp_mon_cml
,dp_quar_cml
,dp_year_cml
,dp_mon_avl
,dp_quar_avl
,dp_year_avl
,xd_dp_mon_cml
,xd_dp_quar_cml
,xd_dp_year_cml
,xd_dp_mon_avl
,xd_dp_quar_avl
,xd_dp_year_avl
,dp_acct_cnt_sum
,dp_acct_open_cnt_new
,dp_acct_clos_cnt
,dp_acct_clos_ant_new
,dp_acct_slep_ant
,last_dp_bal
,last_mon_dp_bal
,last_dp_mon_cml
from ${idl_schema}.crms_ods_a_d_dp_info_ft
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/crms_ods_a_d_dp_info_ft_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes