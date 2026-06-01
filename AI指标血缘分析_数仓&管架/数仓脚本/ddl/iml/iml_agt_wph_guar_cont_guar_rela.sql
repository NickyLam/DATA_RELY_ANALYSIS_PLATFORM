/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_wph_guar_cont_guar_rela
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_wph_guar_cont_guar_rela
whenever sqlerror continue none;
drop table ${iml_schema}.agt_wph_guar_cont_guar_rela purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_wph_guar_cont_guar_rela(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,guar_cont_id varchar2(100) -- 担保合同编号
    ,guar_id varchar2(100) -- 担保物编号
    ,obj_type_name varchar2(500) -- 对象类型名称
    ,obj_id varchar2(100) -- 对象编号
    ,rela_status_cd varchar2(30) -- 关联状态代码
    ,guar_amt number(30,8) -- 担保金额
    ,curr_cd varchar2(30) -- 币种代码
    ,pm_rat number(30,8) -- 抵质押率
    ,actl_pm_rat number(30,8) -- 实际抵质押率
    ,remark varchar2(1000) -- 备注
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_org_id varchar2(250) -- 登记机构编号
    ,rgst_dt date -- 登记日期
    ,update_teller_id varchar2(100) -- 更新柜员编号
    ,update_org_id varchar2(250) -- 更新机构编号
    ,final_update_dt date -- 最后更新日期
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
grant select on ${iml_schema}.agt_wph_guar_cont_guar_rela to ${icl_schema};
grant select on ${iml_schema}.agt_wph_guar_cont_guar_rela to ${idl_schema};
grant select on ${iml_schema}.agt_wph_guar_cont_guar_rela to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_wph_guar_cont_guar_rela is '唯品会担保合同与担保物关系历史';
comment on column ${iml_schema}.agt_wph_guar_cont_guar_rela.agt_id is '协议编号';
comment on column ${iml_schema}.agt_wph_guar_cont_guar_rela.lp_id is '法人编号';
comment on column ${iml_schema}.agt_wph_guar_cont_guar_rela.guar_cont_id is '担保合同编号';
comment on column ${iml_schema}.agt_wph_guar_cont_guar_rela.guar_id is '担保物编号';
comment on column ${iml_schema}.agt_wph_guar_cont_guar_rela.obj_type_name is '对象类型名称';
comment on column ${iml_schema}.agt_wph_guar_cont_guar_rela.obj_id is '对象编号';
comment on column ${iml_schema}.agt_wph_guar_cont_guar_rela.rela_status_cd is '关联状态代码';
comment on column ${iml_schema}.agt_wph_guar_cont_guar_rela.guar_amt is '担保金额';
comment on column ${iml_schema}.agt_wph_guar_cont_guar_rela.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_wph_guar_cont_guar_rela.pm_rat is '抵质押率';
comment on column ${iml_schema}.agt_wph_guar_cont_guar_rela.actl_pm_rat is '实际抵质押率';
comment on column ${iml_schema}.agt_wph_guar_cont_guar_rela.remark is '备注';
comment on column ${iml_schema}.agt_wph_guar_cont_guar_rela.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_wph_guar_cont_guar_rela.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_wph_guar_cont_guar_rela.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_wph_guar_cont_guar_rela.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.agt_wph_guar_cont_guar_rela.update_org_id is '更新机构编号';
comment on column ${iml_schema}.agt_wph_guar_cont_guar_rela.final_update_dt is '最后更新日期';
comment on column ${iml_schema}.agt_wph_guar_cont_guar_rela.start_dt is '开始时间';
comment on column ${iml_schema}.agt_wph_guar_cont_guar_rela.end_dt is '结束时间';
comment on column ${iml_schema}.agt_wph_guar_cont_guar_rela.id_mark is '增删标志';
comment on column ${iml_schema}.agt_wph_guar_cont_guar_rela.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_wph_guar_cont_guar_rela.job_cd is '任务编码';
comment on column ${iml_schema}.agt_wph_guar_cont_guar_rela.etl_timestamp is 'ETL处理时间戳';
