/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_eqty_nv_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_eqty_nv_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.prd_eqty_nv_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_eqty_nv_info_h(
    fin_instm_id varchar2(100) -- 金融工具编号
    ,asset_type_id varchar2(100) -- 资产类型编号
    ,market_type_id varchar2(100) -- 市场类型编号
    ,lp_id varchar2(60) -- 法人编号
    ,nv_id varchar2(100) -- 净值编号
    ,tot_nv number(30,8) -- 总净值
    ,corp_nv number(30,8) -- 单位净值
    ,ten_thous_prft_lmt number(30,8) -- 万份收益额
    ,sevn_aual_yld number(30,8) -- 七日年化收益率
    ,imp_dt date -- 导入日期
    ,imp_way_id varchar2(100) -- 导入方式编号
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
grant select on ${iml_schema}.prd_eqty_nv_info_h to ${icl_schema};
grant select on ${iml_schema}.prd_eqty_nv_info_h to ${idl_schema};
grant select on ${iml_schema}.prd_eqty_nv_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_eqty_nv_info_h is '权益类净值信息历史';
comment on column ${iml_schema}.prd_eqty_nv_info_h.fin_instm_id is '金融工具编号';
comment on column ${iml_schema}.prd_eqty_nv_info_h.asset_type_id is '资产类型编号';
comment on column ${iml_schema}.prd_eqty_nv_info_h.market_type_id is '市场类型编号';
comment on column ${iml_schema}.prd_eqty_nv_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.prd_eqty_nv_info_h.nv_id is '净值编号';
comment on column ${iml_schema}.prd_eqty_nv_info_h.tot_nv is '总净值';
comment on column ${iml_schema}.prd_eqty_nv_info_h.corp_nv is '单位净值';
comment on column ${iml_schema}.prd_eqty_nv_info_h.ten_thous_prft_lmt is '万份收益额';
comment on column ${iml_schema}.prd_eqty_nv_info_h.sevn_aual_yld is '七日年化收益率';
comment on column ${iml_schema}.prd_eqty_nv_info_h.imp_dt is '导入日期';
comment on column ${iml_schema}.prd_eqty_nv_info_h.imp_way_id is '导入方式编号';
comment on column ${iml_schema}.prd_eqty_nv_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.prd_eqty_nv_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.prd_eqty_nv_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.prd_eqty_nv_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_eqty_nv_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.prd_eqty_nv_info_h.etl_timestamp is 'ETL处理时间戳';
