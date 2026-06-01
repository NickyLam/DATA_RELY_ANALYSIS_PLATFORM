/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_agt_finc_lot_h
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_agt_finc_lot_h purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_agt_finc_lot_h(
etl_dt date --数据日期
,intnal_cust_id varchar2(60) --内部客户编号
,seller_cd varchar2(10) --销售商代码
,bank_id varchar2(60) --银行编号
,bank_cust_id varchar2(60) --银行客户编号
,bank_acct_id varchar2(100) --银行账户编号
,ta_tran_acct_id varchar2(60) --TA交易账户编号
,ec_flg varchar2(10) --钞汇标志
,tran_med_type_cd varchar2(10) --交易介质类型代码
,tran_med varchar2(90) --交易介质
,ta_cd varchar2(30) --TA代码
,finc_acct_id varchar2(60) --理财账户编号
,prod_id varchar2(60) --产品编号
,std_prod_id varchar2(500) --标准产品编号
,cont_id varchar2(60) --合约编号
,final_tran_dt date --最后交易日期
,lot_tot number(30,2) --份额总数
,froz_lot number(30,2) --冻结份额
,lonterm_froz_lot number(30,2) --长期冻结份额
,deflt_divd_way_cd varchar2(10) --默认分红方式代码
,init_divd_way_cd varchar2(10) --原分红方式代码
,tran_belong_org_id varchar2(100) --交易所属机构编号
,supp_invest_flg varchar2(10) --追加投资标志
,buy_cost_amt number(30,2) --买入成本金额
,acm_inco_amt number(30,2) --累计收入金额
,start_dt date --开始时间
,end_dt date --结束时间
,id_mark varchar2(10) --增删标志
,comb_invest_lot number(30,2) --组合投资份额
,loc_froz_lot number(30,2) --本地冻结份额
,agt_id varchar2(60) --协议编号
,lp_id varchar2(60) --法人编号

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_agt_finc_lot_h to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_agt_finc_lot_h is '理财份额历史';
comment on column ${idl_schema}.oass_agt_finc_lot_h.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_agt_finc_lot_h.intnal_cust_id is '内部客户编号';
comment on column ${idl_schema}.oass_agt_finc_lot_h.seller_cd is '销售商代码';
comment on column ${idl_schema}.oass_agt_finc_lot_h.bank_id is '银行编号';
comment on column ${idl_schema}.oass_agt_finc_lot_h.bank_cust_id is '银行客户编号';
comment on column ${idl_schema}.oass_agt_finc_lot_h.bank_acct_id is '银行账户编号';
comment on column ${idl_schema}.oass_agt_finc_lot_h.ta_tran_acct_id is 'TA交易账户编号';
comment on column ${idl_schema}.oass_agt_finc_lot_h.ec_flg is '钞汇标志';
comment on column ${idl_schema}.oass_agt_finc_lot_h.tran_med_type_cd is '交易介质类型代码';
comment on column ${idl_schema}.oass_agt_finc_lot_h.tran_med is '交易介质';
comment on column ${idl_schema}.oass_agt_finc_lot_h.ta_cd is 'TA代码';
comment on column ${idl_schema}.oass_agt_finc_lot_h.finc_acct_id is '理财账户编号';
comment on column ${idl_schema}.oass_agt_finc_lot_h.prod_id is '产品编号';
comment on column ${idl_schema}.oass_agt_finc_lot_h.std_prod_id is '标准产品编号';
comment on column ${idl_schema}.oass_agt_finc_lot_h.cont_id is '合约编号';
comment on column ${idl_schema}.oass_agt_finc_lot_h.final_tran_dt is '最后交易日期';
comment on column ${idl_schema}.oass_agt_finc_lot_h.lot_tot is '份额总数';
comment on column ${idl_schema}.oass_agt_finc_lot_h.froz_lot is '冻结份额';
comment on column ${idl_schema}.oass_agt_finc_lot_h.lonterm_froz_lot is '长期冻结份额';
comment on column ${idl_schema}.oass_agt_finc_lot_h.deflt_divd_way_cd is '默认分红方式代码';
comment on column ${idl_schema}.oass_agt_finc_lot_h.init_divd_way_cd is '原分红方式代码';
comment on column ${idl_schema}.oass_agt_finc_lot_h.tran_belong_org_id is '交易所属机构编号';
comment on column ${idl_schema}.oass_agt_finc_lot_h.supp_invest_flg is '追加投资标志';
comment on column ${idl_schema}.oass_agt_finc_lot_h.buy_cost_amt is '买入成本金额';
comment on column ${idl_schema}.oass_agt_finc_lot_h.acm_inco_amt is '累计收入金额';
comment on column ${idl_schema}.oass_agt_finc_lot_h.start_dt is '开始时间';
comment on column ${idl_schema}.oass_agt_finc_lot_h.end_dt is '结束时间';
comment on column ${idl_schema}.oass_agt_finc_lot_h.id_mark is '增删标志';
comment on column ${idl_schema}.oass_agt_finc_lot_h.comb_invest_lot is '组合投资份额';
comment on column ${idl_schema}.oass_agt_finc_lot_h.loc_froz_lot is '本地冻结份额';
comment on column ${idl_schema}.oass_agt_finc_lot_h.agt_id is '协议编号';
comment on column ${idl_schema}.oass_agt_finc_lot_h.lp_id is '法人编号';

