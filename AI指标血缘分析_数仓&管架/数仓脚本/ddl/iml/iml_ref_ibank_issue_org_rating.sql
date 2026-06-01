/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_ibank_issue_org_rating
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ref_ibank_issue_org_rating
whenever sqlerror continue none;
drop table ${iml_schema}.ref_ibank_issue_org_rating purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_ibank_issue_org_rating(
    issue_org_id varchar2(100) -- 发行机构编号
    ,lp_id varchar2(60) -- 法人编号
    ,issue_org_name varchar2(750) -- 发行公司名称
    ,rating_type_cd varchar2(10) -- 评级类型代码
    ,crdt_rating_cd varchar2(10) -- 信用评级代码
    ,rating_org_name varchar2(375) -- 评级机构名称
    ,effect_dt date -- 生效日期
    ,invalid_dt date -- 失效日期
    ,rating_outl varchar2(150) -- 评级展望
    ,input_dt date -- 录入日期
    ,create_dt date -- 创建日期
    ,update_dt date -- 更新日期
    ,etl_dt date -- ETL处理日期
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.ref_ibank_issue_org_rating to ${icl_schema};
grant select on ${iml_schema}.ref_ibank_issue_org_rating to ${idl_schema};
grant select on ${iml_schema}.ref_ibank_issue_org_rating to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_ibank_issue_org_rating is '同业发行机构评级';
comment on column ${iml_schema}.ref_ibank_issue_org_rating.issue_org_id is '发行机构编号';
comment on column ${iml_schema}.ref_ibank_issue_org_rating.lp_id is '法人编号';
comment on column ${iml_schema}.ref_ibank_issue_org_rating.issue_org_name is '发行公司名称';
comment on column ${iml_schema}.ref_ibank_issue_org_rating.rating_type_cd is '评级类型代码';
comment on column ${iml_schema}.ref_ibank_issue_org_rating.crdt_rating_cd is '信用评级代码';
comment on column ${iml_schema}.ref_ibank_issue_org_rating.rating_org_name is '评级机构名称';
comment on column ${iml_schema}.ref_ibank_issue_org_rating.effect_dt is '生效日期';
comment on column ${iml_schema}.ref_ibank_issue_org_rating.invalid_dt is '失效日期';
comment on column ${iml_schema}.ref_ibank_issue_org_rating.rating_outl is '评级展望';
comment on column ${iml_schema}.ref_ibank_issue_org_rating.input_dt is '录入日期';
comment on column ${iml_schema}.ref_ibank_issue_org_rating.create_dt is '创建日期';
comment on column ${iml_schema}.ref_ibank_issue_org_rating.update_dt is '更新日期';
comment on column ${iml_schema}.ref_ibank_issue_org_rating.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.ref_ibank_issue_org_rating.id_mark is '增删标志';
comment on column ${iml_schema}.ref_ibank_issue_org_rating.src_table_name is '源表名称';
comment on column ${iml_schema}.ref_ibank_issue_org_rating.job_cd is '任务编码';
comment on column ${iml_schema}.ref_ibank_issue_org_rating.etl_timestamp is 'ETL处理时间戳';
