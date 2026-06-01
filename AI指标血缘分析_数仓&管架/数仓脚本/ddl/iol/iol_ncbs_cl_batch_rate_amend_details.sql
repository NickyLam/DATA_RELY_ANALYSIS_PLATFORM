/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_batch_rate_amend_details
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_batch_rate_amend_details
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_batch_rate_amend_details purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_batch_rate_amend_details(
    branch varchar2(12) -- 机构编号
    ,ccy varchar2(3) -- 币种
    ,dd_no number(5) -- 发放号
    ,prod_type varchar2(12) -- 产品编号
    ,batch_no varchar2(50) -- 批次号
    ,calc_by_int varchar2(1) -- 是否按正常利率浮动
    ,company varchar2(20) -- 法人
    ,error_code varchar2(50) -- 错误码
    ,int_appl_type varchar2(1) -- 利率启用方式
    ,job_run_id varchar2(50) -- 批处理任务id
    ,rate_effect_type varchar2(1) -- 利率生效方式
    ,ret_msg varchar2(3000) -- 服务状态描述
    ,seq_no varchar2(50) -- 序号
    ,status varchar2(1) -- 状态
    ,int_class varchar2(6) -- 利息分类
    ,effect_date date -- 产品生效日期
    ,new_next_roll_date date -- 新利率变更日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,loan_no varchar2(50) -- 贷款号
    ,new_int_type varchar2(5) -- 新利率类型
    ,new_real_rate number(15,8) -- 新执行利率
    ,new_roll_day varchar2(2) -- 新利率变更日
    ,new_roll_freq varchar2(5) -- 新利率变更周期
    ,new_spread_percent number(11,7) -- 新利率浮动百分比
    ,new_spread_rate number(15,8) -- 新浮动点数
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
grant select on ${iol_schema}.ncbs_cl_batch_rate_amend_details to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_batch_rate_amend_details to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_batch_rate_amend_details to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_batch_rate_amend_details to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_batch_rate_amend_details is '批量利率变更明细表';
comment on column ${iol_schema}.ncbs_cl_batch_rate_amend_details.branch is '机构编号';
comment on column ${iol_schema}.ncbs_cl_batch_rate_amend_details.ccy is '币种';
comment on column ${iol_schema}.ncbs_cl_batch_rate_amend_details.dd_no is '发放号';
comment on column ${iol_schema}.ncbs_cl_batch_rate_amend_details.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_cl_batch_rate_amend_details.batch_no is '批次号';
comment on column ${iol_schema}.ncbs_cl_batch_rate_amend_details.calc_by_int is '是否按正常利率浮动';
comment on column ${iol_schema}.ncbs_cl_batch_rate_amend_details.company is '法人';
comment on column ${iol_schema}.ncbs_cl_batch_rate_amend_details.error_code is '错误码';
comment on column ${iol_schema}.ncbs_cl_batch_rate_amend_details.int_appl_type is '利率启用方式';
comment on column ${iol_schema}.ncbs_cl_batch_rate_amend_details.job_run_id is '批处理任务id';
comment on column ${iol_schema}.ncbs_cl_batch_rate_amend_details.rate_effect_type is '利率生效方式';
comment on column ${iol_schema}.ncbs_cl_batch_rate_amend_details.ret_msg is '服务状态描述';
comment on column ${iol_schema}.ncbs_cl_batch_rate_amend_details.seq_no is '序号';
comment on column ${iol_schema}.ncbs_cl_batch_rate_amend_details.status is '状态';
comment on column ${iol_schema}.ncbs_cl_batch_rate_amend_details.int_class is '利息分类';
comment on column ${iol_schema}.ncbs_cl_batch_rate_amend_details.effect_date is '产品生效日期';
comment on column ${iol_schema}.ncbs_cl_batch_rate_amend_details.new_next_roll_date is '新利率变更日期';
comment on column ${iol_schema}.ncbs_cl_batch_rate_amend_details.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_batch_rate_amend_details.loan_no is '贷款号';
comment on column ${iol_schema}.ncbs_cl_batch_rate_amend_details.new_int_type is '新利率类型';
comment on column ${iol_schema}.ncbs_cl_batch_rate_amend_details.new_real_rate is '新执行利率';
comment on column ${iol_schema}.ncbs_cl_batch_rate_amend_details.new_roll_day is '新利率变更日';
comment on column ${iol_schema}.ncbs_cl_batch_rate_amend_details.new_roll_freq is '新利率变更周期';
comment on column ${iol_schema}.ncbs_cl_batch_rate_amend_details.new_spread_percent is '新利率浮动百分比';
comment on column ${iol_schema}.ncbs_cl_batch_rate_amend_details.new_spread_rate is '新浮动点数';
comment on column ${iol_schema}.ncbs_cl_batch_rate_amend_details.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_batch_rate_amend_details.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_batch_rate_amend_details.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_batch_rate_amend_details.etl_timestamp is 'ETL处理时间戳';
