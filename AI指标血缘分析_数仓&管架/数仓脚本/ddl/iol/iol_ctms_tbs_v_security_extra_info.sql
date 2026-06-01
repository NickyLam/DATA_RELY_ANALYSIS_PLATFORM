/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_tbs_v_security_extra_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_tbs_v_security_extra_info
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_tbs_v_security_extra_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_v_security_extra_info(
    security_code varchar2(24) -- 债券代码
    ,payment_return_type varchar2(2) -- 还款方式
    ,floating_rate_type varchar2(2) -- 浮动公式
    ,payment_day number(3,0) -- 付息日调整至后第n个营业日
    ,selfdefineschd varchar2(2) -- 不规则日程
    ,scan_modify varchar2(2) -- 假日自动重展
    ,circ_market varchar2(2) -- 自定义券流通市场
    ,calc_mthd varchar2(2) -- 计算规则
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
grant select on ${iol_schema}.ctms_tbs_v_security_extra_info to ${iml_schema};
grant select on ${iol_schema}.ctms_tbs_v_security_extra_info to ${icl_schema};
grant select on ${iol_schema}.ctms_tbs_v_security_extra_info to ${idl_schema};
grant select on ${iol_schema}.ctms_tbs_v_security_extra_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_tbs_v_security_extra_info is '债券扩展信息视图2';
comment on column ${iol_schema}.ctms_tbs_v_security_extra_info.security_code is '债券代码';
comment on column ${iol_schema}.ctms_tbs_v_security_extra_info.payment_return_type is '还款方式';
comment on column ${iol_schema}.ctms_tbs_v_security_extra_info.floating_rate_type is '浮动公式';
comment on column ${iol_schema}.ctms_tbs_v_security_extra_info.payment_day is '付息日调整至后第n个营业日';
comment on column ${iol_schema}.ctms_tbs_v_security_extra_info.selfdefineschd is '不规则日程';
comment on column ${iol_schema}.ctms_tbs_v_security_extra_info.scan_modify is '假日自动重展';
comment on column ${iol_schema}.ctms_tbs_v_security_extra_info.circ_market is '自定义券流通市场';
comment on column ${iol_schema}.ctms_tbs_v_security_extra_info.calc_mthd is '计算规则';
comment on column ${iol_schema}.ctms_tbs_v_security_extra_info.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_tbs_v_security_extra_info.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_tbs_v_security_extra_info.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_tbs_v_security_extra_info.etl_timestamp is 'ETL处理时间戳';
