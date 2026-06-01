/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_fin_rate_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_fin_rate_info
whenever sqlerror continue none;
drop table ${iol_schema}.fams_fin_rate_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_fin_rate_info(
    cash_id varchar2(100) -- 现金流代码
    ,eff_date date -- 生效日
    ,int_type varchar2(50) -- 利率类型
    ,basis varchar2(50) -- 计息基础，a/360，a/365等
    ,reset_type varchar2(50) -- 重置类型，基准利率变动后固定间隔生效、付息后下一计息期生效
    ,reset_freq varchar2(50) -- 重置频率，针对固定频率重置，目前无
    ,first_reset_date date -- 首次重置日，针对固定频率重置，目前无
    ,reset_date varchar2(200) -- 指定重置日期，针对指定日期重置，目前无
    ,observe_bef_day number(20) -- 提前观察数量，所有重置类型都有
    ,observe_bef_unit varchar2(50) -- 提前观察单位，自然日、工作日、自然月等
    ,rate number(30,14) -- 初始利率
    ,coefficient number(30,14) -- 系数
    ,spread_rate number(30,14) -- 利差
    ,highest_rate number(15,8) -- 利率上限
    ,lowest_rate number(15,8) -- 利率下限
    ,benchmark_id varchar2(32) -- 基准编号
    ,benchmark_type varchar2(50) -- 基准类型，复合基准、利率行情、指数行情、曲线
    ,finprod_id varchar2(50) -- 金融产品代码
    ,branch number(10) -- 分支序号
    ,finprod_type varchar2(50) -- 金融产品类型（估值核算），债券、理财产品、基金、理财产品模板、理财产品分层
    ,finprod_type2 varchar2(50) -- 金融产品类型（投管分类），债券、理财产品、基金、理财产品模板、理财产品分层
    ,remark varchar2(1000) -- 备注
    ,create_user varchar2(20) -- 创建人
    ,create_dept varchar2(32) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(20) -- 更新人
    ,update_time timestamp -- 更新时间
    ,first_confirm_date date -- 首期利率确定日
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.fams_fin_rate_info to ${iml_schema};
grant select on ${iol_schema}.fams_fin_rate_info to ${icl_schema};
grant select on ${iol_schema}.fams_fin_rate_info to ${idl_schema};
grant select on ${iol_schema}.fams_fin_rate_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_fin_rate_info is '现金流利率信息表';
comment on column ${iol_schema}.fams_fin_rate_info.cash_id is '现金流代码';
comment on column ${iol_schema}.fams_fin_rate_info.eff_date is '生效日';
comment on column ${iol_schema}.fams_fin_rate_info.int_type is '利率类型';
comment on column ${iol_schema}.fams_fin_rate_info.basis is '计息基础，a/360，a/365等';
comment on column ${iol_schema}.fams_fin_rate_info.reset_type is '重置类型，基准利率变动后固定间隔生效、付息后下一计息期生效';
comment on column ${iol_schema}.fams_fin_rate_info.reset_freq is '重置频率，针对固定频率重置，目前无';
comment on column ${iol_schema}.fams_fin_rate_info.first_reset_date is '首次重置日，针对固定频率重置，目前无';
comment on column ${iol_schema}.fams_fin_rate_info.reset_date is '指定重置日期，针对指定日期重置，目前无';
comment on column ${iol_schema}.fams_fin_rate_info.observe_bef_day is '提前观察数量，所有重置类型都有';
comment on column ${iol_schema}.fams_fin_rate_info.observe_bef_unit is '提前观察单位，自然日、工作日、自然月等';
comment on column ${iol_schema}.fams_fin_rate_info.rate is '初始利率';
comment on column ${iol_schema}.fams_fin_rate_info.coefficient is '系数';
comment on column ${iol_schema}.fams_fin_rate_info.spread_rate is '利差';
comment on column ${iol_schema}.fams_fin_rate_info.highest_rate is '利率上限';
comment on column ${iol_schema}.fams_fin_rate_info.lowest_rate is '利率下限';
comment on column ${iol_schema}.fams_fin_rate_info.benchmark_id is '基准编号';
comment on column ${iol_schema}.fams_fin_rate_info.benchmark_type is '基准类型，复合基准、利率行情、指数行情、曲线';
comment on column ${iol_schema}.fams_fin_rate_info.finprod_id is '金融产品代码';
comment on column ${iol_schema}.fams_fin_rate_info.branch is '分支序号';
comment on column ${iol_schema}.fams_fin_rate_info.finprod_type is '金融产品类型（估值核算），债券、理财产品、基金、理财产品模板、理财产品分层';
comment on column ${iol_schema}.fams_fin_rate_info.finprod_type2 is '金融产品类型（投管分类），债券、理财产品、基金、理财产品模板、理财产品分层';
comment on column ${iol_schema}.fams_fin_rate_info.remark is '备注';
comment on column ${iol_schema}.fams_fin_rate_info.create_user is '创建人';
comment on column ${iol_schema}.fams_fin_rate_info.create_dept is '创建部门';
comment on column ${iol_schema}.fams_fin_rate_info.create_time is '创建时间';
comment on column ${iol_schema}.fams_fin_rate_info.update_user is '更新人';
comment on column ${iol_schema}.fams_fin_rate_info.update_time is '更新时间';
comment on column ${iol_schema}.fams_fin_rate_info.first_confirm_date is '首期利率确定日';
comment on column ${iol_schema}.fams_fin_rate_info.start_dt is '开始时间';
comment on column ${iol_schema}.fams_fin_rate_info.end_dt is '结束时间';
comment on column ${iol_schema}.fams_fin_rate_info.id_mark is '增删标志';
comment on column ${iol_schema}.fams_fin_rate_info.etl_timestamp is 'ETL处理时间戳';
