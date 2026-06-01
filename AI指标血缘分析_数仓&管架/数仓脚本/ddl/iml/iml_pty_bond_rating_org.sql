/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_bond_rating_org
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_bond_rating_org
whenever sqlerror continue none;
drop table ${iml_schema}.pty_bond_rating_org purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_bond_rating_org(
    rating_org_id varchar2(60) -- 评级机构编号
    ,lp_id varchar2(60) -- 法人编号
    ,valid_flg varchar2(10) -- 有效标志
    ,rating_org_cn_name varchar2(150) -- 评级机构中文名称
    ,rating_org_en_name varchar2(150) -- 评级机构英文名称
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
grant select on ${iml_schema}.pty_bond_rating_org to ${icl_schema};
grant select on ${iml_schema}.pty_bond_rating_org to ${idl_schema};
grant select on ${iml_schema}.pty_bond_rating_org to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_bond_rating_org is '债券评级机构';
comment on column ${iml_schema}.pty_bond_rating_org.rating_org_id is '评级机构编号';
comment on column ${iml_schema}.pty_bond_rating_org.lp_id is '法人编号';
comment on column ${iml_schema}.pty_bond_rating_org.valid_flg is '有效标志';
comment on column ${iml_schema}.pty_bond_rating_org.rating_org_cn_name is '评级机构中文名称';
comment on column ${iml_schema}.pty_bond_rating_org.rating_org_en_name is '评级机构英文名称';
comment on column ${iml_schema}.pty_bond_rating_org.create_dt is '创建日期';
comment on column ${iml_schema}.pty_bond_rating_org.update_dt is '更新日期';
comment on column ${iml_schema}.pty_bond_rating_org.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.pty_bond_rating_org.id_mark is '增删标志';
comment on column ${iml_schema}.pty_bond_rating_org.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_bond_rating_org.job_cd is '任务编码';
comment on column ${iml_schema}.pty_bond_rating_org.etl_timestamp is 'ETL处理时间戳';
