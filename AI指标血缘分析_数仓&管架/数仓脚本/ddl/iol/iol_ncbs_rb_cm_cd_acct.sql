/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_cm_cd_acct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_cm_cd_acct
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_cm_cd_acct purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_cm_cd_acct(
    base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,channel_seq_no varchar2(33) -- 全局流水号
    ,cm_cd_flag varchar2(1) -- 存管现管标志
    ,cm_cd_operate varchar2(1) -- 现管存管操作标识
    ,company varchar2(20) -- 法人
    ,source_type varchar2(6) -- 渠道编号
    ,sub_channel_seq_no varchar2(50) -- 子渠道流水号
    ,xg_sign_status varchar2(1) -- 现金管理协议状态
    ,last_change_date date -- 最后修改日期
    ,sign_date date -- 签约日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,base_client_no varchar2(16) -- 主账户客户号
    ,last_change_user_id varchar2(8) -- 最后修改柜员
    ,sub_acct_name varchar2(200) -- 子账户中文名
    ,sub_acct_no varchar2(50) -- 子账户
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
grant select on ${iol_schema}.ncbs_rb_cm_cd_acct to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_cm_cd_acct to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_cm_cd_acct to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_cm_cd_acct to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_cm_cd_acct is '现管存管子账户同步记录表';
comment on column ${iol_schema}.ncbs_rb_cm_cd_acct.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_cm_cd_acct.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_cm_cd_acct.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_cm_cd_acct.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_rb_cm_cd_acct.cm_cd_flag is '存管现管标志';
comment on column ${iol_schema}.ncbs_rb_cm_cd_acct.cm_cd_operate is '现管存管操作标识';
comment on column ${iol_schema}.ncbs_rb_cm_cd_acct.company is '法人';
comment on column ${iol_schema}.ncbs_rb_cm_cd_acct.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_rb_cm_cd_acct.sub_channel_seq_no is '子渠道流水号';
comment on column ${iol_schema}.ncbs_rb_cm_cd_acct.xg_sign_status is '现金管理协议状态';
comment on column ${iol_schema}.ncbs_rb_cm_cd_acct.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_rb_cm_cd_acct.sign_date is '签约日期';
comment on column ${iol_schema}.ncbs_rb_cm_cd_acct.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_cm_cd_acct.base_client_no is '主账户客户号';
comment on column ${iol_schema}.ncbs_rb_cm_cd_acct.last_change_user_id is '最后修改柜员';
comment on column ${iol_schema}.ncbs_rb_cm_cd_acct.sub_acct_name is '子账户中文名';
comment on column ${iol_schema}.ncbs_rb_cm_cd_acct.sub_acct_no is '子账户';
comment on column ${iol_schema}.ncbs_rb_cm_cd_acct.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_cm_cd_acct.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_cm_cd_acct.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_cm_cd_acct.etl_timestamp is 'ETL处理时间戳';
