: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_bok_prd_position_n_f
CreateDate: 20180529
FileName:   ${iel_data_path}/fams_bok_prd_position_n.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
replace(replace(t1.accountid,chr(13),''),chr(10),'') as accountid
,t1.drawdate as drawdate
,replace(replace(t1.ptype,chr(13),''),chr(10),'') as ptype
,t1.gendate as gendate
,t1.createtime as createtime
,t1.prinamt as prinamt
,t1.tdyassetamount as tdyassetamount
,t1.tdyplgain as tdyplgain
,t1.tdypapergain as tdypapergain
,t1.tdybonusbassetamount as tdybonusbassetamount
,t1.tdybfamount as tdybfamount
,t1.tdynonfeeamount as tdynonfeeamount
,to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.etl_timestamp as etl_timestamp
from iol.fams_bok_prd_position_n t1
where t1.etl_dt=TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_bok_prd_position_n.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes