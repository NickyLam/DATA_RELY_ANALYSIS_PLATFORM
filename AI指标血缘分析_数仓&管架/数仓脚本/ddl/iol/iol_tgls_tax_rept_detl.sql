/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_tax_rept_detl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_tax_rept_detl
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_tax_rept_detl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_tax_rept_detl(
    stacid number(9) -- 账套
    ,deptcdbf varchar2(12) -- 上划前机构编号
    ,period varchar2(10) -- 计提序号
    ,taxcode varchar2(2) -- 税种代码（01-增值税，02-城建税，03-教育附加税，04-地方教育附加税，05-印花税，06-房产税，07-土地使用税，08-企业所得税，09-递延所得税，10-车船税）
    ,deptcdaf varchar2(12) -- 上划后机构编号
    ,crcycd varchar2(3) -- 币种代码
    ,markam number(21,2) -- 本期上划金额
    ,ymaram number(21,2) -- 本年累计上划金额
    ,vatxrt number(17,8) -- 税率
    ,startdate varchar2(8) -- 开始日期
    ,enddate varchar2(8) -- 结束日期
    ,status varchar2(1) -- 上划状态（0-未冲销，1-已冲销）
    ,soursq varchar2(50) -- 源系统流水
    ,markam_beq number(20,2) -- 本期上划本位币金额
    ,ymaram_beq number(20,2) -- 本年累计上划本位币金额
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
grant select on ${iol_schema}.tgls_tax_rept_detl to ${iml_schema};
grant select on ${iol_schema}.tgls_tax_rept_detl to ${icl_schema};
grant select on ${iol_schema}.tgls_tax_rept_detl to ${idl_schema};
grant select on ${iol_schema}.tgls_tax_rept_detl to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_tax_rept_detl is '上划明细表';
comment on column ${iol_schema}.tgls_tax_rept_detl.stacid is '账套';
comment on column ${iol_schema}.tgls_tax_rept_detl.deptcdbf is '上划前机构编号';
comment on column ${iol_schema}.tgls_tax_rept_detl.period is '计提序号';
comment on column ${iol_schema}.tgls_tax_rept_detl.taxcode is '税种代码（01-增值税，02-城建税，03-教育附加税，04-地方教育附加税，05-印花税，06-房产税，07-土地使用税，08-企业所得税，09-递延所得税，10-车船税）';
comment on column ${iol_schema}.tgls_tax_rept_detl.deptcdaf is '上划后机构编号';
comment on column ${iol_schema}.tgls_tax_rept_detl.crcycd is '币种代码';
comment on column ${iol_schema}.tgls_tax_rept_detl.markam is '本期上划金额';
comment on column ${iol_schema}.tgls_tax_rept_detl.ymaram is '本年累计上划金额';
comment on column ${iol_schema}.tgls_tax_rept_detl.vatxrt is '税率';
comment on column ${iol_schema}.tgls_tax_rept_detl.startdate is '开始日期';
comment on column ${iol_schema}.tgls_tax_rept_detl.enddate is '结束日期';
comment on column ${iol_schema}.tgls_tax_rept_detl.status is '上划状态（0-未冲销，1-已冲销）';
comment on column ${iol_schema}.tgls_tax_rept_detl.soursq is '源系统流水';
comment on column ${iol_schema}.tgls_tax_rept_detl.markam_beq is '本期上划本位币金额';
comment on column ${iol_schema}.tgls_tax_rept_detl.ymaram_beq is '本年累计上划本位币金额';
comment on column ${iol_schema}.tgls_tax_rept_detl.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_tax_rept_detl.etl_timestamp is 'ETL处理时间戳';
