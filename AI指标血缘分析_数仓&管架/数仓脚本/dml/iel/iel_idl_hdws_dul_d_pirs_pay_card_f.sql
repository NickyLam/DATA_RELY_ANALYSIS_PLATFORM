: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_pirs_pay_card_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_pirs_pay_card.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_char(t1.etl_dt,'YYYY-MM-DD') as data_dt
,replace(replace(t1.org_num,chr(13),''),chr(10),'') as org_num
,replace(replace(t1.cardkind,chr(13),''),chr(10),'') as cardkind
,replace(replace(t1.card_issuers,chr(13),''),chr(10),'') as card_issuers
,replace(replace(t1.card_curr,chr(13),''),chr(10),'') as card_curr
,replace(replace(t1.card_logo,chr(13),''),chr(10),'') as card_logo
,replace(replace(t1.card_medium,chr(13),''),chr(10),'') as card_medium
,replace(replace(t1.electronic_cash_flg,chr(13),''),chr(10),'') as electronic_cash_flg
,replace(replace(t1.cust_typ,chr(13),''),chr(10),'') as cust_typ
,t1.card_num as card_num
,t1.newcard_num as newcard_num
,t1.newcard_num2 as newcard_num2
,t1.cancel_card_num as cancel_card_num
,replace(replace(t1.card_act,chr(13),''),chr(10),'') as card_act
,replace(replace(t1.special_card_type,chr(13),''),chr(10),'') as special_card_type
,t1.newcard_num_q as newcard_num_q
from ${idl_schema}.hdws_dul_d_pirs_pay_card t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_pirs_pay_card.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes