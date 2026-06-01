/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_t05_pub_payment_sign
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_t05_pub_payment_sign
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_t05_pub_payment_sign purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_t05_pub_payment_sign(
    sign_contract_id varchar2(45) -- 签约id
    ,agreement_id varchar2(30) -- 签约编号
    ,agreement_item_seq_id varchar2(30) -- 协议项编号
    ,payment_id varchar2(30) -- 中间业务标识号
    ,legal_address_type varchar2(30) -- 地址类型
    ,idtype varchar2(30) -- 标识类型（证件标识）
    ,sign_id varchar2(90) -- 协议书编号
    ,sp_id varchar2(90) -- 第三方代码
    ,sp_sign_id varchar2(30) -- 第三方协议号
    ,txn_limit number(19,2) -- 交易限额
    ,payment_mode varchar2(30) -- 扣款方式
    ,day_limit number(19,2) -- 客户日累计限额
    ,month_limit number(21,0) -- 客户月累计限额
    ,service_num varchar2(30) -- 委托服务号码
    ,service_name varchar2(30) -- 委托服务户名
    ,service_type varchar2(30) -- 委托服务类型
    ,sign_kind varchar2(30) -- 协议类型
    ,sp_child_id varchar2(30) -- 分局编号
    ,entente_dt varchar2(12) -- 协约日期
    ,involce_cd varchar2(30) -- 取发票方式
    ,sign_control_ind varchar2(30) -- 签约服务控制码
    ,curr_cd varchar2(5) -- 币种
    ,cash_trans_cd varchar2(30) -- 钞汇标志
    ,service_unit_name varchar2(150) -- 委托单位名称
    ,service_unit_tpfa varchar2(53) -- 委托单位第三方资金账号
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
grant select on ${iol_schema}.eifs_t05_pub_payment_sign to ${iml_schema};
grant select on ${iol_schema}.eifs_t05_pub_payment_sign to ${icl_schema};
grant select on ${iol_schema}.eifs_t05_pub_payment_sign to ${idl_schema};
grant select on ${iol_schema}.eifs_t05_pub_payment_sign to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_t05_pub_payment_sign is '代收付签约信息';
comment on column ${iol_schema}.eifs_t05_pub_payment_sign.sign_contract_id is '签约id';
comment on column ${iol_schema}.eifs_t05_pub_payment_sign.agreement_id is '签约编号';
comment on column ${iol_schema}.eifs_t05_pub_payment_sign.agreement_item_seq_id is '协议项编号';
comment on column ${iol_schema}.eifs_t05_pub_payment_sign.payment_id is '中间业务标识号';
comment on column ${iol_schema}.eifs_t05_pub_payment_sign.legal_address_type is '地址类型';
comment on column ${iol_schema}.eifs_t05_pub_payment_sign.idtype is '标识类型（证件标识）';
comment on column ${iol_schema}.eifs_t05_pub_payment_sign.sign_id is '协议书编号';
comment on column ${iol_schema}.eifs_t05_pub_payment_sign.sp_id is '第三方代码';
comment on column ${iol_schema}.eifs_t05_pub_payment_sign.sp_sign_id is '第三方协议号';
comment on column ${iol_schema}.eifs_t05_pub_payment_sign.txn_limit is '交易限额';
comment on column ${iol_schema}.eifs_t05_pub_payment_sign.payment_mode is '扣款方式';
comment on column ${iol_schema}.eifs_t05_pub_payment_sign.day_limit is '客户日累计限额';
comment on column ${iol_schema}.eifs_t05_pub_payment_sign.month_limit is '客户月累计限额';
comment on column ${iol_schema}.eifs_t05_pub_payment_sign.service_num is '委托服务号码';
comment on column ${iol_schema}.eifs_t05_pub_payment_sign.service_name is '委托服务户名';
comment on column ${iol_schema}.eifs_t05_pub_payment_sign.service_type is '委托服务类型';
comment on column ${iol_schema}.eifs_t05_pub_payment_sign.sign_kind is '协议类型';
comment on column ${iol_schema}.eifs_t05_pub_payment_sign.sp_child_id is '分局编号';
comment on column ${iol_schema}.eifs_t05_pub_payment_sign.entente_dt is '协约日期';
comment on column ${iol_schema}.eifs_t05_pub_payment_sign.involce_cd is '取发票方式';
comment on column ${iol_schema}.eifs_t05_pub_payment_sign.sign_control_ind is '签约服务控制码';
comment on column ${iol_schema}.eifs_t05_pub_payment_sign.curr_cd is '币种';
comment on column ${iol_schema}.eifs_t05_pub_payment_sign.cash_trans_cd is '钞汇标志';
comment on column ${iol_schema}.eifs_t05_pub_payment_sign.service_unit_name is '委托单位名称';
comment on column ${iol_schema}.eifs_t05_pub_payment_sign.service_unit_tpfa is '委托单位第三方资金账号';
comment on column ${iol_schema}.eifs_t05_pub_payment_sign.create_te is '创建柜员';
comment on column ${iol_schema}.eifs_t05_pub_payment_sign.create_org is '创建机构号';
comment on column ${iol_schema}.eifs_t05_pub_payment_sign.init_system_id is '创建渠道';
comment on column ${iol_schema}.eifs_t05_pub_payment_sign.init_created_ts is '源系统创建时间';
comment on column ${iol_schema}.eifs_t05_pub_payment_sign.created_ts is '进入ecif的时间';
comment on column ${iol_schema}.eifs_t05_pub_payment_sign.updated_ts is '在ecif中失效的时间';
comment on column ${iol_schema}.eifs_t05_pub_payment_sign.last_updated_te is '最新更新柜员';
comment on column ${iol_schema}.eifs_t05_pub_payment_sign.last_updated_org is '最新更新机构号';
comment on column ${iol_schema}.eifs_t05_pub_payment_sign.last_system_id is '最新更新渠道';
comment on column ${iol_schema}.eifs_t05_pub_payment_sign.last_updated_ts is '最新更新时间';
comment on column ${iol_schema}.eifs_t05_pub_payment_sign.src_sys_num is '来源系统编号';
comment on column ${iol_schema}.eifs_t05_pub_payment_sign.last_updated_src_sys_num is '最新更新源系统编号';
comment on column ${iol_schema}.eifs_t05_pub_payment_sign.start_dt is '开始时间';
comment on column ${iol_schema}.eifs_t05_pub_payment_sign.end_dt is '结束时间';
comment on column ${iol_schema}.eifs_t05_pub_payment_sign.id_mark is '增删标志';
comment on column ${iol_schema}.eifs_t05_pub_payment_sign.etl_timestamp is 'ETL处理时间戳';
