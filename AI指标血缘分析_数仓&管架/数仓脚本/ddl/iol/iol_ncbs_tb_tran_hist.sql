/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_tb_tran_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_tb_tran_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_tb_tran_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_tran_hist(
    acct_seq_no varchar2(5) -- 账户子账号
    ,amt_type varchar2(10) -- 金额类型
    ,base_acct_no varchar2(64) -- 交易账号/卡号
    ,branch varchar2(12) -- 机构编号
    ,ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,client_type varchar2(3) -- 客户类型
    ,gl_code varchar2(20) -- 科目代码
    ,prod_type varchar2(12) -- 产品编号
    ,profit_center varchar2(20) -- 利润中心
    ,reference varchar2(50) -- 交易参考号
    ,tran_type varchar2(10) -- 交易类型
    ,user_id varchar2(8) -- 交易柜员编号
    ,channel_seq_no varchar2(33) -- 全局流水号
    ,company varchar2(20) -- 法人
    ,event_type varchar2(20) -- 事件类型
    ,gl_seq_no varchar2(50) -- 总账序号
    ,marketing_prod_desc varchar2(500) -- 营销产品名称
    ,narrative varchar2(400) -- 摘要
    ,post_flag varchar2(1) -- 是否生成分录
    ,reserve_flag varchar2(1) -- 冲正标志
    ,reversal_seq_no varchar2(50) -- 冲正流水号
    ,seq_no varchar2(50) -- 序号
    ,source_module varchar2(3) -- 源模块
    ,source_type varchar2(6) -- 渠道编号
    ,sub_seq_no varchar2(100) -- 系统流水号
    ,system_id varchar2(20) -- 系统id
    ,tae_seq_no varchar2(200) -- tae返回流水号
    ,tran_status varchar2(1) -- 冲补抹标志
    ,accounting_status varchar2(3) -- 核算状态
    ,channel_date date -- 渠道日期
    ,effect_date date -- 产品生效日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_ccy varchar2(3) -- 账户币种
    ,marketing_prod varchar2(12) -- 营销产品
    ,oth_ccy varchar2(3) -- 对手账户币种
    ,pre_reference varchar2(50) -- 原交易参考号
    ,tran_amt number(17,2) -- 交易金额
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,bus_seq_no varchar2(33) -- 业务流水号
    ,oth_base_acct_no varchar2(64) -- 对方账号/卡号
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
grant select on ${iol_schema}.ncbs_tb_tran_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_tb_tran_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_tb_tran_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_tb_tran_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_tb_tran_hist is '公共交易流水表';
comment on column ${iol_schema}.ncbs_tb_tran_hist.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_tb_tran_hist.amt_type is '金额类型';
comment on column ${iol_schema}.ncbs_tb_tran_hist.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_tb_tran_hist.branch is '机构编号';
comment on column ${iol_schema}.ncbs_tb_tran_hist.ccy is '币种';
comment on column ${iol_schema}.ncbs_tb_tran_hist.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_tb_tran_hist.client_type is '客户类型';
comment on column ${iol_schema}.ncbs_tb_tran_hist.gl_code is '科目代码';
comment on column ${iol_schema}.ncbs_tb_tran_hist.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_tb_tran_hist.profit_center is '利润中心';
comment on column ${iol_schema}.ncbs_tb_tran_hist.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_tb_tran_hist.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_tb_tran_hist.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_tb_tran_hist.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_tb_tran_hist.company is '法人';
comment on column ${iol_schema}.ncbs_tb_tran_hist.event_type is '事件类型';
comment on column ${iol_schema}.ncbs_tb_tran_hist.gl_seq_no is '总账序号';
comment on column ${iol_schema}.ncbs_tb_tran_hist.marketing_prod_desc is '营销产品名称';
comment on column ${iol_schema}.ncbs_tb_tran_hist.narrative is '摘要';
comment on column ${iol_schema}.ncbs_tb_tran_hist.post_flag is '是否生成分录';
comment on column ${iol_schema}.ncbs_tb_tran_hist.reserve_flag is '冲正标志';
comment on column ${iol_schema}.ncbs_tb_tran_hist.reversal_seq_no is '冲正流水号';
comment on column ${iol_schema}.ncbs_tb_tran_hist.seq_no is '序号';
comment on column ${iol_schema}.ncbs_tb_tran_hist.source_module is '源模块';
comment on column ${iol_schema}.ncbs_tb_tran_hist.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_tb_tran_hist.sub_seq_no is '系统流水号';
comment on column ${iol_schema}.ncbs_tb_tran_hist.system_id is '系统id';
comment on column ${iol_schema}.ncbs_tb_tran_hist.tae_seq_no is 'tae返回流水号';
comment on column ${iol_schema}.ncbs_tb_tran_hist.tran_status is '冲补抹标志';
comment on column ${iol_schema}.ncbs_tb_tran_hist.accounting_status is '核算状态';
comment on column ${iol_schema}.ncbs_tb_tran_hist.channel_date is '渠道日期';
comment on column ${iol_schema}.ncbs_tb_tran_hist.effect_date is '产品生效日期';
comment on column ${iol_schema}.ncbs_tb_tran_hist.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_tb_tran_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_tb_tran_hist.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_tb_tran_hist.marketing_prod is '营销产品';
comment on column ${iol_schema}.ncbs_tb_tran_hist.oth_ccy is '对手账户币种';
comment on column ${iol_schema}.ncbs_tb_tran_hist.pre_reference is '原交易参考号';
comment on column ${iol_schema}.ncbs_tb_tran_hist.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_tb_tran_hist.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_tb_tran_hist.bus_seq_no is '业务流水号';
comment on column ${iol_schema}.ncbs_tb_tran_hist.oth_base_acct_no is '对方账号/卡号';
comment on column ${iol_schema}.ncbs_tb_tran_hist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_tb_tran_hist.etl_timestamp is 'ETL处理时间戳';
