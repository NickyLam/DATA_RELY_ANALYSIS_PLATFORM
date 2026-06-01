/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_wph_loan_guar_cont_rela
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_wph_loan_guar_cont_rela
whenever sqlerror continue none;
drop table ${iml_schema}.agt_wph_loan_guar_cont_rela purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_wph_loan_guar_cont_rela(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,loan_cont_id varchar2(100) -- 贷款合同编号
    ,obj_type_name varchar2(500) -- 对象类型名称
    ,obj_id varchar2(100) -- 对象编号
    ,rela_amt number(30,8) -- 关联金额
    ,rela_status_cd varchar2(30) -- 关联状态代码
    ,renew_amt number(30,8) -- 展期金额
    ,a_renew_exp_dt date -- 展期后到期日期
    ,sync_remit_bus_cont_rela_flg varchar2(10) -- 同步解除业务合同关系标志
    ,intd_init_guar_cont_flg varchar2(10) -- 引入原担保合同标志
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
grant select on ${iml_schema}.agt_wph_loan_guar_cont_rela to ${icl_schema};
grant select on ${iml_schema}.agt_wph_loan_guar_cont_rela to ${idl_schema};
grant select on ${iml_schema}.agt_wph_loan_guar_cont_rela to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_wph_loan_guar_cont_rela is '唯品会贷款合同与担保合同关系历史';
comment on column ${iml_schema}.agt_wph_loan_guar_cont_rela.agt_id is '协议编号';
comment on column ${iml_schema}.agt_wph_loan_guar_cont_rela.lp_id is '法人编号';
comment on column ${iml_schema}.agt_wph_loan_guar_cont_rela.loan_cont_id is '贷款合同编号';
comment on column ${iml_schema}.agt_wph_loan_guar_cont_rela.obj_type_name is '对象类型名称';
comment on column ${iml_schema}.agt_wph_loan_guar_cont_rela.obj_id is '对象编号';
comment on column ${iml_schema}.agt_wph_loan_guar_cont_rela.rela_amt is '关联金额';
comment on column ${iml_schema}.agt_wph_loan_guar_cont_rela.rela_status_cd is '关联状态代码';
comment on column ${iml_schema}.agt_wph_loan_guar_cont_rela.renew_amt is '展期金额';
comment on column ${iml_schema}.agt_wph_loan_guar_cont_rela.a_renew_exp_dt is '展期后到期日期';
comment on column ${iml_schema}.agt_wph_loan_guar_cont_rela.sync_remit_bus_cont_rela_flg is '同步解除业务合同关系标志';
comment on column ${iml_schema}.agt_wph_loan_guar_cont_rela.intd_init_guar_cont_flg is '引入原担保合同标志';
comment on column ${iml_schema}.agt_wph_loan_guar_cont_rela.start_dt is '开始时间';
comment on column ${iml_schema}.agt_wph_loan_guar_cont_rela.end_dt is '结束时间';
comment on column ${iml_schema}.agt_wph_loan_guar_cont_rela.id_mark is '增删标志';
comment on column ${iml_schema}.agt_wph_loan_guar_cont_rela.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_wph_loan_guar_cont_rela.job_cd is '任务编码';
comment on column ${iml_schema}.agt_wph_loan_guar_cont_rela.etl_timestamp is 'ETL处理时间戳';
