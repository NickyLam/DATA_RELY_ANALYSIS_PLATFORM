/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_prd_finc_prod_imp_info_ext_h
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_prd_finc_prod_imp_info_ext_h purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_prd_finc_prod_imp_info_ext_h(
etl_dt date --数据日期
,cfm_dt date --确认日期
,prod_cd varchar2(20) --产品代码
,nv_type_cd varchar2(10) --净值类型代码
,reg_quota_status_cd varchar2(10) --定期定额状态代码
,turn_trust_status_cd varchar2(10) --转托管状态代码
,curr_cd varchar2(10) --币种代码
,affi_flg varchar2(10) --公告标志
,indv_issue_way_cd varchar2(10) --个人发行方式代码
,org_issue_way_cd varchar2(10) --机构发行方式代码
,divd_dt date --分红日期
,eqty_rgst_dt date --权益登记日期
,ex_righ_dt date --除权日期
,subscr_way_cd varchar2(10) --认购方式代码
,charge_way_cd varchar2(10) --收费方式代码
,curr_fund_year_yld_rat number(18,6) --货币基金年收益率
,allow_deflt_redem_flg varchar2(10) --允许违约赎回标志
,ta_cd varchar2(10) --TA代码
,start_dt date --开始时间
,end_dt date --结束时间
,id_mark varchar2(10) --增删标志
,quar_aual_yld number(18,6) --季度年化收益率
,quar_aual_yld_pm_cd varchar2(30) --季度年化收益率正负代码
,ped_yld_rat number(18,6) --周期收益率
,ped_yld_rat_pm_cd varchar2(30) --周期收益率正负代码
,am_nv_dt date --资管净值日期
,issue_dt date --发布日期
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
grant select on ${idl_schema}.oass_prd_finc_prod_imp_info_ext_h to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_prd_finc_prod_imp_info_ext_h is '理财产品重要信息扩展历史';
comment on column ${idl_schema}.oass_prd_finc_prod_imp_info_ext_h.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_prd_finc_prod_imp_info_ext_h.cfm_dt is '确认日期';
comment on column ${idl_schema}.oass_prd_finc_prod_imp_info_ext_h.prod_cd is '产品代码';
comment on column ${idl_schema}.oass_prd_finc_prod_imp_info_ext_h.nv_type_cd is '净值类型代码';
comment on column ${idl_schema}.oass_prd_finc_prod_imp_info_ext_h.reg_quota_status_cd is '定期定额状态代码';
comment on column ${idl_schema}.oass_prd_finc_prod_imp_info_ext_h.turn_trust_status_cd is '转托管状态代码';
comment on column ${idl_schema}.oass_prd_finc_prod_imp_info_ext_h.curr_cd is '币种代码';
comment on column ${idl_schema}.oass_prd_finc_prod_imp_info_ext_h.affi_flg is '公告标志';
comment on column ${idl_schema}.oass_prd_finc_prod_imp_info_ext_h.indv_issue_way_cd is '个人发行方式代码';
comment on column ${idl_schema}.oass_prd_finc_prod_imp_info_ext_h.org_issue_way_cd is '机构发行方式代码';
comment on column ${idl_schema}.oass_prd_finc_prod_imp_info_ext_h.divd_dt is '分红日期';
comment on column ${idl_schema}.oass_prd_finc_prod_imp_info_ext_h.eqty_rgst_dt is '权益登记日期';
comment on column ${idl_schema}.oass_prd_finc_prod_imp_info_ext_h.ex_righ_dt is '除权日期';
comment on column ${idl_schema}.oass_prd_finc_prod_imp_info_ext_h.subscr_way_cd is '认购方式代码';
comment on column ${idl_schema}.oass_prd_finc_prod_imp_info_ext_h.charge_way_cd is '收费方式代码';
comment on column ${idl_schema}.oass_prd_finc_prod_imp_info_ext_h.curr_fund_year_yld_rat is '货币基金年收益率';
comment on column ${idl_schema}.oass_prd_finc_prod_imp_info_ext_h.allow_deflt_redem_flg is '允许违约赎回标志';
comment on column ${idl_schema}.oass_prd_finc_prod_imp_info_ext_h.ta_cd is 'TA代码';
comment on column ${idl_schema}.oass_prd_finc_prod_imp_info_ext_h.start_dt is '开始时间';
comment on column ${idl_schema}.oass_prd_finc_prod_imp_info_ext_h.end_dt is '结束时间';
comment on column ${idl_schema}.oass_prd_finc_prod_imp_info_ext_h.id_mark is '增删标志';
comment on column ${idl_schema}.oass_prd_finc_prod_imp_info_ext_h.quar_aual_yld is '季度年化收益率';
comment on column ${idl_schema}.oass_prd_finc_prod_imp_info_ext_h.quar_aual_yld_pm_cd is '季度年化收益率正负代码';
comment on column ${idl_schema}.oass_prd_finc_prod_imp_info_ext_h.ped_yld_rat is '周期收益率';
comment on column ${idl_schema}.oass_prd_finc_prod_imp_info_ext_h.ped_yld_rat_pm_cd is '周期收益率正负代码';
comment on column ${idl_schema}.oass_prd_finc_prod_imp_info_ext_h.am_nv_dt is '资管净值日期';
comment on column ${idl_schema}.oass_prd_finc_prod_imp_info_ext_h.issue_dt is '发布日期';
comment on column ${idl_schema}.oass_prd_finc_prod_imp_info_ext_h.lp_id is '法人编号';

