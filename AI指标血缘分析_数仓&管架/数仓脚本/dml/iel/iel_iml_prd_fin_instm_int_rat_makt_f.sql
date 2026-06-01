: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_prd_fin_instm_int_rat_makt_f
CreateDate: 20230109
FileName:   ${iel_data_path}/prd_fin_instm_int_rat_makt.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.flow_num,chr(13),''),chr(10),'') as flow_num
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.fin_instm_id,chr(13),''),chr(10),'') as fin_instm_id
,replace(replace(t1.asset_type_id,chr(13),''),chr(10),'') as asset_type_id
,replace(replace(t1.market_type_id,chr(13),''),chr(10),'') as market_type_id
,close_quot_price
,higt_price
,lowt_price
,sell_price
,buy_price
,mdl_p
,effect_dt
,invalid_dt
,imp_tm
,replace(replace(t1.imp_way_id,chr(13),''),chr(10),'') as imp_way_id
,replace(replace(t1.data_src_type,chr(13),''),chr(10),'') as data_src_type
,replace(replace(t1.effect_flg,chr(13),''),chr(10),'') as effect_flg
,create_dt
,update_dt

from ${iml_schema}.prd_fin_instm_int_rat_makt t1
where etl_dt = to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/prd_fin_instm_int_rat_makt.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
