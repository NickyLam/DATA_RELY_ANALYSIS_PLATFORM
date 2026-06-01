: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_cbss_agt_black_acct_detl_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_cbss_agt_black_acct_detl.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       etl_dt
      ,seqno
      ,invodt
      ,replace(replace(datatype,chr(10),''),chr(13),'') as datatype
      ,replace(replace(acctno,chr(10),''),chr(13),'') as acctno
      ,replace(replace(idtype,chr(10),''),chr(13),'') as idtype
      ,replace(replace(idno,chr(10),''),chr(13),'') as idno
      ,replace(replace(custno,chr(10),''),chr(13),'') as custno
      ,replace(replace(mobiphone,chr(10),''),chr(13),'') as mobiphone
      ,replace(replace(telphone,chr(10),''),chr(13),'') as telphone
      ,replace(replace(ismsg,chr(10),''),chr(13),'') as ismsg
      ,replace(replace(invotype,chr(10),''),chr(13),'') as invotype
      ,replace(replace(invodesc,chr(10),''),chr(13),'') as invodesc
      ,replace(replace(isdo,chr(10),''),chr(13),'') as isdo
      ,replace(replace(starti,chr(10),''),chr(13),'') as starti
      ,replace(replace(endti,chr(10),''),chr(13),'') as endti
      ,replace(replace(deal_flg_h,chr(10),''),chr(13),'') as deal_flg_h 
from idl.hdws_dul_d_cbss_agt_black_acct_detl 
where to_date(${batch_date},'yyyymmdd') = etl_dt;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_cbss_agt_black_acct_detl.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes