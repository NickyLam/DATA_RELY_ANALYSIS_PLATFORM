/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_tax_nvat_detl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_tax_nvat_detl
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_tax_nvat_detl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_tax_nvat_detl(
    stacid number(9) -- 账套
    ,period varchar2(10) -- 计提序号
    ,trandt varchar2(8) -- 计提日期
    ,taxcode varchar2(2) -- 税种代码（01-增值税，02-城建税，03-教育附加税，04-地方教育附加税，05-印花税，06-房产税，07-土地使用税，08-企业所得税，09-递延所得税，10-车船税）
    ,deptcode varchar2(12) -- 机构编号
    ,crcycd varchar2(3) -- 币种代码
    ,itemcd varchar2(30) -- 科目编号
    ,markam number(21,2) -- 金额
    ,startdate varchar2(8) -- 开始日期
    ,enddate varchar2(8) -- 结束日期
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
grant select on ${iol_schema}.tgls_tax_nvat_detl to ${iml_schema};
grant select on ${iol_schema}.tgls_tax_nvat_detl to ${icl_schema};
grant select on ${iol_schema}.tgls_tax_nvat_detl to ${idl_schema};
grant select on ${iol_schema}.tgls_tax_nvat_detl to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_tax_nvat_detl is '未交增值税计提明细表';
comment on column ${iol_schema}.tgls_tax_nvat_detl.stacid is '账套';
comment on column ${iol_schema}.tgls_tax_nvat_detl.period is '计提序号';
comment on column ${iol_schema}.tgls_tax_nvat_detl.trandt is '计提日期';
comment on column ${iol_schema}.tgls_tax_nvat_detl.taxcode is '税种代码（01-增值税，02-城建税，03-教育附加税，04-地方教育附加税，05-印花税，06-房产税，07-土地使用税，08-企业所得税，09-递延所得税，10-车船税）';
comment on column ${iol_schema}.tgls_tax_nvat_detl.deptcode is '机构编号';
comment on column ${iol_schema}.tgls_tax_nvat_detl.crcycd is '币种代码';
comment on column ${iol_schema}.tgls_tax_nvat_detl.itemcd is '科目编号';
comment on column ${iol_schema}.tgls_tax_nvat_detl.markam is '金额';
comment on column ${iol_schema}.tgls_tax_nvat_detl.startdate is '开始日期';
comment on column ${iol_schema}.tgls_tax_nvat_detl.enddate is '结束日期';
comment on column ${iol_schema}.tgls_tax_nvat_detl.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_tax_nvat_detl.etl_timestamp is 'ETL处理时间戳';
