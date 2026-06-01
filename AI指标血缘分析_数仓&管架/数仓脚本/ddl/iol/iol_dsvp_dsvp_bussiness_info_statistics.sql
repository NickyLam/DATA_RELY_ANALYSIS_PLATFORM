/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol dsvp_dsvp_bussiness_info_statistics
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.dsvp_dsvp_bussiness_info_statistics
whenever sqlerror continue none;
drop table ${iol_schema}.dsvp_dsvp_bussiness_info_statistics purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.dsvp_dsvp_bussiness_info_statistics(
    id varchar2(120) -- 序列号
    ,txn_dt date -- 交易日期
    ,txn_tm varchar2(768) -- 交易时间
    ,blng_org_id varchar2(36) -- 机构号
    ,oper_teller_id varchar2(60) -- 操作柜员号
    ,oper_teller_name varchar2(300) -- 操作柜员名称
    ,auth_teller_id varchar2(60) -- 授权柜员号
    ,auth_teller_name varchar2(300) -- 授权柜员名称
    ,txn_num varchar2(120) -- 操作类型编码
    ,txn_desc varchar2(4000) -- 操作名称描述
    ,biz_sys_evt_id varchar2(24) -- 无实际数据
    ,bcs_evt_id varchar2(24) -- 无实际数据
    ,data_src_cd varchar2(24) -- 数据来源标识（默认SDVP）
    ,pay_agt_id varchar2(24) -- 无实际数据
    ,rcv_agt_id varchar2(24) -- 无实际数据
    ,txn_amt varchar2(24) -- 无实际数据
    ,etl_dt_ora date -- 结束时间（与操作时间一致）
    ,menuid varchar2(24) -- 无实际数据
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
grant select on ${iol_schema}.dsvp_dsvp_bussiness_info_statistics to ${iml_schema};
grant select on ${iol_schema}.dsvp_dsvp_bussiness_info_statistics to ${icl_schema};
grant select on ${iol_schema}.dsvp_dsvp_bussiness_info_statistics to ${idl_schema};
grant select on ${iol_schema}.dsvp_dsvp_bussiness_info_statistics to ${iel_schema};

-- comment
comment on table ${iol_schema}.dsvp_dsvp_bussiness_info_statistics is '';
comment on column ${iol_schema}.dsvp_dsvp_bussiness_info_statistics.id is '序列号';
comment on column ${iol_schema}.dsvp_dsvp_bussiness_info_statistics.txn_dt is '交易日期';
comment on column ${iol_schema}.dsvp_dsvp_bussiness_info_statistics.txn_tm is '交易时间';
comment on column ${iol_schema}.dsvp_dsvp_bussiness_info_statistics.blng_org_id is '机构号';
comment on column ${iol_schema}.dsvp_dsvp_bussiness_info_statistics.oper_teller_id is '操作柜员号';
comment on column ${iol_schema}.dsvp_dsvp_bussiness_info_statistics.oper_teller_name is '操作柜员名称';
comment on column ${iol_schema}.dsvp_dsvp_bussiness_info_statistics.auth_teller_id is '授权柜员号';
comment on column ${iol_schema}.dsvp_dsvp_bussiness_info_statistics.auth_teller_name is '授权柜员名称';
comment on column ${iol_schema}.dsvp_dsvp_bussiness_info_statistics.txn_num is '操作类型编码';
comment on column ${iol_schema}.dsvp_dsvp_bussiness_info_statistics.txn_desc is '操作名称描述';
comment on column ${iol_schema}.dsvp_dsvp_bussiness_info_statistics.biz_sys_evt_id is '无实际数据';
comment on column ${iol_schema}.dsvp_dsvp_bussiness_info_statistics.bcs_evt_id is '无实际数据';
comment on column ${iol_schema}.dsvp_dsvp_bussiness_info_statistics.data_src_cd is '数据来源标识（默认SDVP）';
comment on column ${iol_schema}.dsvp_dsvp_bussiness_info_statistics.pay_agt_id is '无实际数据';
comment on column ${iol_schema}.dsvp_dsvp_bussiness_info_statistics.rcv_agt_id is '无实际数据';
comment on column ${iol_schema}.dsvp_dsvp_bussiness_info_statistics.txn_amt is '无实际数据';
comment on column ${iol_schema}.dsvp_dsvp_bussiness_info_statistics.etl_dt_ora is '结束时间（与操作时间一致）';
comment on column ${iol_schema}.dsvp_dsvp_bussiness_info_statistics.menuid is '无实际数据';
comment on column ${iol_schema}.dsvp_dsvp_bussiness_info_statistics.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.dsvp_dsvp_bussiness_info_statistics.etl_timestamp is 'ETL处理时间戳';
