/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_ifs_int_rat_para
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ref_ifs_int_rat_para
whenever sqlerror continue none;
drop table ${iml_schema}.ref_ifs_int_rat_para purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_ifs_int_rat_para(
    int_rat_cate_cd varchar2(10) -- 利率类别代码
    ,int_rat_tenor_cd varchar2(10) -- 利率期限代码
    ,curr_cd varchar2(10) -- 币种代码
    ,effect_dt date -- 生效日期
    ,invalid_dt date -- 失效日期
    ,int_rat_status_cd varchar2(10) -- 利率状态代码
    ,base_rat number(18,8) -- 基准利率
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by range (end_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_default_20991231 values less than (maxvalue)
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.ref_ifs_int_rat_para to ${icl_schema};
grant select on ${iml_schema}.ref_ifs_int_rat_para to ${idl_schema};
grant select on ${iml_schema}.ref_ifs_int_rat_para to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_ifs_int_rat_para is '联合存款利率参数表';
comment on column ${iml_schema}.ref_ifs_int_rat_para.int_rat_cate_cd is '利率类别代码';
comment on column ${iml_schema}.ref_ifs_int_rat_para.int_rat_tenor_cd is '利率期限代码';
comment on column ${iml_schema}.ref_ifs_int_rat_para.curr_cd is '币种代码';
comment on column ${iml_schema}.ref_ifs_int_rat_para.effect_dt is '生效日期';
comment on column ${iml_schema}.ref_ifs_int_rat_para.invalid_dt is '失效日期';
comment on column ${iml_schema}.ref_ifs_int_rat_para.int_rat_status_cd is '利率状态代码';
comment on column ${iml_schema}.ref_ifs_int_rat_para.base_rat is '基准利率';
comment on column ${iml_schema}.ref_ifs_int_rat_para.start_dt is '开始时间';
comment on column ${iml_schema}.ref_ifs_int_rat_para.end_dt is '结束时间';
comment on column ${iml_schema}.ref_ifs_int_rat_para.id_mark is '增删标志';
comment on column ${iml_schema}.ref_ifs_int_rat_para.src_table_name is '源表名称';
comment on column ${iml_schema}.ref_ifs_int_rat_para.job_cd is '任务编码';
comment on column ${iml_schema}.ref_ifs_int_rat_para.etl_timestamp is 'ETL处理时间戳';
