/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_ban_bok_subject
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_ban_bok_subject
whenever sqlerror continue none;
drop table ${iol_schema}.fams_ban_bok_subject purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_ban_bok_subject(
    bookset_id varchar2(50) -- 账套代码
    ,subject_no varchar2(30) -- 科目号
    ,subject_name varchar2(200) -- 科目名称
    ,fsubject_id varchar2(32) -- 上级科目号
    ,bal_flag varchar2(50) -- 余额方向
    ,subject_type varchar2(50) -- 科目类型
    ,subject_level number(10) -- 科目级别
    ,acc_qua_flag varchar2(50) -- 是否核算数量
    ,acc_int_flag varchar2(1) -- 是否计息
    ,overdrawn_flag varchar2(50) -- 是否允许透支
    ,gen_detsub_flag varchar2(50) -- 是否生成四级科目
    ,base_subject_nature varchar2(100) -- 基础科目性质
    ,inv_aim varchar2(50) -- 投资目的
    ,sec_manage_acct_id varchar2(32) -- 证券管理户代码
    ,acct_type varchar2(2) -- 科目账户类型: 01产品; 02资产
    ,match_type varchar2(2) -- 账户匹配方式: 01自动匹; 02固定
    ,orgcode varchar2(10) -- 记账机构
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
grant select on ${iol_schema}.fams_ban_bok_subject to ${iml_schema};
grant select on ${iol_schema}.fams_ban_bok_subject to ${icl_schema};
grant select on ${iol_schema}.fams_ban_bok_subject to ${idl_schema};
grant select on ${iol_schema}.fams_ban_bok_subject to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_ban_bok_subject is '银行账科目表';
comment on column ${iol_schema}.fams_ban_bok_subject.bookset_id is '账套代码';
comment on column ${iol_schema}.fams_ban_bok_subject.subject_no is '科目号';
comment on column ${iol_schema}.fams_ban_bok_subject.subject_name is '科目名称';
comment on column ${iol_schema}.fams_ban_bok_subject.fsubject_id is '上级科目号';
comment on column ${iol_schema}.fams_ban_bok_subject.bal_flag is '余额方向';
comment on column ${iol_schema}.fams_ban_bok_subject.subject_type is '科目类型';
comment on column ${iol_schema}.fams_ban_bok_subject.subject_level is '科目级别';
comment on column ${iol_schema}.fams_ban_bok_subject.acc_qua_flag is '是否核算数量';
comment on column ${iol_schema}.fams_ban_bok_subject.acc_int_flag is '是否计息';
comment on column ${iol_schema}.fams_ban_bok_subject.overdrawn_flag is '是否允许透支';
comment on column ${iol_schema}.fams_ban_bok_subject.gen_detsub_flag is '是否生成四级科目';
comment on column ${iol_schema}.fams_ban_bok_subject.base_subject_nature is '基础科目性质';
comment on column ${iol_schema}.fams_ban_bok_subject.inv_aim is '投资目的';
comment on column ${iol_schema}.fams_ban_bok_subject.sec_manage_acct_id is '证券管理户代码';
comment on column ${iol_schema}.fams_ban_bok_subject.acct_type is '科目账户类型: 01产品; 02资产';
comment on column ${iol_schema}.fams_ban_bok_subject.match_type is '账户匹配方式: 01自动匹; 02固定';
comment on column ${iol_schema}.fams_ban_bok_subject.orgcode is '记账机构';
comment on column ${iol_schema}.fams_ban_bok_subject.create_user is '创建人';
comment on column ${iol_schema}.fams_ban_bok_subject.create_dept is '创建部门';
comment on column ${iol_schema}.fams_ban_bok_subject.create_time is '创建时间';
comment on column ${iol_schema}.fams_ban_bok_subject.update_user is '更新人';
comment on column ${iol_schema}.fams_ban_bok_subject.update_time is '更新时间';
comment on column ${iol_schema}.fams_ban_bok_subject.start_dt is '开始时间';
comment on column ${iol_schema}.fams_ban_bok_subject.end_dt is '结束时间';
comment on column ${iol_schema}.fams_ban_bok_subject.id_mark is '增删标志';
comment on column ${iol_schema}.fams_ban_bok_subject.etl_timestamp is 'ETL处理时间戳';
