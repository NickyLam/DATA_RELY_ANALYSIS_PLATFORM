/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_prd_am_prod_sell_para
CreateDate: 20230404
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_prd_am_prod_sell_para purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_prd_am_prod_sell_para(
etl_dt date --ETL处理日期
,am_prod_id varchar2(100) --资管产品编号
,finc_prod_id varchar2(100) --理财产品编号
,sell_chn_cd_comb varchar2(2000) --销售渠道代码组合
,sell_rg_cd_comb varchar2(2000) --销售地区代码组合
,target_cust_type_cd_comb varchar2(100) --目标客户类型代码组合
,coll_amt_uplmi number(30,2) --募集金额上限
,coll_amt_lolmi number(30,2) --募集金额下限
,plan_coll_amt number(30,2) --计划募集金额
,subscr_amt_sp number(30,2) --认购金额起点
,least_supp_amt number(30,2) --最少追加金额
,huge_redem_ratio number(30,14) --巨额赎回比例
,lowt_book_lot number(30,8) --最低账面份额
,lowt_redem_lot number(30,8) --最低赎回份额
,inpwned_flg varchar2(250) --
,fir_coll_start_dt date --首次募集开始日期
,fir_coll_end_dt date --首次募集结束日期
,supt_consmt_flg varchar2(250) --
,allow_adv_termnt_flg varchar2(250) --
,allow_cust_redem_flg varchar2(250) --
,deflt_redem_flg varchar2(250) --
,advd_found_flg varchar2(250) --
,invest_flg varchar2(250) --
,ibank_cust_id_comb varchar2(100) --同业客户编号组合
,create_dt date --创建日期
,update_dt date --更新日期
,id_mark varchar2(10) --增删标志
,prod_id varchar2(100) --产品编号
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
grant select on ${idl_schema}.oass_prd_am_prod_sell_para to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_prd_am_prod_sell_para is '资管产品销售参数';
comment on column ${idl_schema}.oass_prd_am_prod_sell_para.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.oass_prd_am_prod_sell_para.am_prod_id is '资管产品编号';
comment on column ${idl_schema}.oass_prd_am_prod_sell_para.finc_prod_id is '理财产品编号';
comment on column ${idl_schema}.oass_prd_am_prod_sell_para.sell_chn_cd_comb is '销售渠道代码组合';
comment on column ${idl_schema}.oass_prd_am_prod_sell_para.sell_rg_cd_comb is '销售地区代码组合';
comment on column ${idl_schema}.oass_prd_am_prod_sell_para.target_cust_type_cd_comb is '目标客户类型代码组合';
comment on column ${idl_schema}.oass_prd_am_prod_sell_para.coll_amt_uplmi is '募集金额上限';
comment on column ${idl_schema}.oass_prd_am_prod_sell_para.coll_amt_lolmi is '募集金额下限';
comment on column ${idl_schema}.oass_prd_am_prod_sell_para.plan_coll_amt is '计划募集金额';
comment on column ${idl_schema}.oass_prd_am_prod_sell_para.subscr_amt_sp is '认购金额起点';
comment on column ${idl_schema}.oass_prd_am_prod_sell_para.least_supp_amt is '最少追加金额';
comment on column ${idl_schema}.oass_prd_am_prod_sell_para.huge_redem_ratio is '巨额赎回比例';
comment on column ${idl_schema}.oass_prd_am_prod_sell_para.lowt_book_lot is '最低账面份额';
comment on column ${idl_schema}.oass_prd_am_prod_sell_para.lowt_redem_lot is '最低赎回份额';
comment on column ${idl_schema}.oass_prd_am_prod_sell_para.inpwned_flg is '';
comment on column ${idl_schema}.oass_prd_am_prod_sell_para.fir_coll_start_dt is '首次募集开始日期';
comment on column ${idl_schema}.oass_prd_am_prod_sell_para.fir_coll_end_dt is '首次募集结束日期';
comment on column ${idl_schema}.oass_prd_am_prod_sell_para.supt_consmt_flg is '';
comment on column ${idl_schema}.oass_prd_am_prod_sell_para.allow_adv_termnt_flg is '';
comment on column ${idl_schema}.oass_prd_am_prod_sell_para.allow_cust_redem_flg is '';
comment on column ${idl_schema}.oass_prd_am_prod_sell_para.deflt_redem_flg is '';
comment on column ${idl_schema}.oass_prd_am_prod_sell_para.advd_found_flg is '';
comment on column ${idl_schema}.oass_prd_am_prod_sell_para.invest_flg is '';
comment on column ${idl_schema}.oass_prd_am_prod_sell_para.ibank_cust_id_comb is '同业客户编号组合';
comment on column ${idl_schema}.oass_prd_am_prod_sell_para.create_dt is '创建日期';
comment on column ${idl_schema}.oass_prd_am_prod_sell_para.update_dt is '更新日期';
comment on column ${idl_schema}.oass_prd_am_prod_sell_para.id_mark is '增删标志';
comment on column ${idl_schema}.oass_prd_am_prod_sell_para.prod_id is '产品编号';
comment on column ${idl_schema}.oass_prd_am_prod_sell_para.lp_id is '法人编号';

