/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_curr_fin_instm_int_rat
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ref_curr_fin_instm_int_rat
whenever sqlerror continue none;
drop table ${iml_schema}.ref_curr_fin_instm_int_rat purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_curr_fin_instm_int_rat(
    int_rat_id varchar2(60) -- 利率编号
    ,lp_id varchar2(60) -- 法人编号
    ,int_rat_def_id varchar2(60) -- 利率定义编号
    ,int_rat number(18,8) -- 利率
    ,vp_start_dt date -- 有效期起始日期
    ,vp_end_dt date -- 有效期结束日期
    ,cfm_id varchar2(100) -- 确认单编号
    ,txy_matn_flg varchar2(10) -- 同兴赢维护标志
    ,sign_lmt number(38,8) -- 签约额度
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
grant select on ${iml_schema}.ref_curr_fin_instm_int_rat to ${icl_schema};
grant select on ${iml_schema}.ref_curr_fin_instm_int_rat to ${idl_schema};
grant select on ${iml_schema}.ref_curr_fin_instm_int_rat to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_curr_fin_instm_int_rat is '活期金融工具利率';
comment on column ${iml_schema}.ref_curr_fin_instm_int_rat.int_rat_id is '利率编号';
comment on column ${iml_schema}.ref_curr_fin_instm_int_rat.lp_id is '法人编号';
comment on column ${iml_schema}.ref_curr_fin_instm_int_rat.int_rat_def_id is '利率定义编号';
comment on column ${iml_schema}.ref_curr_fin_instm_int_rat.int_rat is '利率';
comment on column ${iml_schema}.ref_curr_fin_instm_int_rat.vp_start_dt is '有效期起始日期';
comment on column ${iml_schema}.ref_curr_fin_instm_int_rat.vp_end_dt is '有效期结束日期';
comment on column ${iml_schema}.ref_curr_fin_instm_int_rat.cfm_id is '确认单编号';
comment on column ${iml_schema}.ref_curr_fin_instm_int_rat.txy_matn_flg is '同兴赢维护标志';
comment on column ${iml_schema}.ref_curr_fin_instm_int_rat.sign_lmt is '签约额度';
comment on column ${iml_schema}.ref_curr_fin_instm_int_rat.create_dt is '创建日期';
comment on column ${iml_schema}.ref_curr_fin_instm_int_rat.update_dt is '更新日期';
comment on column ${iml_schema}.ref_curr_fin_instm_int_rat.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.ref_curr_fin_instm_int_rat.id_mark is '增删标志';
comment on column ${iml_schema}.ref_curr_fin_instm_int_rat.src_table_name is '源表名称';
comment on column ${iml_schema}.ref_curr_fin_instm_int_rat.job_cd is '任务编码';
comment on column ${iml_schema}.ref_curr_fin_instm_int_rat.etl_timestamp is 'ETL处理时间戳';
