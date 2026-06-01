/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_mb_fee_type
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_mb_fee_type
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_mb_fee_type purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_mb_fee_type(
    amortize_month varchar2(2) -- 摊销月
    ,amortize_time_type varchar2(1) -- 摊销时间类型
    ,bo_ind varchar2(1) -- 日终/联机标志
    ,boundary_amt_id varchar2(30) -- 缺口计算金额编码
    ,boundary_desc varchar2(50) -- 缺口描述
    ,ccy_flag varchar2(1) -- 收费币种标识
    ,company varchar2(20) -- 法人
    ,convert_flag varchar2(1) -- 折算标志
    ,disc_type varchar2(2) -- 折扣类型
    ,fee_amt_id varchar2(30) -- 费用计算金额编码
    ,fee_desc varchar2(200) -- 费用类型描述
    ,fee_item varchar2(10) -- 费用项目代码
    ,fee_mode varchar2(1) -- 收费定价方式
    ,fee_type varchar2(20) -- 费率类型
    ,prod_grp varchar2(3) -- 产品组
    ,profit_allot_flag varchar2(1) -- 是否需要分润
    ,profit_amortize_flag varchar2(1) -- 是否需要摊销
    ,tax_type varchar2(2) -- 税种
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,amortize_day varchar2(2) -- 摊销日
    ,amortize_period_type varchar2(1) -- 摊销期限类型
    ,mb_ccy_type varchar2(3) -- 目标收费币种
    ,open_branch_percent number(11,7) -- 账户行比例
    ,tran_branch_percent number(11,7) -- 交易行比例,记录百分数
    ,accr_flag varchar2(1) -- 是否需要计提
    ,fee_price_standard varchar2(3000) -- 
    ,fee_standard_discount_remark varchar2(3000) -- 
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
grant select on ${iol_schema}.ncbs_mb_fee_type to ${iml_schema};
grant select on ${iol_schema}.ncbs_mb_fee_type to ${icl_schema};
grant select on ${iol_schema}.ncbs_mb_fee_type to ${idl_schema};
grant select on ${iol_schema}.ncbs_mb_fee_type to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_mb_fee_type is '费用类型表';
comment on column ${iol_schema}.ncbs_mb_fee_type.amortize_month is '摊销月';
comment on column ${iol_schema}.ncbs_mb_fee_type.amortize_time_type is '摊销时间类型';
comment on column ${iol_schema}.ncbs_mb_fee_type.bo_ind is '日终/联机标志';
comment on column ${iol_schema}.ncbs_mb_fee_type.boundary_amt_id is '缺口计算金额编码';
comment on column ${iol_schema}.ncbs_mb_fee_type.boundary_desc is '缺口描述';
comment on column ${iol_schema}.ncbs_mb_fee_type.ccy_flag is '收费币种标识';
comment on column ${iol_schema}.ncbs_mb_fee_type.company is '法人';
comment on column ${iol_schema}.ncbs_mb_fee_type.convert_flag is '折算标志';
comment on column ${iol_schema}.ncbs_mb_fee_type.disc_type is '折扣类型';
comment on column ${iol_schema}.ncbs_mb_fee_type.fee_amt_id is '费用计算金额编码';
comment on column ${iol_schema}.ncbs_mb_fee_type.fee_desc is '费用类型描述';
comment on column ${iol_schema}.ncbs_mb_fee_type.fee_item is '费用项目代码';
comment on column ${iol_schema}.ncbs_mb_fee_type.fee_mode is '收费定价方式';
comment on column ${iol_schema}.ncbs_mb_fee_type.fee_type is '费率类型';
comment on column ${iol_schema}.ncbs_mb_fee_type.prod_grp is '产品组';
comment on column ${iol_schema}.ncbs_mb_fee_type.profit_allot_flag is '是否需要分润';
comment on column ${iol_schema}.ncbs_mb_fee_type.profit_amortize_flag is '是否需要摊销';
comment on column ${iol_schema}.ncbs_mb_fee_type.tax_type is '税种';
comment on column ${iol_schema}.ncbs_mb_fee_type.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_mb_fee_type.amortize_day is '摊销日';
comment on column ${iol_schema}.ncbs_mb_fee_type.amortize_period_type is '摊销期限类型';
comment on column ${iol_schema}.ncbs_mb_fee_type.mb_ccy_type is '目标收费币种';
comment on column ${iol_schema}.ncbs_mb_fee_type.open_branch_percent is '账户行比例';
comment on column ${iol_schema}.ncbs_mb_fee_type.tran_branch_percent is '交易行比例,记录百分数';
comment on column ${iol_schema}.ncbs_mb_fee_type.accr_flag is '是否需要计提';
comment on column ${iol_schema}.ncbs_mb_fee_type.fee_price_standard is '';
comment on column ${iol_schema}.ncbs_mb_fee_type.fee_standard_discount_remark is '';
comment on column ${iol_schema}.ncbs_mb_fee_type.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_mb_fee_type.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_mb_fee_type.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_mb_fee_type.etl_timestamp is 'ETL处理时间戳';
