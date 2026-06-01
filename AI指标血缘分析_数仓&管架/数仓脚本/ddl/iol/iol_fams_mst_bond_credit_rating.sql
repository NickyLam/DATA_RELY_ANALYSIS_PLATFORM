/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_mst_bond_credit_rating
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_mst_bond_credit_rating
whenever sqlerror continue none;
drop table ${iol_schema}.fams_mst_bond_credit_rating purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_mst_bond_credit_rating(
    sec_id varchar2(30) -- 债券代码（市场代码）
    ,grade_org_id varchar2(50) -- 评级机构
    ,grade_date date -- 评级日期
    ,grade_type varchar2(50) -- 评级类型，主体评级、债项评级
    ,short_long_term varchar2(50) -- 长短期
    ,grade_result varchar2(50) -- 评级结果
    ,sec_issue_id varchar2(32) -- 债券发行人
    ,input_type varchar2(50) -- 录入方式
    ,create_user varchar2(20) -- 创建人
    ,create_dept varchar2(32) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(20) -- 更新人
    ,update_time timestamp -- 更新时间
    ,is_recommand varchar2(50) -- 
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
grant select on ${iol_schema}.fams_mst_bond_credit_rating to ${iml_schema};
grant select on ${iol_schema}.fams_mst_bond_credit_rating to ${icl_schema};
grant select on ${iol_schema}.fams_mst_bond_credit_rating to ${idl_schema};
grant select on ${iol_schema}.fams_mst_bond_credit_rating to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_mst_bond_credit_rating is '债券信用评级';
comment on column ${iol_schema}.fams_mst_bond_credit_rating.sec_id is '债券代码（市场代码）';
comment on column ${iol_schema}.fams_mst_bond_credit_rating.grade_org_id is '评级机构';
comment on column ${iol_schema}.fams_mst_bond_credit_rating.grade_date is '评级日期';
comment on column ${iol_schema}.fams_mst_bond_credit_rating.grade_type is '评级类型，主体评级、债项评级';
comment on column ${iol_schema}.fams_mst_bond_credit_rating.short_long_term is '长短期';
comment on column ${iol_schema}.fams_mst_bond_credit_rating.grade_result is '评级结果';
comment on column ${iol_schema}.fams_mst_bond_credit_rating.sec_issue_id is '债券发行人';
comment on column ${iol_schema}.fams_mst_bond_credit_rating.input_type is '录入方式';
comment on column ${iol_schema}.fams_mst_bond_credit_rating.create_user is '创建人';
comment on column ${iol_schema}.fams_mst_bond_credit_rating.create_dept is '创建部门';
comment on column ${iol_schema}.fams_mst_bond_credit_rating.create_time is '创建时间';
comment on column ${iol_schema}.fams_mst_bond_credit_rating.update_user is '更新人';
comment on column ${iol_schema}.fams_mst_bond_credit_rating.update_time is '更新时间';
comment on column ${iol_schema}.fams_mst_bond_credit_rating.is_recommand is '';
comment on column ${iol_schema}.fams_mst_bond_credit_rating.start_dt is '开始时间';
comment on column ${iol_schema}.fams_mst_bond_credit_rating.end_dt is '结束时间';
comment on column ${iol_schema}.fams_mst_bond_credit_rating.id_mark is '增删标志';
comment on column ${iol_schema}.fams_mst_bond_credit_rating.etl_timestamp is 'ETL处理时间戳';
