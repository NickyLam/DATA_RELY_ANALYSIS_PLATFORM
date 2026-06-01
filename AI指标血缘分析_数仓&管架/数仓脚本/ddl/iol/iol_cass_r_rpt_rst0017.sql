/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cass_r_rpt_rst0017
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cass_r_rpt_rst0017
whenever sqlerror continue none;
drop table ${iol_schema}.cass_r_rpt_rst0017 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cass_r_rpt_rst0017(
    etl_dt_ora date -- 数据日期
    ,acct_no varchar2(60) -- 账号
    ,dubil_no varchar2(60) -- 借据号
    ,cust_no varchar2(60) -- 客户号
    ,accts_org_no varchar2(60) -- 记账机构号
    ,manager_org varchar2(60) -- 考核机构号
    ,cust_type varchar2(60) -- 客户类型
    ,corp_size_cd varchar2(60) -- 企业规模代码
    ,bus_type varchar2(60) -- 业务类型
    ,std_prod_no varchar2(60) -- 产品编号
    ,curr_cd varchar2(60) -- 币种
    ,bal_avg_y number(38,8) -- 余额年日均
    ,int_income_y number(38,8) -- 利息收入年累计
    ,int_expns_y number(38,8) -- 利息支出年累计
    ,int_adj_bal_y number(38,8) -- 利息调整年累计
    ,invest_prft_y number(38,8) -- 投资收益年累计
    ,evha_val_chag_y number(38,8) -- 公允价值变动损益年累计
    ,fee_y number(38,8) -- 手续费收支年累计
    ,expense_y number(38,8) -- 营业费用年累计
    ,asset_impair_loss_y number(38,8) -- 减值损失年累计
    ,rwaamount_avg_y number(38,8) -- RWA（风险加权资产）金额年日均
    ,ca_risk_y number(38,8) -- 资本占用年累计
    ,coc_y number(38,8) -- 资本成本年累计
    ,surttax_y number(38,8) -- 税金及附加年累计
    ,ftp_net_profit_y number(38,8) -- FTP净利润年累计
    ,income_tax_fee_y number(38,8) -- 所得税费用年累计
    ,eva_y number(38,8) -- EVA(经济利润)年累计
    ,raroc number(38,8) -- RAROC（风险调整后的资本收益率）
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
grant select on ${iol_schema}.cass_r_rpt_rst0017 to ${iml_schema};
grant select on ${iol_schema}.cass_r_rpt_rst0017 to ${icl_schema};
grant select on ${iol_schema}.cass_r_rpt_rst0017 to ${idl_schema};
grant select on ${iol_schema}.cass_r_rpt_rst0017 to ${iel_schema};

-- comment
comment on table ${iol_schema}.cass_r_rpt_rst0017 is '管会存贷款成本明细表';
comment on column ${iol_schema}.cass_r_rpt_rst0017.etl_dt_ora is '数据日期';
comment on column ${iol_schema}.cass_r_rpt_rst0017.acct_no is '账号';
comment on column ${iol_schema}.cass_r_rpt_rst0017.dubil_no is '借据号';
comment on column ${iol_schema}.cass_r_rpt_rst0017.cust_no is '客户号';
comment on column ${iol_schema}.cass_r_rpt_rst0017.accts_org_no is '记账机构号';
comment on column ${iol_schema}.cass_r_rpt_rst0017.manager_org is '考核机构号';
comment on column ${iol_schema}.cass_r_rpt_rst0017.cust_type is '客户类型';
comment on column ${iol_schema}.cass_r_rpt_rst0017.corp_size_cd is '企业规模代码';
comment on column ${iol_schema}.cass_r_rpt_rst0017.bus_type is '业务类型';
comment on column ${iol_schema}.cass_r_rpt_rst0017.std_prod_no is '产品编号';
comment on column ${iol_schema}.cass_r_rpt_rst0017.curr_cd is '币种';
comment on column ${iol_schema}.cass_r_rpt_rst0017.bal_avg_y is '余额年日均';
comment on column ${iol_schema}.cass_r_rpt_rst0017.int_income_y is '利息收入年累计';
comment on column ${iol_schema}.cass_r_rpt_rst0017.int_expns_y is '利息支出年累计';
comment on column ${iol_schema}.cass_r_rpt_rst0017.int_adj_bal_y is '利息调整年累计';
comment on column ${iol_schema}.cass_r_rpt_rst0017.invest_prft_y is '投资收益年累计';
comment on column ${iol_schema}.cass_r_rpt_rst0017.evha_val_chag_y is '公允价值变动损益年累计';
comment on column ${iol_schema}.cass_r_rpt_rst0017.fee_y is '手续费收支年累计';
comment on column ${iol_schema}.cass_r_rpt_rst0017.expense_y is '营业费用年累计';
comment on column ${iol_schema}.cass_r_rpt_rst0017.asset_impair_loss_y is '减值损失年累计';
comment on column ${iol_schema}.cass_r_rpt_rst0017.rwaamount_avg_y is 'RWA（风险加权资产）金额年日均';
comment on column ${iol_schema}.cass_r_rpt_rst0017.ca_risk_y is '资本占用年累计';
comment on column ${iol_schema}.cass_r_rpt_rst0017.coc_y is '资本成本年累计';
comment on column ${iol_schema}.cass_r_rpt_rst0017.surttax_y is '税金及附加年累计';
comment on column ${iol_schema}.cass_r_rpt_rst0017.ftp_net_profit_y is 'FTP净利润年累计';
comment on column ${iol_schema}.cass_r_rpt_rst0017.income_tax_fee_y is '所得税费用年累计';
comment on column ${iol_schema}.cass_r_rpt_rst0017.eva_y is 'EVA(经济利润)年累计';
comment on column ${iol_schema}.cass_r_rpt_rst0017.raroc is 'RAROC（风险调整后的资本收益率）';
comment on column ${iol_schema}.cass_r_rpt_rst0017.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cass_r_rpt_rst0017.etl_timestamp is 'ETL处理时间戳';
