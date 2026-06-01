: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ncbs_cd_card_chg_i
CreateDate: 20240328
FileName:   ${iel_data_path}/ncbs_cd_card_chg.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.address,chr(13),''),chr(10),'') as address
,replace(replace(t1.base_acct_no,chr(13),''),chr(10),'') as base_acct_no
,replace(replace(t1.client_no,chr(13),''),chr(10),'') as client_no
,replace(replace(t1.prod_type,chr(13),''),chr(10),'') as prod_type
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.user_id,chr(13),''),chr(10),'') as user_id
,replace(replace(t1.card_change_reason,chr(13),''),chr(10),'') as card_change_reason
,replace(replace(t1.change_status,chr(13),''),chr(10),'') as change_status
,replace(replace(t1.company,chr(13),''),chr(10),'') as company
,replace(replace(t1.contact_tel,chr(13),''),chr(10),'') as contact_tel
,replace(replace(t1.gain_type,chr(13),''),chr(10),'') as gain_type
,replace(replace(t1.lost_no,chr(13),''),chr(10),'') as lost_no
,replace(replace(t1.postal_code,chr(13),''),chr(10),'') as postal_code
,replace(replace(t1.same_no_flag,chr(13),''),chr(10),'') as same_no_flag
,replace(replace(t1.urgent_flag,chr(13),''),chr(10),'') as urgent_flag
,apply_date
,promissory_date
,tran_date
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,replace(replace(t1.apply_user_id,chr(13),''),chr(10),'') as apply_user_id
,replace(replace(t1.new_card_no,chr(13),''),chr(10),'') as new_card_no
,replace(replace(t1.old_card_no,chr(13),''),chr(10),'') as old_card_no
,replace(replace(t1.tran_branch,chr(13),''),chr(10),'') as tran_branch
,replace(replace(t1.deal_status,chr(13),''),chr(10),'') as deal_status
,replace(replace(t1.msg_notice_type,chr(13),''),chr(10),'') as msg_notice_type

from ${iol_schema}.ncbs_cd_card_chg t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_cd_card_chg.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
