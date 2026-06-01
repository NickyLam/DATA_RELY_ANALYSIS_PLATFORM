: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_wl_acct_f
CreateDate: 20221021
FileName:   ${iel_data_path}/agt_wl_acct.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(acct_id,chr(13),''),chr(10),'')
,replace(replace(lp_id,chr(13),''),chr(10),'')
,replace(replace(acct_name,chr(13),''),chr(10),'')
,replace(replace(acct_type_cd,chr(13),''),chr(10),'')
,replace(replace(cap_acct_id,chr(13),''),chr(10),'')
,replace(replace(open_bank_name,chr(13),''),chr(10),'')
,replace(replace(open_bank_num,chr(13),''),chr(10),'')
,replace(replace(open_acct_name,chr(13),''),chr(10),'')
,replace(replace(acct_status_cd,chr(13),''),chr(10),'')
,replace(replace(teller_id,chr(13),''),chr(10),'')
,replace(replace(asset_acct_type_cd,chr(13),''),chr(10),'')
,replace(replace(bd_card_no,chr(13),''),chr(10),'')
,replace(replace(bind_mobile_no,chr(13),''),chr(10),'')
,replace(replace(pbc_fin_inst_code,chr(13),''),chr(10),'')
,replace(replace(obank_card_flg,chr(13),''),chr(10),'')
,replace(replace(cust_id,chr(13),''),chr(10),'')
,start_dt
,end_dt
,replace(replace(id_mark,chr(13),''),chr(10),'')

from ${iml_schema}.agt_wl_acct t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_wl_acct.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
