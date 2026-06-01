/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_plan_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_plan_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_plan_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_plan_hist(
    amount number(17,2) -- 金额
    ,amt_type varchar2(10) -- 金额类型
    ,client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,period_freq varchar2(5) -- 频率id
    ,user_id varchar2(8) -- 交易柜员编号
    ,company varchar2(20) -- 法人
    ,event_type varchar2(20) -- 事件类型
    ,plan_no varchar2(50) -- 执行计划编号
    ,plan_status varchar2(1) -- 计划状态
    ,reserve1 varchar2(50) -- 预留字段1
    ,reserve2 varchar2(50) -- 预留字段2
    ,total_times number(5) -- 扣划总次数
    ,end_date date -- 结束日期
    ,last_change_date date -- 最后修改日期
    ,last_deal_date date -- 上一处理日
    ,next_deal_date date -- 下一处理日
    ,start_date date -- 开始日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,deal_day varchar2(2) -- 处理日
    ,last_change_user_id varchar2(8) -- 最后修改柜员
    ,loan_no varchar2(50) -- 贷款号
    ,total_amt number(17,2) -- 总金额
    ,tran_branch varchar2(12) -- 核心交易机构编号
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
grant select on ${iol_schema}.ncbs_cl_plan_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_plan_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_plan_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_plan_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_plan_hist is '贷款执行计划历史表';
comment on column ${iol_schema}.ncbs_cl_plan_hist.amount is '金额';
comment on column ${iol_schema}.ncbs_cl_plan_hist.amt_type is '金额类型';
comment on column ${iol_schema}.ncbs_cl_plan_hist.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_plan_hist.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_cl_plan_hist.period_freq is '频率id';
comment on column ${iol_schema}.ncbs_cl_plan_hist.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_cl_plan_hist.company is '法人';
comment on column ${iol_schema}.ncbs_cl_plan_hist.event_type is '事件类型';
comment on column ${iol_schema}.ncbs_cl_plan_hist.plan_no is '执行计划编号';
comment on column ${iol_schema}.ncbs_cl_plan_hist.plan_status is '计划状态';
comment on column ${iol_schema}.ncbs_cl_plan_hist.reserve1 is '预留字段1';
comment on column ${iol_schema}.ncbs_cl_plan_hist.reserve2 is '预留字段2';
comment on column ${iol_schema}.ncbs_cl_plan_hist.total_times is '扣划总次数';
comment on column ${iol_schema}.ncbs_cl_plan_hist.end_date is '结束日期';
comment on column ${iol_schema}.ncbs_cl_plan_hist.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_cl_plan_hist.last_deal_date is '上一处理日';
comment on column ${iol_schema}.ncbs_cl_plan_hist.next_deal_date is '下一处理日';
comment on column ${iol_schema}.ncbs_cl_plan_hist.start_date is '开始日期';
comment on column ${iol_schema}.ncbs_cl_plan_hist.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_cl_plan_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_plan_hist.deal_day is '处理日';
comment on column ${iol_schema}.ncbs_cl_plan_hist.last_change_user_id is '最后修改柜员';
comment on column ${iol_schema}.ncbs_cl_plan_hist.loan_no is '贷款号';
comment on column ${iol_schema}.ncbs_cl_plan_hist.total_amt is '总金额';
comment on column ${iol_schema}.ncbs_cl_plan_hist.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_cl_plan_hist.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_plan_hist.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_plan_hist.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_plan_hist.etl_timestamp is 'ETL处理时间戳';
