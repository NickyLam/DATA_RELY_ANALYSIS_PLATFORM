/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_tax_pay_mark
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_tax_pay_mark
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_tax_pay_mark purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_tax_pay_mark(
    stacid number(9) -- 账套
    ,taxcode varchar2(10) -- 税种代码（01-增值税，02-城建税，03-教育附加税，04-地方教育附加税，05-印花税，06-房产税，07-土地使用税，08-企业所得税，09-递延所得税，10-车船税）
    ,deptcdbf varchar2(12) -- 上划前机构编号
    ,deptcdaf varchar2(12) -- 上划后机构编号
    ,smrytx varchar2(300) -- 备注
    ,status varchar2(1) -- 是否允许同步0-否,1-是
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.tgls_tax_pay_mark to ${iml_schema};
grant select on ${iol_schema}.tgls_tax_pay_mark to ${icl_schema};
grant select on ${iol_schema}.tgls_tax_pay_mark to ${idl_schema};
grant select on ${iol_schema}.tgls_tax_pay_mark to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_tax_pay_mark is '税费上划定义';
comment on column ${iol_schema}.tgls_tax_pay_mark.stacid is '账套';
comment on column ${iol_schema}.tgls_tax_pay_mark.taxcode is '税种代码（01-增值税，02-城建税，03-教育附加税，04-地方教育附加税，05-印花税，06-房产税，07-土地使用税，08-企业所得税，09-递延所得税，10-车船税）';
comment on column ${iol_schema}.tgls_tax_pay_mark.deptcdbf is '上划前机构编号';
comment on column ${iol_schema}.tgls_tax_pay_mark.deptcdaf is '上划后机构编号';
comment on column ${iol_schema}.tgls_tax_pay_mark.smrytx is '备注';
comment on column ${iol_schema}.tgls_tax_pay_mark.status is '是否允许同步0-否,1-是';
comment on column ${iol_schema}.tgls_tax_pay_mark.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_tax_pay_mark.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_tax_pay_mark.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_tax_pay_mark.etl_timestamp is 'ETL处理时间戳';
