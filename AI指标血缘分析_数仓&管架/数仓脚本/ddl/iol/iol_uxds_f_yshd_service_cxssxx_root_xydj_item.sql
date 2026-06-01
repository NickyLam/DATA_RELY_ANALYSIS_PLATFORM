/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_yshd_service_cxssxx_root_xydj_item
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_yshd_service_cxssxx_root_xydj_item
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_yshd_service_cxssxx_root_xydj_item purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_yshd_service_cxssxx_root_xydj_item(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,item varchar2(4000) -- 关联标签
    ,pjjg varchar2(4000) -- 评价结果
    ,shxydm varchar2(4000) -- 社会信用代码
    ,nsrsbh varchar2(4000) -- 纳税人识别号
    ,xydj varchar2(4000) -- 信用等级
    ,pdnd varchar2(4000) -- 评定年度
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
grant select on ${iol_schema}.uxds_f_yshd_service_cxssxx_root_xydj_item to ${iml_schema};
grant select on ${iol_schema}.uxds_f_yshd_service_cxssxx_root_xydj_item to ${icl_schema};
grant select on ${iol_schema}.uxds_f_yshd_service_cxssxx_root_xydj_item to ${idl_schema};
grant select on ${iol_schema}.uxds_f_yshd_service_cxssxx_root_xydj_item to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_yshd_service_cxssxx_root_xydj_item is '深圳税局涉税信息信用等级';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_xydj_item.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_xydj_item.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_xydj_item.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_xydj_item.item is '关联标签';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_xydj_item.pjjg is '评价结果';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_xydj_item.shxydm is '社会信用代码';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_xydj_item.nsrsbh is '纳税人识别号';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_xydj_item.xydj is '信用等级';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_xydj_item.pdnd is '评定年度';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_xydj_item.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_xydj_item.etl_timestamp is 'ETL处理时间戳';
