/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_gdpronsrsqssxx_body_xypjxx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_gdpronsrsqssxx_body_xypjxx
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_gdpronsrsqssxx_body_xypjxx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_gdpronsrsqssxx_body_xypjxx(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,message varchar2(4000) -- 状态返回信息
    ,code varchar2(4000) -- 返回码
    ,pjsj varchar2(4000) -- 评级时间
    ,rtncode varchar2(4000) -- 状态返回码
    ,reason varchar2(4000) -- 原因描述
    ,xypjxx varchar2(4000) -- 关联标签
    ,nsrsbh varchar2(4000) -- 纳税人识别号
    ,nsrdzdah varchar2(4000) -- 纳税人电子档案号
    ,xydj varchar2(4000) -- 信用等级（a
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
grant select on ${iol_schema}.uxds_f_gdpronsrsqssxx_body_xypjxx to ${iml_schema};
grant select on ${iol_schema}.uxds_f_gdpronsrsqssxx_body_xypjxx to ${icl_schema};
grant select on ${iol_schema}.uxds_f_gdpronsrsqssxx_body_xypjxx to ${idl_schema};
grant select on ${iol_schema}.uxds_f_gdpronsrsqssxx_body_xypjxx to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_gdpronsrsqssxx_body_xypjxx is '广东税局纳税人涉税信息信用评价信息';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_xypjxx.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_xypjxx.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_xypjxx.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_xypjxx.message is '状态返回信息';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_xypjxx.code is '返回码';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_xypjxx.pjsj is '评级时间';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_xypjxx.rtncode is '状态返回码';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_xypjxx.reason is '原因描述';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_xypjxx.xypjxx is '关联标签';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_xypjxx.nsrsbh is '纳税人识别号';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_xypjxx.nsrdzdah is '纳税人电子档案号';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_xypjxx.xydj is '信用等级（a';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_xypjxx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_xypjxx.etl_timestamp is 'ETL处理时间戳';
