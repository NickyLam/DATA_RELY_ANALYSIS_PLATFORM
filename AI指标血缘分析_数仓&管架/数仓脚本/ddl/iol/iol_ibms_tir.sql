/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_tir
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_tir
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_tir purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_tir(
    i_code varchar2(150) -- 金融工具代码
    ,a_type varchar2(30) -- 资产类型
    ,m_type varchar2(30) -- 市场类型
    ,currency varchar2(5) -- 国家
    ,q_type varchar2(3) -- 报价方式
    ,r_daycount varchar2(45) -- 计息基准
    ,r_name varchar2(450) -- 名称
    ,r_term varchar2(9) -- 期限
    ,imp_date varchar2(15) -- 导入日期
    ,pipe_id number(22) -- 导入管道
    ,r_names_match varchar2(300) -- 名字匹配
    ,chinesespell varchar2(75) -- 中文简写
    ,settle_days number(22) -- 结算日偏移天数
    ,settle_bizday_conv varchar2(45) -- 结算日偏移规则
    ,fixing_days number(22) -- 定盘日偏移天数
    ,fixing_bizday_conv varchar2(45) -- 定盘日偏移规则
    ,quote_scale number(22) -- 报价精度
    ,imp_time varchar2(29) -- 导入时间
    ,r_extsys_name varchar2(75) -- 外部名称
    ,country varchar2(3) -- 国家
    ,p_class varchar2(90) -- 产品分类
    ,p_type varchar2(45) -- 产品类型
    ,acc_bizday_conv varchar2(30) -- 计息调整规则
    ,endofmonth varchar2(2) -- 月末规则，0：不是；1：是
    ,mm_index varchar2(2) -- 是否货币市场基准，0：不是；1：是
    ,s_type varchar2(45) -- 标准类型
    ,fixing_calendar varchar2(30) -- 定盘日历
    ,financial_center_calendar varchar2(150) -- 交易中心日历
    ,financial_center varchar2(150) -- 交易中心
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
grant select on ${iol_schema}.ibms_tir to ${iml_schema};
grant select on ${iol_schema}.ibms_tir to ${icl_schema};
grant select on ${iol_schema}.ibms_tir to ${idl_schema};
grant select on ${iol_schema}.ibms_tir to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_tir is '基准利率表';
comment on column ${iol_schema}.ibms_tir.i_code is '金融工具代码';
comment on column ${iol_schema}.ibms_tir.a_type is '资产类型';
comment on column ${iol_schema}.ibms_tir.m_type is '市场类型';
comment on column ${iol_schema}.ibms_tir.currency is '国家';
comment on column ${iol_schema}.ibms_tir.q_type is '报价方式';
comment on column ${iol_schema}.ibms_tir.r_daycount is '计息基准';
comment on column ${iol_schema}.ibms_tir.r_name is '名称';
comment on column ${iol_schema}.ibms_tir.r_term is '期限';
comment on column ${iol_schema}.ibms_tir.imp_date is '导入日期';
comment on column ${iol_schema}.ibms_tir.pipe_id is '导入管道';
comment on column ${iol_schema}.ibms_tir.r_names_match is '名字匹配';
comment on column ${iol_schema}.ibms_tir.chinesespell is '中文简写';
comment on column ${iol_schema}.ibms_tir.settle_days is '结算日偏移天数';
comment on column ${iol_schema}.ibms_tir.settle_bizday_conv is '结算日偏移规则';
comment on column ${iol_schema}.ibms_tir.fixing_days is '定盘日偏移天数';
comment on column ${iol_schema}.ibms_tir.fixing_bizday_conv is '定盘日偏移规则';
comment on column ${iol_schema}.ibms_tir.quote_scale is '报价精度';
comment on column ${iol_schema}.ibms_tir.imp_time is '导入时间';
comment on column ${iol_schema}.ibms_tir.r_extsys_name is '外部名称';
comment on column ${iol_schema}.ibms_tir.country is '国家';
comment on column ${iol_schema}.ibms_tir.p_class is '产品分类';
comment on column ${iol_schema}.ibms_tir.p_type is '产品类型';
comment on column ${iol_schema}.ibms_tir.acc_bizday_conv is '计息调整规则';
comment on column ${iol_schema}.ibms_tir.endofmonth is '月末规则，0：不是；1：是';
comment on column ${iol_schema}.ibms_tir.mm_index is '是否货币市场基准，0：不是；1：是';
comment on column ${iol_schema}.ibms_tir.s_type is '标准类型';
comment on column ${iol_schema}.ibms_tir.fixing_calendar is '定盘日历';
comment on column ${iol_schema}.ibms_tir.financial_center_calendar is '交易中心日历';
comment on column ${iol_schema}.ibms_tir.financial_center is '交易中心';
comment on column ${iol_schema}.ibms_tir.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_tir.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_tir.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_tir.etl_timestamp is 'ETL处理时间戳';
