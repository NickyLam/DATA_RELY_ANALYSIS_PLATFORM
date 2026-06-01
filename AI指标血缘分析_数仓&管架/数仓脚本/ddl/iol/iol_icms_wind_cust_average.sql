/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_wind_cust_average
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_wind_cust_average
whenever sqlerror continue none;
drop table ${iol_schema}.icms_wind_cust_average purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wind_cust_average(
    serialno varchar2(40) -- 流水号
    ,badrateave number(24,6) -- 不良贷款率
    ,recordcount number(22) -- 均值计算样本记录数
    ,updatedate date -- 更新日期
    ,updateorgid varchar2(20) -- 更新机构
    ,loanprovisionrateave number(24,6) -- 贷款拨备率
    ,costincomerateave number(24,6) -- 成本收入比
    ,yicapirateave number(24,6) -- 一级资本充足率
    ,assetliqcoverrateave number(24,6) -- 流动性覆盖率
    ,assetprofitrateave number(24,6) -- 资本利润率
    ,attentionrateave number(24,6) -- 关注类贷款占比
    ,capirateave number(24,6) -- 资本充足率
    ,inputorgid varchar2(16) -- 新增机构编号
    ,assetliqrateave number(24,6) -- 流动性比例)
    ,migtflag varchar2(80) -- 
    ,inputdate date -- 新增日期
    ,inputuserid varchar2(8) -- 新增员工编号
    ,coreyicapirateave number(24,6) -- 核心一级资本充足率
    ,provisionrateave number(24,6) -- 拨备覆盖率
    ,leverrateave number(24,6) -- 杠杆率
    ,singlegrouprateave number(24,6) -- 单一集团贷款集中度
    ,updateuserid varchar2(8) -- 更新人
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
grant select on ${iol_schema}.icms_wind_cust_average to ${iml_schema};
grant select on ${iol_schema}.icms_wind_cust_average to ${icl_schema};
grant select on ${iol_schema}.icms_wind_cust_average to ${idl_schema};
grant select on ${iol_schema}.icms_wind_cust_average to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_wind_cust_average is '同业主动授信wind客户行业均值';
comment on column ${iol_schema}.icms_wind_cust_average.serialno is '流水号';
comment on column ${iol_schema}.icms_wind_cust_average.badrateave is '不良贷款率';
comment on column ${iol_schema}.icms_wind_cust_average.recordcount is '均值计算样本记录数';
comment on column ${iol_schema}.icms_wind_cust_average.updatedate is '更新日期';
comment on column ${iol_schema}.icms_wind_cust_average.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_wind_cust_average.loanprovisionrateave is '贷款拨备率';
comment on column ${iol_schema}.icms_wind_cust_average.costincomerateave is '成本收入比';
comment on column ${iol_schema}.icms_wind_cust_average.yicapirateave is '一级资本充足率';
comment on column ${iol_schema}.icms_wind_cust_average.assetliqcoverrateave is '流动性覆盖率';
comment on column ${iol_schema}.icms_wind_cust_average.assetprofitrateave is '资本利润率';
comment on column ${iol_schema}.icms_wind_cust_average.attentionrateave is '关注类贷款占比';
comment on column ${iol_schema}.icms_wind_cust_average.capirateave is '资本充足率';
comment on column ${iol_schema}.icms_wind_cust_average.inputorgid is '新增机构编号';
comment on column ${iol_schema}.icms_wind_cust_average.assetliqrateave is '流动性比例)';
comment on column ${iol_schema}.icms_wind_cust_average.migtflag is '';
comment on column ${iol_schema}.icms_wind_cust_average.inputdate is '新增日期';
comment on column ${iol_schema}.icms_wind_cust_average.inputuserid is '新增员工编号';
comment on column ${iol_schema}.icms_wind_cust_average.coreyicapirateave is '核心一级资本充足率';
comment on column ${iol_schema}.icms_wind_cust_average.provisionrateave is '拨备覆盖率';
comment on column ${iol_schema}.icms_wind_cust_average.leverrateave is '杠杆率';
comment on column ${iol_schema}.icms_wind_cust_average.singlegrouprateave is '单一集团贷款集中度';
comment on column ${iol_schema}.icms_wind_cust_average.updateuserid is '更新人';
comment on column ${iol_schema}.icms_wind_cust_average.start_dt is '开始时间';
comment on column ${iol_schema}.icms_wind_cust_average.end_dt is '结束时间';
comment on column ${iol_schema}.icms_wind_cust_average.id_mark is '增删标志';
comment on column ${iol_schema}.icms_wind_cust_average.etl_timestamp is 'ETL处理时间戳';
