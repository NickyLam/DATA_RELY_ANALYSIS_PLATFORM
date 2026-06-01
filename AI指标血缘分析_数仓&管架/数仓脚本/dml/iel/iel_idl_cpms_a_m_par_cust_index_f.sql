: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_cpms_a_m_par_cust_index_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cpms_a_m_par_cust_index_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select create_date
,data_date
,custno
,dpsa_bal
,dptd_bal
,dplc_bal
,dpbz_bal
,gold
,marketvaule
,tbond
,secu_asset
,dep_tot_bal
,fan_loan_bal
,che_loan_bal
,other_loan_bal
,ln_bal from idl.cpms_a_m_par_cust_index where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/cpms_a_m_par_cust_index_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes