/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_view_trans_opponent_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_view_trans_opponent_info
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_view_trans_opponent_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_view_trans_opponent_info(
    bsnssq varchar2(50) -- 全局流水号
    ,transq varchar2(96) -- 交易流水号
    ,serino varchar2(30) -- 序列号
    ,cust_acct varchar2(150) -- 交易对手账号
    ,cust_name varchar2(675) -- 交易对手名称
    ,cust_bank_no varchar2(18) -- 交易对手行号
    ,cust_bank_name varchar2(450) -- 交易对手行名
    ,province_no varchar2(3) -- 对手银行所在地行政区划
    ,province_name varchar2(450) -- 区域名称
    ,cert_id varchar2(75) -- 交易对手证件类型
    ,cert_type varchar2(30) -- 交易对手证件号码
    ,social_credit_no varchar2(48) -- 统一社会信用代码
    ,txn_bank_type varchar2(21) -- 交易对手行号类型
    ,evetdn varchar2(32) -- 借贷方向
    ,iscustacct varchar2(2) -- 是否客户账务标识
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
grant select on ${iol_schema}.bdms_view_trans_opponent_info to ${iml_schema};
grant select on ${iol_schema}.bdms_view_trans_opponent_info to ${icl_schema};
grant select on ${iol_schema}.bdms_view_trans_opponent_info to ${idl_schema};
grant select on ${iol_schema}.bdms_view_trans_opponent_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_view_trans_opponent_info is '交易对手信息视图';
comment on column ${iol_schema}.bdms_view_trans_opponent_info.bsnssq is '全局流水号';
comment on column ${iol_schema}.bdms_view_trans_opponent_info.transq is '交易流水号';
comment on column ${iol_schema}.bdms_view_trans_opponent_info.serino is '序列号';
comment on column ${iol_schema}.bdms_view_trans_opponent_info.cust_acct is '交易对手账号';
comment on column ${iol_schema}.bdms_view_trans_opponent_info.cust_name is '交易对手名称';
comment on column ${iol_schema}.bdms_view_trans_opponent_info.cust_bank_no is '交易对手行号';
comment on column ${iol_schema}.bdms_view_trans_opponent_info.cust_bank_name is '交易对手行名';
comment on column ${iol_schema}.bdms_view_trans_opponent_info.province_no is '对手银行所在地行政区划';
comment on column ${iol_schema}.bdms_view_trans_opponent_info.province_name is '区域名称';
comment on column ${iol_schema}.bdms_view_trans_opponent_info.cert_id is '交易对手证件类型';
comment on column ${iol_schema}.bdms_view_trans_opponent_info.cert_type is '交易对手证件号码';
comment on column ${iol_schema}.bdms_view_trans_opponent_info.social_credit_no is '统一社会信用代码';
comment on column ${iol_schema}.bdms_view_trans_opponent_info.txn_bank_type is '交易对手行号类型';
comment on column ${iol_schema}.bdms_view_trans_opponent_info.evetdn is '借贷方向';
comment on column ${iol_schema}.bdms_view_trans_opponent_info.iscustacct is '是否客户账务标识';
comment on column ${iol_schema}.bdms_view_trans_opponent_info.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_view_trans_opponent_info.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_view_trans_opponent_info.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_view_trans_opponent_info.etl_timestamp is 'ETL处理时间戳';
