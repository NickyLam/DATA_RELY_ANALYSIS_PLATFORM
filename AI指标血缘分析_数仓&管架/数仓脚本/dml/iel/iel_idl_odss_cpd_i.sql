: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_cpd_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_cpd_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select INR,
OWNREF,
NAM,
PYEPTYINR,
PYEPTAINR,
PYENAM,
PYEREF,
PYBPTYINR,
PYBPTAINR,
PYBNAM,
PYBREF,
ORCPTYINR,
ORCPTAINR,
ORCNAM,
ORCREF,
ORIPTYINR,
ORIPTAINR,
ORINAM,
ORIREF,
VALDAT,
OPNDAT,
CLSDAT,
CHATO,
CREDAT,
OWNUSR,
VER,
DETCHGCOD,
PAYTYP,
STAGOD,
STACTY,
ETYEXTKEY,
SYSNO,
OTHBCH,
GORS,
FEECUR,
FEEAMT,
TRNTYP,
PAYTYPE,
PAYDAT,
CLITYP,
TRDINT,
CURF33B,
CUR71F,
AMT71F,
AMTF33B,
F36,
F23E,
F23B,
TRDOUT,
SWFTYP,
TRDINR,
REL21,
BRANCHINR,
BCHKEYINR,
ACCMOD,
SZTYP,
SNDBANREF,
ORCACT,
PYEACT,
CANFLG,
NRAFLG,
QSQDBH from ${idl_schema}.odss_CPD where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_cpd_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes