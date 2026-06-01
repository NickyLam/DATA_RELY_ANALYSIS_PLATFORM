/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_comb_prod_and_dtl_prod_rela_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_comb_prod_and_dtl_prod_rela_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_comb_prod_and_dtl_prod_rela_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_comb_prod_and_dtl_prod_rela_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,comb_prod_id varchar2(100) -- 组合产品编号
    ,ta_cd varchar2(30) -- TA代码
    ,dtl_prod_id varchar2(100) -- 明细产品编号
    ,status_cd varchar2(30) -- 状态代码
    ,tran_out_prior_level number(38) -- 转出优先级
    ,prod_prior_level number(38) -- 备选产品优先级
    ,diplay_prior_level number(38) -- 展示优先级
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
grant select on ${iml_schema}.agt_comb_prod_and_dtl_prod_rela_h to ${icl_schema};
grant select on ${iml_schema}.agt_comb_prod_and_dtl_prod_rela_h to ${idl_schema};
grant select on ${iml_schema}.agt_comb_prod_and_dtl_prod_rela_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_comb_prod_and_dtl_prod_rela_h is '组合产品与明细产品关系历史';
comment on column ${iml_schema}.agt_comb_prod_and_dtl_prod_rela_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_comb_prod_and_dtl_prod_rela_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_comb_prod_and_dtl_prod_rela_h.comb_prod_id is '组合产品编号';
comment on column ${iml_schema}.agt_comb_prod_and_dtl_prod_rela_h.ta_cd is 'TA代码';
comment on column ${iml_schema}.agt_comb_prod_and_dtl_prod_rela_h.dtl_prod_id is '明细产品编号';
comment on column ${iml_schema}.agt_comb_prod_and_dtl_prod_rela_h.status_cd is '状态代码';
comment on column ${iml_schema}.agt_comb_prod_and_dtl_prod_rela_h.tran_out_prior_level is '转出优先级';
comment on column ${iml_schema}.agt_comb_prod_and_dtl_prod_rela_h.prod_prior_level is '备选产品优先级';
comment on column ${iml_schema}.agt_comb_prod_and_dtl_prod_rela_h.diplay_prior_level is '展示优先级';
comment on column ${iml_schema}.agt_comb_prod_and_dtl_prod_rela_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_comb_prod_and_dtl_prod_rela_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_comb_prod_and_dtl_prod_rela_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_comb_prod_and_dtl_prod_rela_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_comb_prod_and_dtl_prod_rela_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_comb_prod_and_dtl_prod_rela_h.etl_timestamp is 'ETL处理时间戳';
