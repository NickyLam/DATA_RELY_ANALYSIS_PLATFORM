: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_pty_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_pty_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select INR,
EXTKEY,
NAM,
PTYTYP,
ACCUSR,
HBKACCFLG,
HBKCONFLG,
HBKINR,
HEQACCFLG,
HEQCONFLG,
HEQINR,
PRFCTR,
RESUSR,
RSKCLS,
RSKCTY,
RSKTXT,
UIL,
VER,
AKKBRA,
AKKCOM,
AKKREG,
LIDCNDFLG,
LIDMAXDUR,
TRDCNDFLG,
TRDTENTOT,
TRDTENINI,
TRDTENEXT,
TRDEXTNMB,
BADCNDFLG,
BADTENEXT,
ADRSTA,
SELTYP,
BUYTYP,
SLA,
ETGEXTKEY,
NAM1,
JUSCOD,
BILVVV,
CUNQII,
IDCODE,
IDTYPE,
BCHKEYINR,
CLSCTY,
PROCOD,
TRNMAN,
SPEECO,
IDTYP1,
'',
BANKTYP from ${idl_schema}.odss_PTY where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_pty_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes