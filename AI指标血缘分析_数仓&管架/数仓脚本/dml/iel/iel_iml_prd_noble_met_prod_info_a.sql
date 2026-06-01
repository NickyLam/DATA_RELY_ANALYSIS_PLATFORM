: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_prd_noble_met_prod_info_a
CreateDate: 20180529
FileName:   ${iel_data_path}/prd_noble_met_prod_info.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
t.start_dt as etl_dt
,replace(replace(t.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.ser_num,chr(13),''),chr(10),'') as ser_num
,replace(replace(t.merchd_id,chr(13),''),chr(10),'') as merchd_id
,replace(replace(t.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t.merchd_name,chr(13),''),chr(10),'') as merchd_name
,replace(replace(t.merchd_brand,chr(13),''),chr(10),'') as merchd_brand
,replace(replace(t.provi_name,chr(13),''),chr(10),'') as provi_name
,replace(replace(t.merchd_type_cd,chr(13),''),chr(10),'') as merchd_type_cd
,replace(replace(t.merchd_cls_cd,chr(13),''),chr(10),'') as merchd_cls_cd
,replace(replace(t.goods_id,chr(13),''),chr(10),'') as goods_id
,replace(replace(t.prod_fine,chr(13),''),chr(10),'') as prod_fine
,replace(replace(t.prod_gold_ct,chr(13),''),chr(10),'') as prod_gold_ct
,replace(replace(t.prod_artm_ct,chr(13),''),chr(10),'') as prod_artm_ct
,replace(replace(t.prod_matrl,chr(13),''),chr(10),'') as prod_matrl
,replace(replace(t.craft,chr(13),''),chr(10),'') as craft
,replace(replace(t.weight_corp,chr(13),''),chr(10),'') as weight_corp
,replace(replace(t.weight,chr(13),''),chr(10),'') as weight
,replace(replace(t.measure,chr(13),''),chr(10),'') as measure
,t.prod_price as prod_price
,t.prod_qtty as prod_qtty
,replace(replace(t.prod_comm_fee_rule,chr(13),''),chr(10),'') as prod_comm_fee_rule
,t.sell_lmt_qtty as sell_lmt_qtty
,replace(replace(t.prod_status_cd,chr(13),''),chr(10),'') as prod_status_cd
,t.grounding_tm as grounding_tm
,t.under_carige_tm as under_carige_tm
,t.prod_info_create_tm as prod_info_create_tm
,t.prod_info_update_tm as prod_info_update_tm
,replace(replace(t.addit_data_1,chr(13),''),chr(10),'') as addit_data_1
,replace(replace(t.addit_data_2,chr(13),''),chr(10),'') as addit_data_2
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.prd_noble_met_prod_info t
where 1=1;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/prd_noble_met_prod_info.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes