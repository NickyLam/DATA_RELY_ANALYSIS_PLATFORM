/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_seal_relation_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_seal_relation_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_seal_relation_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_seal_relation_hist(
    client_no varchar2(16) -- 客户编号
    ,doc_type varchar2(10) -- 凭证类型
    ,internal_key number(15) -- 账户内部键值
    ,remark varchar2(600) -- 备注
    ,voucher_no varchar2(50) -- 凭证号码
    ,company varchar2(20) -- 法人
    ,lead_acct_flag varchar2(1) -- 主账户标志
    ,operate_flag varchar2(1) -- 操作类型
    ,prefix varchar2(10) -- 前缀
    ,end_date date -- 结束日期
    ,last_change_date date -- 最后修改日期
    ,start_date date -- 开始日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,last_change_user_id varchar2(8) -- 最后修改柜员
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
grant select on ${iol_schema}.ncbs_rb_seal_relation_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_seal_relation_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_seal_relation_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_seal_relation_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_seal_relation_hist is '帐户印鉴关联交易历史表';
comment on column ${iol_schema}.ncbs_rb_seal_relation_hist.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_seal_relation_hist.doc_type is '凭证类型';
comment on column ${iol_schema}.ncbs_rb_seal_relation_hist.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_seal_relation_hist.remark is '备注';
comment on column ${iol_schema}.ncbs_rb_seal_relation_hist.voucher_no is '凭证号码';
comment on column ${iol_schema}.ncbs_rb_seal_relation_hist.company is '法人';
comment on column ${iol_schema}.ncbs_rb_seal_relation_hist.lead_acct_flag is '主账户标志';
comment on column ${iol_schema}.ncbs_rb_seal_relation_hist.operate_flag is '操作类型';
comment on column ${iol_schema}.ncbs_rb_seal_relation_hist.prefix is '前缀';
comment on column ${iol_schema}.ncbs_rb_seal_relation_hist.end_date is '结束日期';
comment on column ${iol_schema}.ncbs_rb_seal_relation_hist.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_rb_seal_relation_hist.start_date is '开始日期';
comment on column ${iol_schema}.ncbs_rb_seal_relation_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_seal_relation_hist.last_change_user_id is '最后修改柜员';
comment on column ${iol_schema}.ncbs_rb_seal_relation_hist.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_seal_relation_hist.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_seal_relation_hist.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_seal_relation_hist.etl_timestamp is 'ETL处理时间戳';
