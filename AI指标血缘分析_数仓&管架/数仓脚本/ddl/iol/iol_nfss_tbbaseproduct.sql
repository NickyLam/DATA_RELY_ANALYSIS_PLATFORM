/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nfss_tbbaseproduct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nfss_tbbaseproduct
whenever sqlerror continue none;
drop table ${iol_schema}.nfss_tbbaseproduct purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_tbbaseproduct(
    prd_code varchar2(48) -- 产品代码
    ,prd_name varchar2(375) -- 产品名称
    ,prd_manager varchar2(27) -- 产品管理人代码
    ,manager_name varchar2(375) -- 产品管理人姓名
    ,nav number(18,8) -- 单位净值
    ,risk_level number(38) -- 风险级别:风险等级 [k_khfxdj] k_khfxdj	客户风险等级	0	未评定	0	0 k_khfxdj	客户风险等级	1	低风险	0	0 k_khfxdj	客户风险等级	2	中低风险	0	0 k_khfxdj	客户风险等级	3	中风险	0	0 k_khfxdj	客户风险等级	4	中高风险	0	0 k_khfxdj	客户风险等级	5	高风险	0	0
    ,prd_status varchar2(2) -- 产品状态:确认日期的状态  *：准备期  0：认购期  1：正常开放  3：暂停赎回  4：暂停申购  5：暂停交易  6：基金终止  9：发行失败
    ,open_time number(38) -- 开市时间
    ,close_time number(38) -- 闭市时间
    ,pmax_accu_amt number(18,2) -- 个人单户累计最大购买金额
    ,pdaily_red_maxvol number(18,3) -- 个人单日单户赎回份额上限
    ,ta_code varchar2(27) -- ta代码
    ,yield number(18,8) -- 七日年化收益率
    ,income_unit number(22,12) -- 万份收益
    ,prd_type varchar2(2) -- 产品类型:1-基金
    ,remark1 varchar2(375) -- 备用字段1
    ,remark2 varchar2(375) -- 备用字段2
    ,remark3 varchar2(375) -- 备用字段3
    ,integer1 number(38) -- 备用整型1
    ,integer2 number(38) -- 备用整型2
    ,double1 number(22,8) -- 扩展浮点数1
    ,double2 number(22,8) -- 备用double2
    ,double3 number(22,8) -- 备用double3
    ,prd_flag varchar2(2) -- 产品标志
    ,iss_date number(38) -- 发布日期
    ,nav_date number(38) -- 净值日期
    ,clt_rapid_pmaxvol number(18,2) -- 个人单日单户实时赎回金额
    ,daily_buy_pmaxvol number(18,2) -- 个人当日累计最大购买
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
grant select on ${iol_schema}.nfss_tbbaseproduct to ${iml_schema};
grant select on ${iol_schema}.nfss_tbbaseproduct to ${icl_schema};
grant select on ${iol_schema}.nfss_tbbaseproduct to ${idl_schema};
grant select on ${iol_schema}.nfss_tbbaseproduct to ${iel_schema};

-- comment
comment on table ${iol_schema}.nfss_tbbaseproduct is '子产品表';
comment on column ${iol_schema}.nfss_tbbaseproduct.prd_code is '产品代码';
comment on column ${iol_schema}.nfss_tbbaseproduct.prd_name is '产品名称';
comment on column ${iol_schema}.nfss_tbbaseproduct.prd_manager is '产品管理人代码';
comment on column ${iol_schema}.nfss_tbbaseproduct.manager_name is '产品管理人姓名';
comment on column ${iol_schema}.nfss_tbbaseproduct.nav is '单位净值';
comment on column ${iol_schema}.nfss_tbbaseproduct.risk_level is '风险级别:风险等级 [k_khfxdj] k_khfxdj	客户风险等级	0	未评定	0	0 k_khfxdj	客户风险等级	1	低风险	0	0 k_khfxdj	客户风险等级	2	中低风险	0	0 k_khfxdj	客户风险等级	3	中风险	0	0 k_khfxdj	客户风险等级	4	中高风险	0	0 k_khfxdj	客户风险等级	5	高风险	0	0';
comment on column ${iol_schema}.nfss_tbbaseproduct.prd_status is '产品状态:确认日期的状态  *：准备期  0：认购期  1：正常开放  3：暂停赎回  4：暂停申购  5：暂停交易  6：基金终止  9：发行失败';
comment on column ${iol_schema}.nfss_tbbaseproduct.open_time is '开市时间';
comment on column ${iol_schema}.nfss_tbbaseproduct.close_time is '闭市时间';
comment on column ${iol_schema}.nfss_tbbaseproduct.pmax_accu_amt is '个人单户累计最大购买金额';
comment on column ${iol_schema}.nfss_tbbaseproduct.pdaily_red_maxvol is '个人单日单户赎回份额上限';
comment on column ${iol_schema}.nfss_tbbaseproduct.ta_code is 'ta代码';
comment on column ${iol_schema}.nfss_tbbaseproduct.yield is '七日年化收益率';
comment on column ${iol_schema}.nfss_tbbaseproduct.income_unit is '万份收益';
comment on column ${iol_schema}.nfss_tbbaseproduct.prd_type is '产品类型:1-基金';
comment on column ${iol_schema}.nfss_tbbaseproduct.remark1 is '备用字段1';
comment on column ${iol_schema}.nfss_tbbaseproduct.remark2 is '备用字段2';
comment on column ${iol_schema}.nfss_tbbaseproduct.remark3 is '备用字段3';
comment on column ${iol_schema}.nfss_tbbaseproduct.integer1 is '备用整型1';
comment on column ${iol_schema}.nfss_tbbaseproduct.integer2 is '备用整型2';
comment on column ${iol_schema}.nfss_tbbaseproduct.double1 is '扩展浮点数1';
comment on column ${iol_schema}.nfss_tbbaseproduct.double2 is '备用double2';
comment on column ${iol_schema}.nfss_tbbaseproduct.double3 is '备用double3';
comment on column ${iol_schema}.nfss_tbbaseproduct.prd_flag is '产品标志';
comment on column ${iol_schema}.nfss_tbbaseproduct.iss_date is '发布日期';
comment on column ${iol_schema}.nfss_tbbaseproduct.nav_date is '净值日期';
comment on column ${iol_schema}.nfss_tbbaseproduct.clt_rapid_pmaxvol is '个人单日单户实时赎回金额';
comment on column ${iol_schema}.nfss_tbbaseproduct.daily_buy_pmaxvol is '个人当日累计最大购买';
comment on column ${iol_schema}.nfss_tbbaseproduct.start_dt is '开始时间';
comment on column ${iol_schema}.nfss_tbbaseproduct.end_dt is '结束时间';
comment on column ${iol_schema}.nfss_tbbaseproduct.id_mark is '增删标志';
comment on column ${iol_schema}.nfss_tbbaseproduct.etl_timestamp is 'ETL处理时间戳';
