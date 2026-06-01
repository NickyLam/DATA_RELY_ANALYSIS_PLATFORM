/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_other_order_smooth_depo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_other_order_smooth_depo
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_other_order_smooth_depo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_other_order_smooth_depo(
    id number(20) -- 自增主键
    ,ord_id varchar2(75) -- 审批单号
    ,entity_type varchar2(5) -- 非交易类型 214- 顺心存定期签约 215-顺心存定期解约
    ,acct_id varchar2(30) -- 定期账号
    ,ext_cash_acctid varchar2(30) -- 活期账号
    ,sign_beg_date varchar2(15) -- 签约起始日
    ,sign_end_date varchar2(15) -- 签约到期日
    ,repo_term number(10) -- 实际占款天数
    ,depo_term varchar2(45) -- 定期期限
    ,in_rate number(10,6) -- 存款利率
    ,in_amount number(12,2) -- 存款金额
    ,advance_rate number(10,6) -- 提支利率
    ,overdue_rate number(10,6) -- 逾期利率
    ,accumulated_mode varchar2(2) -- 滚存模式 1-单利 2-复利
    ,daycount varchar2(45) -- 计息基准
    ,sign_type varchar2(2) -- 签约状态 1-已签约 2- 已解约
    ,contract_number varchar2(150) -- 合约号
    ,break_cause varchar2(2) -- 解约原因 1-解约 2-提前支取
    ,break_date varchar2(15) -- 解约日期
    ,memo varchar2(3000) -- 备注
    ,operator_user_id number(19) -- 发起人
    ,operator_org_id number(19) -- 发起机构
    ,operator_time varchar2(29) -- 发起时间
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
grant select on ${iol_schema}.ibms_ttrd_other_order_smooth_depo to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_other_order_smooth_depo to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_other_order_smooth_depo to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_other_order_smooth_depo to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_other_order_smooth_depo is '顺心存定期签约解约表';
comment on column ${iol_schema}.ibms_ttrd_other_order_smooth_depo.id is '自增主键';
comment on column ${iol_schema}.ibms_ttrd_other_order_smooth_depo.ord_id is '审批单号';
comment on column ${iol_schema}.ibms_ttrd_other_order_smooth_depo.entity_type is '非交易类型 214- 顺心存定期签约 215-顺心存定期解约';
comment on column ${iol_schema}.ibms_ttrd_other_order_smooth_depo.acct_id is '定期账号';
comment on column ${iol_schema}.ibms_ttrd_other_order_smooth_depo.ext_cash_acctid is '活期账号';
comment on column ${iol_schema}.ibms_ttrd_other_order_smooth_depo.sign_beg_date is '签约起始日';
comment on column ${iol_schema}.ibms_ttrd_other_order_smooth_depo.sign_end_date is '签约到期日';
comment on column ${iol_schema}.ibms_ttrd_other_order_smooth_depo.repo_term is '实际占款天数';
comment on column ${iol_schema}.ibms_ttrd_other_order_smooth_depo.depo_term is '定期期限';
comment on column ${iol_schema}.ibms_ttrd_other_order_smooth_depo.in_rate is '存款利率';
comment on column ${iol_schema}.ibms_ttrd_other_order_smooth_depo.in_amount is '存款金额';
comment on column ${iol_schema}.ibms_ttrd_other_order_smooth_depo.advance_rate is '提支利率';
comment on column ${iol_schema}.ibms_ttrd_other_order_smooth_depo.overdue_rate is '逾期利率';
comment on column ${iol_schema}.ibms_ttrd_other_order_smooth_depo.accumulated_mode is '滚存模式 1-单利 2-复利';
comment on column ${iol_schema}.ibms_ttrd_other_order_smooth_depo.daycount is '计息基准';
comment on column ${iol_schema}.ibms_ttrd_other_order_smooth_depo.sign_type is '签约状态 1-已签约 2- 已解约';
comment on column ${iol_schema}.ibms_ttrd_other_order_smooth_depo.contract_number is '合约号';
comment on column ${iol_schema}.ibms_ttrd_other_order_smooth_depo.break_cause is '解约原因 1-解约 2-提前支取';
comment on column ${iol_schema}.ibms_ttrd_other_order_smooth_depo.break_date is '解约日期';
comment on column ${iol_schema}.ibms_ttrd_other_order_smooth_depo.memo is '备注';
comment on column ${iol_schema}.ibms_ttrd_other_order_smooth_depo.operator_user_id is '发起人';
comment on column ${iol_schema}.ibms_ttrd_other_order_smooth_depo.operator_org_id is '发起机构';
comment on column ${iol_schema}.ibms_ttrd_other_order_smooth_depo.operator_time is '发起时间';
comment on column ${iol_schema}.ibms_ttrd_other_order_smooth_depo.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_other_order_smooth_depo.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_other_order_smooth_depo.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_other_order_smooth_depo.etl_timestamp is 'ETL处理时间戳';
