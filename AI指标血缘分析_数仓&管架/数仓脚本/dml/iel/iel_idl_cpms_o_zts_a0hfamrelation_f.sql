: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_cpms_o_zts_a0hfamrelation_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cpms_o_zts_a0hfamrelation_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select familyid
,memsignid
,custacc
,custno
,custname
,phonenum
,cardgrade
,signstate
,cardstate
,signdate
,unsigndate from idl.cpms_o_zts_a0hfamrelation where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/cpms_o_zts_a0hfamrelation_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes