: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_glms_bank_vouchertemp_i
CreateDate: 20180529
FileName:   ${iel_data_path}/bank_vouchertemp_${batch_date}_inc.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
ACCTDT   ,
CRCYCD   ,
BRCHNO   ,
ITEMCD   ,
BDTITEM  ,
LINE     ,
PDCODE   ,
RSCSYSFLG,
ICM0     ,
ICM0_1   ,
DRTSAM   ,
CRTSAM   ,
IOFLAG   
from ${idl_schema}.glms_bank_vouchertemp where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/bank_vouchertemp_${batch_date}_inc.dat" \
        charset=zhs16gbk
        safe=yes