/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_tb_cash_sign_deal_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_tb_cash_sign_deal_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_tb_cash_sign_deal_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_cash_sign_deal_hist(
    acct_name varchar2(200) -- 账户名称
    ,acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,document_id varchar2(60) -- 证件号码
    ,document_type varchar2(4) -- 客户证件类型
    ,prod_type varchar2(12) -- 产品编号
    ,reference varchar2(50) -- 交易参考号
    ,tran_type varchar2(10) -- 交易类型
    ,cash_from_to varchar2(1) -- 资金去向来源
    ,cash_item varchar2(10) -- 现金项目
    ,cash_sign_type varchar2(1) -- 长短款标记
    ,cash_sign_id varchar2(50) -- 现金长短款汇总编号
    ,cash_sign_no varchar2(50) -- 长短款明细编号
    ,company varchar2(20) -- 法人
    ,narrative varchar2(400) -- 摘要
    ,cash_sign_deal_no varchar2(50) -- 长短款明细处理序号
    ,reserve_flag varchar2(1) -- 冲正标志
    ,seq_no varchar2(50) -- 序号
    ,effect_date date -- 产品生效日期
    ,cash_sign_deal_date date -- 长短钞处理日期
    ,reversal_date date -- 冲正日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_ccy varchar2(3) -- 账户币种
    ,auth_user_id varchar2(8) -- 授权柜员
    ,cash_sign_deal_branch varchar2(12) -- 处理机构
    ,cash_sign_deal_user varchar2(8) -- 现金长短款处理柜员
    ,reversal_auth_user_id varchar2(8) -- 冲正授权柜员
    ,reversal_user_id varchar2(8) -- 冲正柜员
    ,tran_amt number(17,2) -- 交易金额
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
grant select on ${iol_schema}.ncbs_tb_cash_sign_deal_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_tb_cash_sign_deal_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_tb_cash_sign_deal_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_tb_cash_sign_deal_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_tb_cash_sign_deal_hist is '现金长短款挂账处理信息表';
comment on column ${iol_schema}.ncbs_tb_cash_sign_deal_hist.acct_name is '账户名称';
comment on column ${iol_schema}.ncbs_tb_cash_sign_deal_hist.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_tb_cash_sign_deal_hist.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_tb_cash_sign_deal_hist.ccy is '币种';
comment on column ${iol_schema}.ncbs_tb_cash_sign_deal_hist.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_tb_cash_sign_deal_hist.document_id is '证件号码';
comment on column ${iol_schema}.ncbs_tb_cash_sign_deal_hist.document_type is '客户证件类型';
comment on column ${iol_schema}.ncbs_tb_cash_sign_deal_hist.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_tb_cash_sign_deal_hist.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_tb_cash_sign_deal_hist.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_tb_cash_sign_deal_hist.cash_from_to is '资金去向来源';
comment on column ${iol_schema}.ncbs_tb_cash_sign_deal_hist.cash_item is '现金项目';
comment on column ${iol_schema}.ncbs_tb_cash_sign_deal_hist.cash_sign_type is '长短款标记';
comment on column ${iol_schema}.ncbs_tb_cash_sign_deal_hist.cash_sign_id is '现金长短款汇总编号';
comment on column ${iol_schema}.ncbs_tb_cash_sign_deal_hist.cash_sign_no is '长短款明细编号';
comment on column ${iol_schema}.ncbs_tb_cash_sign_deal_hist.company is '法人';
comment on column ${iol_schema}.ncbs_tb_cash_sign_deal_hist.narrative is '摘要';
comment on column ${iol_schema}.ncbs_tb_cash_sign_deal_hist.cash_sign_deal_no is '长短款明细处理序号';
comment on column ${iol_schema}.ncbs_tb_cash_sign_deal_hist.reserve_flag is '冲正标志';
comment on column ${iol_schema}.ncbs_tb_cash_sign_deal_hist.seq_no is '序号';
comment on column ${iol_schema}.ncbs_tb_cash_sign_deal_hist.effect_date is '产品生效日期';
comment on column ${iol_schema}.ncbs_tb_cash_sign_deal_hist.cash_sign_deal_date is '长短钞处理日期';
comment on column ${iol_schema}.ncbs_tb_cash_sign_deal_hist.reversal_date is '冲正日期';
comment on column ${iol_schema}.ncbs_tb_cash_sign_deal_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_tb_cash_sign_deal_hist.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_tb_cash_sign_deal_hist.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_tb_cash_sign_deal_hist.cash_sign_deal_branch is '处理机构';
comment on column ${iol_schema}.ncbs_tb_cash_sign_deal_hist.cash_sign_deal_user is '现金长短款处理柜员';
comment on column ${iol_schema}.ncbs_tb_cash_sign_deal_hist.reversal_auth_user_id is '冲正授权柜员';
comment on column ${iol_schema}.ncbs_tb_cash_sign_deal_hist.reversal_user_id is '冲正柜员';
comment on column ${iol_schema}.ncbs_tb_cash_sign_deal_hist.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_tb_cash_sign_deal_hist.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_tb_cash_sign_deal_hist.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_tb_cash_sign_deal_hist.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_tb_cash_sign_deal_hist.etl_timestamp is 'ETL处理时间戳';
