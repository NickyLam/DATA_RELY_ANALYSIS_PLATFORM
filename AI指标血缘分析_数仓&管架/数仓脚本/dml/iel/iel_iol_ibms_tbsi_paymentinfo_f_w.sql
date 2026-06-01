: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_tbsi_paymentinfo_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ibms_tbsi_paymentinfo_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(i_code,chr(10),''),chr(13),'') as i_code
,replace(replace(a_type,chr(10),''),chr(13),'') as a_type
,replace(replace(m_type,chr(10),''),chr(13),'') as m_type
,replace(replace(tg_code,chr(10),''),chr(13),'') as tg_code
,replace(replace(pi_id,chr(10),''),chr(13),'') as pi_id
,replace(replace(stream_id,chr(10),''),chr(13),'') as stream_id
,replace(replace(pi_fixed,chr(10),''),chr(13),'') as pi_fixed
,replace(replace(pi_calcenddate,chr(10),''),chr(13),'') as pi_calcenddate
,replace(replace(pi_paymentdate,chr(10),''),chr(13),'') as pi_paymentdate
,replace(replace(pi_amount,chr(10),''),chr(13),'') as pi_amount
,replace(replace(pi_discount,chr(10),''),chr(13),'') as pi_discount
,replace(replace(pi_notionalamount,chr(10),''),chr(13),'') as pi_notionalamount
,replace(replace(pi_notionalamount_forcasted,chr(10),''),chr(13),'') as pi_notionalamount_forcasted
,replace(replace(pi_interestamount,chr(10),''),chr(13),'') as pi_interestamount
,replace(replace(pi_interestamount_forcasted,chr(10),''),chr(13),'') as pi_interestamount_forcasted
,replace(replace(pi_prenotionalamount,chr(10),''),chr(13),'') as pi_prenotionalamount
,replace(replace(pi_nextnotionalamount,chr(10),''),chr(13),'') as pi_nextnotionalamount
,replace(replace(pi_premium,chr(10),''),chr(13),'') as pi_premium
,replace(replace(pi_premium_forcasted,chr(10),''),chr(13),'') as pi_premium_forcasted
,replace(replace(pi_probability,chr(10),''),chr(13),'') as pi_probability
,replace(replace(imp_time,chr(10),''),chr(13),'') as imp_time
,replace(replace(real_i_code,chr(10),''),chr(13),'') as real_i_code
,replace(replace(pi_calcstartdate,chr(10),''),chr(13),'') as pi_calcstartdate
,replace(replace(pi_currency,chr(10),''),chr(13),'') as pi_currency
,replace(replace(pi_settlecurrency,chr(10),''),chr(13),'') as pi_settlecurrency
,replace(replace(pi_discounttime,chr(10),''),chr(13),'') as pi_discounttime
,replace(replace(pe_code,chr(10),''),chr(13),'') as pe_code
,replace(replace(beg_date,chr(10),''),chr(13),'') as beg_date
,replace(replace(pi_cumudefaultrate,chr(10),''),chr(13),'') as pi_cumudefaultrate
,start_dt
,end_dt
,id_mark
,etl_timestamp
from iol.ibms_tbsi_paymentinfo
where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_tbsi_paymentinfo_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes