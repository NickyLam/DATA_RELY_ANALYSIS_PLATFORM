/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_t09_corp_cust_info_modify_seq
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_t09_corp_cust_info_modify_seq
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_t09_corp_cust_info_modify_seq purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_t09_corp_cust_info_modify_seq(
    cust_oper_type varchar2(2) -- 客户操作类型
    ,srv_seq_num varchar2(75) -- 业务流水号
    ,glob_seq_num varchar2(75) -- 全局流水号
    ,cust_num varchar2(24) -- 客户编号
    ,cust_type_cd varchar2(3) -- 客户类型
    ,type varchar2(150) -- 类别
    ,tab_name varchar2(90) -- 表名
    ,key_id varchar2(90) -- 主键ID
    ,col_name varchar2(90) -- 字段名
    ,col_chn_name varchar2(450) -- 字段中文名
    ,before_change varchar2(3605) -- 修改前值
    ,now_value varchar2(3605) -- 当前值
    ,last_updated_te varchar2(15) -- 更新柜员
    ,last_updated_org varchar2(30) -- 更新机构
    ,last_system_id varchar2(15) -- 更新渠道
    ,last_updated_ts timestamp -- 更新时间
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
grant select on ${iol_schema}.eifs_t09_corp_cust_info_modify_seq to ${iml_schema};
grant select on ${iol_schema}.eifs_t09_corp_cust_info_modify_seq to ${icl_schema};
grant select on ${iol_schema}.eifs_t09_corp_cust_info_modify_seq to ${idl_schema};
grant select on ${iol_schema}.eifs_t09_corp_cust_info_modify_seq to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_t09_corp_cust_info_modify_seq is '对公客户信息修改流水表';
comment on column ${iol_schema}.eifs_t09_corp_cust_info_modify_seq.cust_oper_type is '客户操作类型';
comment on column ${iol_schema}.eifs_t09_corp_cust_info_modify_seq.srv_seq_num is '业务流水号';
comment on column ${iol_schema}.eifs_t09_corp_cust_info_modify_seq.glob_seq_num is '全局流水号';
comment on column ${iol_schema}.eifs_t09_corp_cust_info_modify_seq.cust_num is '客户编号';
comment on column ${iol_schema}.eifs_t09_corp_cust_info_modify_seq.cust_type_cd is '客户类型';
comment on column ${iol_schema}.eifs_t09_corp_cust_info_modify_seq.type is '类别';
comment on column ${iol_schema}.eifs_t09_corp_cust_info_modify_seq.tab_name is '表名';
comment on column ${iol_schema}.eifs_t09_corp_cust_info_modify_seq.key_id is '主键ID';
comment on column ${iol_schema}.eifs_t09_corp_cust_info_modify_seq.col_name is '字段名';
comment on column ${iol_schema}.eifs_t09_corp_cust_info_modify_seq.col_chn_name is '字段中文名';
comment on column ${iol_schema}.eifs_t09_corp_cust_info_modify_seq.before_change is '修改前值';
comment on column ${iol_schema}.eifs_t09_corp_cust_info_modify_seq.now_value is '当前值';
comment on column ${iol_schema}.eifs_t09_corp_cust_info_modify_seq.last_updated_te is '更新柜员';
comment on column ${iol_schema}.eifs_t09_corp_cust_info_modify_seq.last_updated_org is '更新机构';
comment on column ${iol_schema}.eifs_t09_corp_cust_info_modify_seq.last_system_id is '更新渠道';
comment on column ${iol_schema}.eifs_t09_corp_cust_info_modify_seq.last_updated_ts is '更新时间';
comment on column ${iol_schema}.eifs_t09_corp_cust_info_modify_seq.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.eifs_t09_corp_cust_info_modify_seq.etl_timestamp is 'ETL处理时间戳';
