: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_rcrs_myjb_cus_zm_info_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_rcrs_myjb_cus_zm_info.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.serno
,t1.company_name
,t1.occupation
,t1.have_car_flag
,t1.have_fang_flag
,t1.auth_fin_last_1m_cnt
,t1.auth_fin_last_3m_cnt
,t1.auth_fin_last_6m_cnt
,t1.ovd_order_cnt_6m
,t1.ovd_order_amt_6m
,t1.mobile_fixed_days
,t1.adr_stability_days
,t1.last_6m_avg_asset_total
,t1.tot_pay_amt_6m
,t1.xfdc_index
,t1.positive_biz_cnt_1y
,t1.address
,t1.area
,t1.city
,t1.prov
,t1.zm_score
,t1.start_dt
,t1.end_dt
,t1.id_mark
from ${idl_schema}.hdws_rcrs_myjb_cus_zm_info t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_rcrs_myjb_cus_zm_info.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes