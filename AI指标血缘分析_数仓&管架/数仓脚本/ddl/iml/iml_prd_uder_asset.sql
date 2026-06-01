/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_uder_asset
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_uder_asset
whenever sqlerror continue none;
drop table ${iml_schema}.prd_uder_asset purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_uder_asset(
    intnal_asset_id varchar2(100) -- 内部资产编号
    ,lp_id varchar2(60) -- 法人编号
    ,up_level_asset_id varchar2(100) -- 上层资产编号
    ,fin_instm_id varchar2(100) -- 金融工具编号
    ,asset_type_id varchar2(100) -- 资产类型编号
    ,market_type_id varchar2(100) -- 市场类型编号
    ,asset_id varchar2(100) -- 资产编号
    ,asset_name varchar2(750) -- 资产名称
    ,asset_cls_cd varchar2(30) -- 资产分类代码
    ,asset_subdv_cd varchar2(30) -- 资产细分类代码
    ,invest_amt number(30,8) -- 投资金额
    ,invest_dt date -- 投资日期
    ,value_dt date -- 起息日期
    ,exp_dt date -- 到期日期
    ,int_rat number(18,8) -- 利率
    ,pay_int_freq varchar2(30) -- 付息频率
    ,fir_pay_int_dt date -- 首次付息日期
    ,curr_cd varchar2(30) -- 币种代码
    ,imp_dt date -- 导入日期
    ,cntpty_id varchar2(100) -- 交易对手编号
    ,uder_asset_status_cd varchar2(30) -- 底层资产状态代码
    ,ocup_crdt_flg varchar2(10) -- 占用授信标志
    ,crdt_status_cd varchar2(30) -- 授信状态代码
    ,crdt_main_id varchar2(100) -- 授信主体编号
    ,crdt_wt number(18,6) -- 授信权重
    ,crdt_amt number(30,8) -- 授信金额
    ,checker_id varchar2(100) -- 复核人编号
    ,check_tm timestamp -- 复核时间
    ,check_dt date -- 复核日期
    ,invest_ratio number(18,6) -- 投资比例
    ,risk_wt number(18,6) -- 风险权重
    ,rating_rest_cd varchar2(30) -- 评级结果代码
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by range (end_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_default_20991231 values less than (maxvalue)
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.prd_uder_asset to ${icl_schema};
grant select on ${iml_schema}.prd_uder_asset to ${idl_schema};
grant select on ${iml_schema}.prd_uder_asset to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_uder_asset is '底层资产表';
comment on column ${iml_schema}.prd_uder_asset.intnal_asset_id is '内部资产编号';
comment on column ${iml_schema}.prd_uder_asset.lp_id is '法人编号';
comment on column ${iml_schema}.prd_uder_asset.up_level_asset_id is '上层资产编号';
comment on column ${iml_schema}.prd_uder_asset.fin_instm_id is '金融工具编号';
comment on column ${iml_schema}.prd_uder_asset.asset_type_id is '资产类型编号';
comment on column ${iml_schema}.prd_uder_asset.market_type_id is '市场类型编号';
comment on column ${iml_schema}.prd_uder_asset.asset_id is '资产编号';
comment on column ${iml_schema}.prd_uder_asset.asset_name is '资产名称';
comment on column ${iml_schema}.prd_uder_asset.asset_cls_cd is '资产分类代码';
comment on column ${iml_schema}.prd_uder_asset.asset_subdv_cd is '资产细分类代码';
comment on column ${iml_schema}.prd_uder_asset.invest_amt is '投资金额';
comment on column ${iml_schema}.prd_uder_asset.invest_dt is '投资日期';
comment on column ${iml_schema}.prd_uder_asset.value_dt is '起息日期';
comment on column ${iml_schema}.prd_uder_asset.exp_dt is '到期日期';
comment on column ${iml_schema}.prd_uder_asset.int_rat is '利率';
comment on column ${iml_schema}.prd_uder_asset.pay_int_freq is '付息频率';
comment on column ${iml_schema}.prd_uder_asset.fir_pay_int_dt is '首次付息日期';
comment on column ${iml_schema}.prd_uder_asset.curr_cd is '币种代码';
comment on column ${iml_schema}.prd_uder_asset.imp_dt is '导入日期';
comment on column ${iml_schema}.prd_uder_asset.cntpty_id is '交易对手编号';
comment on column ${iml_schema}.prd_uder_asset.uder_asset_status_cd is '底层资产状态代码';
comment on column ${iml_schema}.prd_uder_asset.ocup_crdt_flg is '占用授信标志';
comment on column ${iml_schema}.prd_uder_asset.crdt_status_cd is '授信状态代码';
comment on column ${iml_schema}.prd_uder_asset.crdt_main_id is '授信主体编号';
comment on column ${iml_schema}.prd_uder_asset.crdt_wt is '授信权重';
comment on column ${iml_schema}.prd_uder_asset.crdt_amt is '授信金额';
comment on column ${iml_schema}.prd_uder_asset.checker_id is '复核人编号';
comment on column ${iml_schema}.prd_uder_asset.check_tm is '复核时间';
comment on column ${iml_schema}.prd_uder_asset.check_dt is '复核日期';
comment on column ${iml_schema}.prd_uder_asset.invest_ratio is '投资比例';
comment on column ${iml_schema}.prd_uder_asset.risk_wt is '风险权重';
comment on column ${iml_schema}.prd_uder_asset.rating_rest_cd is '评级结果代码';
comment on column ${iml_schema}.prd_uder_asset.start_dt is '开始时间';
comment on column ${iml_schema}.prd_uder_asset.end_dt is '结束时间';
comment on column ${iml_schema}.prd_uder_asset.id_mark is '增删标志';
comment on column ${iml_schema}.prd_uder_asset.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_uder_asset.job_cd is '任务编码';
comment on column ${iml_schema}.prd_uder_asset.etl_timestamp is 'ETL处理时间戳';
