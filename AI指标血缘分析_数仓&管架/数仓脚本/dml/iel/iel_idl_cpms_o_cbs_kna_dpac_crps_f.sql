: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_cpms_o_cbs_kna_dpac_crps_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cpms_o_cbs_kna_dpac_crps_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select acctid
,bltype
,modutp
,onlnbl
,acmlbl
,edctbl from idl.cpms_o_cbs_kna_dpac_crps where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/cpms_o_cbs_kna_dpac_crps_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes