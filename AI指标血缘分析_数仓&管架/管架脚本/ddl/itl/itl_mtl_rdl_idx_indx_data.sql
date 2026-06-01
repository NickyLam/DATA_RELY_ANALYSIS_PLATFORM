/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl mtl_rdl_idx_indx_data
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.mtl_rdl_idx_indx_data
whenever sqlerror continue none;
drop table ${itl_schema}.mtl_rdl_idx_indx_data purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.mtl_rdl_idx_indx_data(
    indx_no varchar2(60) -- 指标编号
    ,org_no varchar2(60) -- 机构编号
    ,curr_cd varchar2(10) -- 币种代码
    ,indx_dimen_no varchar2(10) -- 指标维度编号
    ,indx_dimen_cd varchar2(10) -- 指标维度代码
    ,stat_ped_cd varchar2(10) -- 统计周期代码
    ,indx_val number(38,6) -- 指标值
    ,comp_ear_year_val number(18,6) -- 与年初比
    ,comp_same_term_val number(18,6) -- 与同期比
    ,comp_last_mon_val number(18,6) -- 与上月比
    ,comp_last_qua_val number(18,6) -- 与上季比
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
    ,biz_strip_line_cd varchar2(64) -- 业务条线代码
    ,index_measure varchar2(64) -- 指标度量
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- 
-- comment
comment on table ${itl_schema}.mtl_rdl_idx_indx_data is 'RDL_指标_指标数据';
comment on column ${itl_schema}.mtl_rdl_idx_indx_data.indx_no is '指标编号';
comment on column ${itl_schema}.mtl_rdl_idx_indx_data.org_no is '机构编号';
comment on column ${itl_schema}.mtl_rdl_idx_indx_data.curr_cd is '币种代码';
comment on column ${itl_schema}.mtl_rdl_idx_indx_data.indx_dimen_no is '指标维度编号';
comment on column ${itl_schema}.mtl_rdl_idx_indx_data.indx_dimen_cd is '指标维度代码';
comment on column ${itl_schema}.mtl_rdl_idx_indx_data.stat_ped_cd is '统计周期代码';
comment on column ${itl_schema}.mtl_rdl_idx_indx_data.indx_val is '指标值';
comment on column ${itl_schema}.mtl_rdl_idx_indx_data.comp_ear_year_val is '与年初比';
comment on column ${itl_schema}.mtl_rdl_idx_indx_data.comp_same_term_val is '与同期比';
comment on column ${itl_schema}.mtl_rdl_idx_indx_data.comp_last_mon_val is '与上月比';
comment on column ${itl_schema}.mtl_rdl_idx_indx_data.comp_last_qua_val is '与上季比';
comment on column ${itl_schema}.mtl_rdl_idx_indx_data.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.mtl_rdl_idx_indx_data.etl_timestamp is 'ETL处理时间戳';
comment on column ${itl_schema}.mtl_rdl_idx_indx_data.biz_strip_line_cd is '业务条线代码';
comment on column ${itl_schema}.mtl_rdl_idx_indx_data.index_measure is '指标度量';
comment on column ${itl_schema}.mtl_rdl_idx_indx_data.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.mtl_rdl_idx_indx_data.etl_timestamp is 'ETL处理时间戳';
