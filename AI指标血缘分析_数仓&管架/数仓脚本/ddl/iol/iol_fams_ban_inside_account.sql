/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_ban_inside_account
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_ban_inside_account
whenever sqlerror continue none;
drop table ${iol_schema}.fams_ban_inside_account purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_ban_inside_account(
    prodcode varchar2(50) -- 产品代码
    ,orgcode varchar2(30) -- 机构号
    ,subject varchar2(50) -- 科目号
    ,acct_no varchar2(50) -- 内部户
    ,acct_name varchar2(200) -- 内部户名称
    ,acct_type varchar2(2) -- 账户类型: 01产品; 02资产
    ,saletarget varchar2(2) -- 销售对象: 01个人; 02对公; 03同业
    ,effectflag varchar2(2) -- 有效状态: 01有效; 02无效
    ,match_type varchar2(2) -- 匹配方式: 01自动匹; 02固定
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
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.fams_ban_inside_account to ${iml_schema};
grant select on ${iol_schema}.fams_ban_inside_account to ${icl_schema};
grant select on ${iol_schema}.fams_ban_inside_account to ${idl_schema};
grant select on ${iol_schema}.fams_ban_inside_account to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_ban_inside_account is '内部户匹配';
comment on column ${iol_schema}.fams_ban_inside_account.prodcode is '产品代码';
comment on column ${iol_schema}.fams_ban_inside_account.orgcode is '机构号';
comment on column ${iol_schema}.fams_ban_inside_account.subject is '科目号';
comment on column ${iol_schema}.fams_ban_inside_account.acct_no is '内部户';
comment on column ${iol_schema}.fams_ban_inside_account.acct_name is '内部户名称';
comment on column ${iol_schema}.fams_ban_inside_account.acct_type is '账户类型: 01产品; 02资产';
comment on column ${iol_schema}.fams_ban_inside_account.saletarget is '销售对象: 01个人; 02对公; 03同业';
comment on column ${iol_schema}.fams_ban_inside_account.effectflag is '有效状态: 01有效; 02无效';
comment on column ${iol_schema}.fams_ban_inside_account.match_type is '匹配方式: 01自动匹; 02固定';
comment on column ${iol_schema}.fams_ban_inside_account.create_user is '创建人';
comment on column ${iol_schema}.fams_ban_inside_account.create_dept is '创建部门';
comment on column ${iol_schema}.fams_ban_inside_account.create_time is '创建时间';
comment on column ${iol_schema}.fams_ban_inside_account.update_user is '更新人';
comment on column ${iol_schema}.fams_ban_inside_account.update_time is '更新时间';
comment on column ${iol_schema}.fams_ban_inside_account.start_dt is '开始时间';
comment on column ${iol_schema}.fams_ban_inside_account.end_dt is '结束时间';
comment on column ${iol_schema}.fams_ban_inside_account.id_mark is '增删标志';
comment on column ${iol_schema}.fams_ban_inside_account.etl_timestamp is 'ETL处理时间戳';
