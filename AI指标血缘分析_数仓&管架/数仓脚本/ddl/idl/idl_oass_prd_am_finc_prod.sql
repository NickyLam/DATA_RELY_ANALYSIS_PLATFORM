/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_prd_am_finc_prod
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_prd_am_finc_prod purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_prd_am_finc_prod(
etl_dt date --ETL处理日期
,std_prod_id varchar2(60) --标准产品编号
,src_prod_id varchar2(60) --源产品编号
,prod_cate_cd varchar2(60) --产品类别代码
,prod_abbr varchar2(250) --产品简称
,prod_fname varchar2(250) --产品全称
,prft_mode_cd varchar2(60) --收益模式代码
,finc_prod_id varchar2(60) --理财产品编号
,issue_curr_cd varchar2(60) --发行币种代码
,tran_caln_cd varchar2(60) --交易日历代码
,coll_way_cd varchar2(60) --募集方式代码
,oper_mode_cd varchar2(60) --运作模式代码
,entr_way_cd varchar2(60) --委托方式代码
,csner_id varchar2(60) --委托人编号
,trustee_id varchar2(60) --托管人编号
,value_dt date --起息日期
,exp_dt date --到期日期
,prod_tenor number(10,0) --产品期限
,actl_exp_dt date --实际到期日期
,liqd_dt date --清盘日期
,subtn_flg varchar2(60) --永续标志
,subtn_claus varchar2(1000) --永续条款
,super_prod_id varchar2(60) --上级产品编号
,sell_dept_id varchar2(60) --销售部门编号
,purch_cfm_tenor number(10,0) --申购确认期限
,redem_cfm_tenor number(10,0) --赎回确认期限
,inv_port_id varchar2(60) --投资组合编号
,prod_rgst_code varchar2(20) --产品登记编码
,ped_prod_flg varchar2(60) --周期型产品标志
,layered_flg varchar2(60) --分层标志
,layered_type_cd varchar2(60) --分层类型代码
,invest_char_type_cd varchar2(60) --投资性质类型代码
,prft_type_cd varchar2(60) --收益类型代码
,issue_status_cd varchar2(60) --发行状态代码
,cash_mgmt_flg varchar2(60) --现金管理标志
,risk_level_cd varchar2(60) --风险等级代码
,proc_mode_cd varchar2(60) --处理模式代码
,exlus_prod_flg varchar2(60) --专属产品标志
,ped_days varchar2(60) --周期天数
,prod_mgr_name varchar2(100) --产品经理名称
,init_create_tm timestamp(6) --原创建时间
,init_update_tm timestamp(6) --原更新时间
,tenor_type_cd varchar2(60) --期限类型代码
,prod_seri_cd varchar2(60) --产品系列代码
,prod_cls_cd varchar2(60) --产品分类代码
,exlus_ibank_org_id varchar2(60) --专属同业机构编号
,create_dt date --创建日期
,update_dt date --更新日期
,id_mark varchar2(10) --增删标志
,prod_id varchar2(60) --产品编号
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
grant select on ${idl_schema}.oass_prd_am_finc_prod to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_prd_am_finc_prod is '资管理财产品';
comment on column ${idl_schema}.oass_prd_am_finc_prod.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.oass_prd_am_finc_prod.std_prod_id is '标准产品编号';
comment on column ${idl_schema}.oass_prd_am_finc_prod.src_prod_id is '源产品编号';
comment on column ${idl_schema}.oass_prd_am_finc_prod.prod_cate_cd is '产品类别代码';
comment on column ${idl_schema}.oass_prd_am_finc_prod.prod_abbr is '产品简称';
comment on column ${idl_schema}.oass_prd_am_finc_prod.prod_fname is '产品全称';
comment on column ${idl_schema}.oass_prd_am_finc_prod.prft_mode_cd is '收益模式代码';
comment on column ${idl_schema}.oass_prd_am_finc_prod.finc_prod_id is '理财产品编号';
comment on column ${idl_schema}.oass_prd_am_finc_prod.issue_curr_cd is '发行币种代码';
comment on column ${idl_schema}.oass_prd_am_finc_prod.tran_caln_cd is '交易日历代码';
comment on column ${idl_schema}.oass_prd_am_finc_prod.coll_way_cd is '募集方式代码';
comment on column ${idl_schema}.oass_prd_am_finc_prod.oper_mode_cd is '运作模式代码';
comment on column ${idl_schema}.oass_prd_am_finc_prod.entr_way_cd is '委托方式代码';
comment on column ${idl_schema}.oass_prd_am_finc_prod.csner_id is '委托人编号';
comment on column ${idl_schema}.oass_prd_am_finc_prod.trustee_id is '托管人编号';
comment on column ${idl_schema}.oass_prd_am_finc_prod.value_dt is '起息日期';
comment on column ${idl_schema}.oass_prd_am_finc_prod.exp_dt is '到期日期';
comment on column ${idl_schema}.oass_prd_am_finc_prod.prod_tenor is '产品期限';
comment on column ${idl_schema}.oass_prd_am_finc_prod.actl_exp_dt is '实际到期日期';
comment on column ${idl_schema}.oass_prd_am_finc_prod.liqd_dt is '清盘日期';
comment on column ${idl_schema}.oass_prd_am_finc_prod.subtn_flg is '永续标志';
comment on column ${idl_schema}.oass_prd_am_finc_prod.subtn_claus is '永续条款';
comment on column ${idl_schema}.oass_prd_am_finc_prod.super_prod_id is '上级产品编号';
comment on column ${idl_schema}.oass_prd_am_finc_prod.sell_dept_id is '销售部门编号';
comment on column ${idl_schema}.oass_prd_am_finc_prod.purch_cfm_tenor is '申购确认期限';
comment on column ${idl_schema}.oass_prd_am_finc_prod.redem_cfm_tenor is '赎回确认期限';
comment on column ${idl_schema}.oass_prd_am_finc_prod.inv_port_id is '投资组合编号';
comment on column ${idl_schema}.oass_prd_am_finc_prod.prod_rgst_code is '产品登记编码';
comment on column ${idl_schema}.oass_prd_am_finc_prod.ped_prod_flg is '周期型产品标志';
comment on column ${idl_schema}.oass_prd_am_finc_prod.layered_flg is '分层标志';
comment on column ${idl_schema}.oass_prd_am_finc_prod.layered_type_cd is '分层类型代码';
comment on column ${idl_schema}.oass_prd_am_finc_prod.invest_char_type_cd is '投资性质类型代码';
comment on column ${idl_schema}.oass_prd_am_finc_prod.prft_type_cd is '收益类型代码';
comment on column ${idl_schema}.oass_prd_am_finc_prod.issue_status_cd is '发行状态代码';
comment on column ${idl_schema}.oass_prd_am_finc_prod.cash_mgmt_flg is '现金管理标志';
comment on column ${idl_schema}.oass_prd_am_finc_prod.risk_level_cd is '风险等级代码';
comment on column ${idl_schema}.oass_prd_am_finc_prod.proc_mode_cd is '处理模式代码';
comment on column ${idl_schema}.oass_prd_am_finc_prod.exlus_prod_flg is '专属产品标志';
comment on column ${idl_schema}.oass_prd_am_finc_prod.ped_days is '周期天数';
comment on column ${idl_schema}.oass_prd_am_finc_prod.prod_mgr_name is '产品经理名称';
comment on column ${idl_schema}.oass_prd_am_finc_prod.init_create_tm is '原创建时间';
comment on column ${idl_schema}.oass_prd_am_finc_prod.init_update_tm is '原更新时间';
comment on column ${idl_schema}.oass_prd_am_finc_prod.tenor_type_cd is '期限类型代码';
comment on column ${idl_schema}.oass_prd_am_finc_prod.prod_seri_cd is '产品系列代码';
comment on column ${idl_schema}.oass_prd_am_finc_prod.prod_cls_cd is '产品分类代码';
comment on column ${idl_schema}.oass_prd_am_finc_prod.exlus_ibank_org_id is '专属同业机构编号';
comment on column ${idl_schema}.oass_prd_am_finc_prod.create_dt is '创建日期';
comment on column ${idl_schema}.oass_prd_am_finc_prod.update_dt is '更新日期';
comment on column ${idl_schema}.oass_prd_am_finc_prod.id_mark is '增删标志';
comment on column ${idl_schema}.oass_prd_am_finc_prod.prod_id is '产品编号';
comment on column ${idl_schema}.oass_prd_am_finc_prod.lp_id is '法人编号';

