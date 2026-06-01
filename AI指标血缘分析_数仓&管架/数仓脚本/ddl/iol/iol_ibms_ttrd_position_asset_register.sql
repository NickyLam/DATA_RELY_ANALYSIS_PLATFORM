/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_position_asset_register
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_position_asset_register
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_position_asset_register purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_position_asset_register(
    id number(22) -- 主键
    ,p_type varchar2(75) -- 产品类型
    ,i_code varchar2(75) -- 产品代码
    ,i_name varchar2(383) -- 产品名称
    ,effective_date varchar2(15) -- 生效日
    ,ftp_rate number(10,4) -- ftp利率
    ,remark varchar2(1500) -- 备注
    ,start_date varchar2(15) -- 起息日
    ,mtr_date varchar2(15) -- 到期日
    ,register_type varchar2(2) -- 登记类型 0:ftp 1:风险资产 2:营销机构
    ,project varchar2(30) -- 项目
    ,risk_weight varchar2(30) -- 风险权重
    ,risk_assets_amount number(10,2) -- 风险资产总额
    ,register_date varchar2(15) -- 登记日期
    ,market_inst varchar2(75) -- 
    ,customer_manager varchar2(75) -- 
    ,a_type varchar2(30) -- 资产类型
    ,m_type varchar2(30) -- 市场类型
    ,obj_id varchar2(45) -- 券核算对象id
    ,amount number(31,4) -- 金额
    ,field1 varchar2(384) -- 扩展字段1
    ,field2 varchar2(384) -- 扩展字段2
    ,check_user varchar2(150) -- 复核人
    ,usable_flag number(22,0) -- 
    ,update_user varchar2(150) -- 
    ,secu_acct_id varchar2(45) -- 内部证券账户ID
    ,provision_accrual_prop number(33,8) -- 拨备计提比例
    ,ensure_amt number(31,4) -- 保证金金额(元)
    ,deposit_receipt_amt number(31,4) -- 一般存单金额(元)
    ,wealth_treasure_amt number(31,4) -- 财富盈、财富宝(元)
    ,government_bond_amt number(31,4) -- 国债金额(元)
    ,policy_bank_amt number(31,4) -- 我国政策性银行(元)
    ,common_department_amt number(31,4) -- 我国公共部门实体(元)
    ,other_amt number(31,4) -- 其他(元)
    ,belonger varchar2(30) -- 业绩归属人
    ,head_belonger varchar2(30) -- 总行业绩归属人
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ibms_ttrd_position_asset_register to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_position_asset_register to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_position_asset_register to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_position_asset_register to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_position_asset_register is '持仓资产登记';
comment on column ${iol_schema}.ibms_ttrd_position_asset_register.id is '主键';
comment on column ${iol_schema}.ibms_ttrd_position_asset_register.p_type is '产品类型';
comment on column ${iol_schema}.ibms_ttrd_position_asset_register.i_code is '产品代码';
comment on column ${iol_schema}.ibms_ttrd_position_asset_register.i_name is '产品名称';
comment on column ${iol_schema}.ibms_ttrd_position_asset_register.effective_date is '生效日';
comment on column ${iol_schema}.ibms_ttrd_position_asset_register.ftp_rate is 'ftp利率';
comment on column ${iol_schema}.ibms_ttrd_position_asset_register.remark is '备注';
comment on column ${iol_schema}.ibms_ttrd_position_asset_register.start_date is '起息日';
comment on column ${iol_schema}.ibms_ttrd_position_asset_register.mtr_date is '到期日';
comment on column ${iol_schema}.ibms_ttrd_position_asset_register.register_type is '登记类型 0:ftp 1:风险资产 2:营销机构';
comment on column ${iol_schema}.ibms_ttrd_position_asset_register.project is '项目';
comment on column ${iol_schema}.ibms_ttrd_position_asset_register.risk_weight is '风险权重';
comment on column ${iol_schema}.ibms_ttrd_position_asset_register.risk_assets_amount is '风险资产总额';
comment on column ${iol_schema}.ibms_ttrd_position_asset_register.register_date is '登记日期';
comment on column ${iol_schema}.ibms_ttrd_position_asset_register.market_inst is '';
comment on column ${iol_schema}.ibms_ttrd_position_asset_register.customer_manager is '';
comment on column ${iol_schema}.ibms_ttrd_position_asset_register.a_type is '资产类型';
comment on column ${iol_schema}.ibms_ttrd_position_asset_register.m_type is '市场类型';
comment on column ${iol_schema}.ibms_ttrd_position_asset_register.obj_id is '券核算对象id';
comment on column ${iol_schema}.ibms_ttrd_position_asset_register.amount is '金额';
comment on column ${iol_schema}.ibms_ttrd_position_asset_register.field1 is '扩展字段1';
comment on column ${iol_schema}.ibms_ttrd_position_asset_register.field2 is '扩展字段2';
comment on column ${iol_schema}.ibms_ttrd_position_asset_register.check_user is '复核人';
comment on column ${iol_schema}.ibms_ttrd_position_asset_register.usable_flag is '';
comment on column ${iol_schema}.ibms_ttrd_position_asset_register.update_user is '';
comment on column ${iol_schema}.ibms_ttrd_position_asset_register.secu_acct_id is '内部证券账户ID';
comment on column ${iol_schema}.ibms_ttrd_position_asset_register.provision_accrual_prop is '拨备计提比例';
comment on column ${iol_schema}.ibms_ttrd_position_asset_register.ensure_amt is '保证金金额(元)';
comment on column ${iol_schema}.ibms_ttrd_position_asset_register.deposit_receipt_amt is '一般存单金额(元)';
comment on column ${iol_schema}.ibms_ttrd_position_asset_register.wealth_treasure_amt is '财富盈、财富宝(元)';
comment on column ${iol_schema}.ibms_ttrd_position_asset_register.government_bond_amt is '国债金额(元)';
comment on column ${iol_schema}.ibms_ttrd_position_asset_register.policy_bank_amt is '我国政策性银行(元)';
comment on column ${iol_schema}.ibms_ttrd_position_asset_register.common_department_amt is '我国公共部门实体(元)';
comment on column ${iol_schema}.ibms_ttrd_position_asset_register.other_amt is '其他(元)';
comment on column ${iol_schema}.ibms_ttrd_position_asset_register.belonger is '业绩归属人';
comment on column ${iol_schema}.ibms_ttrd_position_asset_register.head_belonger is '总行业绩归属人';
comment on column ${iol_schema}.ibms_ttrd_position_asset_register.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ibms_ttrd_position_asset_register.etl_timestamp is 'ETL处理时间戳';
