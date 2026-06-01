/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_cap_cntpty_cls
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ref_cap_cntpty_cls
whenever sqlerror continue none;
drop table ${iml_schema}.ref_cap_cntpty_cls purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_cap_cntpty_cls(
    cls_id varchar2(60) -- 分类编号
    ,lp_id varchar2(60) -- 法人编号
    ,tran_dir_cd varchar2(10) -- 交易方向代码
    ,cls_abbr varchar2(150) -- 分类简称
    ,cls_descb varchar2(750) -- 分类描述
    ,super_cls_id varchar2(60) -- 上级分类编号
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
grant select on ${iml_schema}.ref_cap_cntpty_cls to ${icl_schema};
grant select on ${iml_schema}.ref_cap_cntpty_cls to ${idl_schema};
grant select on ${iml_schema}.ref_cap_cntpty_cls to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_cap_cntpty_cls is '资金交易对手分类';
comment on column ${iml_schema}.ref_cap_cntpty_cls.cls_id is '分类编号';
comment on column ${iml_schema}.ref_cap_cntpty_cls.lp_id is '法人编号';
comment on column ${iml_schema}.ref_cap_cntpty_cls.tran_dir_cd is '交易方向代码';
comment on column ${iml_schema}.ref_cap_cntpty_cls.cls_abbr is '分类简称';
comment on column ${iml_schema}.ref_cap_cntpty_cls.cls_descb is '分类描述';
comment on column ${iml_schema}.ref_cap_cntpty_cls.super_cls_id is '上级分类编号';
comment on column ${iml_schema}.ref_cap_cntpty_cls.create_dt is '创建日期';
comment on column ${iml_schema}.ref_cap_cntpty_cls.update_dt is '更新日期';
comment on column ${iml_schema}.ref_cap_cntpty_cls.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.ref_cap_cntpty_cls.id_mark is '增删标志';
comment on column ${iml_schema}.ref_cap_cntpty_cls.src_table_name is '源表名称';
comment on column ${iml_schema}.ref_cap_cntpty_cls.job_cd is '任务编码';
comment on column ${iml_schema}.ref_cap_cntpty_cls.etl_timestamp is 'ETL处理时间戳';
