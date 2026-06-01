/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ast_col_type_def
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ast_col_type_def
whenever sqlerror continue none;
drop table ${iml_schema}.ast_col_type_def purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_col_type_def(
    col_type_cd varchar2(30) -- 押品类型代码
    ,col_type_name varchar2(750) -- 押品类型名称
    ,up_level_node_type_cd varchar2(30) -- 上层节点类型代码
    ,lev number(10) -- 级别
    ,base_cate_flg varchar2(10) -- 基础类别标志
    ,spcl_info_type_cd varchar2(250) -- 专项信息类型代码
    ,keyw_a varchar2(750) -- 关键字段A
    ,effect_way_cd varchar2(10) -- 生效方式代码
    ,col_descb varchar2(1500) -- 押品描述
    ,status_descb varchar2(375) -- 状态描述
    ,admit_cls varchar2(15) -- 准入分类
    ,modif_dt date -- 修改日期
    ,modif_org_id varchar2(60) -- 修改机构编号
    ,data_type_cd varchar2(10) -- 数据类型代码
    ,guar_admit_cls_cd varchar2(10) -- 担保准入分类代码
    ,modif_emply_id varchar2(60) -- 修改员工编号
    ,reval_freq_cd varchar2(10) -- 重估频率代码
    ,higt_pm_rat number(18,6) -- 最高抵质押率
    ,keyw_b varchar2(375) -- 关键字段B
    ,gen_cd varchar2(30) -- 大类代码
    ,manu_idtfy_flg varchar2(10) -- 人工认定标志
    ,tshold number(18,6) -- 阀值
    ,strip_line_cd varchar2(10) -- 条线代码
    ,ab_divd_cd varchar2(10) -- AB类划分代码
    ,keyw_comb_use_flg varchar2(10) -- 关键字段结合使用标志
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
grant select on ${iml_schema}.ast_col_type_def to ${icl_schema};
grant select on ${iml_schema}.ast_col_type_def to ${idl_schema};
grant select on ${iml_schema}.ast_col_type_def to ${iel_schema};

-- comment
comment on table ${iml_schema}.ast_col_type_def is '押品类型定义表';
comment on column ${iml_schema}.ast_col_type_def.col_type_cd is '押品类型代码';
comment on column ${iml_schema}.ast_col_type_def.col_type_name is '押品类型名称';
comment on column ${iml_schema}.ast_col_type_def.up_level_node_type_cd is '上层节点类型代码';
comment on column ${iml_schema}.ast_col_type_def.lev is '级别';
comment on column ${iml_schema}.ast_col_type_def.base_cate_flg is '基础类别标志';
comment on column ${iml_schema}.ast_col_type_def.spcl_info_type_cd is '专项信息类型代码';
comment on column ${iml_schema}.ast_col_type_def.keyw_a is '关键字段A';
comment on column ${iml_schema}.ast_col_type_def.effect_way_cd is '生效方式代码';
comment on column ${iml_schema}.ast_col_type_def.col_descb is '押品描述';
comment on column ${iml_schema}.ast_col_type_def.status_descb is '状态描述';
comment on column ${iml_schema}.ast_col_type_def.admit_cls is '准入分类';
comment on column ${iml_schema}.ast_col_type_def.modif_dt is '修改日期';
comment on column ${iml_schema}.ast_col_type_def.modif_org_id is '修改机构编号';
comment on column ${iml_schema}.ast_col_type_def.data_type_cd is '数据类型代码';
comment on column ${iml_schema}.ast_col_type_def.guar_admit_cls_cd is '担保准入分类代码';
comment on column ${iml_schema}.ast_col_type_def.modif_emply_id is '修改员工编号';
comment on column ${iml_schema}.ast_col_type_def.reval_freq_cd is '重估频率代码';
comment on column ${iml_schema}.ast_col_type_def.higt_pm_rat is '最高抵质押率';
comment on column ${iml_schema}.ast_col_type_def.keyw_b is '关键字段B';
comment on column ${iml_schema}.ast_col_type_def.gen_cd is '大类代码';
comment on column ${iml_schema}.ast_col_type_def.manu_idtfy_flg is '人工认定标志';
comment on column ${iml_schema}.ast_col_type_def.tshold is '阀值';
comment on column ${iml_schema}.ast_col_type_def.strip_line_cd is '条线代码';
comment on column ${iml_schema}.ast_col_type_def.ab_divd_cd is 'AB类划分代码';
comment on column ${iml_schema}.ast_col_type_def.keyw_comb_use_flg is '关键字段结合使用标志';
comment on column ${iml_schema}.ast_col_type_def.create_dt is '创建日期';
comment on column ${iml_schema}.ast_col_type_def.update_dt is '更新日期';
comment on column ${iml_schema}.ast_col_type_def.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.ast_col_type_def.id_mark is '增删标志';
comment on column ${iml_schema}.ast_col_type_def.src_table_name is '源表名称';
comment on column ${iml_schema}.ast_col_type_def.job_cd is '任务编码';
comment on column ${iml_schema}.ast_col_type_def.etl_timestamp is 'ETL处理时间戳';
