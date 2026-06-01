/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_t05_pub_third_sign
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_t05_pub_third_sign
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_t05_pub_third_sign purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_t05_pub_third_sign(
    sign_contract_id varchar2(45) -- 签约id
    ,agreement_id varchar2(30) -- 签约编号
    ,agreement_item_seq_id varchar2(30) -- 协议项编号
    ,sp_id varchar2(90) -- 第三方代码
    ,settle_act varchar2(90) -- 清算账号
    ,entente_dt varchar2(12) -- 协约日期
    ,settle_bank_id varchar2(30) -- 清算银行号
    ,settle_bank_name varchar2(90) -- 清算银行名称
    ,sign_control_ind varchar2(30) -- 签约服务控制码
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
grant select on ${iol_schema}.eifs_t05_pub_third_sign to ${iml_schema};
grant select on ${iol_schema}.eifs_t05_pub_third_sign to ${icl_schema};
grant select on ${iol_schema}.eifs_t05_pub_third_sign to ${idl_schema};
grant select on ${iol_schema}.eifs_t05_pub_third_sign to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_t05_pub_third_sign is '第三方签约信息';
comment on column ${iol_schema}.eifs_t05_pub_third_sign.sign_contract_id is '签约id';
comment on column ${iol_schema}.eifs_t05_pub_third_sign.agreement_id is '签约编号';
comment on column ${iol_schema}.eifs_t05_pub_third_sign.agreement_item_seq_id is '协议项编号';
comment on column ${iol_schema}.eifs_t05_pub_third_sign.sp_id is '第三方代码';
comment on column ${iol_schema}.eifs_t05_pub_third_sign.settle_act is '清算账号';
comment on column ${iol_schema}.eifs_t05_pub_third_sign.entente_dt is '协约日期';
comment on column ${iol_schema}.eifs_t05_pub_third_sign.settle_bank_id is '清算银行号';
comment on column ${iol_schema}.eifs_t05_pub_third_sign.settle_bank_name is '清算银行名称';
comment on column ${iol_schema}.eifs_t05_pub_third_sign.sign_control_ind is '签约服务控制码';
comment on column ${iol_schema}.eifs_t05_pub_third_sign.create_te is '创建柜员';
comment on column ${iol_schema}.eifs_t05_pub_third_sign.create_org is '创建机构号';
comment on column ${iol_schema}.eifs_t05_pub_third_sign.init_system_id is '创建渠道';
comment on column ${iol_schema}.eifs_t05_pub_third_sign.init_created_ts is '源系统创建时间';
comment on column ${iol_schema}.eifs_t05_pub_third_sign.created_ts is '进入ecif的时间';
comment on column ${iol_schema}.eifs_t05_pub_third_sign.updated_ts is '在ecif中失效的时间';
comment on column ${iol_schema}.eifs_t05_pub_third_sign.last_updated_te is '最新更新柜员';
comment on column ${iol_schema}.eifs_t05_pub_third_sign.last_updated_org is '最新更新机构号';
comment on column ${iol_schema}.eifs_t05_pub_third_sign.last_system_id is '最新更新渠道';
comment on column ${iol_schema}.eifs_t05_pub_third_sign.last_updated_ts is '最新更新时间';
comment on column ${iol_schema}.eifs_t05_pub_third_sign.src_sys_num is '来源系统编号';
comment on column ${iol_schema}.eifs_t05_pub_third_sign.last_updated_src_sys_num is '最新更新源系统编号';
comment on column ${iol_schema}.eifs_t05_pub_third_sign.start_dt is '开始时间';
comment on column ${iol_schema}.eifs_t05_pub_third_sign.end_dt is '结束时间';
comment on column ${iol_schema}.eifs_t05_pub_third_sign.id_mark is '增删标志';
comment on column ${iol_schema}.eifs_t05_pub_third_sign.etl_timestamp is 'ETL处理时间戳';
