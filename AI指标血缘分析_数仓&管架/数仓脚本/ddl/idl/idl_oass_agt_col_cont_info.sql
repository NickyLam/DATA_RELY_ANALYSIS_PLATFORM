/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_agt_col_cont_info
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_agt_col_cont_info purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_agt_col_cont_info(
etl_dt date --ETL处理日期
,cont_id varchar2(60) --合同编号
,cust_id varchar2(60) --客户编号
,rg_cd varchar2(10) --地区代码
,org_id varchar2(60) --机构编号
,enter_acct_org_id varchar2(60) --入账机构编号
,cust_mgr_id varchar2(60) --客户经理编号
,crdt_breed_id varchar2(60) --授信品种编号
,loan_dir_indus_cd varchar2(10) --贷款投向行业代码
,guar_curr_cd varchar2(10) --担保币种代码
,cont_amt number(30,2) --合同金额
,cont_bal number(30,2) --合同余额
,margin_ratio number(18,6) --保证金比例
,margin_amt number(30,2) --保证金余额
,effect_dt date --生效日期
,exp_dt date --到期日期
,guar_way_cd varchar2(10) --担保方式代码
,main_guar_way_cd varchar2(60) --主担保方式代码
,setup_dt date --建立日期
,chg_dt date --更改日期
,distrd_amt number(30,2) --已发放金额
,level5_cls_cd varchar2(10) --五级分类代码
,off_bs_bal number(30,2) --表外余额
,in_bs_bal number(30,2) --表内余额
,over_int_amt number(30,2) --欠息金额
,payoff_status_cd varchar2(10) --结清状态代码
,loan_rating_cd varchar2(10) --贷款评级代码
,reply_id varchar2(60) --批复编号
,strip_line_cd varchar2(10) --条线代码
,crdt_cont_id varchar2(60) --授信合同编号
,crdt_appl_id varchar2(60) --授信申请编号
,paper_cont_id varchar2(100) --纸质合同编号
,data_src_cd varchar2(10) --数据来源代码
,create_dt date --创建日期
,update_dt date --更新日期
,id_mark varchar2(10) --增删标志
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
grant select on ${idl_schema}.oass_agt_col_cont_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_agt_col_cont_info is '押品合同信息表';
comment on column ${idl_schema}.oass_agt_col_cont_info.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.oass_agt_col_cont_info.cont_id is '合同编号';
comment on column ${idl_schema}.oass_agt_col_cont_info.cust_id is '客户编号';
comment on column ${idl_schema}.oass_agt_col_cont_info.rg_cd is '地区代码';
comment on column ${idl_schema}.oass_agt_col_cont_info.org_id is '机构编号';
comment on column ${idl_schema}.oass_agt_col_cont_info.enter_acct_org_id is '入账机构编号';
comment on column ${idl_schema}.oass_agt_col_cont_info.cust_mgr_id is '客户经理编号';
comment on column ${idl_schema}.oass_agt_col_cont_info.crdt_breed_id is '授信品种编号';
comment on column ${idl_schema}.oass_agt_col_cont_info.loan_dir_indus_cd is '贷款投向行业代码';
comment on column ${idl_schema}.oass_agt_col_cont_info.guar_curr_cd is '担保币种代码';
comment on column ${idl_schema}.oass_agt_col_cont_info.cont_amt is '合同金额';
comment on column ${idl_schema}.oass_agt_col_cont_info.cont_bal is '合同余额';
comment on column ${idl_schema}.oass_agt_col_cont_info.margin_ratio is '保证金比例';
comment on column ${idl_schema}.oass_agt_col_cont_info.margin_amt is '保证金余额';
comment on column ${idl_schema}.oass_agt_col_cont_info.effect_dt is '生效日期';
comment on column ${idl_schema}.oass_agt_col_cont_info.exp_dt is '到期日期';
comment on column ${idl_schema}.oass_agt_col_cont_info.guar_way_cd is '担保方式代码';
comment on column ${idl_schema}.oass_agt_col_cont_info.main_guar_way_cd is '主担保方式代码';
comment on column ${idl_schema}.oass_agt_col_cont_info.setup_dt is '建立日期';
comment on column ${idl_schema}.oass_agt_col_cont_info.chg_dt is '更改日期';
comment on column ${idl_schema}.oass_agt_col_cont_info.distrd_amt is '已发放金额';
comment on column ${idl_schema}.oass_agt_col_cont_info.level5_cls_cd is '五级分类代码';
comment on column ${idl_schema}.oass_agt_col_cont_info.off_bs_bal is '表外余额';
comment on column ${idl_schema}.oass_agt_col_cont_info.in_bs_bal is '表内余额';
comment on column ${idl_schema}.oass_agt_col_cont_info.over_int_amt is '欠息金额';
comment on column ${idl_schema}.oass_agt_col_cont_info.payoff_status_cd is '结清状态代码';
comment on column ${idl_schema}.oass_agt_col_cont_info.loan_rating_cd is '贷款评级代码';
comment on column ${idl_schema}.oass_agt_col_cont_info.reply_id is '批复编号';
comment on column ${idl_schema}.oass_agt_col_cont_info.strip_line_cd is '条线代码';
comment on column ${idl_schema}.oass_agt_col_cont_info.crdt_cont_id is '授信合同编号';
comment on column ${idl_schema}.oass_agt_col_cont_info.crdt_appl_id is '授信申请编号';
comment on column ${idl_schema}.oass_agt_col_cont_info.paper_cont_id is '纸质合同编号';
comment on column ${idl_schema}.oass_agt_col_cont_info.data_src_cd is '数据来源代码';
comment on column ${idl_schema}.oass_agt_col_cont_info.create_dt is '创建日期';
comment on column ${idl_schema}.oass_agt_col_cont_info.update_dt is '更新日期';
comment on column ${idl_schema}.oass_agt_col_cont_info.id_mark is '增删标志';
comment on column ${idl_schema}.oass_agt_col_cont_info.agt_id is '协议编号';
comment on column ${idl_schema}.oass_agt_col_cont_info.lp_id is '法人编号';

