/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rsts_src_dw_agt_cms_risk_rat
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rsts_src_dw_agt_cms_risk_rat
whenever sqlerror continue none;
drop table ${iol_schema}.rsts_src_dw_agt_cms_risk_rat purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rsts_src_dw_agt_cms_risk_rat(
    loan_acct_id varchar2(60) -- 贷款账户编号
    ,etl_dt_ora date -- 数据日期
    ,blng_pty_id varchar2(60) -- 所属客户编号
    ,risk_rat_categ_cd varchar2(1) -- 风险评级类别代码
    ,risk_rat_resu_cd varchar2(2) -- 风险评级结果代码
    ,rat_dt date -- 评级日期
    ,rat_org_id varchar2(30) -- 评级机构编号
    ,rat_oper_emply_id varchar2(30) -- 评级经办员工编号
    ,auto_rat_flg varchar2(1) -- 自动评级标志
    ,aprv_emply_num varchar2(30) -- 审批员工号
    ,auth_emply_num varchar2(30) -- 授权员工号
    ,adj_emply_num varchar2(20) -- 调整员工号
    ,loan_fifth_modal_chg_rsns varchar2(500) -- 贷款五级形态变动原因
    ,data_src_cd varchar2(4) -- 数据来源代码
    ,del_flg varchar2(1) -- 删除标志
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.rsts_src_dw_agt_cms_risk_rat to ${iml_schema};
grant select on ${iol_schema}.rsts_src_dw_agt_cms_risk_rat to ${icl_schema};
grant select on ${iol_schema}.rsts_src_dw_agt_cms_risk_rat to ${idl_schema};
grant select on ${iol_schema}.rsts_src_dw_agt_cms_risk_rat to ${iel_schema};

-- comment
comment on table ${iol_schema}.rsts_src_dw_agt_cms_risk_rat is '数仓_信贷风险评级';
comment on column ${iol_schema}.rsts_src_dw_agt_cms_risk_rat.loan_acct_id is '贷款账户编号';
comment on column ${iol_schema}.rsts_src_dw_agt_cms_risk_rat.etl_dt_ora is '数据日期';
comment on column ${iol_schema}.rsts_src_dw_agt_cms_risk_rat.blng_pty_id is '所属客户编号';
comment on column ${iol_schema}.rsts_src_dw_agt_cms_risk_rat.risk_rat_categ_cd is '风险评级类别代码';
comment on column ${iol_schema}.rsts_src_dw_agt_cms_risk_rat.risk_rat_resu_cd is '风险评级结果代码';
comment on column ${iol_schema}.rsts_src_dw_agt_cms_risk_rat.rat_dt is '评级日期';
comment on column ${iol_schema}.rsts_src_dw_agt_cms_risk_rat.rat_org_id is '评级机构编号';
comment on column ${iol_schema}.rsts_src_dw_agt_cms_risk_rat.rat_oper_emply_id is '评级经办员工编号';
comment on column ${iol_schema}.rsts_src_dw_agt_cms_risk_rat.auto_rat_flg is '自动评级标志';
comment on column ${iol_schema}.rsts_src_dw_agt_cms_risk_rat.aprv_emply_num is '审批员工号';
comment on column ${iol_schema}.rsts_src_dw_agt_cms_risk_rat.auth_emply_num is '授权员工号';
comment on column ${iol_schema}.rsts_src_dw_agt_cms_risk_rat.adj_emply_num is '调整员工号';
comment on column ${iol_schema}.rsts_src_dw_agt_cms_risk_rat.loan_fifth_modal_chg_rsns is '贷款五级形态变动原因';
comment on column ${iol_schema}.rsts_src_dw_agt_cms_risk_rat.data_src_cd is '数据来源代码';
comment on column ${iol_schema}.rsts_src_dw_agt_cms_risk_rat.del_flg is '删除标志';
comment on column ${iol_schema}.rsts_src_dw_agt_cms_risk_rat.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.rsts_src_dw_agt_cms_risk_rat.etl_timestamp is 'ETL处理时间戳';
