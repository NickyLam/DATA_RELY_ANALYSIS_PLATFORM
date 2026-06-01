/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_t05_pub_summary_sign
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_t05_pub_summary_sign
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_t05_pub_summary_sign purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_t05_pub_summary_sign(
    sign_contract_id varchar2(45) -- 签约id
    ,party_id varchar2(45) -- 参与人id
    ,agreement_id varchar2(30) -- 签约编号
    ,product_id varchar2(30) -- 产品标识
    ,agreement_type_id varchar2(30) -- 签约类型
    ,agreement_date varchar2(12) -- 协议日期
    ,from_date varchar2(12) -- 开始日期
    ,thru_date varchar2(12) -- 结束日期
    ,act_type varchar2(30) -- 账号类型
    ,acct_num varchar2(383) -- 账号
    ,sign_level varchar2(12) -- 签约层级
    ,sign_status varchar2(30) -- 签约状态
    ,phone_num varchar2(150) -- 签约手机号
    ,prod_id varchar2(30) -- 服务产品编号
    ,prod_serv_name varchar2(383) -- 产品服务名称
    ,recmd_type varchar2(383) -- 推荐类型
    ,recmd_num varchar2(383) -- 推荐号码
    ,recmd_person_name varchar2(383) -- 推荐人名称
    ,remark varchar2(383) -- 备注
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
    ,open_date varchar2(12) -- 签约日期
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
grant select on ${iol_schema}.eifs_t05_pub_summary_sign to ${iml_schema};
grant select on ${iol_schema}.eifs_t05_pub_summary_sign to ${icl_schema};
grant select on ${iol_schema}.eifs_t05_pub_summary_sign to ${idl_schema};
grant select on ${iol_schema}.eifs_t05_pub_summary_sign to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_t05_pub_summary_sign is '签约协议总表';
comment on column ${iol_schema}.eifs_t05_pub_summary_sign.sign_contract_id is '签约id';
comment on column ${iol_schema}.eifs_t05_pub_summary_sign.party_id is '参与人id';
comment on column ${iol_schema}.eifs_t05_pub_summary_sign.agreement_id is '签约编号';
comment on column ${iol_schema}.eifs_t05_pub_summary_sign.product_id is '产品标识';
comment on column ${iol_schema}.eifs_t05_pub_summary_sign.agreement_type_id is '签约类型';
comment on column ${iol_schema}.eifs_t05_pub_summary_sign.agreement_date is '协议日期';
comment on column ${iol_schema}.eifs_t05_pub_summary_sign.from_date is '开始日期';
comment on column ${iol_schema}.eifs_t05_pub_summary_sign.thru_date is '结束日期';
comment on column ${iol_schema}.eifs_t05_pub_summary_sign.act_type is '账号类型';
comment on column ${iol_schema}.eifs_t05_pub_summary_sign.acct_num is '账号';
comment on column ${iol_schema}.eifs_t05_pub_summary_sign.sign_level is '签约层级';
comment on column ${iol_schema}.eifs_t05_pub_summary_sign.sign_status is '签约状态';
comment on column ${iol_schema}.eifs_t05_pub_summary_sign.phone_num is '签约手机号';
comment on column ${iol_schema}.eifs_t05_pub_summary_sign.prod_id is '服务产品编号';
comment on column ${iol_schema}.eifs_t05_pub_summary_sign.prod_serv_name is '产品服务名称';
comment on column ${iol_schema}.eifs_t05_pub_summary_sign.recmd_type is '推荐类型';
comment on column ${iol_schema}.eifs_t05_pub_summary_sign.recmd_num is '推荐号码';
comment on column ${iol_schema}.eifs_t05_pub_summary_sign.recmd_person_name is '推荐人名称';
comment on column ${iol_schema}.eifs_t05_pub_summary_sign.remark is '备注';
comment on column ${iol_schema}.eifs_t05_pub_summary_sign.create_te is '创建柜员';
comment on column ${iol_schema}.eifs_t05_pub_summary_sign.create_org is '创建机构号';
comment on column ${iol_schema}.eifs_t05_pub_summary_sign.init_system_id is '创建渠道';
comment on column ${iol_schema}.eifs_t05_pub_summary_sign.init_created_ts is '源系统创建时间';
comment on column ${iol_schema}.eifs_t05_pub_summary_sign.created_ts is '进入ecif的时间';
comment on column ${iol_schema}.eifs_t05_pub_summary_sign.updated_ts is '在ecif中失效的时间';
comment on column ${iol_schema}.eifs_t05_pub_summary_sign.last_updated_te is '最新更新柜员';
comment on column ${iol_schema}.eifs_t05_pub_summary_sign.last_updated_org is '最新更新机构号';
comment on column ${iol_schema}.eifs_t05_pub_summary_sign.last_system_id is '最新更新渠道';
comment on column ${iol_schema}.eifs_t05_pub_summary_sign.last_updated_ts is '最新更新时间';
comment on column ${iol_schema}.eifs_t05_pub_summary_sign.open_date is '签约日期';
comment on column ${iol_schema}.eifs_t05_pub_summary_sign.src_sys_num is '来源系统编号';
comment on column ${iol_schema}.eifs_t05_pub_summary_sign.last_updated_src_sys_num is '最新更新源系统编号';
comment on column ${iol_schema}.eifs_t05_pub_summary_sign.start_dt is '开始时间';
comment on column ${iol_schema}.eifs_t05_pub_summary_sign.end_dt is '结束时间';
comment on column ${iol_schema}.eifs_t05_pub_summary_sign.id_mark is '增删标志';
comment on column ${iol_schema}.eifs_t05_pub_summary_sign.etl_timestamp is 'ETL处理时间戳';
