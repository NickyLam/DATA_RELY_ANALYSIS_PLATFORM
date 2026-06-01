/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_ta_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ref_ta_info
whenever sqlerror continue none;
drop table ${iml_schema}.ref_ta_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_ta_info(
    ta_cd varchar2(30) -- TA代码
    ,lp_id varchar2(60) -- 法人编号
    ,sys_src_abbr varchar2(150) -- 系统来源简称
    ,ta_abbr varchar2(150) -- TA简称
    ,ta_name varchar2(150) -- TA名称
    ,check_entry_mode_cd varchar2(10) -- 对账模式代码
    ,open_tm varchar2(10) -- 开市时间
    ,close_tm varchar2(10) -- 闭市时间
    ,status_cd varchar2(10) -- 状态代码
    ,prod_cate_cd varchar2(10) -- 产品类别代码
    ,tot_flg varchar2(10) -- 汇总标志
    ,multi_acct_num_mode_flg varchar2(10) -- 多账号模式标志
    ,clear_way_cd varchar2(10) -- 清算方式代码
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
grant select on ${iml_schema}.ref_ta_info to ${icl_schema};
grant select on ${iml_schema}.ref_ta_info to ${idl_schema};
grant select on ${iml_schema}.ref_ta_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_ta_info is 'TA信息表';
comment on column ${iml_schema}.ref_ta_info.ta_cd is 'TA代码';
comment on column ${iml_schema}.ref_ta_info.lp_id is '法人编号';
comment on column ${iml_schema}.ref_ta_info.sys_src_abbr is '系统来源简称';
comment on column ${iml_schema}.ref_ta_info.ta_abbr is 'TA简称';
comment on column ${iml_schema}.ref_ta_info.ta_name is 'TA名称';
comment on column ${iml_schema}.ref_ta_info.check_entry_mode_cd is '对账模式代码';
comment on column ${iml_schema}.ref_ta_info.open_tm is '开市时间';
comment on column ${iml_schema}.ref_ta_info.close_tm is '闭市时间';
comment on column ${iml_schema}.ref_ta_info.status_cd is '状态代码';
comment on column ${iml_schema}.ref_ta_info.prod_cate_cd is '产品类别代码';
comment on column ${iml_schema}.ref_ta_info.tot_flg is '汇总标志';
comment on column ${iml_schema}.ref_ta_info.multi_acct_num_mode_flg is '多账号模式标志';
comment on column ${iml_schema}.ref_ta_info.clear_way_cd is '清算方式代码';
comment on column ${iml_schema}.ref_ta_info.create_dt is '创建日期';
comment on column ${iml_schema}.ref_ta_info.update_dt is '更新日期';
comment on column ${iml_schema}.ref_ta_info.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.ref_ta_info.id_mark is '增删标志';
comment on column ${iml_schema}.ref_ta_info.src_table_name is '源表名称';
comment on column ${iml_schema}.ref_ta_info.job_cd is '任务编码';
comment on column ${iml_schema}.ref_ta_info.etl_timestamp is 'ETL处理时间戳';
