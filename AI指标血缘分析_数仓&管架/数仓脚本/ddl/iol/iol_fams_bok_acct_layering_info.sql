/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_bok_acct_layering_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_bok_acct_layering_info
whenever sqlerror continue none;
drop table ${iol_schema}.fams_bok_acct_layering_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_bok_acct_layering_info(
    bookset_id varchar2(50) -- 账套代码
    ,layering_id varchar2(80) -- 分层代码
    ,layering_name varchar2(200) -- 分层名称
    ,f_layering_id varchar2(80) -- 上层代码
    ,bok_detail_id varchar2(32) -- 账务明细代码
    ,busi_id varchar2(50) -- 业务明细代码
    ,busi_detail_type varchar2(50) -- 业务明细类型
    ,vdate date -- 起息日
    ,mdate date -- 到期日
    ,calendar_id varchar2(32) -- 交易日历
    ,branch number(10) -- 分支序号
    ,lev varchar2(200) -- 级别序号
    ,cur_lev number(10) -- 当前级别
    ,s_branch number(10) -- 下级最新序号
    ,create_user varchar2(20) -- 创建人
    ,create_dept varchar2(32) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(20) -- 更新人
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
grant select on ${iol_schema}.fams_bok_acct_layering_info to ${iml_schema};
grant select on ${iol_schema}.fams_bok_acct_layering_info to ${icl_schema};
grant select on ${iol_schema}.fams_bok_acct_layering_info to ${idl_schema};
grant select on ${iol_schema}.fams_bok_acct_layering_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_bok_acct_layering_info is '核算分层信息';
comment on column ${iol_schema}.fams_bok_acct_layering_info.bookset_id is '账套代码';
comment on column ${iol_schema}.fams_bok_acct_layering_info.layering_id is '分层代码';
comment on column ${iol_schema}.fams_bok_acct_layering_info.layering_name is '分层名称';
comment on column ${iol_schema}.fams_bok_acct_layering_info.f_layering_id is '上层代码';
comment on column ${iol_schema}.fams_bok_acct_layering_info.bok_detail_id is '账务明细代码';
comment on column ${iol_schema}.fams_bok_acct_layering_info.busi_id is '业务明细代码';
comment on column ${iol_schema}.fams_bok_acct_layering_info.busi_detail_type is '业务明细类型';
comment on column ${iol_schema}.fams_bok_acct_layering_info.vdate is '起息日';
comment on column ${iol_schema}.fams_bok_acct_layering_info.mdate is '到期日';
comment on column ${iol_schema}.fams_bok_acct_layering_info.calendar_id is '交易日历';
comment on column ${iol_schema}.fams_bok_acct_layering_info.branch is '分支序号';
comment on column ${iol_schema}.fams_bok_acct_layering_info.lev is '级别序号';
comment on column ${iol_schema}.fams_bok_acct_layering_info.cur_lev is '当前级别';
comment on column ${iol_schema}.fams_bok_acct_layering_info.s_branch is '下级最新序号';
comment on column ${iol_schema}.fams_bok_acct_layering_info.create_user is '创建人';
comment on column ${iol_schema}.fams_bok_acct_layering_info.create_dept is '创建部门';
comment on column ${iol_schema}.fams_bok_acct_layering_info.create_time is '创建时间';
comment on column ${iol_schema}.fams_bok_acct_layering_info.update_user is '更新人';
comment on column ${iol_schema}.fams_bok_acct_layering_info.update_time is '更新时间';
comment on column ${iol_schema}.fams_bok_acct_layering_info.start_dt is '开始时间';
comment on column ${iol_schema}.fams_bok_acct_layering_info.end_dt is '结束时间';
comment on column ${iol_schema}.fams_bok_acct_layering_info.id_mark is '增删标志';
comment on column ${iol_schema}.fams_bok_acct_layering_info.etl_timestamp is 'ETL处理时间戳';
