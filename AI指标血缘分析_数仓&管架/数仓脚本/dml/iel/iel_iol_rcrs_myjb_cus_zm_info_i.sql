: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcrs_myjb_cus_zm_info_i
CreateDate: 20180529
FileName:   ${iel_data_path}/rcrs_myjb_cus_zm_info.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.serno,chr(13),''),chr(10),'') as serno
,replace(replace(t.company_name,chr(13),''),chr(10),'') as company_name
,replace(replace(t.occupation,chr(13),''),chr(10),'') as occupation
,replace(replace(t.have_car_flag,chr(13),''),chr(10),'') as have_car_flag
,replace(replace(t.have_fang_flag,chr(13),''),chr(10),'') as have_fang_flag
,replace(replace(t.auth_fin_last_1m_cnt,chr(13),''),chr(10),'') as auth_fin_last_1m_cnt
,replace(replace(t.auth_fin_last_3m_cnt,chr(13),''),chr(10),'') as auth_fin_last_3m_cnt
,replace(replace(t.auth_fin_last_6m_cnt,chr(13),''),chr(10),'') as auth_fin_last_6m_cnt
,replace(replace(t.ovd_order_cnt_6m,chr(13),''),chr(10),'') as ovd_order_cnt_6m
,replace(replace(t.ovd_order_amt_6m,chr(13),''),chr(10),'') as ovd_order_amt_6m
,replace(replace(t.mobile_fixed_days,chr(13),''),chr(10),'') as mobile_fixed_days
,replace(replace(t.adr_stability_days,chr(13),''),chr(10),'') as adr_stability_days
,replace(replace(t.last_6m_avg_asset_total,chr(13),''),chr(10),'') as last_6m_avg_asset_total
,replace(replace(t.tot_pay_amt_6m,chr(13),''),chr(10),'') as tot_pay_amt_6m
,replace(replace(t.xfdc_index,chr(13),''),chr(10),'') as xfdc_index
,replace(replace(t.positive_biz_cnt_1y,chr(13),''),chr(10),'') as positive_biz_cnt_1y
,replace(replace(t.address,chr(13),''),chr(10),'') as address
,replace(replace(t.area,chr(13),''),chr(10),'') as area
,replace(replace(t.city,chr(13),''),chr(10),'') as city
,replace(replace(t.prov,chr(13),''),chr(10),'') as prov
,t.zm_score as zm_score
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.RCRS_MYJB_CUS_ZM_INFO t 
where to_char(to_date(substr(serno,5,8),'yyyy-MM-dd'),'yyyymmdd')='${batch_date}' and substr(serno,0,4)='MYJB'
and start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcrs_myjb_cus_zm_info.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes