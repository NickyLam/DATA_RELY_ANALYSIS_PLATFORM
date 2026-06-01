/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_nbzz_gskhsxfsdmx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_nbzz_gskhsxfsdmx
whenever sqlerror continue none;
drop table ${iol_schema}.pams_nbzz_gskhsxfsdmx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_nbzz_gskhsxfsdmx(
    tjrq number(22) -- 统计日期
    ,khh varchar2(90) -- 客户号
    ,hth varchar2(150) -- 合同号
    ,kmh varchar2(60) -- 科目号
    ,jgdh varchar2(30) -- 机构代号
    ,cpmc varchar2(1500) -- 产品名称
    ,xwdkbs varchar2(6) -- 小微贷款标识
    ,gyljrywbz varchar2(6) -- 供应链金融业务标志
    ,bwbs varchar2(6) -- 表外标识
    ,sxckye number(25,4) -- 授信敞口余额
    ,khsxckye number(25,4) -- 客户总授信敞口余额
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
grant select on ${iol_schema}.pams_nbzz_gskhsxfsdmx to ${iml_schema};
grant select on ${iol_schema}.pams_nbzz_gskhsxfsdmx to ${icl_schema};
grant select on ${iol_schema}.pams_nbzz_gskhsxfsdmx to ${idl_schema};
grant select on ${iol_schema}.pams_nbzz_gskhsxfsdmx to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_nbzz_gskhsxfsdmx is '内部总账_公司客户授信分散度明细';
comment on column ${iol_schema}.pams_nbzz_gskhsxfsdmx.tjrq is '统计日期';
comment on column ${iol_schema}.pams_nbzz_gskhsxfsdmx.khh is '客户号';
comment on column ${iol_schema}.pams_nbzz_gskhsxfsdmx.hth is '合同号';
comment on column ${iol_schema}.pams_nbzz_gskhsxfsdmx.kmh is '科目号';
comment on column ${iol_schema}.pams_nbzz_gskhsxfsdmx.jgdh is '机构代号';
comment on column ${iol_schema}.pams_nbzz_gskhsxfsdmx.cpmc is '产品名称';
comment on column ${iol_schema}.pams_nbzz_gskhsxfsdmx.xwdkbs is '小微贷款标识';
comment on column ${iol_schema}.pams_nbzz_gskhsxfsdmx.gyljrywbz is '供应链金融业务标志';
comment on column ${iol_schema}.pams_nbzz_gskhsxfsdmx.bwbs is '表外标识';
comment on column ${iol_schema}.pams_nbzz_gskhsxfsdmx.sxckye is '授信敞口余额';
comment on column ${iol_schema}.pams_nbzz_gskhsxfsdmx.khsxckye is '客户总授信敞口余额';
comment on column ${iol_schema}.pams_nbzz_gskhsxfsdmx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_nbzz_gskhsxfsdmx.etl_timestamp is 'ETL处理时间戳';
