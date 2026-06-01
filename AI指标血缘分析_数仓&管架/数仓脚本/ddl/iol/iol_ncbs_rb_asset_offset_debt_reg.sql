/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_asset_offset_debt_reg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_asset_offset_debt_reg
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_asset_offset_debt_reg purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_asset_offset_debt_reg(
    base_acct_no varchar2(50) -- 交易账号/卡号
    ,acct_desc varchar2(200) -- 账户描述
    ,prod_type varchar2(12) -- 产品编号
    ,ccy varchar2(3) -- 账户币种
    ,internal_key number(15) -- 账户内部键值
    ,client_no varchar2(16) -- 客户编号
    ,individual_flag varchar2(1) -- 对公对私标志
    ,branch varchar2(12) -- 开户机构编号
    ,amt_type varchar2(10) -- 金额类型
    ,balance number(17,2) -- 金额
    ,cr_dr_ind varchar2(1) -- 借贷标志
    ,oth_real_base_acct_no varchar2(50) -- 真实交易对手账号
    ,oth_real_tran_name varchar2(200) -- 真实交易对手名称
    ,reference varchar2(50) -- 交易参考号
    ,channel_seq_no varchar2(33) -- 全局流水号
    ,reversal_flag varchar2(1) -- 交易是否已冲正
    ,gl_posted_flag varchar2(1) -- 过账标记
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
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
grant select on ${iol_schema}.ncbs_rb_asset_offset_debt_reg to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_asset_offset_debt_reg to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_asset_offset_debt_reg to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_asset_offset_debt_reg to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_asset_offset_debt_reg is '以资抵债登记表';
comment on column ${iol_schema}.ncbs_rb_asset_offset_debt_reg.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_asset_offset_debt_reg.acct_desc is '账户描述';
comment on column ${iol_schema}.ncbs_rb_asset_offset_debt_reg.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_asset_offset_debt_reg.ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_asset_offset_debt_reg.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_asset_offset_debt_reg.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_asset_offset_debt_reg.individual_flag is '对公对私标志';
comment on column ${iol_schema}.ncbs_rb_asset_offset_debt_reg.branch is '开户机构编号';
comment on column ${iol_schema}.ncbs_rb_asset_offset_debt_reg.amt_type is '金额类型';
comment on column ${iol_schema}.ncbs_rb_asset_offset_debt_reg.balance is '金额';
comment on column ${iol_schema}.ncbs_rb_asset_offset_debt_reg.cr_dr_ind is '借贷标志';
comment on column ${iol_schema}.ncbs_rb_asset_offset_debt_reg.oth_real_base_acct_no is '真实交易对手账号';
comment on column ${iol_schema}.ncbs_rb_asset_offset_debt_reg.oth_real_tran_name is '真实交易对手名称';
comment on column ${iol_schema}.ncbs_rb_asset_offset_debt_reg.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_asset_offset_debt_reg.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_rb_asset_offset_debt_reg.reversal_flag is '交易是否已冲正';
comment on column ${iol_schema}.ncbs_rb_asset_offset_debt_reg.gl_posted_flag is '过账标记';
comment on column ${iol_schema}.ncbs_rb_asset_offset_debt_reg.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_asset_offset_debt_reg.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_asset_offset_debt_reg.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_asset_offset_debt_reg.etl_timestamp is 'ETL处理时间戳';
