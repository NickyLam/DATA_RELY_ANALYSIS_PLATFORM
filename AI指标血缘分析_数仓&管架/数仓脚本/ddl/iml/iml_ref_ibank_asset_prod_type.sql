/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_ibank_asset_prod_type
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ref_ibank_asset_prod_type
whenever sqlerror continue none;
drop table ${iml_schema}.ref_ibank_asset_prod_type purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_ibank_asset_prod_type(
    prod_type_cd varchar2(20) -- 产品类型代码
    ,lp_id varchar2(60) -- 法人编号
    ,asset_type_cd varchar2(20) -- 资产类型代码
    ,prod_type_name varchar2(150) -- 产品类型名称
    ,auto_ird_flg varchar2(10) -- 自动息差标志
    ,delay_exp_flg varchar2(10) -- 延迟到期标志
    ,amort_way_cd varchar2(10) -- 摊销方式代码
    ,amort_way_name varchar2(150) -- 摊销方式名称
    ,evltion_flg varchar2(10) -- 估值标志
    ,evltion_type_cd varchar2(10) -- 估值类型代码
    ,drawdown_flg varchar2(10) -- 支取标志
    ,provi_flg varchar2(10) -- 计提标志
    ,col_int_flg varchar2(10) -- 收息标志
    ,auto_ovdue_flg varchar2(10) -- 自动逾期标志
    ,on_acct_id varchar2(60) -- 挂账账户编号
    ,on_acct_name varchar2(150) -- 挂账账户名
    ,create_dt date -- 创建日期
    ,update_dt date -- 更新日期
    ,etl_dt date -- ETL处理日期
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.ref_ibank_asset_prod_type to ${icl_schema};
grant select on ${iml_schema}.ref_ibank_asset_prod_type to ${idl_schema};
grant select on ${iml_schema}.ref_ibank_asset_prod_type to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_ibank_asset_prod_type is '同业资产产品类型表';
comment on column ${iml_schema}.ref_ibank_asset_prod_type.prod_type_cd is '产品类型代码';
comment on column ${iml_schema}.ref_ibank_asset_prod_type.lp_id is '法人编号';
comment on column ${iml_schema}.ref_ibank_asset_prod_type.asset_type_cd is '资产类型代码';
comment on column ${iml_schema}.ref_ibank_asset_prod_type.prod_type_name is '产品类型名称';
comment on column ${iml_schema}.ref_ibank_asset_prod_type.auto_ird_flg is '自动息差标志';
comment on column ${iml_schema}.ref_ibank_asset_prod_type.delay_exp_flg is '延迟到期标志';
comment on column ${iml_schema}.ref_ibank_asset_prod_type.amort_way_cd is '摊销方式代码';
comment on column ${iml_schema}.ref_ibank_asset_prod_type.amort_way_name is '摊销方式名称';
comment on column ${iml_schema}.ref_ibank_asset_prod_type.evltion_flg is '估值标志';
comment on column ${iml_schema}.ref_ibank_asset_prod_type.evltion_type_cd is '估值类型代码';
comment on column ${iml_schema}.ref_ibank_asset_prod_type.drawdown_flg is '支取标志';
comment on column ${iml_schema}.ref_ibank_asset_prod_type.provi_flg is '计提标志';
comment on column ${iml_schema}.ref_ibank_asset_prod_type.col_int_flg is '收息标志';
comment on column ${iml_schema}.ref_ibank_asset_prod_type.auto_ovdue_flg is '自动逾期标志';
comment on column ${iml_schema}.ref_ibank_asset_prod_type.on_acct_id is '挂账账户编号';
comment on column ${iml_schema}.ref_ibank_asset_prod_type.on_acct_name is '挂账账户名';
comment on column ${iml_schema}.ref_ibank_asset_prod_type.create_dt is '创建日期';
comment on column ${iml_schema}.ref_ibank_asset_prod_type.update_dt is '更新日期';
comment on column ${iml_schema}.ref_ibank_asset_prod_type.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.ref_ibank_asset_prod_type.id_mark is '增删标志';
comment on column ${iml_schema}.ref_ibank_asset_prod_type.src_table_name is '源表名称';
comment on column ${iml_schema}.ref_ibank_asset_prod_type.job_cd is '任务编码';
comment on column ${iml_schema}.ref_ibank_asset_prod_type.etl_timestamp is 'ETL处理时间戳';
