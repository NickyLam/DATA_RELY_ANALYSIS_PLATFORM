/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pbms_tbl_cust_member
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pbms_tbl_cust_member
whenever sqlerror continue none;
drop table ${iol_schema}.pbms_tbl_cust_member purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pbms_tbl_cust_member(
    id number(20,0) -- 主键
    ,cust_id varchar2(300) -- 客户ID（客户号 or 潜客号）
    ,is_positive number(4,0) -- 客户类型 1-正式客户 0-潜客
    ,member_code varchar2(24) -- 等级编码，关联tbl_member_grade表必须是拿start_flag=1的
    ,start_date varchar2(24) -- 等级开始日
    ,start_time varchar2(24) -- 等级开始时间
    ,end_date varchar2(24) -- 等级到期日
    ,last_upgrade_time date -- 最近升级时间
    ,last_downgrade_time date -- 最近降级时间
    ,del_flag number(11,0) -- 逻辑删除
    ,created_by varchar2(60) -- 创建人
    ,create_time varchar2(60) -- 创建时间
    ,updated_by varchar2(60) -- 修改人
    ,update_time varchar2(60) -- 修改时间
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
grant select on ${iol_schema}.pbms_tbl_cust_member to ${iml_schema};
grant select on ${iol_schema}.pbms_tbl_cust_member to ${icl_schema};
grant select on ${iol_schema}.pbms_tbl_cust_member to ${idl_schema};
grant select on ${iol_schema}.pbms_tbl_cust_member to ${iel_schema};

-- comment
comment on table ${iol_schema}.pbms_tbl_cust_member is '客戶会员等级表';
comment on column ${iol_schema}.pbms_tbl_cust_member.id is '主键';
comment on column ${iol_schema}.pbms_tbl_cust_member.cust_id is '客户ID（客户号 or 潜客号）';
comment on column ${iol_schema}.pbms_tbl_cust_member.is_positive is '客户类型 1-正式客户 0-潜客';
comment on column ${iol_schema}.pbms_tbl_cust_member.member_code is '等级编码，关联tbl_member_grade表必须是拿start_flag=1的';
comment on column ${iol_schema}.pbms_tbl_cust_member.start_date is '等级开始日';
comment on column ${iol_schema}.pbms_tbl_cust_member.start_time is '等级开始时间';
comment on column ${iol_schema}.pbms_tbl_cust_member.end_date is '等级到期日';
comment on column ${iol_schema}.pbms_tbl_cust_member.last_upgrade_time is '最近升级时间';
comment on column ${iol_schema}.pbms_tbl_cust_member.last_downgrade_time is '最近降级时间';
comment on column ${iol_schema}.pbms_tbl_cust_member.del_flag is '逻辑删除';
comment on column ${iol_schema}.pbms_tbl_cust_member.created_by is '创建人';
comment on column ${iol_schema}.pbms_tbl_cust_member.create_time is '创建时间';
comment on column ${iol_schema}.pbms_tbl_cust_member.updated_by is '修改人';
comment on column ${iol_schema}.pbms_tbl_cust_member.update_time is '修改时间';
comment on column ${iol_schema}.pbms_tbl_cust_member.start_dt is '开始时间';
comment on column ${iol_schema}.pbms_tbl_cust_member.end_dt is '结束时间';
comment on column ${iol_schema}.pbms_tbl_cust_member.id_mark is '增删标志';
comment on column ${iol_schema}.pbms_tbl_cust_member.etl_timestamp is 'ETL处理时间戳';
