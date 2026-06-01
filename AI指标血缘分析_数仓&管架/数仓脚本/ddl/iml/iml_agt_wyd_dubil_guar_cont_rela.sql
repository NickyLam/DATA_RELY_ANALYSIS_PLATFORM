/*
Purpose:    整合模型层-切片建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_wyd_dubil_guar_cont_rela
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_wyd_dubil_guar_cont_rela
whenever sqlerror continue none;
drop table ${iml_schema}.agt_wyd_dubil_guar_cont_rela purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_wyd_dubil_guar_cont_rela(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,dubil_id varchar2(100) -- 借据编号
    ,guar_cont_id varchar2(100) -- 担保合同编号
    ,cont_id varchar2(100) -- 合同编号
    ,prod_id varchar2(100) -- 产品编号
    ,cust_id varchar2(100) -- 客户编号
    ,level5_cls_cd varchar2(30) -- 五级分类代码
    ,org_id varchar2(100) -- 机构编号
    ,loan_bal number(30,8) -- 贷款余额
    ,guar_amt number(30,8) -- 担保金额
    ,guar_rela_nomal_flg varchar2(10) -- 担保关系正常标志
    ,guar_rela_effect_dt date -- 担保关系生效日期
    ,guar_rela_invalid_dt date -- 担保关系失效日期
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_belong_org_id varchar2(100) -- 登记所属机构编号
    ,rgst_dt date -- 登记日期
    ,final_update_teller_id varchar2(100) -- 最后更新柜员编号
    ,final_update_org_id varchar2(100) -- 最后更新机构编号
    ,final_update_dt date -- 最后更新日期
    ,etl_dt date -- ETL处理日期
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
grant select on ${iml_schema}.agt_wyd_dubil_guar_cont_rela to ${icl_schema};
grant select on ${iml_schema}.agt_wyd_dubil_guar_cont_rela to ${idl_schema};
grant select on ${iml_schema}.agt_wyd_dubil_guar_cont_rela to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_wyd_dubil_guar_cont_rela is '微业贷借据与担保合同关系历史';
comment on column ${iml_schema}.agt_wyd_dubil_guar_cont_rela.agt_id is '协议编号';
comment on column ${iml_schema}.agt_wyd_dubil_guar_cont_rela.lp_id is '法人编号';
comment on column ${iml_schema}.agt_wyd_dubil_guar_cont_rela.dubil_id is '借据编号';
comment on column ${iml_schema}.agt_wyd_dubil_guar_cont_rela.guar_cont_id is '担保合同编号';
comment on column ${iml_schema}.agt_wyd_dubil_guar_cont_rela.cont_id is '合同编号';
comment on column ${iml_schema}.agt_wyd_dubil_guar_cont_rela.prod_id is '产品编号';
comment on column ${iml_schema}.agt_wyd_dubil_guar_cont_rela.cust_id is '客户编号';
comment on column ${iml_schema}.agt_wyd_dubil_guar_cont_rela.level5_cls_cd is '五级分类代码';
comment on column ${iml_schema}.agt_wyd_dubil_guar_cont_rela.org_id is '机构编号';
comment on column ${iml_schema}.agt_wyd_dubil_guar_cont_rela.loan_bal is '贷款余额';
comment on column ${iml_schema}.agt_wyd_dubil_guar_cont_rela.guar_amt is '担保金额';
comment on column ${iml_schema}.agt_wyd_dubil_guar_cont_rela.guar_rela_nomal_flg is '担保关系正常标志';
comment on column ${iml_schema}.agt_wyd_dubil_guar_cont_rela.guar_rela_effect_dt is '担保关系生效日期';
comment on column ${iml_schema}.agt_wyd_dubil_guar_cont_rela.guar_rela_invalid_dt is '担保关系失效日期';
comment on column ${iml_schema}.agt_wyd_dubil_guar_cont_rela.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_wyd_dubil_guar_cont_rela.rgst_belong_org_id is '登记所属机构编号';
comment on column ${iml_schema}.agt_wyd_dubil_guar_cont_rela.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_wyd_dubil_guar_cont_rela.final_update_teller_id is '最后更新柜员编号';
comment on column ${iml_schema}.agt_wyd_dubil_guar_cont_rela.final_update_org_id is '最后更新机构编号';
comment on column ${iml_schema}.agt_wyd_dubil_guar_cont_rela.final_update_dt is '最后更新日期';
comment on column ${iml_schema}.agt_wyd_dubil_guar_cont_rela.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_wyd_dubil_guar_cont_rela.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_wyd_dubil_guar_cont_rela.job_cd is '任务编码';
comment on column ${iml_schema}.agt_wyd_dubil_guar_cont_rela.etl_timestamp is 'ETL处理时间戳';
