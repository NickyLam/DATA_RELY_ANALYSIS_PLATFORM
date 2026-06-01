: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_rcrs_myjb_cus_zm_info_i
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_rcrs_myjb_cus_zm_info.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.serno,chr(13),''),chr(10),'') as serno
,replace(replace(t1.company_name,chr(13),''),chr(10),'') as company_name
,replace(replace(t1.occupation,chr(13),''),chr(10),'') as occupation
,replace(replace(t1.have_car_flag,chr(13),''),chr(10),'') as have_car_flag
,replace(replace(t1.have_fang_flag,chr(13),''),chr(10),'') as have_fang_flag
,replace(replace(t1.auth_fin_last_1m_cnt,chr(13),''),chr(10),'') as auth_fin_last_1m_cnt
,replace(replace(t1.auth_fin_last_3m_cnt,chr(13),''),chr(10),'') as auth_fin_last_3m_cnt
,replace(replace(t1.auth_fin_last_6m_cnt,chr(13),''),chr(10),'') as auth_fin_last_6m_cnt
,replace(replace(t1.ovd_order_cnt_6m,chr(13),''),chr(10),'') as ovd_order_cnt_6m
,replace(replace(t1.ovd_order_amt_6m,chr(13),''),chr(10),'') as ovd_order_amt_6m
,replace(replace(t1.mobile_fixed_days,chr(13),''),chr(10),'') as mobile_fixed_days
,replace(replace(t1.adr_stability_days,chr(13),''),chr(10),'') as adr_stability_days
,replace(replace(t1.last_6m_avg_asset_total,chr(13),''),chr(10),'') as last_6m_avg_asset_total
,replace(replace(t1.tot_pay_amt_6m,chr(13),''),chr(10),'') as tot_pay_amt_6m
,replace(replace(t1.xfdc_index,chr(13),''),chr(10),'') as xfdc_index
,replace(replace(t1.positive_biz_cnt_1y,chr(13),''),chr(10),'') as positive_biz_cnt_1y
,replace(replace(t1.address,chr(13),''),chr(10),'') as address
,replace(replace(t1.area,chr(13),''),chr(10),'') as area
,replace(replace(t1.city,chr(13),''),chr(10),'') as city
,replace(replace(t1.prov,chr(13),''),chr(10),'') as prov
,t1.zm_score as zm_score
 from iol.rcrs_myjb_cus_zm_info T1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd') and to_char(to_date(substr(serno,5,8),'yyyy-mm-dd'),'yyyymmdd')='${batch_date}' and substr(serno, 0,4)='MYJB';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_rcrs_myjb_cus_zm_info.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes