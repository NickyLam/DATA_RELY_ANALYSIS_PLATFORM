/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_wph_interest_accrual
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_wph_interest_accrual
whenever sqlerror continue none;
drop table ${iol_schema}.icms_wph_interest_accrual purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wph_interest_accrual(
    trandate varchar2(10) -- 交易日期
    ,trantype varchar2(10) -- 交易类型
    ,internalkey varchar2(50) -- 借据号
    ,prodtype varchar2(50) -- 产品类型
    ,intclass varchar2(20) -- 利息分类
    ,ccy varchar2(3) -- 币种
    ,stageno number(5,0) -- 期次
    ,intaccrued number(17,2) -- 累计计提利息
    ,intaccruedctd number(17,2) -- 计提日计提利息
    ,realrate number(15,8) -- 执行利率
    ,tdintnumdays number(5,0) -- 当期累计计息天数
    ,inputdate date -- 登记日期
    ,bizdate varchar2(10) -- 流程日期
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
grant select on ${iol_schema}.icms_wph_interest_accrual to ${iml_schema};
grant select on ${iol_schema}.icms_wph_interest_accrual to ${icl_schema};
grant select on ${iol_schema}.icms_wph_interest_accrual to ${idl_schema};
grant select on ${iol_schema}.icms_wph_interest_accrual to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_wph_interest_accrual is '唯品消金利息计提表';
comment on column ${iol_schema}.icms_wph_interest_accrual.trandate is '交易日期';
comment on column ${iol_schema}.icms_wph_interest_accrual.trantype is '交易类型';
comment on column ${iol_schema}.icms_wph_interest_accrual.internalkey is '借据号';
comment on column ${iol_schema}.icms_wph_interest_accrual.prodtype is '产品类型';
comment on column ${iol_schema}.icms_wph_interest_accrual.intclass is '利息分类';
comment on column ${iol_schema}.icms_wph_interest_accrual.ccy is '币种';
comment on column ${iol_schema}.icms_wph_interest_accrual.stageno is '期次';
comment on column ${iol_schema}.icms_wph_interest_accrual.intaccrued is '累计计提利息';
comment on column ${iol_schema}.icms_wph_interest_accrual.intaccruedctd is '计提日计提利息';
comment on column ${iol_schema}.icms_wph_interest_accrual.realrate is '执行利率';
comment on column ${iol_schema}.icms_wph_interest_accrual.tdintnumdays is '当期累计计息天数';
comment on column ${iol_schema}.icms_wph_interest_accrual.inputdate is '登记日期';
comment on column ${iol_schema}.icms_wph_interest_accrual.bizdate is '流程日期';
comment on column ${iol_schema}.icms_wph_interest_accrual.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_wph_interest_accrual.etl_timestamp is 'ETL处理时间戳';
