/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol lmis_asset_lessee_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.lmis_asset_lessee_info
whenever sqlerror continue none;
drop table ${iol_schema}.lmis_asset_lessee_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.lmis_asset_lessee_info(
    id number(22) -- 承租资产id
    ,asset_id number(22) -- 资产id
    ,line_num number(22) -- 行号
    ,contract_id number(22) -- 承租合同id
    ,contract_code varchar2(75) -- 合同编号
    ,contract_name varchar2(150) -- 合同名称
    ,contract_effect_date timestamp -- 合同生效日
    ,lessor varchar2(150) -- 出租方
    ,operate_type varchar2(75) -- 操作类型
    ,book_code varchar2(30) -- 账簿代码
    ,asset_number varchar2(75) -- 资产编号
    ,tag_number varchar2(23) -- 资产标签号
    ,asset_type varchar2(15) -- 资产类型
    ,asset_name varchar2(450) -- 资产名称
    ,asset_category_id number(22) -- 资产类别id
    ,company_id number(22) -- 使用机构
    ,department_id number(22) -- 使用部门
    ,quantity number(22) -- 数量
    ,lessee_status varchar2(23) -- 状态
    ,account_status varchar2(23) -- 凭证状态
    ,prepayment_amount number(22) -- 预付账款（不含税）
    ,other_direct_cost number(22) -- 其他直接费用（不含税）
    ,lease_liability_pay_amt_tax number(22) -- 租赁负债-应付租赁款（含税）
    ,lease_liability_pay_amt number(22) -- 租赁负债-应付租赁款（不含税）
    ,lease_liability_bal number(22) -- 租赁负债
    ,lease_liability_int_bal number(22) -- 租赁负债-未确认融资费用
    ,asset_amount number(22) -- 使用权资产-原值
    ,deducted_tax number(22) -- 其他待抵扣进项税额
    ,lease_begin_date timestamp -- 租赁开始日
    ,lease_end_date timestamp -- 租赁到期日
    ,lease_life_month number(22) -- 租赁期限（月）
    ,amount_tax number(22) -- 税额
    ,amount_no_tax number(22) -- 计划付款总额（不含税）
    ,amount_with_tax number(22) -- 计划付款总额（含税）
    ,discount_rule_code varchar2(75) -- 折现规则代码
    ,year_discount_rate number(22) -- 折现率（年）
    ,day_discount_rate number(22) -- 折现率（日）
    ,date_effective timestamp -- 有效日期（记账日期）
    ,date_ineffective timestamp -- 失效日期
    ,transaction_header_id_in number(22) -- 事物处理生效头id
    ,transaction_header_id_out number(22) -- 事物处理失效头id
    ,tenant_id number(22) -- 租户id
    ,created_by number(22) -- 创建人
    ,created_date timestamp -- 创建时间
    ,last_updated_by number(22) -- 最后更新人
    ,last_updated_date timestamp -- 最后更新时间
    ,version_number number(22) -- 版本号
    ,memo varchar2(1200) -- 备注说明
    ,deposit_amount number(22) -- 押金
    ,lessee_scope number(22) -- 租赁范围
    ,monthly_rent_amt number(22) -- 月租金（含税）
    ,tax_rate number(22) -- 税率（%）
    ,pay_frequency varchar2(45) -- 付款频率
    ,plan_payment_date timestamp -- 首期计划付款日
    ,fund_growth_rate number(22) -- 资金增长率
    ,fund_growth_date timestamp -- 资金增长率起始日
    ,create_mode varchar2(45) -- 创建方式
    ,attachment_oid varchar2(300) -- 附件oid
    ,lease_id number(22) -- asset_lessee_contract_identify表id
    ,area number(22) -- 面积
    ,termin_fine number(22) -- 终止罚金
    ,buy_right_price number(22) -- 购买行权价
    ,recovery_cost number(22) -- 预计复原成本
    ,residual_value number(22) -- 剩余价值担保金额
    ,urge_measure_amount number(22) -- 激励措施金
    ,invoice_type varchar2(300) -- 发票类型
    ,rent_pay_amt number(22) -- 应付租赁款
    ,lease_usage varchar2(300) -- 租赁用途
    ,pay_type varchar2(300) -- 支付方式
    ,deduction_flag varchar2(3) -- 是否可抵扣
    ,i16_begin_date timestamp -- 准则起始日
    ,lessee_prepay_amount number(22) -- 预付待摊余额
    ,company_code varchar2(300) -- 公司code
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
grant select on ${iol_schema}.lmis_asset_lessee_info to ${iml_schema};
grant select on ${iol_schema}.lmis_asset_lessee_info to ${icl_schema};
grant select on ${iol_schema}.lmis_asset_lessee_info to ${idl_schema};
grant select on ${iol_schema}.lmis_asset_lessee_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.lmis_asset_lessee_info is '承租租赁资产基础信息表';
comment on column ${iol_schema}.lmis_asset_lessee_info.id is '承租资产id';
comment on column ${iol_schema}.lmis_asset_lessee_info.asset_id is '资产id';
comment on column ${iol_schema}.lmis_asset_lessee_info.line_num is '行号';
comment on column ${iol_schema}.lmis_asset_lessee_info.contract_id is '承租合同id';
comment on column ${iol_schema}.lmis_asset_lessee_info.contract_code is '合同编号';
comment on column ${iol_schema}.lmis_asset_lessee_info.contract_name is '合同名称';
comment on column ${iol_schema}.lmis_asset_lessee_info.contract_effect_date is '合同生效日';
comment on column ${iol_schema}.lmis_asset_lessee_info.lessor is '出租方';
comment on column ${iol_schema}.lmis_asset_lessee_info.operate_type is '操作类型';
comment on column ${iol_schema}.lmis_asset_lessee_info.book_code is '账簿代码';
comment on column ${iol_schema}.lmis_asset_lessee_info.asset_number is '资产编号';
comment on column ${iol_schema}.lmis_asset_lessee_info.tag_number is '资产标签号';
comment on column ${iol_schema}.lmis_asset_lessee_info.asset_type is '资产类型';
comment on column ${iol_schema}.lmis_asset_lessee_info.asset_name is '资产名称';
comment on column ${iol_schema}.lmis_asset_lessee_info.asset_category_id is '资产类别id';
comment on column ${iol_schema}.lmis_asset_lessee_info.company_id is '使用机构';
comment on column ${iol_schema}.lmis_asset_lessee_info.department_id is '使用部门';
comment on column ${iol_schema}.lmis_asset_lessee_info.quantity is '数量';
comment on column ${iol_schema}.lmis_asset_lessee_info.lessee_status is '状态';
comment on column ${iol_schema}.lmis_asset_lessee_info.account_status is '凭证状态';
comment on column ${iol_schema}.lmis_asset_lessee_info.prepayment_amount is '预付账款（不含税）';
comment on column ${iol_schema}.lmis_asset_lessee_info.other_direct_cost is '其他直接费用（不含税）';
comment on column ${iol_schema}.lmis_asset_lessee_info.lease_liability_pay_amt_tax is '租赁负债-应付租赁款（含税）';
comment on column ${iol_schema}.lmis_asset_lessee_info.lease_liability_pay_amt is '租赁负债-应付租赁款（不含税）';
comment on column ${iol_schema}.lmis_asset_lessee_info.lease_liability_bal is '租赁负债';
comment on column ${iol_schema}.lmis_asset_lessee_info.lease_liability_int_bal is '租赁负债-未确认融资费用';
comment on column ${iol_schema}.lmis_asset_lessee_info.asset_amount is '使用权资产-原值';
comment on column ${iol_schema}.lmis_asset_lessee_info.deducted_tax is '其他待抵扣进项税额';
comment on column ${iol_schema}.lmis_asset_lessee_info.lease_begin_date is '租赁开始日';
comment on column ${iol_schema}.lmis_asset_lessee_info.lease_end_date is '租赁到期日';
comment on column ${iol_schema}.lmis_asset_lessee_info.lease_life_month is '租赁期限（月）';
comment on column ${iol_schema}.lmis_asset_lessee_info.amount_tax is '税额';
comment on column ${iol_schema}.lmis_asset_lessee_info.amount_no_tax is '计划付款总额（不含税）';
comment on column ${iol_schema}.lmis_asset_lessee_info.amount_with_tax is '计划付款总额（含税）';
comment on column ${iol_schema}.lmis_asset_lessee_info.discount_rule_code is '折现规则代码';
comment on column ${iol_schema}.lmis_asset_lessee_info.year_discount_rate is '折现率（年）';
comment on column ${iol_schema}.lmis_asset_lessee_info.day_discount_rate is '折现率（日）';
comment on column ${iol_schema}.lmis_asset_lessee_info.date_effective is '有效日期（记账日期）';
comment on column ${iol_schema}.lmis_asset_lessee_info.date_ineffective is '失效日期';
comment on column ${iol_schema}.lmis_asset_lessee_info.transaction_header_id_in is '事物处理生效头id';
comment on column ${iol_schema}.lmis_asset_lessee_info.transaction_header_id_out is '事物处理失效头id';
comment on column ${iol_schema}.lmis_asset_lessee_info.tenant_id is '租户id';
comment on column ${iol_schema}.lmis_asset_lessee_info.created_by is '创建人';
comment on column ${iol_schema}.lmis_asset_lessee_info.created_date is '创建时间';
comment on column ${iol_schema}.lmis_asset_lessee_info.last_updated_by is '最后更新人';
comment on column ${iol_schema}.lmis_asset_lessee_info.last_updated_date is '最后更新时间';
comment on column ${iol_schema}.lmis_asset_lessee_info.version_number is '版本号';
comment on column ${iol_schema}.lmis_asset_lessee_info.memo is '备注说明';
comment on column ${iol_schema}.lmis_asset_lessee_info.deposit_amount is '押金';
comment on column ${iol_schema}.lmis_asset_lessee_info.lessee_scope is '租赁范围';
comment on column ${iol_schema}.lmis_asset_lessee_info.monthly_rent_amt is '月租金（含税）';
comment on column ${iol_schema}.lmis_asset_lessee_info.tax_rate is '税率（%）';
comment on column ${iol_schema}.lmis_asset_lessee_info.pay_frequency is '付款频率';
comment on column ${iol_schema}.lmis_asset_lessee_info.plan_payment_date is '首期计划付款日';
comment on column ${iol_schema}.lmis_asset_lessee_info.fund_growth_rate is '资金增长率';
comment on column ${iol_schema}.lmis_asset_lessee_info.fund_growth_date is '资金增长率起始日';
comment on column ${iol_schema}.lmis_asset_lessee_info.create_mode is '创建方式';
comment on column ${iol_schema}.lmis_asset_lessee_info.attachment_oid is '附件oid';
comment on column ${iol_schema}.lmis_asset_lessee_info.lease_id is 'asset_lessee_contract_identify表id';
comment on column ${iol_schema}.lmis_asset_lessee_info.area is '面积';
comment on column ${iol_schema}.lmis_asset_lessee_info.termin_fine is '终止罚金';
comment on column ${iol_schema}.lmis_asset_lessee_info.buy_right_price is '购买行权价';
comment on column ${iol_schema}.lmis_asset_lessee_info.recovery_cost is '预计复原成本';
comment on column ${iol_schema}.lmis_asset_lessee_info.residual_value is '剩余价值担保金额';
comment on column ${iol_schema}.lmis_asset_lessee_info.urge_measure_amount is '激励措施金';
comment on column ${iol_schema}.lmis_asset_lessee_info.invoice_type is '发票类型';
comment on column ${iol_schema}.lmis_asset_lessee_info.rent_pay_amt is '应付租赁款';
comment on column ${iol_schema}.lmis_asset_lessee_info.lease_usage is '租赁用途';
comment on column ${iol_schema}.lmis_asset_lessee_info.pay_type is '支付方式';
comment on column ${iol_schema}.lmis_asset_lessee_info.deduction_flag is '是否可抵扣';
comment on column ${iol_schema}.lmis_asset_lessee_info.i16_begin_date is '准则起始日';
comment on column ${iol_schema}.lmis_asset_lessee_info.lessee_prepay_amount is '预付待摊余额';
comment on column ${iol_schema}.lmis_asset_lessee_info.company_code is '公司code';
comment on column ${iol_schema}.lmis_asset_lessee_info.start_dt is '开始时间';
comment on column ${iol_schema}.lmis_asset_lessee_info.end_dt is '结束时间';
comment on column ${iol_schema}.lmis_asset_lessee_info.id_mark is '增删标志';
comment on column ${iol_schema}.lmis_asset_lessee_info.etl_timestamp is 'ETL处理时间戳';
