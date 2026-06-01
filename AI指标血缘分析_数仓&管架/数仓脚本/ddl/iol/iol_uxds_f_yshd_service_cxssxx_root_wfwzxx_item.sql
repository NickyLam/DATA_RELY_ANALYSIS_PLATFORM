/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_yshd_service_cxssxx_root_wfwzxx_item
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_yshd_service_cxssxx_root_wfwzxx_item
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_yshd_service_cxssxx_root_wfwzxx_item purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_yshd_service_cxssxx_root_wfwzxx_item(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,djrq varchar2(4000) -- 登记日期
    ,wfss varchar2(4000) -- 违法事实
    ,ajly varchar2(4000) -- 案件来源
    ,sswfsdmc varchar2(4000) -- 违法手段名称
    ,sswflxmc varchar2(4000) -- 违法类型名称
    ,ssqjz_1 varchar2(4000) -- 所属期止
    ,jcajbz varchar2(4000) -- 稽查案件标志
    ,item varchar2(4000) -- 关联标签
    ,qyxmmc varchar2(4000) -- 负债和所有者权益项目名称
    ,ssqjq_1 varchar2(4000) -- 所属期起
    ,sswfxwclztmc varchar2(4000) -- 违法处理状态名称
    ,sfsbfwf varchar2(4000) -- 是否社保费违法
    ,shxydm varchar2(4000) -- 社会信用代码
    ,wfxwmc varchar2(4000) -- 违法行为名称
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
grant select on ${iol_schema}.uxds_f_yshd_service_cxssxx_root_wfwzxx_item to ${iml_schema};
grant select on ${iol_schema}.uxds_f_yshd_service_cxssxx_root_wfwzxx_item to ${icl_schema};
grant select on ${iol_schema}.uxds_f_yshd_service_cxssxx_root_wfwzxx_item to ${idl_schema};
grant select on ${iol_schema}.uxds_f_yshd_service_cxssxx_root_wfwzxx_item to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_yshd_service_cxssxx_root_wfwzxx_item is '深圳税局涉税信息违法违章信息';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_wfwzxx_item.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_wfwzxx_item.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_wfwzxx_item.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_wfwzxx_item.djrq is '登记日期';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_wfwzxx_item.wfss is '违法事实';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_wfwzxx_item.ajly is '案件来源';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_wfwzxx_item.sswfsdmc is '违法手段名称';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_wfwzxx_item.sswflxmc is '违法类型名称';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_wfwzxx_item.ssqjz_1 is '所属期止';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_wfwzxx_item.jcajbz is '稽查案件标志';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_wfwzxx_item.item is '关联标签';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_wfwzxx_item.qyxmmc is '负债和所有者权益项目名称';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_wfwzxx_item.ssqjq_1 is '所属期起';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_wfwzxx_item.sswfxwclztmc is '违法处理状态名称';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_wfwzxx_item.sfsbfwf is '是否社保费违法';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_wfwzxx_item.shxydm is '社会信用代码';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_wfwzxx_item.wfxwmc is '违法行为名称';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_wfwzxx_item.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_wfwzxx_item.etl_timestamp is 'ETL处理时间戳';
