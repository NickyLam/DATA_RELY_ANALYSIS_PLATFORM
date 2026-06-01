: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_tbsi_paymentinfo_f
CreateDate: 20221013
FileName:   ${iel_data_path}/ibms_tbsi_paymentinfo.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.i_code,chr(13),''),chr(10),'') as i_code
,replace(replace(t1.a_type,chr(13),''),chr(10),'') as a_type
,replace(replace(t1.m_type,chr(13),''),chr(10),'') as m_type
,replace(replace(t1.tg_code,chr(13),''),chr(10),'') as tg_code
,replace(replace(t1.pi_id,chr(13),''),chr(10),'') as pi_id
,replace(replace(t1.stream_id,chr(13),''),chr(10),'') as stream_id
,t1.pi_fixed as pi_fixed
,replace(replace(t1.pi_calcenddate,chr(13),''),chr(10),'') as pi_calcenddate
,replace(replace(t1.pi_paymentdate,chr(13),''),chr(10),'') as pi_paymentdate
,t1.pi_amount as pi_amount
,t1.pi_discount as pi_discount
,t1.pi_notionalamount as pi_notionalamount
,t1.pi_notionalamount_forcasted as pi_notionalamount_forcasted
,t1.pi_interestamount as pi_interestamount
,t1.pi_interestamount_forcasted as pi_interestamount_forcasted
,t1.pi_prenotionalamount as pi_prenotionalamount
,t1.pi_nextnotionalamount as pi_nextnotionalamount
,t1.pi_premium as pi_premium
,t1.pi_premium_forcasted as pi_premium_forcasted
,t1.pi_probability as pi_probability
,replace(replace(t1.imp_time,chr(13),''),chr(10),'') as imp_time
,replace(replace(t1.real_i_code,chr(13),''),chr(10),'') as real_i_code
,replace(replace(t1.pi_calcstartdate,chr(13),''),chr(10),'') as pi_calcstartdate
,replace(replace(t1.pi_currency,chr(13),''),chr(10),'') as pi_currency
,replace(replace(t1.pi_settlecurrency,chr(13),''),chr(10),'') as pi_settlecurrency
,t1.pi_discounttime as pi_discounttime
,replace(replace(t1.pe_code,chr(13),''),chr(10),'') as pe_code
,replace(replace(t1.beg_date,chr(13),''),chr(10),'') as beg_date
,t1.pi_cumudefaultrate as pi_cumudefaultrate
,replace(replace(t1.i_code_rpt,chr(13),''),chr(10),'') as i_code_rpt

from ${iol_schema}.ibms_tbsi_paymentinfo t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_tbsi_paymentinfo.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
