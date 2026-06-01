/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_batch_reserve_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_batch_reserve_info
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_batch_reserve_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_batch_reserve_info(
    reference varchar2(50) -- 交易参考号
    ,close_acct_flag varchar2(1) -- 是否可销户
    ,advanced_amt number(17,2) -- 保函垫款金额
    ,new_settle_base_acct_no varchar2(50) -- 新利息入账账号
    ,register_date date -- 登记日期
    ,ext_trade_no varchar2(50) -- 原业务编号
    ,advanced_next_cycle_date date -- 垫款下一结息日
    ,advanced_branch varchar2(12) -- 垫款发放机构
    ,advanced_int_day varchar2(2) -- 垫款结息日
    ,advanced_cycle_freq varchar2(5) -- 垫款结息频率
    ,ext_ref_no varchar2(50) -- 来单编号
    ,advanced_real_rate number(15,8) -- 垫款执行利率
    ,reserve_amt number(17,2) -- 核心备款金额
    ,trade_type varchar2(30) -- 业务类型
    ,reserve_date date -- 备款日期
    ,advanced_sched_mode varchar2(2) -- 垫款还款方式
    ,from_channel varchar2(30) -- 记录来源
    ,reserve_status varchar2(3) -- 备款状态
    ,advanced_cmisloan_no varchar2(60) -- 垫款借据号
    ,error_desc varchar2(3000) -- 错误描述
    ,corp_size varchar2(5) -- 企业规模
    ,econ_department_type varchar2(200) -- 国民经济部门类型
    ,deal_date date -- 处理日期
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
grant select on ${iol_schema}.ncbs_rb_batch_reserve_info to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_batch_reserve_info to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_batch_reserve_info to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_batch_reserve_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_batch_reserve_info is '备款基础信息表';
comment on column ${iol_schema}.ncbs_rb_batch_reserve_info.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_batch_reserve_info.close_acct_flag is '是否可销户';
comment on column ${iol_schema}.ncbs_rb_batch_reserve_info.advanced_amt is '保函垫款金额';
comment on column ${iol_schema}.ncbs_rb_batch_reserve_info.new_settle_base_acct_no is '新利息入账账号';
comment on column ${iol_schema}.ncbs_rb_batch_reserve_info.register_date is '登记日期';
comment on column ${iol_schema}.ncbs_rb_batch_reserve_info.ext_trade_no is '原业务编号';
comment on column ${iol_schema}.ncbs_rb_batch_reserve_info.advanced_next_cycle_date is '垫款下一结息日';
comment on column ${iol_schema}.ncbs_rb_batch_reserve_info.advanced_branch is '垫款发放机构';
comment on column ${iol_schema}.ncbs_rb_batch_reserve_info.advanced_int_day is '垫款结息日';
comment on column ${iol_schema}.ncbs_rb_batch_reserve_info.advanced_cycle_freq is '垫款结息频率';
comment on column ${iol_schema}.ncbs_rb_batch_reserve_info.ext_ref_no is '来单编号';
comment on column ${iol_schema}.ncbs_rb_batch_reserve_info.advanced_real_rate is '垫款执行利率';
comment on column ${iol_schema}.ncbs_rb_batch_reserve_info.reserve_amt is '核心备款金额';
comment on column ${iol_schema}.ncbs_rb_batch_reserve_info.trade_type is '业务类型';
comment on column ${iol_schema}.ncbs_rb_batch_reserve_info.reserve_date is '备款日期';
comment on column ${iol_schema}.ncbs_rb_batch_reserve_info.advanced_sched_mode is '垫款还款方式';
comment on column ${iol_schema}.ncbs_rb_batch_reserve_info.from_channel is '记录来源';
comment on column ${iol_schema}.ncbs_rb_batch_reserve_info.reserve_status is '备款状态';
comment on column ${iol_schema}.ncbs_rb_batch_reserve_info.advanced_cmisloan_no is '垫款借据号';
comment on column ${iol_schema}.ncbs_rb_batch_reserve_info.error_desc is '错误描述';
comment on column ${iol_schema}.ncbs_rb_batch_reserve_info.corp_size is '企业规模';
comment on column ${iol_schema}.ncbs_rb_batch_reserve_info.econ_department_type is '国民经济部门类型';
comment on column ${iol_schema}.ncbs_rb_batch_reserve_info.deal_date is '处理日期';
comment on column ${iol_schema}.ncbs_rb_batch_reserve_info.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_batch_reserve_info.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_batch_reserve_info.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_batch_reserve_info.etl_timestamp is 'ETL处理时间戳';
