: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_ccd_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_ccd_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select INR,
OWNUSR,
OWNREF,
NAM,
CORPTYINR,
CORPTAINR,
CORNAM,
CORREF,
NOBPTYINR,
NOBPTAINR,
NOBNAM,
NOBREF,
DROPTYINR,
DROPTAINR,
DRONAM,
DROREF,
PREPTYINR,
PREPTAINR,
PRENAM,
PREREF,
CHKDAT,
CREDAT,
CLSDAT,
PAYDAT,
OPNDAT,
STACTY,
NGRCOD,
INFDSP,
CCFORM,
PURFLG,
MODSET,
TOCSEL,
BRCHREF,
CHCKNUM,
COLREF,
COLNAM,
COLPTYINR,
COLPTAINR,
RPTBTCHNO,
BCHKEYINR,
BRANCHINR,
VERCERREF,
DECNUM,
PRETYP,
PRODAT,
REGREF,
VER,
FREPAYFLG,
ETYEXTKEY,
NRAFLG from ${idl_schema}.odss_CCD where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_ccd_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes