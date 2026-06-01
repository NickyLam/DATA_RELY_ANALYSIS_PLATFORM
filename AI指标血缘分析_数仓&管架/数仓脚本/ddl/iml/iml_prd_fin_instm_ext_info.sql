/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_fin_instm_ext_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_fin_instm_ext_info
whenever sqlerror continue none;
drop table ${iml_schema}.prd_fin_instm_ext_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_fin_instm_ext_info(
    fin_instm_id varchar2(60) -- 金融工具编号
    ,asset_type_id varchar2(60) -- 资产类型编号
    ,market_type_id varchar2(60) -- 市场类型编号
    ,lp_id varchar2(60) -- 法人编号
    ,ext_type_cd varchar2(30) -- 扩展类型代码
    ,effect_dt date -- 生效日期
    ,invalid_dt date -- 失效日期
    ,int_rat_multir number(30) -- 利率乘数
    ,amt number(38,8) -- 发生额
    ,contn_weight_type_cd varchar2(30) -- 含权类型代码
    ,ex_type_cd varchar2(30) -- 行权类型代码
    ,actl_ex_dt date -- 实际行权日期
    ,ex_price number(38,8) -- 行权价格
    ,value_dt date -- 起息日期
    ,exp_dt date -- 到期日期
    ,updater_name varchar2(150) -- 更新人名称
    ,update_tm timestamp -- 更新时间
    ,imp_way_id varchar2(60) -- 导入方式编号
    ,imp_dt date -- 导入日期
    ,etl_dt date -- ETL处理日期
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
grant select on ${iml_schema}.prd_fin_instm_ext_info to ${icl_schema};
grant select on ${iml_schema}.prd_fin_instm_ext_info to ${idl_schema};
grant select on ${iml_schema}.prd_fin_instm_ext_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_fin_instm_ext_info is '金融工具扩展信息';
comment on column ${iml_schema}.prd_fin_instm_ext_info.fin_instm_id is '金融工具编号';
comment on column ${iml_schema}.prd_fin_instm_ext_info.asset_type_id is '资产类型编号';
comment on column ${iml_schema}.prd_fin_instm_ext_info.market_type_id is '市场类型编号';
comment on column ${iml_schema}.prd_fin_instm_ext_info.lp_id is '法人编号';
comment on column ${iml_schema}.prd_fin_instm_ext_info.ext_type_cd is '扩展类型代码';
comment on column ${iml_schema}.prd_fin_instm_ext_info.effect_dt is '生效日期';
comment on column ${iml_schema}.prd_fin_instm_ext_info.invalid_dt is '失效日期';
comment on column ${iml_schema}.prd_fin_instm_ext_info.int_rat_multir is '利率乘数';
comment on column ${iml_schema}.prd_fin_instm_ext_info.amt is '发生额';
comment on column ${iml_schema}.prd_fin_instm_ext_info.contn_weight_type_cd is '含权类型代码';
comment on column ${iml_schema}.prd_fin_instm_ext_info.ex_type_cd is '行权类型代码';
comment on column ${iml_schema}.prd_fin_instm_ext_info.actl_ex_dt is '实际行权日期';
comment on column ${iml_schema}.prd_fin_instm_ext_info.ex_price is '行权价格';
comment on column ${iml_schema}.prd_fin_instm_ext_info.value_dt is '起息日期';
comment on column ${iml_schema}.prd_fin_instm_ext_info.exp_dt is '到期日期';
comment on column ${iml_schema}.prd_fin_instm_ext_info.updater_name is '更新人名称';
comment on column ${iml_schema}.prd_fin_instm_ext_info.update_tm is '更新时间';
comment on column ${iml_schema}.prd_fin_instm_ext_info.imp_way_id is '导入方式编号';
comment on column ${iml_schema}.prd_fin_instm_ext_info.imp_dt is '导入日期';
comment on column ${iml_schema}.prd_fin_instm_ext_info.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.prd_fin_instm_ext_info.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_fin_instm_ext_info.job_cd is '任务编码';
comment on column ${iml_schema}.prd_fin_instm_ext_info.etl_timestamp is 'ETL处理时间戳';
