/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cass_r_rpt_rst6202_inc
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cass_r_rpt_rst6202_inc
whenever sqlerror continue none;
drop table ${iol_schema}.cass_r_rpt_rst6202_inc purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cass_r_rpt_rst6202_inc(
    etl_dt_ora date -- 数据日期
    ,bus_no varchar2(300) -- 业务编号
    ,manager_org varchar2(300) -- 考核机构
    ,bus_line varchar2(300) -- 业务条线
    ,subj_no varchar2(300) -- 本金科目
    ,std_prod_no varchar2(300) -- 标准产品编号
    ,curr_cd varchar2(60) -- 币种(折币后目标币种）
    ,cust_no varchar2(300) -- 客户编号
    ,cust_mgr_no varchar2(300) -- 客户经理编号
    ,accts_org_no varchar2(300) -- 账务机构
    ,charge_way_name varchar2(300) -- 收费方式
    ,tran_acct_id varchar2(60) -- 交易账户编号
    ,acct_dt date -- 账务日期
    ,share_tran_amt_sl_m number(32,4) -- 入账金额
    ,entry_flow_num varchar2(90) -- 记账流水号
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
grant select on ${iol_schema}.cass_r_rpt_rst6202_inc to ${iml_schema};
grant select on ${iol_schema}.cass_r_rpt_rst6202_inc to ${icl_schema};
grant select on ${iol_schema}.cass_r_rpt_rst6202_inc to ${idl_schema};
grant select on ${iol_schema}.cass_r_rpt_rst6202_inc to ${iel_schema};

-- comment
comment on table ${iol_schema}.cass_r_rpt_rst6202_inc is 'RDM_中收类业务明细表';
comment on column ${iol_schema}.cass_r_rpt_rst6202_inc.etl_dt_ora is '数据日期';
comment on column ${iol_schema}.cass_r_rpt_rst6202_inc.bus_no is '业务编号';
comment on column ${iol_schema}.cass_r_rpt_rst6202_inc.manager_org is '考核机构';
comment on column ${iol_schema}.cass_r_rpt_rst6202_inc.bus_line is '业务条线';
comment on column ${iol_schema}.cass_r_rpt_rst6202_inc.subj_no is '本金科目';
comment on column ${iol_schema}.cass_r_rpt_rst6202_inc.std_prod_no is '标准产品编号';
comment on column ${iol_schema}.cass_r_rpt_rst6202_inc.curr_cd is '币种(折币后目标币种）';
comment on column ${iol_schema}.cass_r_rpt_rst6202_inc.cust_no is '客户编号';
comment on column ${iol_schema}.cass_r_rpt_rst6202_inc.cust_mgr_no is '客户经理编号';
comment on column ${iol_schema}.cass_r_rpt_rst6202_inc.accts_org_no is '账务机构';
comment on column ${iol_schema}.cass_r_rpt_rst6202_inc.charge_way_name is '收费方式';
comment on column ${iol_schema}.cass_r_rpt_rst6202_inc.tran_acct_id is '交易账户编号';
comment on column ${iol_schema}.cass_r_rpt_rst6202_inc.acct_dt is '账务日期';
comment on column ${iol_schema}.cass_r_rpt_rst6202_inc.share_tran_amt_sl_m is '入账金额';
comment on column ${iol_schema}.cass_r_rpt_rst6202_inc.entry_flow_num is '记账流水号';
comment on column ${iol_schema}.cass_r_rpt_rst6202_inc.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cass_r_rpt_rst6202_inc.etl_timestamp is 'ETL处理时间戳';
