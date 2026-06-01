: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_card_bin_para_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/ref_card_bin_para_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.card_bin_id,chr(13),''),chr(10),'') as card_bin_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,cert_vlid_tenor
,replace(replace(t1.card_type_cd,chr(13),''),chr(10),'') as card_type_cd
,replace(replace(t1.unionpay_card_prod_id,chr(13),''),chr(10),'') as unionpay_card_prod_id

from ${iml_schema}.ref_card_bin_para_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_card_bin_para_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
