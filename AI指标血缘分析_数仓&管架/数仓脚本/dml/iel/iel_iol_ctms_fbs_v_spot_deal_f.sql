: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ctms_fbs_v_spot_deal_f
CreateDate: 20240802
FileName:   ${iel_data_path}/ctms_fbs_v_spot_deal.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,cus_number
,branch_number
,deal_sqno
,deal_date
,value_date
,crncy_pair_id
,spot_rate
,child_rate
,cost_rate
,first_amnt
,second_amnt
,trade_purpose
,business_date
,counter_party_id
,replace(replace(t1.counter_party_scname,chr(13),''),chr(10),'') as counter_party_scname
,split_type
,update_time
,deal_dir
,pdd_deal_sqno
,replace(replace(t1.deal_status,chr(13),''),chr(10),'') as deal_status
,replace(replace(t1.first_crncy,chr(13),''),chr(10),'') as first_crncy
,replace(replace(t1.second_crncy,chr(13),''),chr(10),'') as second_crncy
,replace(replace(t1.client_deal_sqno,chr(13),''),chr(10),'') as client_deal_sqno
,replace(replace(t1.trade_type,chr(13),''),chr(10),'') as trade_type
,replace(replace(t1.deal_source,chr(13),''),chr(10),'') as deal_source
,replace(replace(t1.deal_market,chr(13),''),chr(10),'') as deal_market
,settle_type
,deal_link_sqno
,modify_date
,portfolio_sqno
,portfolio_id
,replace(replace(t1.portfolio_name,chr(13),''),chr(10),'') as portfolio_name
,replace(replace(t1.portfolio_type,chr(13),''),chr(10),'') as portfolio_type
,replace(replace(t1.portfolio_status,chr(13),''),chr(10),'') as portfolio_status
,portfolio_link_sqno
,replace(replace(t1.clear_dep,chr(13),''),chr(10),'') as clear_dep
,replace(replace(t1.event_type,chr(13),''),chr(10),'') as event_type
,event_date
,event_link_sqno
,replace(replace(t1.event_mask,chr(13),''),chr(10),'') as event_mask
,link_deal_sqno
,replace(replace(t1.confirm_indc,chr(13),''),chr(10),'') as confirm_indc
,replace(replace(t1.dealer,chr(13),''),chr(10),'') as dealer

from ${iol_schema}.ctms_fbs_v_spot_deal t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ctms_fbs_v_spot_deal.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
