/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_order
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_order
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_order purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_order(
    order_seq_no varchar2(50) -- 预约登记号
    ,order_no varchar2(50) -- 预约编号
    ,order_effect_date date -- 贷款预约生效日期
    ,order_type varchar2(10) -- 预约项目类型
    ,order_status varchar2(1) -- 预约状态
    ,client_no varchar2(16) -- 客户编号
    ,loan_no varchar2(50) -- 贷款号
    ,prod_type varchar2(12) -- 产品编号
    ,acct_ccy varchar2(3) -- 账户币种
    ,dd_no number(5,0) -- 发放号
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,tran_date date -- 交易日期
    ,order_exec_status varchar2(1) -- 预约执行状态
    ,failure_reason varchar2(200) -- 失败原因
    ,source_module varchar2(3) -- 源模块
    ,appr_user_id varchar2(8) -- 复核柜员
    ,auth_user_id varchar2(8) -- 授权柜员
    ,user_id varchar2(8) -- 交易柜员编号
    ,company varchar2(20) -- 法人
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
grant select on ${iol_schema}.ncbs_cl_order to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_order to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_order to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_order to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_order is '预约业务登记表|记录贷款预约类交易数据';
comment on column ${iol_schema}.ncbs_cl_order.order_seq_no is '预约登记号';
comment on column ${iol_schema}.ncbs_cl_order.order_no is '预约编号';
comment on column ${iol_schema}.ncbs_cl_order.order_effect_date is '贷款预约生效日期';
comment on column ${iol_schema}.ncbs_cl_order.order_type is '预约项目类型';
comment on column ${iol_schema}.ncbs_cl_order.order_status is '预约状态';
comment on column ${iol_schema}.ncbs_cl_order.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_order.loan_no is '贷款号';
comment on column ${iol_schema}.ncbs_cl_order.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_cl_order.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_cl_order.dd_no is '发放号';
comment on column ${iol_schema}.ncbs_cl_order.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_cl_order.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_cl_order.order_exec_status is '预约执行状态';
comment on column ${iol_schema}.ncbs_cl_order.failure_reason is '失败原因';
comment on column ${iol_schema}.ncbs_cl_order.source_module is '源模块';
comment on column ${iol_schema}.ncbs_cl_order.appr_user_id is '复核柜员';
comment on column ${iol_schema}.ncbs_cl_order.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_cl_order.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_cl_order.company is '法人';
comment on column ${iol_schema}.ncbs_cl_order.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_order.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_order.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_order.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_order.etl_timestamp is 'ETL处理时间戳';
