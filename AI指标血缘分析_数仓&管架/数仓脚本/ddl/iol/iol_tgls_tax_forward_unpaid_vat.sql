/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_tax_forward_unpaid_vat
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_tax_forward_unpaid_vat
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_tax_forward_unpaid_vat purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_tax_forward_unpaid_vat(
    stacid number(19) -- 账套标记
    ,sourdt varchar2(8) -- 增值税结转会计日期
    ,prcscd varchar2(12) -- 处理码
    ,soursq varchar2(30) -- 会计分录流水号
    ,transt varchar2(1) -- 附加税入账处理状态(0未入账1开始处理2产生明细3产生分录9处理失败)
    ,acctbr varchar2(12) -- 机构编号
    ,sourst varchar2(30) -- 来源系统编号
    ,crcycd varchar2(3) -- 币种
    ,itemcd varchar2(30) -- 科目编号
    ,tranam_dr number(20,2) -- 发生额借方汇总
    ,tranam_cr number(20,2) -- 发生额贷方汇总
    ,creation_date date -- 创建日期
    ,last_updated_date date -- 最后修改日期
    ,transq varchar2(30) -- 处理批次号
    ,errflag varchar2(1) -- 错误代码(0或空为成功1为出错)
    ,errmsg varchar2(300) -- 错误描述
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
grant select on ${iol_schema}.tgls_tax_forward_unpaid_vat to ${iml_schema};
grant select on ${iol_schema}.tgls_tax_forward_unpaid_vat to ${icl_schema};
grant select on ${iol_schema}.tgls_tax_forward_unpaid_vat to ${idl_schema};
grant select on ${iol_schema}.tgls_tax_forward_unpaid_vat to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_tax_forward_unpaid_vat is '增值税结转记录表';
comment on column ${iol_schema}.tgls_tax_forward_unpaid_vat.stacid is '账套标记';
comment on column ${iol_schema}.tgls_tax_forward_unpaid_vat.sourdt is '增值税结转会计日期';
comment on column ${iol_schema}.tgls_tax_forward_unpaid_vat.prcscd is '处理码';
comment on column ${iol_schema}.tgls_tax_forward_unpaid_vat.soursq is '会计分录流水号';
comment on column ${iol_schema}.tgls_tax_forward_unpaid_vat.transt is '附加税入账处理状态(0未入账1开始处理2产生明细3产生分录9处理失败)';
comment on column ${iol_schema}.tgls_tax_forward_unpaid_vat.acctbr is '机构编号';
comment on column ${iol_schema}.tgls_tax_forward_unpaid_vat.sourst is '来源系统编号';
comment on column ${iol_schema}.tgls_tax_forward_unpaid_vat.crcycd is '币种';
comment on column ${iol_schema}.tgls_tax_forward_unpaid_vat.itemcd is '科目编号';
comment on column ${iol_schema}.tgls_tax_forward_unpaid_vat.tranam_dr is '发生额借方汇总';
comment on column ${iol_schema}.tgls_tax_forward_unpaid_vat.tranam_cr is '发生额贷方汇总';
comment on column ${iol_schema}.tgls_tax_forward_unpaid_vat.creation_date is '创建日期';
comment on column ${iol_schema}.tgls_tax_forward_unpaid_vat.last_updated_date is '最后修改日期';
comment on column ${iol_schema}.tgls_tax_forward_unpaid_vat.transq is '处理批次号';
comment on column ${iol_schema}.tgls_tax_forward_unpaid_vat.errflag is '错误代码(0或空为成功1为出错)';
comment on column ${iol_schema}.tgls_tax_forward_unpaid_vat.errmsg is '错误描述';
comment on column ${iol_schema}.tgls_tax_forward_unpaid_vat.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_tax_forward_unpaid_vat.etl_timestamp is 'ETL处理时间戳';
