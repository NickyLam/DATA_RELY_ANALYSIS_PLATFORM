/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icrm_ref_ibank_asset_prod_type
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.icrm_ref_ibank_asset_prod_type
whenever sqlerror continue none;
drop table ${idl_schema}.icrm_ref_ibank_asset_prod_type purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.icrm_ref_ibank_asset_prod_type(
    etl_dt date -- 数据日期
    ,prod_type_cd varchar2(20) -- 产品类型代码
    ,lp_id varchar2(60) -- 法人编号
    ,asset_type_cd varchar2(20) -- 资产类型代码
    ,prod_type_name varchar2(100) -- 产品类型名称
    ,auto_ird_flg varchar2(10) -- 自动息差标志
    ,delay_exp_flg varchar2(10) -- 延迟到期标志
    ,amort_way_cd varchar2(10) -- 摊销方式代码
    ,amort_way_name varchar2(100) -- 摊销方式名称
    ,evltion_flg varchar2(10) -- 估值标志
    ,evltion_type_cd varchar2(10) -- 估值类型代码
    ,drawdown_flg varchar2(10) -- 支取标志
    ,provi_flg varchar2(10) -- 计提标志
    ,col_int_flg varchar2(10) -- 收息标志
    ,auto_ovdue_flg varchar2(10) -- 自动逾期标志
    ,on_acct_id varchar2(60) -- 挂账账户编号
    ,on_acct_name varchar2(100) -- 挂账账户名
    ,job_cd varchar2(10) -- 任务代码
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
grant select on ${idl_schema}.icrm_ref_ibank_asset_prod_type to ${iel_schema};

-- comment
comment on table ${idl_schema}.icrm_ref_ibank_asset_prod_type is '同业资产产品类型表';
comment on column ${idl_schema}.icrm_ref_ibank_asset_prod_type.etl_dt is '数据日期';
comment on column ${idl_schema}.icrm_ref_ibank_asset_prod_type.prod_type_cd is '产品类型代码';
comment on column ${idl_schema}.icrm_ref_ibank_asset_prod_type.lp_id is '法人编号';
comment on column ${idl_schema}.icrm_ref_ibank_asset_prod_type.asset_type_cd is '资产类型代码';
comment on column ${idl_schema}.icrm_ref_ibank_asset_prod_type.prod_type_name is '产品类型名称';
comment on column ${idl_schema}.icrm_ref_ibank_asset_prod_type.auto_ird_flg is '自动息差标志';
comment on column ${idl_schema}.icrm_ref_ibank_asset_prod_type.delay_exp_flg is '延迟到期标志';
comment on column ${idl_schema}.icrm_ref_ibank_asset_prod_type.amort_way_cd is '摊销方式代码';
comment on column ${idl_schema}.icrm_ref_ibank_asset_prod_type.amort_way_name is '摊销方式名称';
comment on column ${idl_schema}.icrm_ref_ibank_asset_prod_type.evltion_flg is '估值标志';
comment on column ${idl_schema}.icrm_ref_ibank_asset_prod_type.evltion_type_cd is '估值类型代码';
comment on column ${idl_schema}.icrm_ref_ibank_asset_prod_type.drawdown_flg is '支取标志';
comment on column ${idl_schema}.icrm_ref_ibank_asset_prod_type.provi_flg is '计提标志';
comment on column ${idl_schema}.icrm_ref_ibank_asset_prod_type.col_int_flg is '收息标志';
comment on column ${idl_schema}.icrm_ref_ibank_asset_prod_type.auto_ovdue_flg is '自动逾期标志';
comment on column ${idl_schema}.icrm_ref_ibank_asset_prod_type.on_acct_id is '挂账账户编号';
comment on column ${idl_schema}.icrm_ref_ibank_asset_prod_type.on_acct_name is '挂账账户名';
comment on column ${idl_schema}.icrm_ref_ibank_asset_prod_type.job_cd is '任务代码';
comment on column ${idl_schema}.icrm_ref_ibank_asset_prod_type.etl_timestamp is '数据处理时间';
