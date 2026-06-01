/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_acct_protocol_master
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_acct_protocol_master
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_acct_protocol_master purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_acct_protocol_master(
    id varchar2(30) -- 主键
    ,accid varchar2(45) -- 同业赢活期账户id
    ,settle_period varchar2(30) -- 结息周期
    ,start_date varchar2(30) -- 开始日期
    ,expire_date varchar2(30) -- 到期日期
    ,early_end_date varchar2(30) -- 提前结束日期
    ,amount number(31,4) -- 约期金额
    ,amount_rate number(10,6) -- 约期金额利率
    ,break_rate number(10,6) -- 约期违约利率
    ,current_rate number(10,6) -- 约期活期利率
    ,contract_no varchar2(180) -- 合约号
    ,usable_flag number(22,0) -- 是否已生效：1： 正常 0： 新增
    ,operate varchar2(8) -- 操作状态 add 新增  edit 修改
    ,ctrct_id varchar2(75) -- 确认单编号
    ,first_payment_date varchar2(30) -- 首次付息日
    ,is_monthly_mode varchar2(2) -- 是否月均模式
    ,is_near_rate_mode varchar2(2) -- 是否支持靠档模式
    ,stride_month_rate number(10,6) -- 跨月利率
    ,not_stride_month_rate number(10,6) -- 不跨月利率
    ,stride_month_remark varchar2(180) -- 跨月说明
    ,not_stride_month_remark varchar2(180) -- 不跨月说明
    ,fix_settle_period varchar2(30) -- 约期结息频率
    ,end_date varchar2(15) -- 协议结束日
    ,remark varchar2(825) -- 备注
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
grant select on ${iol_schema}.ibms_ttrd_acct_protocol_master to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_acct_protocol_master to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_acct_protocol_master to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_acct_protocol_master to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_acct_protocol_master is '主协议账户表';
comment on column ${iol_schema}.ibms_ttrd_acct_protocol_master.id is '主键';
comment on column ${iol_schema}.ibms_ttrd_acct_protocol_master.accid is '同业赢活期账户id';
comment on column ${iol_schema}.ibms_ttrd_acct_protocol_master.settle_period is '结息周期';
comment on column ${iol_schema}.ibms_ttrd_acct_protocol_master.start_date is '开始日期';
comment on column ${iol_schema}.ibms_ttrd_acct_protocol_master.expire_date is '到期日期';
comment on column ${iol_schema}.ibms_ttrd_acct_protocol_master.early_end_date is '提前结束日期';
comment on column ${iol_schema}.ibms_ttrd_acct_protocol_master.amount is '约期金额';
comment on column ${iol_schema}.ibms_ttrd_acct_protocol_master.amount_rate is '约期金额利率';
comment on column ${iol_schema}.ibms_ttrd_acct_protocol_master.break_rate is '约期违约利率';
comment on column ${iol_schema}.ibms_ttrd_acct_protocol_master.current_rate is '约期活期利率';
comment on column ${iol_schema}.ibms_ttrd_acct_protocol_master.contract_no is '合约号';
comment on column ${iol_schema}.ibms_ttrd_acct_protocol_master.usable_flag is '是否已生效：1： 正常 0： 新增';
comment on column ${iol_schema}.ibms_ttrd_acct_protocol_master.operate is '操作状态 add 新增  edit 修改';
comment on column ${iol_schema}.ibms_ttrd_acct_protocol_master.ctrct_id is '确认单编号';
comment on column ${iol_schema}.ibms_ttrd_acct_protocol_master.first_payment_date is '首次付息日';
comment on column ${iol_schema}.ibms_ttrd_acct_protocol_master.is_monthly_mode is '是否月均模式';
comment on column ${iol_schema}.ibms_ttrd_acct_protocol_master.is_near_rate_mode is '是否支持靠档模式';
comment on column ${iol_schema}.ibms_ttrd_acct_protocol_master.stride_month_rate is '跨月利率';
comment on column ${iol_schema}.ibms_ttrd_acct_protocol_master.not_stride_month_rate is '不跨月利率';
comment on column ${iol_schema}.ibms_ttrd_acct_protocol_master.stride_month_remark is '跨月说明';
comment on column ${iol_schema}.ibms_ttrd_acct_protocol_master.not_stride_month_remark is '不跨月说明';
comment on column ${iol_schema}.ibms_ttrd_acct_protocol_master.fix_settle_period is '约期结息频率';
comment on column ${iol_schema}.ibms_ttrd_acct_protocol_master.end_date is '协议结束日';
comment on column ${iol_schema}.ibms_ttrd_acct_protocol_master.remark is '备注';
comment on column ${iol_schema}.ibms_ttrd_acct_protocol_master.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_acct_protocol_master.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_acct_protocol_master.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_acct_protocol_master.etl_timestamp is 'ETL处理时间戳';
