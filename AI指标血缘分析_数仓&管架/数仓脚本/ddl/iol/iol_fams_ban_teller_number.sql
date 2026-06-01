/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_ban_teller_number
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_ban_teller_number
whenever sqlerror continue none;
drop table ${iol_schema}.fams_ban_teller_number purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_ban_teller_number(
    username varchar2(64) -- 用户名
    ,tellerno1 varchar2(40) -- 资管柜员号
    ,tellerno2 varchar2(40) -- 营运柜员号
    ,status varchar2(2) -- 有效状态: 0删除; 1有效
    ,create_user varchar2(40) -- 创建人
    ,create_dept varchar2(64) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(40) -- 更新人
    ,update_time timestamp -- 更新时间
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
grant select on ${iol_schema}.fams_ban_teller_number to ${iml_schema};
grant select on ${iol_schema}.fams_ban_teller_number to ${icl_schema};
grant select on ${iol_schema}.fams_ban_teller_number to ${idl_schema};
grant select on ${iol_schema}.fams_ban_teller_number to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_ban_teller_number is '柜员号匹配';
comment on column ${iol_schema}.fams_ban_teller_number.username is '用户名';
comment on column ${iol_schema}.fams_ban_teller_number.tellerno1 is '资管柜员号';
comment on column ${iol_schema}.fams_ban_teller_number.tellerno2 is '营运柜员号';
comment on column ${iol_schema}.fams_ban_teller_number.status is '有效状态: 0删除; 1有效';
comment on column ${iol_schema}.fams_ban_teller_number.create_user is '创建人';
comment on column ${iol_schema}.fams_ban_teller_number.create_dept is '创建部门';
comment on column ${iol_schema}.fams_ban_teller_number.create_time is '创建时间';
comment on column ${iol_schema}.fams_ban_teller_number.update_user is '更新人';
comment on column ${iol_schema}.fams_ban_teller_number.update_time is '更新时间';
comment on column ${iol_schema}.fams_ban_teller_number.start_dt is '开始时间';
comment on column ${iol_schema}.fams_ban_teller_number.end_dt is '结束时间';
comment on column ${iol_schema}.fams_ban_teller_number.id_mark is '增删标志';
comment on column ${iol_schema}.fams_ban_teller_number.etl_timestamp is 'ETL处理时间戳';
