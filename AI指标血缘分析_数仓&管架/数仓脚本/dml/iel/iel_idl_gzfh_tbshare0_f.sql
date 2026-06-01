: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_gzfh_tbshare0_f
CreateDate: 20180529
FileName:   ${iel_data_path}/gzfh_tbshare0_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select IN_CLIENT_NO,SELLER_CODE,BANK_NO,CLIENT_NO,BANK_ACC,TA_CLIENT,CASH_FLAG,TRANS_ACCOUNT_TYPE,TRANS_ACCOUNT,TA_CODE,ASSET_ACC,PRD_CODE,CONTRACT_NO,LAST_DATE,TOT_VOL,FROZEN_VOL,LONG_FROZEN_VOL,GROUP_VOL,DIV_MODE,OLD_DIV_MODE,DIV_RATE,YSTDY_TOT_VOL,OPEN_BRANCH,CLIENT_TYPE,APPEND_FLAG,OTHER_FROZEN,INCOME,INCOME_RATE,COST,TOT_INCOME,INCOME_ONWAY,INCOME_FROZEN,INCOME_NEW,MANAGE_AGIO,TOT_MANAGE_FEE,MANAGE_FEE,MANAGE_DATE,RESERVE1,RESERVE2,RESERVE3,RESERVE4,RESERVE5 from  ${idl_schema}.gzfh_tbshare0 where etl_dt=to_date('${batch_date}','yyyymmdd')" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/gzfh_tbshare0_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes