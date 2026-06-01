/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_cross_border_rmb
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_cross_border_rmb
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_cross_border_rmb purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_cross_border_rmb(
    accid varchar2(30) -- 账户代码
    ,accname varchar2(180) -- 账户名称
    ,exhacc varchar2(45) -- 交易所账户（账号）
    ,customer_id varchar2(45) -- 客户（交易对手）编码
    ,customer_name varchar2(150) -- 客户（交易对手）名称
    ,start_date varchar2(15) -- 开始日
    ,mtr_date varchar2(15) -- 到期日
    ,interest_acc_mode varchar2(48) -- 结息周期
    ,early_end_date varchar2(15) -- 提前结束日
    ,is_agree_amount_fixed varchar2(2) -- 约定金额是否固定，0：是，1：否
    ,agree_amount number(31,6) -- 约定金额
    ,agree_amount_rate number(31,6) -- 约定金额利率
    ,agree_current_rate number(31,6) -- 约定活期利率
    ,agree_break_contract_rate number(31,6) -- 约定违约利率
    ,contract_no varchar2(48) -- 合约号
    ,id varchar2(48) -- 唯一标识
    ,is_delete varchar2(2) -- 是否删除
    ,first_payment_date varchar2(15) -- 首次付息日
    ,break_info_flag varchar2(2) -- 是否有违约条款
    ,gear_prod_flag varchar2(2) -- 是否支持靠档模式
    ,agree_freq varchar2(48) -- 约期结息频率
    ,end_date varchar2(15) -- 协议结束日
    ,remark varchar2(825) -- 备注
    ,is_monthly_mode varchar2(2) -- 是否月均模式
    ,stride_month_rate number(10,6) -- 跨月利率
    ,not_stride_month_rate number(10,6) -- 不跨月利率
    ,stride_month_remark varchar2(180) -- 跨月说明
    ,not_stride_month_remark varchar2(180) -- 不跨月说明
    ,near_rate_json varchar2(4000) -- 靠档利率JSON(按余额)
    ,multy_mode varchar2(2) -- 多档模式
    ,core_status varchar2(2) -- 核心状态
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
grant select on ${iol_schema}.ibms_ttrd_cross_border_rmb to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_cross_border_rmb to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_cross_border_rmb to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_cross_border_rmb to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_cross_border_rmb is '跨境人民币同业往来账户维护表';
comment on column ${iol_schema}.ibms_ttrd_cross_border_rmb.accid is '账户代码';
comment on column ${iol_schema}.ibms_ttrd_cross_border_rmb.accname is '账户名称';
comment on column ${iol_schema}.ibms_ttrd_cross_border_rmb.exhacc is '交易所账户（账号）';
comment on column ${iol_schema}.ibms_ttrd_cross_border_rmb.customer_id is '客户（交易对手）编码';
comment on column ${iol_schema}.ibms_ttrd_cross_border_rmb.customer_name is '客户（交易对手）名称';
comment on column ${iol_schema}.ibms_ttrd_cross_border_rmb.start_date is '开始日';
comment on column ${iol_schema}.ibms_ttrd_cross_border_rmb.mtr_date is '到期日';
comment on column ${iol_schema}.ibms_ttrd_cross_border_rmb.interest_acc_mode is '结息周期';
comment on column ${iol_schema}.ibms_ttrd_cross_border_rmb.early_end_date is '提前结束日';
comment on column ${iol_schema}.ibms_ttrd_cross_border_rmb.is_agree_amount_fixed is '约定金额是否固定，0：是，1：否';
comment on column ${iol_schema}.ibms_ttrd_cross_border_rmb.agree_amount is '约定金额';
comment on column ${iol_schema}.ibms_ttrd_cross_border_rmb.agree_amount_rate is '约定金额利率';
comment on column ${iol_schema}.ibms_ttrd_cross_border_rmb.agree_current_rate is '约定活期利率';
comment on column ${iol_schema}.ibms_ttrd_cross_border_rmb.agree_break_contract_rate is '约定违约利率';
comment on column ${iol_schema}.ibms_ttrd_cross_border_rmb.contract_no is '合约号';
comment on column ${iol_schema}.ibms_ttrd_cross_border_rmb.id is '唯一标识';
comment on column ${iol_schema}.ibms_ttrd_cross_border_rmb.is_delete is '是否删除';
comment on column ${iol_schema}.ibms_ttrd_cross_border_rmb.first_payment_date is '首次付息日';
comment on column ${iol_schema}.ibms_ttrd_cross_border_rmb.break_info_flag is '是否有违约条款';
comment on column ${iol_schema}.ibms_ttrd_cross_border_rmb.gear_prod_flag is '是否支持靠档模式';
comment on column ${iol_schema}.ibms_ttrd_cross_border_rmb.agree_freq is '约期结息频率';
comment on column ${iol_schema}.ibms_ttrd_cross_border_rmb.end_date is '协议结束日';
comment on column ${iol_schema}.ibms_ttrd_cross_border_rmb.remark is '备注';
comment on column ${iol_schema}.ibms_ttrd_cross_border_rmb.is_monthly_mode is '是否月均模式';
comment on column ${iol_schema}.ibms_ttrd_cross_border_rmb.stride_month_rate is '跨月利率';
comment on column ${iol_schema}.ibms_ttrd_cross_border_rmb.not_stride_month_rate is '不跨月利率';
comment on column ${iol_schema}.ibms_ttrd_cross_border_rmb.stride_month_remark is '跨月说明';
comment on column ${iol_schema}.ibms_ttrd_cross_border_rmb.not_stride_month_remark is '不跨月说明';
comment on column ${iol_schema}.ibms_ttrd_cross_border_rmb.near_rate_json is '靠档利率JSON(按余额)';
comment on column ${iol_schema}.ibms_ttrd_cross_border_rmb.multy_mode is '多档模式';
comment on column ${iol_schema}.ibms_ttrd_cross_border_rmb.core_status is '核心状态';
comment on column ${iol_schema}.ibms_ttrd_cross_border_rmb.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_cross_border_rmb.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_cross_border_rmb.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_cross_border_rmb.etl_timestamp is 'ETL处理时间戳';
