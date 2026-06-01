: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_amls_t1b_dci_i_trans_f
CreateDate: 20251111
FileName:   ${iel_data_path}/amls_t1b_dci_i_trans.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,trans_count
,trans_sum_amt
,count_c
,sum_c_amt
,count_d
,sum_d_amt
,replace(replace(t1.c_opp_name_1,chr(13),''),chr(10),'') as c_opp_name_1
,c_opp_name_amt_1
,replace(replace(t1.c_opp_name_2,chr(13),''),chr(10),'') as c_opp_name_2
,c_opp_name_amt_2
,replace(replace(t1.c_opp_name_3,chr(13),''),chr(10),'') as c_opp_name_3
,c_opp_name_amt_3
,replace(replace(t1.c_opp_name_4,chr(13),''),chr(10),'') as c_opp_name_4
,c_opp_name_amt_4
,replace(replace(t1.c_opp_name_5,chr(13),''),chr(10),'') as c_opp_name_5
,c_opp_name_amt_5
,replace(replace(t1.d_opp_name_1,chr(13),''),chr(10),'') as d_opp_name_1
,d_opp_name_amt_1
,replace(replace(t1.d_opp_name_2,chr(13),''),chr(10),'') as d_opp_name_2
,d_opp_name_amt_2
,replace(replace(t1.d_opp_name_3,chr(13),''),chr(10),'') as d_opp_name_3
,d_opp_name_amt_3
,replace(replace(t1.d_opp_name_4,chr(13),''),chr(10),'') as d_opp_name_4
,d_opp_name_amt_4
,replace(replace(t1.d_opp_name_5,chr(13),''),chr(10),'') as d_opp_name_5
,d_opp_name_amt_5
,begin_dt
,end_dt

from ${iol_schema}.amls_t1b_dci_i_trans t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/amls_t1b_dci_i_trans.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
