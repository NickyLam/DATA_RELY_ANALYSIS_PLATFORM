: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_cashlb_extend_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ibms_ttrd_cashlb_extend.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
      ,replace(replace(i_code,chr(13),''),chr(10),'') as i_code
      ,replace(replace(a_type,chr(13),''),chr(10),'') as a_type
      ,replace(replace(m_type,chr(13),''),chr(10),'') as m_type
      ,replace(replace(expect_take_day,chr(13),''),chr(10),'') as expect_take_day
      ,break_contract_coupon
      ,replace(replace(main_agreement_no,chr(13),''),chr(10),'') as main_agreement_no
      ,replace(replace(confirm_no,chr(13),''),chr(10),'') as confirm_no
      ,replace(replace(allow_take,chr(13),''),chr(10),'') as allow_take
      ,replace(replace(other_agree_item,chr(13),''),chr(10),'') as other_agree_item
      ,start_dt
      ,end_dt
      ,id_mark
  from ${iol_schema}.ibms_ttrd_cashlb_extend t1
 where start_dt <= to_date('${batch_date}','yyyymmdd')
   and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_cashlb_extend.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes