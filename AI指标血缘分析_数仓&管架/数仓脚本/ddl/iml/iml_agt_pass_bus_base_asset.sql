/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_pass_bus_base_asset
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_pass_bus_base_asset
whenever sqlerror continue none;
drop table ${iml_schema}.agt_pass_bus_base_asset purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_pass_bus_base_asset(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,base_asset_id varchar2(100) -- 基础资产编号
    ,cust_id varchar2(100) -- 客户编号
    ,cust_name varchar2(200) -- 客户名称
    ,cert_type_cd varchar2(30) -- 证件类型代码
    ,cert_no varchar2(60) -- 证件号码
    ,cust_local_indus_cd varchar2(30) -- 客户所在行业代码
    ,curr_cd varchar2(30) -- 币种代码
    ,amt number(30,6) -- 金额
    ,begin_dt date -- 起始日期
    ,exp_dt date -- 到期日期
    ,cash_cust_type_cd varchar2(30) -- 兑付方客户类型代码
    ,book_val number(30,8) -- 账面价值
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_dt date -- 登记日期
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
grant select on ${iml_schema}.agt_pass_bus_base_asset to ${icl_schema};
grant select on ${iml_schema}.agt_pass_bus_base_asset to ${idl_schema};
grant select on ${iml_schema}.agt_pass_bus_base_asset to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_pass_bus_base_asset is '通道业务基础资产';
comment on column ${iml_schema}.agt_pass_bus_base_asset.agt_id is '协议编号';
comment on column ${iml_schema}.agt_pass_bus_base_asset.lp_id is '法人编号';
comment on column ${iml_schema}.agt_pass_bus_base_asset.base_asset_id is '基础资产编号';
comment on column ${iml_schema}.agt_pass_bus_base_asset.cust_id is '客户编号';
comment on column ${iml_schema}.agt_pass_bus_base_asset.cust_name is '客户名称';
comment on column ${iml_schema}.agt_pass_bus_base_asset.cert_type_cd is '证件类型代码';
comment on column ${iml_schema}.agt_pass_bus_base_asset.cert_no is '证件号码';
comment on column ${iml_schema}.agt_pass_bus_base_asset.cust_local_indus_cd is '客户所在行业代码';
comment on column ${iml_schema}.agt_pass_bus_base_asset.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_pass_bus_base_asset.amt is '金额';
comment on column ${iml_schema}.agt_pass_bus_base_asset.begin_dt is '起始日期';
comment on column ${iml_schema}.agt_pass_bus_base_asset.exp_dt is '到期日期';
comment on column ${iml_schema}.agt_pass_bus_base_asset.cash_cust_type_cd is '兑付方客户类型代码';
comment on column ${iml_schema}.agt_pass_bus_base_asset.book_val is '账面价值';
comment on column ${iml_schema}.agt_pass_bus_base_asset.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_pass_bus_base_asset.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_pass_bus_base_asset.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_pass_bus_base_asset.create_dt is '创建日期';
comment on column ${iml_schema}.agt_pass_bus_base_asset.update_dt is '更新日期';
comment on column ${iml_schema}.agt_pass_bus_base_asset.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_pass_bus_base_asset.id_mark is '增删标志';
comment on column ${iml_schema}.agt_pass_bus_base_asset.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_pass_bus_base_asset.job_cd is '任务编码';
comment on column ${iml_schema}.agt_pass_bus_base_asset.etl_timestamp is 'ETL处理时间戳';
