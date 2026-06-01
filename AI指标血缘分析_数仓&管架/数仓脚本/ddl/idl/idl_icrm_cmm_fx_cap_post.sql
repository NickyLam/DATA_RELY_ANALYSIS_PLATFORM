/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icrm_cmm_fx_cap_post
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.icrm_cmm_fx_cap_post
whenever sqlerror continue none;
drop table ${idl_schema}.icrm_cmm_fx_cap_post purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.icrm_cmm_fx_cap_post(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,bal_id varchar2(60) -- 余额编号
    ,tran_acct_b_id varchar2(60) -- 交易账簿编号
    ,asset_type_name varchar2(250) -- 资产类型名称
    ,bus_cate_name varchar2(250) -- 业务类别名称
    ,main_asset_id varchar2(60) -- 主资产编号
    ,minor_asset_id varchar2(60) -- 次资产编号
    ,subj_id varchar2(60) -- 科目编号
    ,stl_dt date -- 结算日期
    ,hold_pos number(30,2) -- 持有仓位
    ,hold_fac_val number(30,2) -- 持有面值
    ,net_price_cost number(30,2) -- 净价成本
    ,int_adj_amt number(30,2) -- 利息调整金额
    ,evha_val_chag number(30,2) -- 公允价值变动
    ,int_cost number(30,2) -- 利息成本
    ,full_price_cost number(30,2) -- 全价成本
    ,impam_prep number(30,2) -- 减值准备
    ,spd_prft number(30,2) -- 价差收益
    ,amort_prft number(30,2) -- 摊销收益
    ,int_prft number(30,2) -- 利息收益
    ,evha_val_chag_pl number(30,2) -- 公允价值变动损益
    ,impam_loss number(30,2) -- 减值损失
    ,tran_fee number(30,2) -- 交易费用
    ,actl_int_rat number(18,8) -- 实际利率
    ,value_dt date -- 起息日期
    ,exp_dt date -- 到期日期
    ,happ_amt number(30,2) -- 发生金额
    ,job_cd varchar2(10) -- 任务代码
    ,entry_org_id     varchar2(60)  -- 记账机构编号 
    ,asset_thd_cls_cd varchar2(30)  -- 资产三分类代码
    ,std_prod_id      varchar2(60)  -- 标准产品编号 
    ,currt_bal        number(30,2)  -- 当期余额   
    ,etl_timestamp timestamp -- 数据处理时间
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.icrm_cmm_fx_cap_post to ${iel_schema};

-- comment
comment on table ${idl_schema}.icrm_cmm_fx_cap_post is '外汇资金持仓';
comment on column ${idl_schema}.icrm_cmm_fx_cap_post.etl_dt is '数据日期';
comment on column ${idl_schema}.icrm_cmm_fx_cap_post.lp_id is '法人编号';
comment on column ${idl_schema}.icrm_cmm_fx_cap_post.bal_id is '余额编号';
comment on column ${idl_schema}.icrm_cmm_fx_cap_post.tran_acct_b_id is '交易账簿编号';
comment on column ${idl_schema}.icrm_cmm_fx_cap_post.asset_type_name is '资产类型名称';
comment on column ${idl_schema}.icrm_cmm_fx_cap_post.bus_cate_name is '业务类别名称';
comment on column ${idl_schema}.icrm_cmm_fx_cap_post.main_asset_id is '主资产编号';
comment on column ${idl_schema}.icrm_cmm_fx_cap_post.minor_asset_id is '次资产编号';
comment on column ${idl_schema}.icrm_cmm_fx_cap_post.subj_id is '科目编号';
comment on column ${idl_schema}.icrm_cmm_fx_cap_post.stl_dt is '结算日期';
comment on column ${idl_schema}.icrm_cmm_fx_cap_post.hold_pos is '持有仓位';
comment on column ${idl_schema}.icrm_cmm_fx_cap_post.hold_fac_val is '持有面值';
comment on column ${idl_schema}.icrm_cmm_fx_cap_post.net_price_cost is '净价成本';
comment on column ${idl_schema}.icrm_cmm_fx_cap_post.int_adj_amt is '利息调整金额';
comment on column ${idl_schema}.icrm_cmm_fx_cap_post.evha_val_chag is '公允价值变动';
comment on column ${idl_schema}.icrm_cmm_fx_cap_post.int_cost is '利息成本';
comment on column ${idl_schema}.icrm_cmm_fx_cap_post.full_price_cost is '全价成本';
comment on column ${idl_schema}.icrm_cmm_fx_cap_post.impam_prep is '减值准备';
comment on column ${idl_schema}.icrm_cmm_fx_cap_post.spd_prft is '价差收益';
comment on column ${idl_schema}.icrm_cmm_fx_cap_post.amort_prft is '摊销收益';
comment on column ${idl_schema}.icrm_cmm_fx_cap_post.int_prft is '利息收益';
comment on column ${idl_schema}.icrm_cmm_fx_cap_post.evha_val_chag_pl is '公允价值变动损益';
comment on column ${idl_schema}.icrm_cmm_fx_cap_post.impam_loss is '减值损失';
comment on column ${idl_schema}.icrm_cmm_fx_cap_post.tran_fee is '交易费用';
comment on column ${idl_schema}.icrm_cmm_fx_cap_post.actl_int_rat is '实际利率';
comment on column ${idl_schema}.icrm_cmm_fx_cap_post.value_dt is '起息日期';
comment on column ${idl_schema}.icrm_cmm_fx_cap_post.exp_dt is '到期日期';
comment on column ${idl_schema}.icrm_cmm_fx_cap_post.happ_amt is '发生金额';
comment on column ${idl_schema}.icrm_cmm_fx_cap_post.job_cd is '任务代码';
comment on column ${idl_schema}.icrm_cmm_fx_cap_post.etl_timestamp is '数据处理时间';
comment on column ${idl_schema}.icrm_cmm_fx_cap_post.entry_org_id is '记账机构编号';
comment on column ${idl_schema}.icrm_cmm_fx_cap_post.asset_thd_cls_cd is '资产三分类代码';
comment on column ${idl_schema}.icrm_cmm_fx_cap_post.std_prod_id is '标准产品编号';
comment on column ${idl_schema}.icrm_cmm_fx_cap_post.currt_bal is '当期余额';
