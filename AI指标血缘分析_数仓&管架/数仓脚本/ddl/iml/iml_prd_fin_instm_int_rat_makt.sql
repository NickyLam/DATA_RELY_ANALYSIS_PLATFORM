/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_fin_instm_int_rat_makt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_fin_instm_int_rat_makt
whenever sqlerror continue none;
drop table ${iml_schema}.prd_fin_instm_int_rat_makt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_fin_instm_int_rat_makt(
    flow_num varchar2(100) -- 流水号
    ,lp_id varchar2(60) -- 法人编号
    ,fin_instm_id varchar2(100) -- 金融工具编号
    ,asset_type_id varchar2(100) -- 资产类型编号
    ,market_type_id varchar2(100) -- 市场类型编号
    ,close_quot_price number(38,15) -- 收盘价
    ,higt_price number(38,15) -- 最高价
    ,lowt_price number(38,15) -- 最低价
    ,sell_price number(38,15) -- 卖出价
    ,buy_price number(38,15) -- 买入价
    ,mdl_p number(38,15) -- 中间价
    ,effect_dt date -- 生效日期
    ,invalid_dt date -- 失效日期
    ,imp_tm timestamp -- 导入时间
    ,imp_way_id varchar2(100) -- 导入方式编号
    ,data_src_type varchar2(75) -- 数据来源类型
    ,effect_flg varchar2(10) -- 生效标志
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
grant select on ${iml_schema}.prd_fin_instm_int_rat_makt to ${icl_schema};
grant select on ${iml_schema}.prd_fin_instm_int_rat_makt to ${idl_schema};
grant select on ${iml_schema}.prd_fin_instm_int_rat_makt to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_fin_instm_int_rat_makt is '金融工具利率行情';
comment on column ${iml_schema}.prd_fin_instm_int_rat_makt.flow_num is '流水号';
comment on column ${iml_schema}.prd_fin_instm_int_rat_makt.lp_id is '法人编号';
comment on column ${iml_schema}.prd_fin_instm_int_rat_makt.fin_instm_id is '金融工具编号';
comment on column ${iml_schema}.prd_fin_instm_int_rat_makt.asset_type_id is '资产类型编号';
comment on column ${iml_schema}.prd_fin_instm_int_rat_makt.market_type_id is '市场类型编号';
comment on column ${iml_schema}.prd_fin_instm_int_rat_makt.close_quot_price is '收盘价';
comment on column ${iml_schema}.prd_fin_instm_int_rat_makt.higt_price is '最高价';
comment on column ${iml_schema}.prd_fin_instm_int_rat_makt.lowt_price is '最低价';
comment on column ${iml_schema}.prd_fin_instm_int_rat_makt.sell_price is '卖出价';
comment on column ${iml_schema}.prd_fin_instm_int_rat_makt.buy_price is '买入价';
comment on column ${iml_schema}.prd_fin_instm_int_rat_makt.mdl_p is '中间价';
comment on column ${iml_schema}.prd_fin_instm_int_rat_makt.effect_dt is '生效日期';
comment on column ${iml_schema}.prd_fin_instm_int_rat_makt.invalid_dt is '失效日期';
comment on column ${iml_schema}.prd_fin_instm_int_rat_makt.imp_tm is '导入时间';
comment on column ${iml_schema}.prd_fin_instm_int_rat_makt.imp_way_id is '导入方式编号';
comment on column ${iml_schema}.prd_fin_instm_int_rat_makt.data_src_type is '数据来源类型';
comment on column ${iml_schema}.prd_fin_instm_int_rat_makt.effect_flg is '生效标志';
comment on column ${iml_schema}.prd_fin_instm_int_rat_makt.create_dt is '创建日期';
comment on column ${iml_schema}.prd_fin_instm_int_rat_makt.update_dt is '更新日期';
comment on column ${iml_schema}.prd_fin_instm_int_rat_makt.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.prd_fin_instm_int_rat_makt.id_mark is '增删标志';
comment on column ${iml_schema}.prd_fin_instm_int_rat_makt.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_fin_instm_int_rat_makt.job_cd is '任务编码';
comment on column ${iml_schema}.prd_fin_instm_int_rat_makt.etl_timestamp is 'ETL处理时间戳';
