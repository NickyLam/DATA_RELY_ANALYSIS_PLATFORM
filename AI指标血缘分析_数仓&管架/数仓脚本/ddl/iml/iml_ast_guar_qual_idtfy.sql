/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ast_guar_qual_idtfy
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ast_guar_qual_idtfy
whenever sqlerror continue none;
drop table ${iml_schema}.ast_guar_qual_idtfy purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_guar_qual_idtfy(
    asset_id varchar2(60) -- 资产编号
    ,lp_id varchar2(60) -- 法人编号
    ,guar_cont_id varchar2(60) -- 担保合同编号
    ,asset_and_brwer_pc_flg varchar2(10) -- 资产与借款人正相关标志
    ,guar_impt_flg varchar2(10) -- 保证落实标志
    ,guar_rela_cd varchar2(10) -- 保证相关性代码
    ,guar_rela_rest_cd varchar2(10) -- 保证相关结果代码
    ,wt_md_guar_cls_qual_flg varchar2(10) -- 权重法担保分类合格标志
    ,wt_md_dr_tool_qual_flg varchar2(10) -- 权重法缓释工具合格标志
    ,wt_md_qual_dr_tool_cate_cd varchar2(10) -- 权重法合格缓释工具类别代码
    ,np_guar_cls_qual_flg varchar2(10) -- 内评初级法担保分类合格标志
    ,np_qual_dr_tool_flg varchar2(10) -- 内评初级法合格缓释工具标志
    ,np_qual_dr_tool_cate_cd varchar2(10) -- 内评初级法合格缓释工具类别代码
    ,guar_amt number(30,2) -- 担保金额
    ,mtg_rat number(18,8) -- 抵质押率
    ,guar_guar_form_cd varchar2(10) -- 保证担保形式代码
    ,guar_way_cd varchar2(10) -- 担保方式代码
    ,curr_cd varchar2(10) -- 币种代码
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
grant select on ${iml_schema}.ast_guar_qual_idtfy to ${icl_schema};
grant select on ${iml_schema}.ast_guar_qual_idtfy to ${idl_schema};
grant select on ${iml_schema}.ast_guar_qual_idtfy to ${iel_schema};

-- comment
comment on table ${iml_schema}.ast_guar_qual_idtfy is '担保合格认定表';
comment on column ${iml_schema}.ast_guar_qual_idtfy.asset_id is '资产编号';
comment on column ${iml_schema}.ast_guar_qual_idtfy.lp_id is '法人编号';
comment on column ${iml_schema}.ast_guar_qual_idtfy.guar_cont_id is '担保合同编号';
comment on column ${iml_schema}.ast_guar_qual_idtfy.asset_and_brwer_pc_flg is '资产与借款人正相关标志';
comment on column ${iml_schema}.ast_guar_qual_idtfy.guar_impt_flg is '保证落实标志';
comment on column ${iml_schema}.ast_guar_qual_idtfy.guar_rela_cd is '保证相关性代码';
comment on column ${iml_schema}.ast_guar_qual_idtfy.guar_rela_rest_cd is '保证相关结果代码';
comment on column ${iml_schema}.ast_guar_qual_idtfy.wt_md_guar_cls_qual_flg is '权重法担保分类合格标志';
comment on column ${iml_schema}.ast_guar_qual_idtfy.wt_md_dr_tool_qual_flg is '权重法缓释工具合格标志';
comment on column ${iml_schema}.ast_guar_qual_idtfy.wt_md_qual_dr_tool_cate_cd is '权重法合格缓释工具类别代码';
comment on column ${iml_schema}.ast_guar_qual_idtfy.np_guar_cls_qual_flg is '内评初级法担保分类合格标志';
comment on column ${iml_schema}.ast_guar_qual_idtfy.np_qual_dr_tool_flg is '内评初级法合格缓释工具标志';
comment on column ${iml_schema}.ast_guar_qual_idtfy.np_qual_dr_tool_cate_cd is '内评初级法合格缓释工具类别代码';
comment on column ${iml_schema}.ast_guar_qual_idtfy.guar_amt is '担保金额';
comment on column ${iml_schema}.ast_guar_qual_idtfy.mtg_rat is '抵质押率';
comment on column ${iml_schema}.ast_guar_qual_idtfy.guar_guar_form_cd is '保证担保形式代码';
comment on column ${iml_schema}.ast_guar_qual_idtfy.guar_way_cd is '担保方式代码';
comment on column ${iml_schema}.ast_guar_qual_idtfy.curr_cd is '币种代码';
comment on column ${iml_schema}.ast_guar_qual_idtfy.create_dt is '创建日期';
comment on column ${iml_schema}.ast_guar_qual_idtfy.update_dt is '更新日期';
comment on column ${iml_schema}.ast_guar_qual_idtfy.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.ast_guar_qual_idtfy.id_mark is '增删标志';
comment on column ${iml_schema}.ast_guar_qual_idtfy.src_table_name is '源表名称';
comment on column ${iml_schema}.ast_guar_qual_idtfy.job_cd is '任务编码';
comment on column ${iml_schema}.ast_guar_qual_idtfy.etl_timestamp is 'ETL处理时间戳';
