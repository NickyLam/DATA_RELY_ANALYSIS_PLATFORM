/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_cbankloanstructure
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_cbankloanstructure
whenever sqlerror continue none;
drop table ${iol_schema}.wind_cbankloanstructure purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_cbankloanstructure(
    object_id varchar2(150) -- 对象ID
    ,s_info_compcode varchar2(60) -- 公司id
    ,report_period varchar2(12) -- 报告期
    ,statement_type number(9,0) -- 报表类型代码
    ,crncy_code varchar2(15) -- 货币代码
    ,crncy_type_code number(9,0) -- 币种类型代码
    ,loan_type_code number(9,0) -- 项目类别代码
    ,ann_item varchar2(150) -- [内部]公布名称
    ,loan_item_code number(9,0) -- 贷款项目代码
    ,total_loans number(20,4) -- 贷款余额
    ,ave_loans number(20,4) -- 贷款平均余额
    ,interest_income number(20,4) -- 贷款利息收入
    ,average_yield number(20,4) -- 贷款平均收益率
    ,non_performing_loans number(20,4) -- 不良贷款余额
    ,non_performing_loans_ratio number(20,4) -- 不良贷款率(%)
    ,memo varchar2(300) -- 备注
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
grant select on ${iol_schema}.wind_cbankloanstructure to ${iml_schema};
grant select on ${iol_schema}.wind_cbankloanstructure to ${icl_schema};
grant select on ${iol_schema}.wind_cbankloanstructure to ${idl_schema};
grant select on ${iol_schema}.wind_cbankloanstructure to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_cbankloanstructure is '银行业贷款结构';
comment on column ${iol_schema}.wind_cbankloanstructure.object_id is '对象ID';
comment on column ${iol_schema}.wind_cbankloanstructure.s_info_compcode is '公司id';
comment on column ${iol_schema}.wind_cbankloanstructure.report_period is '报告期';
comment on column ${iol_schema}.wind_cbankloanstructure.statement_type is '报表类型代码';
comment on column ${iol_schema}.wind_cbankloanstructure.crncy_code is '货币代码';
comment on column ${iol_schema}.wind_cbankloanstructure.crncy_type_code is '币种类型代码';
comment on column ${iol_schema}.wind_cbankloanstructure.loan_type_code is '项目类别代码';
comment on column ${iol_schema}.wind_cbankloanstructure.ann_item is '[内部]公布名称';
comment on column ${iol_schema}.wind_cbankloanstructure.loan_item_code is '贷款项目代码';
comment on column ${iol_schema}.wind_cbankloanstructure.total_loans is '贷款余额';
comment on column ${iol_schema}.wind_cbankloanstructure.ave_loans is '贷款平均余额';
comment on column ${iol_schema}.wind_cbankloanstructure.interest_income is '贷款利息收入';
comment on column ${iol_schema}.wind_cbankloanstructure.average_yield is '贷款平均收益率';
comment on column ${iol_schema}.wind_cbankloanstructure.non_performing_loans is '不良贷款余额';
comment on column ${iol_schema}.wind_cbankloanstructure.non_performing_loans_ratio is '不良贷款率(%)';
comment on column ${iol_schema}.wind_cbankloanstructure.memo is '备注';
comment on column ${iol_schema}.wind_cbankloanstructure.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_cbankloanstructure.etl_timestamp is 'ETL处理时间戳';
