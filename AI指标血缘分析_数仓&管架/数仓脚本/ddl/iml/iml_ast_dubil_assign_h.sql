/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ast_dubil_assign_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ast_dubil_assign_h
whenever sqlerror continue none;
drop table ${iml_schema}.ast_dubil_assign_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_dubil_assign_h(
    asset_id varchar2(60) -- 资产编号
    ,lp_id varchar2(60) -- 法人编号
    ,dubil_id varchar2(60) -- 借据编号
    ,dubil_bal number(30,2) -- 借据余额
    ,loan_assign_bal number(30,2) -- 贷款分配余额
    ,loan_distr_type_cd varchar2(30) -- 贷款发放类型代码
    ,assign_level_cd varchar2(30) -- 分配等级代码
    ,bus_breed_name varchar2(1000) -- 业务品种名称
    ,splt_col_latest_val number(30,2) -- 我行确认价值
    ,splt_col_insto_val number(30,2) -- 拆分押品入库价值
    ,in_out_tab_flg varchar2(10) -- 表内外标志
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.ast_dubil_assign_h to ${icl_schema};
grant select on ${iml_schema}.ast_dubil_assign_h to ${idl_schema};
grant select on ${iml_schema}.ast_dubil_assign_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.ast_dubil_assign_h is '资产借据分配历史';
comment on column ${iml_schema}.ast_dubil_assign_h.asset_id is '资产编号';
comment on column ${iml_schema}.ast_dubil_assign_h.lp_id is '法人编号';
comment on column ${iml_schema}.ast_dubil_assign_h.dubil_id is '借据编号';
comment on column ${iml_schema}.ast_dubil_assign_h.dubil_bal is '借据余额';
comment on column ${iml_schema}.ast_dubil_assign_h.loan_assign_bal is '贷款分配余额';
comment on column ${iml_schema}.ast_dubil_assign_h.loan_distr_type_cd is '贷款发放类型代码';
comment on column ${iml_schema}.ast_dubil_assign_h.assign_level_cd is '分配等级代码';
comment on column ${iml_schema}.ast_dubil_assign_h.bus_breed_name is '业务品种名称';
comment on column ${iml_schema}.ast_dubil_assign_h.splt_col_latest_val is '我行确认价值';
comment on column ${iml_schema}.ast_dubil_assign_h.splt_col_insto_val is '拆分押品入库价值';
comment on column ${iml_schema}.ast_dubil_assign_h.in_out_tab_flg is '表内外标志';
comment on column ${iml_schema}.ast_dubil_assign_h.start_dt is '开始时间';
comment on column ${iml_schema}.ast_dubil_assign_h.end_dt is '结束时间';
comment on column ${iml_schema}.ast_dubil_assign_h.id_mark is '增删标志';
comment on column ${iml_schema}.ast_dubil_assign_h.src_table_name is '源表名称';
comment on column ${iml_schema}.ast_dubil_assign_h.job_cd is '任务编码';
comment on column ${iml_schema}.ast_dubil_assign_h.etl_timestamp is 'ETL处理时间戳';
