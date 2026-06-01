: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_cpms_a_d_dp_card_ft_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cpms_a_d_dp_card_ft_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select date_id
,data_date
,data_time
,cust_no
,cardno
,subs_ac
,debt_tp
,term_code
,dp_mon_cml
,dp_mon_avl
,curr_code
,acc_code
,opendt
,closdt
,acctst
,lsacdt
,lstsdt
,asse_tell_er
,dp_bal
,dp_inst_amt
,dp_quar_cml
,dp_year_cml
,dp_quar_avl
,dp_year_avl
,last_dp_bal
,last_mon_dp_bal
,last_dp_mon_cml
,dplc_mon_cml
,dplc_mon_avl from idl.cpms_a_d_dp_card_ft where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/cpms_a_d_dp_card_ft_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes