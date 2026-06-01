/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_crdt_risk_rating_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_crdt_risk_rating_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_crdt_risk_rating_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_crdt_risk_rating_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,dubil_id varchar2(60) -- 借据编号
    ,cont_id varchar2(60) -- 合同编号
    ,cust_id varchar2(60) -- 客户编号
    ,rating_cate_cd varchar2(10) -- 评级类别代码
    ,rating_rest_cd varchar2(10) -- 评级结果代码
    ,auto_rating_flg varchar2(10) -- 自动评级标志
    ,rating_dt date -- 评级日期
    ,mgmt_org_id varchar2(60) -- 管理机构编号
    ,mgmt_clerk_id varchar2(60) -- 管理行员编号
    ,apv_clerk_id varchar2(60) -- 审批行员编号
    ,oper_teller_id varchar2(60) -- 经办柜员编号
    ,rgst_teller_id varchar2(60) -- 登记柜员编号
    ,update_teller_id varchar2(60) -- 更新柜员编号
    ,manu_adj_rs_descb varchar2(2500) -- 人工调整原因描述
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
 --   ,etl_dt date -- ETL处理日期
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${icl_schema}.cmm_crdt_risk_rating_info to ${idl_schema};
grant select on ${icl_schema}.cmm_crdt_risk_rating_info to ${iel_schema};
grant select on ${icl_schema}.cmm_crdt_risk_rating_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_crdt_risk_rating_info is '信贷风险评级信息';
comment on column ${icl_schema}.cmm_crdt_risk_rating_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_crdt_risk_rating_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_crdt_risk_rating_info.dubil_id is '借据编号';
comment on column ${icl_schema}.cmm_crdt_risk_rating_info.cont_id is '合同编号';
comment on column ${icl_schema}.cmm_crdt_risk_rating_info.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_crdt_risk_rating_info.rating_cate_cd is '评级类别代码';
comment on column ${icl_schema}.cmm_crdt_risk_rating_info.rating_rest_cd is '评级结果代码';
comment on column ${icl_schema}.cmm_crdt_risk_rating_info.auto_rating_flg is '自动评级标志';
comment on column ${icl_schema}.cmm_crdt_risk_rating_info.rating_dt is '评级日期';
comment on column ${icl_schema}.cmm_crdt_risk_rating_info.mgmt_org_id is '管理机构编号';
comment on column ${icl_schema}.cmm_crdt_risk_rating_info.mgmt_clerk_id is '管理行员编号';
comment on column ${icl_schema}.cmm_crdt_risk_rating_info.apv_clerk_id is '审批行员编号';
comment on column ${icl_schema}.cmm_crdt_risk_rating_info.oper_teller_id is '经办柜员编号';
comment on column ${icl_schema}.cmm_crdt_risk_rating_info.rgst_teller_id is '登记柜员编号';
comment on column ${icl_schema}.cmm_crdt_risk_rating_info.update_teller_id is '更新柜员编号';
comment on column ${icl_schema}.cmm_crdt_risk_rating_info.manu_adj_rs_descb is '人工调整原因描述';
comment on column ${icl_schema}.cmm_crdt_risk_rating_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_crdt_risk_rating_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_crdt_risk_rating_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_crdt_risk_rating_info.etl_timestamp is 'ETL处理时间戳';
