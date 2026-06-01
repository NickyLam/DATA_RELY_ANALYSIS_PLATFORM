/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_accounting_status
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_accounting_status
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_accounting_status purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_accounting_status(
    period_freq varchar2(5) -- 频率id
    ,accounting_status_desc varchar2(50) -- 核算状态描述
    ,alloc_seq_fee varchar2(1) -- 贷款费用还款顺序
    ,alloc_seq_int varchar2(1) -- 贷款利息还款顺序
    ,alloc_seq_odi varchar2(1) -- 贷款复利还款顺序
    ,alloc_seq_odp varchar2(1) -- 贷款罚息还款顺序
    ,alloc_seq_pri varchar2(1) -- 贷款本金还款顺序
    ,alloc_seq_type varchar2(1) -- 贷款自动还款类型
    ,auto_change_flag varchar2(1) -- 自动变化标志
    ,available varchar2(1) -- 是否可交易标识
    ,change_type varchar2(3) -- 变化类型
    ,company varchar2(20) -- 法人
    ,grace_day_flag varchar2(1) -- 是否考虑宽限期
    ,non_performing_flag varchar2(1) -- 是否涉及利息
    ,non_performing_pri_flag varchar2(1) -- 是否涉及本金
    ,suspend_ind varchar2(1) -- 是否久悬
    ,terminate_ind varchar2(1) -- 是否终止
    ,wrn_flag varchar2(1) -- 贷款核销标志
    ,libra_op_time number(15) -- libra执行次数
    ,accounting_status varchar2(3) -- 核算状态
    ,hunting_status varchar2(1) -- 持续扣款标志
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,period_type varchar2(1) -- 敞口期限类型
    ,effect_priority varchar2(2) -- 核算状态生效优先级
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
grant select on ${iol_schema}.ncbs_cl_accounting_status to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_accounting_status to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_accounting_status to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_accounting_status to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_accounting_status is '核算状态变化规则配置';
comment on column ${iol_schema}.ncbs_cl_accounting_status.period_freq is '频率id';
comment on column ${iol_schema}.ncbs_cl_accounting_status.accounting_status_desc is '核算状态描述';
comment on column ${iol_schema}.ncbs_cl_accounting_status.alloc_seq_fee is '贷款费用还款顺序';
comment on column ${iol_schema}.ncbs_cl_accounting_status.alloc_seq_int is '贷款利息还款顺序';
comment on column ${iol_schema}.ncbs_cl_accounting_status.alloc_seq_odi is '贷款复利还款顺序';
comment on column ${iol_schema}.ncbs_cl_accounting_status.alloc_seq_odp is '贷款罚息还款顺序';
comment on column ${iol_schema}.ncbs_cl_accounting_status.alloc_seq_pri is '贷款本金还款顺序';
comment on column ${iol_schema}.ncbs_cl_accounting_status.alloc_seq_type is '贷款自动还款类型';
comment on column ${iol_schema}.ncbs_cl_accounting_status.auto_change_flag is '自动变化标志';
comment on column ${iol_schema}.ncbs_cl_accounting_status.available is '是否可交易标识';
comment on column ${iol_schema}.ncbs_cl_accounting_status.change_type is '变化类型';
comment on column ${iol_schema}.ncbs_cl_accounting_status.company is '法人';
comment on column ${iol_schema}.ncbs_cl_accounting_status.grace_day_flag is '是否考虑宽限期';
comment on column ${iol_schema}.ncbs_cl_accounting_status.non_performing_flag is '是否涉及利息';
comment on column ${iol_schema}.ncbs_cl_accounting_status.non_performing_pri_flag is '是否涉及本金';
comment on column ${iol_schema}.ncbs_cl_accounting_status.suspend_ind is '是否久悬';
comment on column ${iol_schema}.ncbs_cl_accounting_status.terminate_ind is '是否终止';
comment on column ${iol_schema}.ncbs_cl_accounting_status.wrn_flag is '贷款核销标志';
comment on column ${iol_schema}.ncbs_cl_accounting_status.libra_op_time is 'libra执行次数';
comment on column ${iol_schema}.ncbs_cl_accounting_status.accounting_status is '核算状态';
comment on column ${iol_schema}.ncbs_cl_accounting_status.hunting_status is '持续扣款标志';
comment on column ${iol_schema}.ncbs_cl_accounting_status.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_accounting_status.period_type is '敞口期限类型';
comment on column ${iol_schema}.ncbs_cl_accounting_status.effect_priority is '核算状态生效优先级';
comment on column ${iol_schema}.ncbs_cl_accounting_status.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_accounting_status.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_accounting_status.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_accounting_status.etl_timestamp is 'ETL处理时间戳';
