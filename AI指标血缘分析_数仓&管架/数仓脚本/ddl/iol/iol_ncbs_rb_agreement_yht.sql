/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_agreement_yht
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_agreement_yht
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_agreement_yht purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_agreement_yht(
    acct_name varchar2(200) -- 账户名称
    ,acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,acct_real_flag varchar2(1) -- 账户虚实标志
    ,agreement_id varchar2(50) -- 协议编号
    ,agreement_status varchar2(2) -- 协议状态
    ,company varchar2(20) -- 法人
    ,int_flag varchar2(1) -- 是否扣划利息标志
    ,iss_od_flag varchar2(1) -- 是否透支
    ,main_agreement_id varchar2(50) -- 主协议协议号
    ,next_max_seq_no varchar2(20) -- 下级账户最大序号
    ,non_transplant_flag varchar2(1) -- 是否未移植数据
    ,self_flag varchar2(1) -- 自有资金子账户标识
    ,settle_ind varchar2(1) -- 账户结算模式
    ,source_type varchar2(6) -- 渠道编号
    ,yht_acct_flag varchar2(1) -- 一户通账户标志
    ,yht_acct_level varchar2(3) -- 一户通账户层级
    ,yht_acct_main_flag varchar2(1) -- 一户通主账户标志
    ,yht_acct_org_schema varchar2(2) -- 一户通账户结构模式
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_ccy varchar2(3) -- 账户币种
    ,alt_acct_name varchar2(200) -- 备用账户名称
    ,parent_internal_key number(15) -- 上级账户标识符
    ,yht_prod_type varchar2(12) -- 一户通产品类型
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
grant select on ${iol_schema}.ncbs_rb_agreement_yht to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_agreement_yht to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_agreement_yht to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_agreement_yht to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_agreement_yht is '一户通子协议表';
comment on column ${iol_schema}.ncbs_rb_agreement_yht.acct_name is '账户名称';
comment on column ${iol_schema}.ncbs_rb_agreement_yht.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_agreement_yht.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_agreement_yht.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_agreement_yht.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_agreement_yht.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_agreement_yht.acct_real_flag is '账户虚实标志';
comment on column ${iol_schema}.ncbs_rb_agreement_yht.agreement_id is '协议编号';
comment on column ${iol_schema}.ncbs_rb_agreement_yht.agreement_status is '协议状态';
comment on column ${iol_schema}.ncbs_rb_agreement_yht.company is '法人';
comment on column ${iol_schema}.ncbs_rb_agreement_yht.int_flag is '是否扣划利息标志';
comment on column ${iol_schema}.ncbs_rb_agreement_yht.iss_od_flag is '是否透支';
comment on column ${iol_schema}.ncbs_rb_agreement_yht.main_agreement_id is '主协议协议号';
comment on column ${iol_schema}.ncbs_rb_agreement_yht.next_max_seq_no is '下级账户最大序号';
comment on column ${iol_schema}.ncbs_rb_agreement_yht.non_transplant_flag is '是否未移植数据';
comment on column ${iol_schema}.ncbs_rb_agreement_yht.self_flag is '自有资金子账户标识';
comment on column ${iol_schema}.ncbs_rb_agreement_yht.settle_ind is '账户结算模式';
comment on column ${iol_schema}.ncbs_rb_agreement_yht.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_rb_agreement_yht.yht_acct_flag is '一户通账户标志';
comment on column ${iol_schema}.ncbs_rb_agreement_yht.yht_acct_level is '一户通账户层级';
comment on column ${iol_schema}.ncbs_rb_agreement_yht.yht_acct_main_flag is '一户通主账户标志';
comment on column ${iol_schema}.ncbs_rb_agreement_yht.yht_acct_org_schema is '一户通账户结构模式';
comment on column ${iol_schema}.ncbs_rb_agreement_yht.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_agreement_yht.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_agreement_yht.alt_acct_name is '备用账户名称';
comment on column ${iol_schema}.ncbs_rb_agreement_yht.parent_internal_key is '上级账户标识符';
comment on column ${iol_schema}.ncbs_rb_agreement_yht.yht_prod_type is '一户通产品类型';
comment on column ${iol_schema}.ncbs_rb_agreement_yht.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_agreement_yht.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_agreement_yht.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_agreement_yht.etl_timestamp is 'ETL处理时间戳';
