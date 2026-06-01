/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_unite_wl_lmt_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_unite_wl_lmt_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_unite_wl_lmt_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_unite_wl_lmt_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,lmt_cont_id varchar2(100) -- 额度合同编号
    ,lmt_rela_appl_id varchar2(250) -- 额度关联申请编号
    ,cust_id varchar2(100) -- 客户编号
    ,bus_breed_id varchar2(100) -- 业务品种编号
    ,actv_flg varchar2(30) -- 激活标志
    ,circl_flg varchar2(30) -- 循环标志
    ,low_risk_bus_flg varchar2(30) -- 低风险业务标志
    ,cust_type_cd varchar2(30) -- 证件类型代码
    ,curr_cd varchar2(60) -- 币种代码
    ,status_cd varchar2(30) -- 状态代码
    ,bus_breed_name varchar2(500) -- 业务品种名称
    ,tenor varchar2(60) -- 期限
    ,begin_dt date -- 起始日期
    ,modif_dt date -- 变更日期
    ,exp_dt date -- 到期日期
    ,belong_org_id varchar2(60) -- 所属机构编号
    ,belong_brch_id varchar2(60) -- 所属分行编号
    ,acct_instit_id varchar2(60) -- 账务机构编号
    ,mgmt_org_id varchar2(60) -- 管理机构编号
    ,crdt_lmt number(38,8) -- 授信额度
    ,incr_lmt_lmt number(30,2) -- 提额额度
    ,occu_crdt_lmt number(30,2) -- 已占用授信额度
    ,surp_crdt_lmt number(38,8) -- 剩余授信额度
    ,crdt_open_amt number(38,8) -- 授信敞口金额
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
grant select on ${icl_schema}.cmm_unite_wl_lmt_info to ${idl_schema};
grant select on ${icl_schema}.cmm_unite_wl_lmt_info to ${iel_schema};
grant select on ${icl_schema}.cmm_unite_wl_lmt_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_unite_wl_lmt_info is '联合网贷额度信息';
comment on column ${icl_schema}.cmm_unite_wl_lmt_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_unite_wl_lmt_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_unite_wl_lmt_info.lmt_cont_id is '额度合同编号';
comment on column ${icl_schema}.cmm_unite_wl_lmt_info.lmt_rela_appl_id is '额度关联申请编号';
comment on column ${icl_schema}.cmm_unite_wl_lmt_info.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_unite_wl_lmt_info.bus_breed_id is '业务品种编号';
comment on column ${icl_schema}.cmm_unite_wl_lmt_info.actv_flg is '激活标志';
comment on column ${icl_schema}.cmm_unite_wl_lmt_info.circl_flg is '循环标志';
comment on column ${icl_schema}.cmm_unite_wl_lmt_info.low_risk_bus_flg is '低风险业务标志';
comment on column ${icl_schema}.cmm_unite_wl_lmt_info.cust_type_cd is '证件类型代码';
comment on column ${icl_schema}.cmm_unite_wl_lmt_info.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_unite_wl_lmt_info.status_cd is '状态代码';
comment on column ${icl_schema}.cmm_unite_wl_lmt_info.bus_breed_name is '业务品种名称';
comment on column ${icl_schema}.cmm_unite_wl_lmt_info.tenor is '期限';
comment on column ${icl_schema}.cmm_unite_wl_lmt_info.begin_dt is '起始日期';
comment on column ${icl_schema}.cmm_unite_wl_lmt_info.modif_dt is '变更日期';
comment on column ${icl_schema}.cmm_unite_wl_lmt_info.exp_dt is '到期日期';
comment on column ${icl_schema}.cmm_unite_wl_lmt_info.belong_org_id is '所属机构编号';
comment on column ${icl_schema}.cmm_unite_wl_lmt_info.belong_brch_id is '所属分行编号';
comment on column ${icl_schema}.cmm_unite_wl_lmt_info.acct_instit_id is '账务机构编号';
comment on column ${icl_schema}.cmm_unite_wl_lmt_info.mgmt_org_id is '管理机构编号';
comment on column ${icl_schema}.cmm_unite_wl_lmt_info.crdt_lmt is '授信额度';
comment on column ${icl_schema}.cmm_unite_wl_lmt_info.incr_lmt_lmt is '提额额度';
comment on column ${icl_schema}.cmm_unite_wl_lmt_info.occu_crdt_lmt is '已占用授信额度';
comment on column ${icl_schema}.cmm_unite_wl_lmt_info.surp_crdt_lmt is '剩余授信额度';
comment on column ${icl_schema}.cmm_unite_wl_lmt_info.crdt_open_amt is '授信敞口金额';
comment on column ${icl_schema}.cmm_unite_wl_lmt_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_unite_wl_lmt_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_unite_wl_lmt_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_unite_wl_lmt_info.etl_timestamp is 'ETL处理时间戳';
