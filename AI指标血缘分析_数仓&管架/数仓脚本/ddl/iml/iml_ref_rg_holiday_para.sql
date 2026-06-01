/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_rg_holiday_para
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ref_rg_holiday_para
whenever sqlerror continue none;
drop table ${iml_schema}.ref_rg_holiday_para purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_rg_holiday_para(
    lp_id varchar2(100) -- 法人编号
    ,holiday_type_cd varchar2(30) -- 假日类型代码
    ,local_cty_rg_cd varchar2(30) -- 所在国家和地区代码
    ,local_prov_cd varchar2(30) -- 所在省代码
    ,holiday_dt date -- 假日日期
    ,holiday_type_descb varchar2(500) -- 假日类型描述
    ,wd_flg varchar2(10) -- 工作日标志
    ,fit_range_cd varchar2(30) -- 适用范围代码
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
grant select on ${iml_schema}.ref_rg_holiday_para to ${icl_schema};
grant select on ${iml_schema}.ref_rg_holiday_para to ${idl_schema};
grant select on ${iml_schema}.ref_rg_holiday_para to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_rg_holiday_para is '地区节假日参数';
comment on column ${iml_schema}.ref_rg_holiday_para.lp_id is '法人编号';
comment on column ${iml_schema}.ref_rg_holiday_para.holiday_type_cd is '假日类型代码';
comment on column ${iml_schema}.ref_rg_holiday_para.local_cty_rg_cd is '所在国家和地区代码';
comment on column ${iml_schema}.ref_rg_holiday_para.local_prov_cd is '所在省代码';
comment on column ${iml_schema}.ref_rg_holiday_para.holiday_dt is '假日日期';
comment on column ${iml_schema}.ref_rg_holiday_para.holiday_type_descb is '假日类型描述';
comment on column ${iml_schema}.ref_rg_holiday_para.wd_flg is '工作日标志';
comment on column ${iml_schema}.ref_rg_holiday_para.fit_range_cd is '适用范围代码';
comment on column ${iml_schema}.ref_rg_holiday_para.start_dt is '开始时间';
comment on column ${iml_schema}.ref_rg_holiday_para.end_dt is '结束时间';
comment on column ${iml_schema}.ref_rg_holiday_para.id_mark is '增删标志';
comment on column ${iml_schema}.ref_rg_holiday_para.src_table_name is '源表名称';
comment on column ${iml_schema}.ref_rg_holiday_para.job_cd is '任务编码';
comment on column ${iml_schema}.ref_rg_holiday_para.etl_timestamp is 'ETL处理时间戳';
