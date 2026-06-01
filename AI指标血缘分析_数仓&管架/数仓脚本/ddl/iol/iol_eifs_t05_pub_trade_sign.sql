/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_t05_pub_trade_sign
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_t05_pub_trade_sign
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_t05_pub_trade_sign purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_t05_pub_trade_sign(
    sign_contract_id varchar2(45) -- 签约id
    ,agreement_id varchar2(30) -- 签约编号
    ,agreement_item_seq_id varchar2(30) -- 协议项编号
    ,txn_chl varchar2(9) -- 交易渠道
    ,txn_type varchar2(30) -- 交易类型代码
    ,curr_cd varchar2(5) -- 币种
    ,time_scale varchar2(30) -- 时间单位代码
    ,txn_times_smy varchar2(30) -- 累计交易次数
    ,txn_times_limit varchar2(30) -- 交易次数上限
    ,txn_credit_smy number(19,2) -- 累计发生额
    ,txn_limit number(19,2) -- 交易限额
    ,last_txn_dt varchar2(12) -- 最近交易日期
    ,last_txn_time timestamp -- 最近交易时间
    ,sign_control_ind varchar2(30) -- 签约服务控制码
    ,third_party_num varchar2(90) -- 第三方编号
    ,project_num varchar2(90) -- 项目编号
    ,create_te varchar2(12) -- 创建柜员
    ,create_org varchar2(15) -- 创建机构号
    ,init_system_id varchar2(15) -- 创建渠道
    ,init_created_ts timestamp -- 源系统创建时间
    ,created_ts timestamp -- 进入ecif的时间
    ,updated_ts timestamp -- 在ecif中失效的时间
    ,last_updated_te varchar2(45) -- 最新更新柜员
    ,last_updated_org varchar2(30) -- 最新更新机构号
    ,last_system_id varchar2(15) -- 最新更新渠道
    ,last_updated_ts timestamp -- 最新更新时间
    ,src_sys_num varchar2(45) -- 来源系统编号
    ,last_updated_src_sys_num varchar2(45) -- 最新更新源系统编号
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
grant select on ${iol_schema}.eifs_t05_pub_trade_sign to ${iml_schema};
grant select on ${iol_schema}.eifs_t05_pub_trade_sign to ${icl_schema};
grant select on ${iol_schema}.eifs_t05_pub_trade_sign to ${idl_schema};
grant select on ${iol_schema}.eifs_t05_pub_trade_sign to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_t05_pub_trade_sign is '交易行为签约表';
comment on column ${iol_schema}.eifs_t05_pub_trade_sign.sign_contract_id is '签约id';
comment on column ${iol_schema}.eifs_t05_pub_trade_sign.agreement_id is '签约编号';
comment on column ${iol_schema}.eifs_t05_pub_trade_sign.agreement_item_seq_id is '协议项编号';
comment on column ${iol_schema}.eifs_t05_pub_trade_sign.txn_chl is '交易渠道';
comment on column ${iol_schema}.eifs_t05_pub_trade_sign.txn_type is '交易类型代码';
comment on column ${iol_schema}.eifs_t05_pub_trade_sign.curr_cd is '币种';
comment on column ${iol_schema}.eifs_t05_pub_trade_sign.time_scale is '时间单位代码';
comment on column ${iol_schema}.eifs_t05_pub_trade_sign.txn_times_smy is '累计交易次数';
comment on column ${iol_schema}.eifs_t05_pub_trade_sign.txn_times_limit is '交易次数上限';
comment on column ${iol_schema}.eifs_t05_pub_trade_sign.txn_credit_smy is '累计发生额';
comment on column ${iol_schema}.eifs_t05_pub_trade_sign.txn_limit is '交易限额';
comment on column ${iol_schema}.eifs_t05_pub_trade_sign.last_txn_dt is '最近交易日期';
comment on column ${iol_schema}.eifs_t05_pub_trade_sign.last_txn_time is '最近交易时间';
comment on column ${iol_schema}.eifs_t05_pub_trade_sign.sign_control_ind is '签约服务控制码';
comment on column ${iol_schema}.eifs_t05_pub_trade_sign.third_party_num is '第三方编号';
comment on column ${iol_schema}.eifs_t05_pub_trade_sign.project_num is '项目编号';
comment on column ${iol_schema}.eifs_t05_pub_trade_sign.create_te is '创建柜员';
comment on column ${iol_schema}.eifs_t05_pub_trade_sign.create_org is '创建机构号';
comment on column ${iol_schema}.eifs_t05_pub_trade_sign.init_system_id is '创建渠道';
comment on column ${iol_schema}.eifs_t05_pub_trade_sign.init_created_ts is '源系统创建时间';
comment on column ${iol_schema}.eifs_t05_pub_trade_sign.created_ts is '进入ecif的时间';
comment on column ${iol_schema}.eifs_t05_pub_trade_sign.updated_ts is '在ecif中失效的时间';
comment on column ${iol_schema}.eifs_t05_pub_trade_sign.last_updated_te is '最新更新柜员';
comment on column ${iol_schema}.eifs_t05_pub_trade_sign.last_updated_org is '最新更新机构号';
comment on column ${iol_schema}.eifs_t05_pub_trade_sign.last_system_id is '最新更新渠道';
comment on column ${iol_schema}.eifs_t05_pub_trade_sign.last_updated_ts is '最新更新时间';
comment on column ${iol_schema}.eifs_t05_pub_trade_sign.src_sys_num is '来源系统编号';
comment on column ${iol_schema}.eifs_t05_pub_trade_sign.last_updated_src_sys_num is '最新更新源系统编号';
comment on column ${iol_schema}.eifs_t05_pub_trade_sign.start_dt is '开始时间';
comment on column ${iol_schema}.eifs_t05_pub_trade_sign.end_dt is '结束时间';
comment on column ${iol_schema}.eifs_t05_pub_trade_sign.id_mark is '增删标志';
comment on column ${iol_schema}.eifs_t05_pub_trade_sign.etl_timestamp is 'ETL处理时间戳';
