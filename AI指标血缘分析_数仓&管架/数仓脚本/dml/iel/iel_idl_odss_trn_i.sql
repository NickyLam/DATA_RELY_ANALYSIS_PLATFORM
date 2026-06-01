: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_trn_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_trn_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select INR,
INIDATTIM,
INIFRM,
INIUSR,
ININAM,
OWNREF,
OBJTYP,
OBJINR,
OBJNAM,
SSNINR,
SMHNXT,
USG,
USR,
CPLDATTIM,
INFDSP,
INFTXT,
RELFLG,
COMFLG,
COMDAT,
CORTRNINR,
XREFLG,
XRECURBLK,
RELCUR,
RELAMT,
RELORICUR,
RELORIAMT,
RELREQ,
RELRES,
CNFFLG,
'',
RPRUSR,
ORDINR,
EXEDAT,
ETYEXTKEY,
BCHKEYINR,
ACCBCHINR,
RELREQ0,
RELREQ1,
RELREQ2,
RELRES0,
RELRES1,
RELRES2,
RELUSR1,
RELUSR2,
RELUSR3,
IMGINR,
BRANCHINR,
ORGFLG,
ADDTXT,
GYLSH,
GYLSH1,
YEWGZH,
CMTFLG from ${idl_schema}.odss_TRN where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_trn_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes