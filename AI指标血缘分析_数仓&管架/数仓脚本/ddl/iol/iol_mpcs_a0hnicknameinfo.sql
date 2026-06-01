/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a0hnicknameinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a0hnicknameinfo
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a0hnicknameinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a0hnicknameinfo(
    familyid varchar2(12) -- 家庭号
    ,startcustno varchar2(18) -- 发起人客户号
    ,custacc varchar2(60) -- 被设置人账号
    ,nickname varchar2(30) -- 昵称
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
grant select on ${iol_schema}.mpcs_a0hnicknameinfo to ${iml_schema};
grant select on ${iol_schema}.mpcs_a0hnicknameinfo to ${icl_schema};
grant select on ${iol_schema}.mpcs_a0hnicknameinfo to ${idl_schema};
grant select on ${iol_schema}.mpcs_a0hnicknameinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a0hnicknameinfo is '家庭卡昵称表';
comment on column ${iol_schema}.mpcs_a0hnicknameinfo.familyid is '家庭号';
comment on column ${iol_schema}.mpcs_a0hnicknameinfo.startcustno is '发起人客户号';
comment on column ${iol_schema}.mpcs_a0hnicknameinfo.custacc is '被设置人账号';
comment on column ${iol_schema}.mpcs_a0hnicknameinfo.nickname is '昵称';
comment on column ${iol_schema}.mpcs_a0hnicknameinfo.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a0hnicknameinfo.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a0hnicknameinfo.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a0hnicknameinfo.etl_timestamp is 'ETL处理时间戳';
