: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_corp_stl_card_card_holder_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/agt_corp_stl_card_card_holder_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.vouch_id,chr(13),''),chr(10),'') as vouch_id
,replace(replace(t1.card_no,chr(13),''),chr(10),'') as card_no
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.main_card_flg,chr(13),''),chr(10),'') as main_card_flg
,replace(replace(t1.main_card_card_no,chr(13),''),chr(10),'') as main_card_card_no
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cert_no,chr(13),''),chr(10),'') as cert_no
,replace(replace(t1.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd
,replace(replace(t1.cust_cn_name,chr(13),''),chr(10),'') as cust_cn_name
,replace(replace(t1.tel_num,chr(13),''),chr(10),'') as tel_num

from ${iml_schema}.agt_corp_stl_card_card_holder_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_corp_stl_card_card_holder_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
