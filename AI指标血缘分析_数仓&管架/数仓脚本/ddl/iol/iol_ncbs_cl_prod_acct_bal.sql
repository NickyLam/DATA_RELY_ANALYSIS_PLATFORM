/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_prod_acct_bal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_prod_acct_bal
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_prod_acct_bal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_prod_acct_bal(
    amt_type varchar2(10) -- 金额类型
    ,balance number(17,2) -- 余额
    ,branch varchar2(12) -- 机构编号
    ,ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,gl_code varchar2(20) -- 科目代码
    ,prod_type varchar2(12) -- 产品编号
    ,profit_center varchar2(20) -- 利润中心
    ,company varchar2(20) -- 法人
    ,seq_no varchar2(50) -- 序号
    ,system_id varchar2(20) -- 系统id
    ,tran_category varchar2(5) -- 交易种类
    ,accounting_status varchar2(3) -- 核算状态
    ,last_change_date date -- 最后修改日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
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
grant select on ${iol_schema}.ncbs_cl_prod_acct_bal to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_prod_acct_bal to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_prod_acct_bal to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_prod_acct_bal to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_prod_acct_bal is '产品分户余额表';
comment on column ${iol_schema}.ncbs_cl_prod_acct_bal.amt_type is '金额类型';
comment on column ${iol_schema}.ncbs_cl_prod_acct_bal.balance is '余额';
comment on column ${iol_schema}.ncbs_cl_prod_acct_bal.branch is '机构编号';
comment on column ${iol_schema}.ncbs_cl_prod_acct_bal.ccy is '币种';
comment on column ${iol_schema}.ncbs_cl_prod_acct_bal.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_prod_acct_bal.gl_code is '科目代码';
comment on column ${iol_schema}.ncbs_cl_prod_acct_bal.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_cl_prod_acct_bal.profit_center is '利润中心';
comment on column ${iol_schema}.ncbs_cl_prod_acct_bal.company is '法人';
comment on column ${iol_schema}.ncbs_cl_prod_acct_bal.seq_no is '序号';
comment on column ${iol_schema}.ncbs_cl_prod_acct_bal.system_id is '系统id';
comment on column ${iol_schema}.ncbs_cl_prod_acct_bal.tran_category is '交易种类';
comment on column ${iol_schema}.ncbs_cl_prod_acct_bal.accounting_status is '核算状态';
comment on column ${iol_schema}.ncbs_cl_prod_acct_bal.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_cl_prod_acct_bal.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_prod_acct_bal.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_prod_acct_bal.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_prod_acct_bal.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_prod_acct_bal.etl_timestamp is 'ETL处理时间戳';
