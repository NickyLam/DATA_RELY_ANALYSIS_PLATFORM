: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ref_asset_bus_breed_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ref_asset_bus_breed_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt
,t.asset_bus_breed_id
,t.sort_id
,t.asset_bus_breed_name
,t.type_sort_id
,t.sub_type
,t.attr1
,t.attr2
,t.attr3
,t.attr4
,t.attr5
,t.attr6
,t.attr7
,t.attr8
,t.attr9
,t.attr10
,t.attr11
,t.asset_thd_cls_cd
,t.attr13
,t.attr14
,t.attr15
,t.attr16
,t.attr17
,t.attr18
,t.attr19
,t.attr20
,t.attr21
,t.attr22
,t.attr23
,t.attr24
,t.attr25
,t.use_flg
,t.loan_size_ctrl_flg
,t.prod_catlg_id
,t.create_dt
,t.update_dt
,t.id_mark
,t.job_cd
from ${idl_schema}.ref_asset_bus_breed t 
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_asset_bus_breed_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes