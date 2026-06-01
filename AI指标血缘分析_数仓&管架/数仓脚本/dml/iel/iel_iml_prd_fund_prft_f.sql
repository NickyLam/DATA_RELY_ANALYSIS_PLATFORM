: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_prd_fund_prft_f
CreateDate: 20180529
FileName:   ${iel_data_path}/prd_fund_prft.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.flow_num,chr(13),''),chr(10),'') as flow_num 
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id 
,replace(replace(t1.fund_id,chr(13),''),chr(10),'') as fund_id 
,replace(replace(t1.asset_type_id,chr(13),''),chr(10),'') as asset_type_id 
,replace(replace(t1.market_type_id,chr(13),''),chr(10),'') as market_type_id 
,t1.tot_net_price as tot_net_price 
,t1.sevn_aual_yld as sevn_aual_yld 
,t1.pub_dt as pub_dt 
,t1.prft_start_dt as prft_start_dt 
,t1.prft_end_dt as prft_end_dt 
,t1.imp_tm as imp_tm 
,replace(replace(t1.imp_way_id,chr(13),''),chr(10),'') as imp_way_id 
,t1.accu_corp_nv as accu_corp_nv 
,t1.sevn_ten_thous_prft as sevn_ten_thous_prft 
,t1.corp_nv as corp_nv 
,t1.fund_size as fund_size 
,t1.fund_tot_lot as fund_tot_lot 
,t1.create_dt as create_dt 
,t1.update_dt as update_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.prd_fund_prft t1 
where create_dt <= to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/prd_fund_prft.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes