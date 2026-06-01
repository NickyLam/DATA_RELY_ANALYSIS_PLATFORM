/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_record_flowmapping_his
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_record_flowmapping_his
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_record_flowmapping_his purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_record_flowmapping_his(
    sendflow_no varchar2(48) -- 发送的流水号
    ,flow_no varchar2(150) -- 资金系统分录流水号
    ,hostflow_no varchar2(45) -- 响应流水号
    ,is_erase number(22,0) -- 1：否 2：是
    ,state number(22,0) -- 0：成功 10：失败 20：未知
    ,ref_sendflow_no varchar2(48) -- 抹账操作时关联的对应操作的发送流水号
    ,batch_no varchar2(75) -- 批量记账时用
    ,opt_type number(22,0) -- 1：记账；2：支付
    ,his_flag number(22,0) -- 0：当前；1：历史
    ,business_date varchar2(15) -- 业务日期
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
grant select on ${iol_schema}.ibms_ttrd_record_flowmapping_his to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_record_flowmapping_his to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_record_flowmapping_his to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_record_flowmapping_his to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_record_flowmapping_his is '接口流水映射历史表';
comment on column ${iol_schema}.ibms_ttrd_record_flowmapping_his.sendflow_no is '发送的流水号';
comment on column ${iol_schema}.ibms_ttrd_record_flowmapping_his.flow_no is '资金系统分录流水号';
comment on column ${iol_schema}.ibms_ttrd_record_flowmapping_his.hostflow_no is '响应流水号';
comment on column ${iol_schema}.ibms_ttrd_record_flowmapping_his.is_erase is '1：否 2：是';
comment on column ${iol_schema}.ibms_ttrd_record_flowmapping_his.state is '0：成功 10：失败 20：未知';
comment on column ${iol_schema}.ibms_ttrd_record_flowmapping_his.ref_sendflow_no is '抹账操作时关联的对应操作的发送流水号';
comment on column ${iol_schema}.ibms_ttrd_record_flowmapping_his.batch_no is '批量记账时用';
comment on column ${iol_schema}.ibms_ttrd_record_flowmapping_his.opt_type is '1：记账；2：支付';
comment on column ${iol_schema}.ibms_ttrd_record_flowmapping_his.his_flag is '0：当前；1：历史';
comment on column ${iol_schema}.ibms_ttrd_record_flowmapping_his.business_date is '业务日期';
comment on column ${iol_schema}.ibms_ttrd_record_flowmapping_his.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ibms_ttrd_record_flowmapping_his.etl_timestamp is 'ETL处理时间戳';
