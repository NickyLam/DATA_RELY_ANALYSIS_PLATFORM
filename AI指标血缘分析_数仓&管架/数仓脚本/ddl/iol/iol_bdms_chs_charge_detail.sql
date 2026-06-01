/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_chs_charge_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_chs_charge_detail
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_chs_charge_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_chs_charge_detail(
    id varchar2(60) -- ID
    ,mem_no varchar2(9) -- 会员代码
    ,mem_name varchar2(675) -- 会员名称
    ,charge_period varchar2(9) -- 服务费期数
    ,busi_date varchar2(12) -- 业务发生日期
    ,branch_no varchar2(30) -- 票据所属机构号
    ,top_branch_no varchar2(30) -- 总行机构号
    ,brh_no varchar2(14) -- 机构代码
    ,brh_name varchar2(270) -- 机构名称
    ,contract_id varchar2(60) -- 业务批次表ID
    ,contract_no varchar2(60) -- 业务表批次号
    ,details_id varchar2(60) -- 明细表ID
    ,draft_number varchar2(45) -- 票号
    ,busi_amount number(18,2) -- 业务金额
    ,charge_item varchar2(2) -- 收费项目： 0 交易手续费 1 账户维护费 2 结算过户费 3 其他结算费
    ,charge_standard varchar2(75) -- 收费标准
    ,busi_type varchar2(6) -- 业务类型： 00 转贴现 01 质押式回购 02 买断式回购 03 转贴现 纯票过户 04 转贴现 票款兑付 05 质押式回购 纯票过户 06 质押式回购 票款对付 07 买断式回购 纯票过户 08 买断式回购 票款对付 09 跨机构权属登记 10 已贴现票据质押 11 非交易过户 12 提前/逾期赎回 13 已贴现票据托收 14 追偿结算 15 票交所资金账户扣划 16 信息更正 17 未贴现票据背书转让 18 未贴现票据托收
    ,total_amt number(18,2) -- 计费总额
    ,rebate_amt number(18,2) -- 优惠金额
    ,fee_amt number(18,2) -- 应缴金额
    ,deal_operator varchar2(45) -- 批量处理操作员
    ,deal_time varchar2(21) -- 操作处理时间
    ,tenor_days number(8,0) -- 持票期限
    ,misc varchar2(384) -- 备注
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
grant select on ${iol_schema}.bdms_chs_charge_detail to ${iml_schema};
grant select on ${iol_schema}.bdms_chs_charge_detail to ${icl_schema};
grant select on ${iol_schema}.bdms_chs_charge_detail to ${idl_schema};
grant select on ${iol_schema}.bdms_chs_charge_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_chs_charge_detail is '计费明细信息表';
comment on column ${iol_schema}.bdms_chs_charge_detail.id is 'ID';
comment on column ${iol_schema}.bdms_chs_charge_detail.mem_no is '会员代码';
comment on column ${iol_schema}.bdms_chs_charge_detail.mem_name is '会员名称';
comment on column ${iol_schema}.bdms_chs_charge_detail.charge_period is '服务费期数';
comment on column ${iol_schema}.bdms_chs_charge_detail.busi_date is '业务发生日期';
comment on column ${iol_schema}.bdms_chs_charge_detail.branch_no is '票据所属机构号';
comment on column ${iol_schema}.bdms_chs_charge_detail.top_branch_no is '总行机构号';
comment on column ${iol_schema}.bdms_chs_charge_detail.brh_no is '机构代码';
comment on column ${iol_schema}.bdms_chs_charge_detail.brh_name is '机构名称';
comment on column ${iol_schema}.bdms_chs_charge_detail.contract_id is '业务批次表ID';
comment on column ${iol_schema}.bdms_chs_charge_detail.contract_no is '业务表批次号';
comment on column ${iol_schema}.bdms_chs_charge_detail.details_id is '明细表ID';
comment on column ${iol_schema}.bdms_chs_charge_detail.draft_number is '票号';
comment on column ${iol_schema}.bdms_chs_charge_detail.busi_amount is '业务金额';
comment on column ${iol_schema}.bdms_chs_charge_detail.charge_item is '收费项目： 0 交易手续费 1 账户维护费 2 结算过户费 3 其他结算费';
comment on column ${iol_schema}.bdms_chs_charge_detail.charge_standard is '收费标准';
comment on column ${iol_schema}.bdms_chs_charge_detail.busi_type is '业务类型： 00 转贴现 01 质押式回购 02 买断式回购 03 转贴现 纯票过户 04 转贴现 票款兑付 05 质押式回购 纯票过户 06 质押式回购 票款对付 07 买断式回购 纯票过户 08 买断式回购 票款对付 09 跨机构权属登记 10 已贴现票据质押 11 非交易过户 12 提前/逾期赎回 13 已贴现票据托收 14 追偿结算 15 票交所资金账户扣划 16 信息更正 17 未贴现票据背书转让 18 未贴现票据托收';
comment on column ${iol_schema}.bdms_chs_charge_detail.total_amt is '计费总额';
comment on column ${iol_schema}.bdms_chs_charge_detail.rebate_amt is '优惠金额';
comment on column ${iol_schema}.bdms_chs_charge_detail.fee_amt is '应缴金额';
comment on column ${iol_schema}.bdms_chs_charge_detail.deal_operator is '批量处理操作员';
comment on column ${iol_schema}.bdms_chs_charge_detail.deal_time is '操作处理时间';
comment on column ${iol_schema}.bdms_chs_charge_detail.tenor_days is '持票期限';
comment on column ${iol_schema}.bdms_chs_charge_detail.misc is '备注';
comment on column ${iol_schema}.bdms_chs_charge_detail.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_chs_charge_detail.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_chs_charge_detail.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_chs_charge_detail.etl_timestamp is 'ETL处理时间戳';
