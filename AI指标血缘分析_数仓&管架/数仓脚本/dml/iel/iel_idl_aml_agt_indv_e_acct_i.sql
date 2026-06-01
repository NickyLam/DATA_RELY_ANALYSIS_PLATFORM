: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_agt_indv_e_acct_i
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_agt_indv_e_acct.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select agt_id
,lp_id
,prod_acct_id
,fund_cust_id
,fund_acct_id
,open_acct_org_id
,acct_id
,cust_id
,acct_name
,agt_effect_tm
,agt_invalid_tm
,last_activ_acct_tm
,acct_tm
,fin_acct_type_cd
,acct_status_cd
,curr_cd
,post_to_gl_flg
,attach_pay_cd
,actl_bal
,acct_level_cls_cd
,acct_type_cd
,vrif_status_cd
,froz_status_cd
,netw_vrfction_flg
,create_dt
,update_dt
,etl_dt
,id_mark
,src_table_name
,job_cd
,etl_timestamp from idl.aml_agt_indv_e_acct where create_dt<=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_agt_indv_e_acct.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes