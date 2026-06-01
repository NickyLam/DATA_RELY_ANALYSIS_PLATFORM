/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_dc_stage_define_attach
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_dc_stage_define_attach
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_dc_stage_define_attach purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_dc_stage_define_attach(
    trf_out_fee_type varchar2(12) -- 转出费用类型
    ,sell_branch varchar2(500) -- 出售分行或者出售机构
    ,change_min_amt number(17,2) -- 期次最小变动金额
    ,client_type varchar2(3) -- 客户类型
    ,int_type varchar2(5) -- 利率类型
    ,user_id varchar2(8) -- 交易柜员编号
    ,company varchar2(20) -- 法人
    ,email varchar2(200) -- 电子邮件
    ,inland_offshore varchar2(1) -- 境内境外标志
    ,settle_acct_type varchar2(1) -- 结算账户类型
    ,stage_code varchar2(50) -- 期次代码
    ,trf_flag varchar2(1) -- 转让标志
    ,int_start_date date -- 起息日
    ,maturity_date date -- 到期日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,available_limit number(17,2) -- 可用额度
    ,float_rate number(15,8) -- 浮动利率
    ,keep_min_bal number(17,2) -- 最小留存金额
    ,real_rate number(15,8) -- 执行利率
    ,sg_max_amt number(17,2) -- 单笔认购最大金额
    ,sg_min_amt number(17,2) -- 单次最小支取金额
    ,spread_percent number(11,7) -- 浮动百分比
    ,tohonor_rate number(15,8) -- 赎回利率
    ,on_sale_channel varchar2(100) -- 产品可售渠道
    ,prod_desc_address varchar2(200) -- 产品说明书链接
    ,redemption_int_type varchar2(5) -- 大额存单赎回利率类型
    ,trf_in_fee_type varchar2(12) -- 转入费用类型
    ,trf_in_fee_amt number(17,2) -- 转入费用
    ,comb_prod_flag varchar2(1) -- 是否组合产品
    ,allow_fund_source_inner_flag varchar2(1) -- 是否允许资金来源为内部户
    ,redemption_int_flag varchar2(2) -- 赎回利率标识
    ,int_start_flag varchar2(1) -- 起息标识
    ,direction_charge_int_flag varchar2(1) -- 指定收息标志
    ,promissory_redeem_date date -- 原约定赎回日期
    ,trf_out_fee_amt number(17,2) -- 转出费用
    ,un_white_view_flag varchar2(1) -- 
    ,om_apply_no varchar2(50) -- 
    ,roll_issue_flag varchar2(1) -- 
    ,roll_start_date date -- 
    ,roll_end_date date -- 
    ,redeem_term_type varchar2(1) -- 
    ,redeem_term varchar2(5) -- 
    ,white_change_flag varchar2(1) -- 
    ,white_support_branch varchar2(500) -- 
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
grant select on ${iol_schema}.ncbs_rb_dc_stage_define_attach to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_dc_stage_define_attach to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_dc_stage_define_attach to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_dc_stage_define_attach to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_dc_stage_define_attach is '期次定义附加表';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define_attach.trf_out_fee_type is '转出费用类型';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define_attach.sell_branch is '出售分行或者出售机构';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define_attach.change_min_amt is '期次最小变动金额';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define_attach.client_type is '客户类型';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define_attach.int_type is '利率类型';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define_attach.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define_attach.company is '法人';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define_attach.email is '电子邮件';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define_attach.inland_offshore is '境内境外标志';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define_attach.settle_acct_type is '结算账户类型';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define_attach.stage_code is '期次代码';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define_attach.trf_flag is '转让标志';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define_attach.int_start_date is '起息日';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define_attach.maturity_date is '到期日期';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define_attach.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define_attach.available_limit is '可用额度';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define_attach.float_rate is '浮动利率';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define_attach.keep_min_bal is '最小留存金额';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define_attach.real_rate is '执行利率';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define_attach.sg_max_amt is '单笔认购最大金额';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define_attach.sg_min_amt is '单次最小支取金额';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define_attach.spread_percent is '浮动百分比';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define_attach.tohonor_rate is '赎回利率';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define_attach.on_sale_channel is '产品可售渠道';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define_attach.prod_desc_address is '产品说明书链接';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define_attach.redemption_int_type is '大额存单赎回利率类型';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define_attach.trf_in_fee_type is '转入费用类型';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define_attach.trf_in_fee_amt is '转入费用';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define_attach.comb_prod_flag is '是否组合产品';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define_attach.allow_fund_source_inner_flag is '是否允许资金来源为内部户';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define_attach.redemption_int_flag is '赎回利率标识';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define_attach.int_start_flag is '起息标识';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define_attach.direction_charge_int_flag is '指定收息标志';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define_attach.promissory_redeem_date is '原约定赎回日期';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define_attach.trf_out_fee_amt is '转出费用';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define_attach.un_white_view_flag is '';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define_attach.om_apply_no is '';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define_attach.roll_issue_flag is '';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define_attach.roll_start_date is '';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define_attach.roll_end_date is '';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define_attach.redeem_term_type is '';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define_attach.redeem_term is '';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define_attach.white_change_flag is '';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define_attach.white_support_branch is '';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define_attach.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define_attach.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define_attach.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define_attach.etl_timestamp is 'ETL处理时间戳';
