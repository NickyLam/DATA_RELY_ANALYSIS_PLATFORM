/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icrm_prd_ibank_post_asset
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.icrm_prd_ibank_post_asset
whenever sqlerror continue none;
drop table ${idl_schema}.icrm_prd_ibank_post_asset purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.icrm_prd_ibank_post_asset(
    etl_dt date -- 数据日期
    ,prod_id varchar2(60) -- 产品编号
    ,lp_id varchar2(60) -- 法人编号
    ,prod_type_cd varchar2(60) -- 产品类型代码
    ,prod_cd varchar2(60) -- 产品代码
    ,prod_name varchar2(200) -- 产品名称
    ,effect_dt date -- 生效日期
    ,ftp_int_rat number(18,8) -- ftp利率
    ,remark varchar2(1000) -- 备注
    ,value_dt date -- 起息日期
    ,exp_dt date -- 到期日期
    ,rgst_type_cd varchar2(10) -- 登记类型代码
    ,proj varchar2(30) -- 项目
    ,risk_wt varchar2(30) -- 风险权重
    ,risk_asset_tot number(30,2) -- 风险资产总额
    ,rgst_dt date -- 登记日期
    ,market_inst varchar2(60) -- MARKET_INST
    ,customer_manager varchar2(60) -- CUSTOMER_MANAGER
    ,asset_type_cd varchar2(30) -- 资产类型代码
    ,market_type_cd varchar2(30) -- 市场类型代码
    ,vch_accti_obj_id varchar2(60) -- 券核算对象编号
    ,amt number(30,2) -- 金额
    ,job_cd varchar2(30) -- 任务代码
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
grant select on ${idl_schema}.icrm_prd_ibank_post_asset to ${iel_schema};

-- comment
comment on table ${idl_schema}.icrm_prd_ibank_post_asset is '同业持仓资产';
comment on column ${idl_schema}.icrm_prd_ibank_post_asset.etl_dt is '数据日期';
comment on column ${idl_schema}.icrm_prd_ibank_post_asset.prod_id is '产品编号';
comment on column ${idl_schema}.icrm_prd_ibank_post_asset.lp_id is '法人编号';
comment on column ${idl_schema}.icrm_prd_ibank_post_asset.prod_type_cd is '产品类型代码';
comment on column ${idl_schema}.icrm_prd_ibank_post_asset.prod_cd is '产品代码';
comment on column ${idl_schema}.icrm_prd_ibank_post_asset.prod_name is '产品名称';
comment on column ${idl_schema}.icrm_prd_ibank_post_asset.effect_dt is '生效日期';
comment on column ${idl_schema}.icrm_prd_ibank_post_asset.ftp_int_rat is 'ftp利率';
comment on column ${idl_schema}.icrm_prd_ibank_post_asset.remark is '备注';
comment on column ${idl_schema}.icrm_prd_ibank_post_asset.value_dt is '起息日期';
comment on column ${idl_schema}.icrm_prd_ibank_post_asset.exp_dt is '到期日期';
comment on column ${idl_schema}.icrm_prd_ibank_post_asset.rgst_type_cd is '登记类型代码';
comment on column ${idl_schema}.icrm_prd_ibank_post_asset.proj is '项目';
comment on column ${idl_schema}.icrm_prd_ibank_post_asset.risk_wt is '风险权重';
comment on column ${idl_schema}.icrm_prd_ibank_post_asset.risk_asset_tot is '风险资产总额';
comment on column ${idl_schema}.icrm_prd_ibank_post_asset.rgst_dt is '登记日期';
comment on column ${idl_schema}.icrm_prd_ibank_post_asset.market_inst is 'MARKET_INST';
comment on column ${idl_schema}.icrm_prd_ibank_post_asset.customer_manager is 'CUSTOMER_MANAGER';
comment on column ${idl_schema}.icrm_prd_ibank_post_asset.asset_type_cd is '资产类型代码';
comment on column ${idl_schema}.icrm_prd_ibank_post_asset.market_type_cd is '市场类型代码';
comment on column ${idl_schema}.icrm_prd_ibank_post_asset.vch_accti_obj_id is '券核算对象编号';
comment on column ${idl_schema}.icrm_prd_ibank_post_asset.amt is '金额';
comment on column ${idl_schema}.icrm_prd_ibank_post_asset.job_cd is '任务代码';
comment on column ${idl_schema}.icrm_prd_ibank_post_asset.etl_timestamp is '数据处理时间';
