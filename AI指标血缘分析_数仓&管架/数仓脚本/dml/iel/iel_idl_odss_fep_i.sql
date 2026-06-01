: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_fep_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_fep_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select INR,
FEECOD,
OBJTYP,
OBJINR,
RELOBJTYP,
RELOBJINR,
EXTKEY,
NAM,
RELCUR,
RELAMT,
DAT1,
DAT2,
MODFLG,
UNT,
UNTAMT,
RATCAL,
RAT,
MINMAXFLG,
CUR,
AMT,
XRFCUR,
XRFAMT,
FEEACC,
INFDETSTM,
PTYINR,
SRCTRNINR,
SRCDAT,
RPLTRNINR,
RPLDAT,
DONTRNINR,
DONDAT,
ADVTRNINR,
ADVDAT,
ACRINR,
SEPINR,
ROL,
OGIAMT,
DCTAMT from ${idl_schema}.odss_FEP where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_fep_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes