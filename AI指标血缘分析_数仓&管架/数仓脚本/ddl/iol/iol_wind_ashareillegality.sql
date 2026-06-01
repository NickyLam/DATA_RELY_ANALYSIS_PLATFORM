/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_ashareillegality
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_ashareillegality
whenever sqlerror continue none;
drop table ${iol_schema}.wind_ashareillegality purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_ashareillegality(
    object_id varchar2(150) -- 对象ID
    ,s_info_windcode varchar2(60) -- Wind代码
    ,s_info_compcode varchar2(60) -- 公司ID
    ,ann_dt varchar2(12) -- 公告日期
    ,illeg_type varchar2(300) -- 违规类型
    ,subject_type number(9,0) -- 主体类别代码
    ,subject varchar2(300) -- 违规主体
    ,relation_type number(9,0) -- 与上市公司的关系
    ,behavior varchar2(4000) -- 违规行为
    ,disposal_dt varchar2(12) -- 处罚日期
    ,disposal_type varchar2(150) -- 处分类型
    ,method varchar2(4000) -- 处分措施
    ,processor varchar2(300) -- 处理人
    ,amount number(20,4) -- 处罚金额(元)
    ,ban_year number(20,4) -- 市场禁入期限(年)
    ,ref_rule varchar2(3000) -- 相关法规
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
grant select on ${iol_schema}.wind_ashareillegality to ${iml_schema};
grant select on ${iol_schema}.wind_ashareillegality to ${icl_schema};
grant select on ${iol_schema}.wind_ashareillegality to ${idl_schema};
grant select on ${iol_schema}.wind_ashareillegality to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_ashareillegality is '中国A股违规事件';
comment on column ${iol_schema}.wind_ashareillegality.object_id is '对象ID';
comment on column ${iol_schema}.wind_ashareillegality.s_info_windcode is 'Wind代码';
comment on column ${iol_schema}.wind_ashareillegality.s_info_compcode is '公司ID';
comment on column ${iol_schema}.wind_ashareillegality.ann_dt is '公告日期';
comment on column ${iol_schema}.wind_ashareillegality.illeg_type is '违规类型';
comment on column ${iol_schema}.wind_ashareillegality.subject_type is '主体类别代码';
comment on column ${iol_schema}.wind_ashareillegality.subject is '违规主体';
comment on column ${iol_schema}.wind_ashareillegality.relation_type is '与上市公司的关系';
comment on column ${iol_schema}.wind_ashareillegality.behavior is '违规行为';
comment on column ${iol_schema}.wind_ashareillegality.disposal_dt is '处罚日期';
comment on column ${iol_schema}.wind_ashareillegality.disposal_type is '处分类型';
comment on column ${iol_schema}.wind_ashareillegality.method is '处分措施';
comment on column ${iol_schema}.wind_ashareillegality.processor is '处理人';
comment on column ${iol_schema}.wind_ashareillegality.amount is '处罚金额(元)';
comment on column ${iol_schema}.wind_ashareillegality.ban_year is '市场禁入期限(年)';
comment on column ${iol_schema}.wind_ashareillegality.ref_rule is '相关法规';
comment on column ${iol_schema}.wind_ashareillegality.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_ashareillegality.etl_timestamp is 'ETL处理时间戳';
