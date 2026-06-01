/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_inter_bank_main
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_inter_bank_main
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_inter_bank_main purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_inter_bank_main(
    ccy varchar2(6) -- 币种
    ,client_no varchar2(32) -- 客户编号
    ,cmisloan_no varchar2(60) -- 客户借据编号
    ,mature_date date -- 到期日
    ,int_start_date date -- 起息日
    ,int_rate number(15,8) -- 出单利率
    ,odp_rate number(15,8) -- 贷款罚息利率
    ,inter_bank_busi_no varchar2(400) -- 同业代付业务编号
    ,prod_type varchar2(24) -- 产品编号
    ,year_basis varchar2(6) -- 年基准天数
    ,month_basis varchar2(6) -- 月基准
    ,inter_bank_status varchar2(2) -- 同业代付状态
    ,timestamp varchar2(52) -- 时间戳
    ,is_last_pay_agent varchar2(2) -- 是否最后一次代付
    ,contract_no varchar2(60) -- 合同编号
    ,home_branch varchar2(24) -- 客户管理行
    ,closed_date date -- 关闭日期
    ,internal_key number(15) -- 账户内部键值
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
grant select on ${iol_schema}.ncbs_cl_inter_bank_main to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_inter_bank_main to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_inter_bank_main to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_inter_bank_main to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_inter_bank_main is '同业代付登记簿主表';
comment on column ${iol_schema}.ncbs_cl_inter_bank_main.ccy is '币种';
comment on column ${iol_schema}.ncbs_cl_inter_bank_main.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_inter_bank_main.cmisloan_no is '客户借据编号';
comment on column ${iol_schema}.ncbs_cl_inter_bank_main.mature_date is '到期日';
comment on column ${iol_schema}.ncbs_cl_inter_bank_main.int_start_date is '起息日';
comment on column ${iol_schema}.ncbs_cl_inter_bank_main.int_rate is '出单利率';
comment on column ${iol_schema}.ncbs_cl_inter_bank_main.odp_rate is '贷款罚息利率';
comment on column ${iol_schema}.ncbs_cl_inter_bank_main.inter_bank_busi_no is '同业代付业务编号';
comment on column ${iol_schema}.ncbs_cl_inter_bank_main.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_cl_inter_bank_main.year_basis is '年基准天数';
comment on column ${iol_schema}.ncbs_cl_inter_bank_main.month_basis is '月基准';
comment on column ${iol_schema}.ncbs_cl_inter_bank_main.inter_bank_status is '同业代付状态';
comment on column ${iol_schema}.ncbs_cl_inter_bank_main.timestamp is '时间戳';
comment on column ${iol_schema}.ncbs_cl_inter_bank_main.is_last_pay_agent is '是否最后一次代付';
comment on column ${iol_schema}.ncbs_cl_inter_bank_main.contract_no is '合同编号';
comment on column ${iol_schema}.ncbs_cl_inter_bank_main.home_branch is '客户管理行';
comment on column ${iol_schema}.ncbs_cl_inter_bank_main.closed_date is '关闭日期';
comment on column ${iol_schema}.ncbs_cl_inter_bank_main.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_cl_inter_bank_main.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_inter_bank_main.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_inter_bank_main.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_inter_bank_main.etl_timestamp is 'ETL处理时间戳';
