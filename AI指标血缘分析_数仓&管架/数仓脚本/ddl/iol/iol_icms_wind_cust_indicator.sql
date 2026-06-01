/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_wind_cust_indicator
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_wind_cust_indicator
whenever sqlerror continue none;
drop table ${iol_schema}.icms_wind_cust_indicator purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wind_cust_indicator(
    compcode varchar2(40) -- 上市、非上市公司代码
    ,islisted varchar2(10) -- 是否上市
    ,updatedate date -- 更新日期
    ,migtflag varchar2(80) -- 
    ,singlegrouprate number(24,6) -- 单一集团贷款集中度
    ,assetprofitrate number(24,6) -- 资本利润率
    ,coreyicapirate number(24,6) -- 核心一级资本充足率
    ,yicapirate number(24,6) -- 一级资本充足率
    ,leverrate number(24,6) -- 杠杆率
    ,badrate number(24,6) -- 不良贷款率
    ,reportperiod varchar2(8) -- 最新一期监管指标期次
    ,capirate number(24,6) -- 资本充足率
    ,core1jassets number(24,6) -- 核心一级资本净额
    ,updateorgid varchar2(12) -- 更新机构编号
    ,provisionrate number(24,6) -- 不良贷款拨备覆盖率(拨备覆盖率)
    ,inputdate date -- 新增日期
    ,loanprovisionrate number(24,6) -- 贷款拨备率
    ,assetliqrate number(24,6) -- 短期资产流动性比例(人民币)(流动性比例)
    ,assetliqcoverrate number(24,6) -- 流动性覆盖率
    ,attentionrate number(24,6) -- 关注类贷款占比
    ,costincomerate number(24,6) -- 成本收入比
    ,updateuserid varchar2(8) -- 更新员工编号
    ,updateflag varchar2(1) -- 操作标志:A-手动新增U-手动更新
    ,inputuserid varchar2(8) -- 新增员工编号
    ,inputorgid varchar2(12) -- 新增机构编号
    ,compname varchar2(100) -- 公司名称
    ,totalassets varchar2(30) -- 总资产
    ,clearassets varchar2(30) -- 净资产
    ,banktype varchar2(30) -- 银行类型
    ,bankclass varchar2(30) -- 银行性质
    ,province varchar2(100) -- 省份名称
    ,city varchar2(50) -- 城市名称
    ,customerid varchar2(64) -- 关联客户编号
    ,customername varchar2(100) -- 关联客户名称
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
grant select on ${iol_schema}.icms_wind_cust_indicator to ${iml_schema};
grant select on ${iol_schema}.icms_wind_cust_indicator to ${icl_schema};
grant select on ${iol_schema}.icms_wind_cust_indicator to ${idl_schema};
grant select on ${iol_schema}.icms_wind_cust_indicator to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_wind_cust_indicator is '同业主动授信wind客户监管指标';
comment on column ${iol_schema}.icms_wind_cust_indicator.compcode is '上市、非上市公司代码';
comment on column ${iol_schema}.icms_wind_cust_indicator.islisted is '是否上市';
comment on column ${iol_schema}.icms_wind_cust_indicator.updatedate is '更新日期';
comment on column ${iol_schema}.icms_wind_cust_indicator.migtflag is '';
comment on column ${iol_schema}.icms_wind_cust_indicator.singlegrouprate is '单一集团贷款集中度';
comment on column ${iol_schema}.icms_wind_cust_indicator.assetprofitrate is '资本利润率';
comment on column ${iol_schema}.icms_wind_cust_indicator.coreyicapirate is '核心一级资本充足率';
comment on column ${iol_schema}.icms_wind_cust_indicator.yicapirate is '一级资本充足率';
comment on column ${iol_schema}.icms_wind_cust_indicator.leverrate is '杠杆率';
comment on column ${iol_schema}.icms_wind_cust_indicator.badrate is '不良贷款率';
comment on column ${iol_schema}.icms_wind_cust_indicator.reportperiod is '最新一期监管指标期次';
comment on column ${iol_schema}.icms_wind_cust_indicator.capirate is '资本充足率';
comment on column ${iol_schema}.icms_wind_cust_indicator.core1jassets is '核心一级资本净额';
comment on column ${iol_schema}.icms_wind_cust_indicator.updateorgid is '更新机构编号';
comment on column ${iol_schema}.icms_wind_cust_indicator.provisionrate is '不良贷款拨备覆盖率(拨备覆盖率)';
comment on column ${iol_schema}.icms_wind_cust_indicator.inputdate is '新增日期';
comment on column ${iol_schema}.icms_wind_cust_indicator.loanprovisionrate is '贷款拨备率';
comment on column ${iol_schema}.icms_wind_cust_indicator.assetliqrate is '短期资产流动性比例(人民币)(流动性比例)';
comment on column ${iol_schema}.icms_wind_cust_indicator.assetliqcoverrate is '流动性覆盖率';
comment on column ${iol_schema}.icms_wind_cust_indicator.attentionrate is '关注类贷款占比';
comment on column ${iol_schema}.icms_wind_cust_indicator.costincomerate is '成本收入比';
comment on column ${iol_schema}.icms_wind_cust_indicator.updateuserid is '更新员工编号';
comment on column ${iol_schema}.icms_wind_cust_indicator.updateflag is '操作标志:A-手动新增U-手动更新';
comment on column ${iol_schema}.icms_wind_cust_indicator.inputuserid is '新增员工编号';
comment on column ${iol_schema}.icms_wind_cust_indicator.inputorgid is '新增机构编号';
comment on column ${iol_schema}.icms_wind_cust_indicator.compname is '公司名称';
comment on column ${iol_schema}.icms_wind_cust_indicator.totalassets is '总资产';
comment on column ${iol_schema}.icms_wind_cust_indicator.clearassets is '净资产';
comment on column ${iol_schema}.icms_wind_cust_indicator.banktype is '银行类型';
comment on column ${iol_schema}.icms_wind_cust_indicator.bankclass is '银行性质';
comment on column ${iol_schema}.icms_wind_cust_indicator.province is '省份名称';
comment on column ${iol_schema}.icms_wind_cust_indicator.city is '城市名称';
comment on column ${iol_schema}.icms_wind_cust_indicator.customerid is '关联客户编号';
comment on column ${iol_schema}.icms_wind_cust_indicator.customername is '关联客户名称';
comment on column ${iol_schema}.icms_wind_cust_indicator.start_dt is '开始时间';
comment on column ${iol_schema}.icms_wind_cust_indicator.end_dt is '结束时间';
comment on column ${iol_schema}.icms_wind_cust_indicator.id_mark is '增删标志';
comment on column ${iol_schema}.icms_wind_cust_indicator.etl_timestamp is 'ETL处理时间戳';
