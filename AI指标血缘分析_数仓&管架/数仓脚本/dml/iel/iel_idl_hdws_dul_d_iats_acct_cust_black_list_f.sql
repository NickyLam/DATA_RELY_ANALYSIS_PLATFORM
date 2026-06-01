: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_iats_acct_cust_black_list_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_iats_acct_cust_black_list.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       id
      ,etl_dt
      ,replace(replace(invo_date,chr(10),''),chr(13),'') as invo_date
      ,replace(replace(data_type,chr(10),''),chr(13),'') as data_type
      ,replace(replace(account_no,chr(10),''),chr(13),'') as account_no
      ,replace(replace(contact_certificate_type_id,chr(10),''),chr(13),'') as contact_certificate_type_id
      ,replace(replace(info_string,chr(10),''),chr(13),'') as info_string
      ,replace(replace(party_id,chr(10),''),chr(13),'') as party_id
      ,replace(replace(mobile_number,chr(10),''),chr(13),'') as mobile_number
      ,replace(replace(telephone_number,chr(10),''),chr(13),'') as telephone_number
      ,replace(replace(is_send_msg,chr(10),''),chr(13),'') as is_send_msg
      ,replace(replace(invo_type,chr(10),''),chr(13),'') as invo_type
      ,replace(replace(invo_desc,chr(10),''),chr(13),'') as invo_desc
      ,replace(replace(deal_flag,chr(10),''),chr(13),'') as deal_flag
      ,replace(replace(starti,chr(10),''),chr(13),'') as starti
      ,replace(replace(endti,chr(10),''),chr(13),'') as endti
      ,replace(replace(deal_flg_h,chr(10),''),chr(13),'') as deal_flg_h 
from idl.hdws_dul_d_iats_acct_cust_black_list 
where to_date(${batch_date},'yyyymmdd') = etl_dt;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_iats_acct_cust_black_list.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes