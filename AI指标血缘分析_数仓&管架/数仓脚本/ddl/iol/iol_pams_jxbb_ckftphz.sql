/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_ckftphz
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_ckftphz
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_ckftphz purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_ckftphz(
    tjrq number(22,0) -- 统计日期
    ,kmh varchar2(75) -- 科目号
    ,kmmc varchar2(150) -- 科目名称
    ,cpmc varchar2(150) -- 产品名称
    ,zhye number(25,4) -- 账户余额
    ,zhyrjye number(25,4) -- 账户月日均余额
    ,zhnrjye number(25,4) -- 账户年日均余额
    ,jqll number(25,4) -- 加权利率
    ,ftplxzcylj number(25,4) -- FTP利息支出月累计
    ,ftplxzcnlj number(25,4) -- FTP利息支出年累计
    ,jqftpjg number(25,4) -- 加权FTP价格
    ,ftpsrylj number(25,4) -- FTP收入月累计
    ,ftpsrnlj number(25,4) -- FTP收入年累计
    ,ftpsyylj number(25,4) -- FTP收益月累计
    ,ftpsynlj number(25,4) -- FTP收益年累计
    ,lxkm varchar2(75) -- 利息科目
    ,lxkmmc varchar2(150) -- 利息科目名称
    ,khjgh varchar2(75) -- 开户机构号
    ,khjgmc varchar2(150) -- 开户机构名称
    ,ssjgh varchar2(75) -- 所属机构号
    ,ssjgmc varchar2(150) -- 所属机构名称
    ,bz varchar2(45) -- 币种
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.pams_jxbb_ckftphz to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_ckftphz to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_ckftphz to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_ckftphz to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_ckftphz is '绩效报表-存款FTP汇总(供数)';
comment on column ${iol_schema}.pams_jxbb_ckftphz.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_ckftphz.kmh is '科目号';
comment on column ${iol_schema}.pams_jxbb_ckftphz.kmmc is '科目名称';
comment on column ${iol_schema}.pams_jxbb_ckftphz.cpmc is '产品名称';
comment on column ${iol_schema}.pams_jxbb_ckftphz.zhye is '账户余额';
comment on column ${iol_schema}.pams_jxbb_ckftphz.zhyrjye is '账户月日均余额';
comment on column ${iol_schema}.pams_jxbb_ckftphz.zhnrjye is '账户年日均余额';
comment on column ${iol_schema}.pams_jxbb_ckftphz.jqll is '加权利率';
comment on column ${iol_schema}.pams_jxbb_ckftphz.ftplxzcylj is 'FTP利息支出月累计';
comment on column ${iol_schema}.pams_jxbb_ckftphz.ftplxzcnlj is 'FTP利息支出年累计';
comment on column ${iol_schema}.pams_jxbb_ckftphz.jqftpjg is '加权FTP价格';
comment on column ${iol_schema}.pams_jxbb_ckftphz.ftpsrylj is 'FTP收入月累计';
comment on column ${iol_schema}.pams_jxbb_ckftphz.ftpsrnlj is 'FTP收入年累计';
comment on column ${iol_schema}.pams_jxbb_ckftphz.ftpsyylj is 'FTP收益月累计';
comment on column ${iol_schema}.pams_jxbb_ckftphz.ftpsynlj is 'FTP收益年累计';
comment on column ${iol_schema}.pams_jxbb_ckftphz.lxkm is '利息科目';
comment on column ${iol_schema}.pams_jxbb_ckftphz.lxkmmc is '利息科目名称';
comment on column ${iol_schema}.pams_jxbb_ckftphz.khjgh is '开户机构号';
comment on column ${iol_schema}.pams_jxbb_ckftphz.khjgmc is '开户机构名称';
comment on column ${iol_schema}.pams_jxbb_ckftphz.ssjgh is '所属机构号';
comment on column ${iol_schema}.pams_jxbb_ckftphz.ssjgmc is '所属机构名称';
comment on column ${iol_schema}.pams_jxbb_ckftphz.bz is '币种';
comment on column ${iol_schema}.pams_jxbb_ckftphz.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_ckftphz.etl_timestamp is 'ETL处理时间戳';
