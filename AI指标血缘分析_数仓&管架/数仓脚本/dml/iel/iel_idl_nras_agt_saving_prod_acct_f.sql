: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_nras_agt_saving_prod_acct_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_saving_prod_acct.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,agt_id
,lp_id
,fin_acct_id
,sign_acct_num
,prod_acct_id
,org_id
,cust_id
,acct_sign_id
,acct_name
,curr_cd
,actl_bal
,aval_bal
,fin_acct_type_cd
,acct_status_cd
,acct_type_cd
,acct_dt
,open_acct_dt
,clos_acct_dt
,open_acct_tm from idl.nras_agt_saving_prod_acct where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_saving_prod_acct.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes