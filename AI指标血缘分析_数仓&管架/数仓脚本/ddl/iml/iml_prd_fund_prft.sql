/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_fund_prft
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_fund_prft
whenever sqlerror continue none;
drop table ${iml_schema}.prd_fund_prft purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_fund_prft(
    flow_num varchar2(100) -- 流水号
    ,lp_id varchar2(60) -- 法人编号
    ,fund_id varchar2(100) -- 基金编号
    ,asset_type_id varchar2(100) -- 资产类型编号
    ,market_type_id varchar2(100) -- 市场类型编号
    ,tot_net_price number(38,4) -- 总净价
    ,sevn_aual_yld number(18,8) -- 七日年化收益率
    ,pub_dt date -- 公布日期
    ,prft_start_dt date -- 收益开始日期
    ,prft_end_dt date -- 收益结束日期
    ,imp_tm timestamp -- 导入时间
    ,imp_way_id varchar2(100) -- 导入方式编号
    ,accu_corp_nv number(38,4) -- 累积单位净值
    ,sevn_ten_thous_prft number(30,4) -- 七日万份收益
    ,corp_nv number(30,4) -- 单位净值
    ,fund_size number(38,2) -- 基金规模
    ,fund_tot_lot number(38,2) -- 基金总份额
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
grant select on ${iml_schema}.prd_fund_prft to ${icl_schema};
grant select on ${iml_schema}.prd_fund_prft to ${idl_schema};
grant select on ${iml_schema}.prd_fund_prft to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_fund_prft is '基金收益';
comment on column ${iml_schema}.prd_fund_prft.flow_num is '流水号';
comment on column ${iml_schema}.prd_fund_prft.lp_id is '法人编号';
comment on column ${iml_schema}.prd_fund_prft.fund_id is '基金编号';
comment on column ${iml_schema}.prd_fund_prft.asset_type_id is '资产类型编号';
comment on column ${iml_schema}.prd_fund_prft.market_type_id is '市场类型编号';
comment on column ${iml_schema}.prd_fund_prft.tot_net_price is '总净价';
comment on column ${iml_schema}.prd_fund_prft.sevn_aual_yld is '七日年化收益率';
comment on column ${iml_schema}.prd_fund_prft.pub_dt is '公布日期';
comment on column ${iml_schema}.prd_fund_prft.prft_start_dt is '收益开始日期';
comment on column ${iml_schema}.prd_fund_prft.prft_end_dt is '收益结束日期';
comment on column ${iml_schema}.prd_fund_prft.imp_tm is '导入时间';
comment on column ${iml_schema}.prd_fund_prft.imp_way_id is '导入方式编号';
comment on column ${iml_schema}.prd_fund_prft.accu_corp_nv is '累积单位净值';
comment on column ${iml_schema}.prd_fund_prft.sevn_ten_thous_prft is '七日万份收益';
comment on column ${iml_schema}.prd_fund_prft.corp_nv is '单位净值';
comment on column ${iml_schema}.prd_fund_prft.fund_size is '基金规模';
comment on column ${iml_schema}.prd_fund_prft.fund_tot_lot is '基金总份额';
comment on column ${iml_schema}.prd_fund_prft.create_dt is '创建日期';
comment on column ${iml_schema}.prd_fund_prft.update_dt is '更新日期';
comment on column ${iml_schema}.prd_fund_prft.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.prd_fund_prft.id_mark is '增删标志';
comment on column ${iml_schema}.prd_fund_prft.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_fund_prft.job_cd is '任务编码';
comment on column ${iml_schema}.prd_fund_prft.etl_timestamp is 'ETL处理时间戳';
