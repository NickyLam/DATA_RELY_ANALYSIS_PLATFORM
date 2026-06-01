/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_ibank_accti_subj_para
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ref_ibank_accti_subj_para
whenever sqlerror continue none;
drop table ${iml_schema}.ref_ibank_accti_subj_para purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_ibank_accti_subj_para(
    seq_num varchar2(100) -- 序号
    ,level1_subj_name varchar2(750) -- 一级科目名称
    ,level2_subj_name varchar2(750) -- 二级科目名称
    ,level3_subj_name varchar2(750) -- 三级科目名称
    ,accti_code varchar2(150) -- 核算码
    ,subj_attr_cd varchar2(30) -- 科目属性代码
    ,subj_dir_cd varchar2(30) -- 科目方向代码
    ,level1_subj_id varchar2(100) -- 一级科目编号
    ,level2_subj_id varchar2(100) -- 二级科目编号
    ,level3_subj_id varchar2(100) -- 三级科目编号
    ,entry_type_cd varchar2(30) -- 分录类型代码
    ,entry_type_cd_1 varchar2(30) -- 分录类型代码1
    ,entry_type_cd_2 varchar2(30) -- 分录类型代码2
    ,entry_type_cd_3 varchar2(30) -- 分录类型代码3
    ,entry_type_cd_4 varchar2(30) -- 分录类型代码4
    ,entry_type_cd_5 varchar2(30) -- 分录类型代码5
    ,charge_type_cd varchar2(30) -- 记账类型代码
    ,level4_subj_name varchar2(750) -- 四级科目名称
    ,level5_subj_name varchar2(750) -- 五级科目名称
    ,level4_subj_id varchar2(100) -- 四级科目编号
    ,level5_subj_id varchar2(100) -- 五级科目编号
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
grant select on ${iml_schema}.ref_ibank_accti_subj_para to ${icl_schema};
grant select on ${iml_schema}.ref_ibank_accti_subj_para to ${idl_schema};
grant select on ${iml_schema}.ref_ibank_accti_subj_para to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_ibank_accti_subj_para is '同业核算科目参数';
comment on column ${iml_schema}.ref_ibank_accti_subj_para.seq_num is '序号';
comment on column ${iml_schema}.ref_ibank_accti_subj_para.level1_subj_name is '一级科目名称';
comment on column ${iml_schema}.ref_ibank_accti_subj_para.level2_subj_name is '二级科目名称';
comment on column ${iml_schema}.ref_ibank_accti_subj_para.level3_subj_name is '三级科目名称';
comment on column ${iml_schema}.ref_ibank_accti_subj_para.accti_code is '核算码';
comment on column ${iml_schema}.ref_ibank_accti_subj_para.subj_attr_cd is '科目属性代码';
comment on column ${iml_schema}.ref_ibank_accti_subj_para.subj_dir_cd is '科目方向代码';
comment on column ${iml_schema}.ref_ibank_accti_subj_para.level1_subj_id is '一级科目编号';
comment on column ${iml_schema}.ref_ibank_accti_subj_para.level2_subj_id is '二级科目编号';
comment on column ${iml_schema}.ref_ibank_accti_subj_para.level3_subj_id is '三级科目编号';
comment on column ${iml_schema}.ref_ibank_accti_subj_para.entry_type_cd is '分录类型代码';
comment on column ${iml_schema}.ref_ibank_accti_subj_para.entry_type_cd_1 is '分录类型代码1';
comment on column ${iml_schema}.ref_ibank_accti_subj_para.entry_type_cd_2 is '分录类型代码2';
comment on column ${iml_schema}.ref_ibank_accti_subj_para.entry_type_cd_3 is '分录类型代码3';
comment on column ${iml_schema}.ref_ibank_accti_subj_para.entry_type_cd_4 is '分录类型代码4';
comment on column ${iml_schema}.ref_ibank_accti_subj_para.entry_type_cd_5 is '分录类型代码5';
comment on column ${iml_schema}.ref_ibank_accti_subj_para.charge_type_cd is '记账类型代码';
comment on column ${iml_schema}.ref_ibank_accti_subj_para.level4_subj_name is '四级科目名称';
comment on column ${iml_schema}.ref_ibank_accti_subj_para.level5_subj_name is '五级科目名称';
comment on column ${iml_schema}.ref_ibank_accti_subj_para.level4_subj_id is '四级科目编号';
comment on column ${iml_schema}.ref_ibank_accti_subj_para.level5_subj_id is '五级科目编号';
comment on column ${iml_schema}.ref_ibank_accti_subj_para.create_dt is '创建日期';
comment on column ${iml_schema}.ref_ibank_accti_subj_para.update_dt is '更新日期';
comment on column ${iml_schema}.ref_ibank_accti_subj_para.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.ref_ibank_accti_subj_para.id_mark is '增删标志';
comment on column ${iml_schema}.ref_ibank_accti_subj_para.src_table_name is '源表名称';
comment on column ${iml_schema}.ref_ibank_accti_subj_para.job_cd is '任务编码';
comment on column ${iml_schema}.ref_ibank_accti_subj_para.etl_timestamp is 'ETL处理时间戳';
