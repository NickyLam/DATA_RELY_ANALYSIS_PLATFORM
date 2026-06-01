/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_wind_cust_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_wind_cust_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_wind_cust_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wind_cust_info(
    compcode varchar2(30) -- 上市、非上市公司代码
    ,islisted varchar2(10) -- 是否上市
    ,totalassets number(24,6) -- 资产合计
    ,inputuserid varchar2(8) -- 新增员工编号
    ,registercapital number(24,6) -- 注册资本
    ,totalrights number(24,6) -- 所有者权益合计
    ,inputdate varchar2(10) -- 新增日期
    ,updateuserid varchar2(8) -- 更新员工编号
    ,country varchar2(20) -- 国家名称
    ,registarea varchar2(40) -- 注册区域
    ,banktype varchar2(10) -- 银行类型:national-全国性的local-地区性的
    ,city varchar2(40) -- 城市名称
    ,customername varchar2(100) -- 关联客户名称
    ,bankclass varchar2(10) -- 银行性质:国有银行/政策银行/邮储银行/上市全国股份制银行/上市非全国性股份制银行/城商行/农商行
    ,updateorgid varchar2(12) -- 更新机构编号
    ,migtflag varchar2(80) -- 
    ,province varchar2(40) -- 省份名称
    ,reportperiod varchar2(8) -- 最新一期资产负债表合并报表
    ,sharecode varchar2(40) -- 上市代码
    ,updatedate date -- 更新日期
    ,updateflag varchar2(1) -- 操作标志:A-手动新增U-手动更新
    ,customerid varchar2(48) -- 关联客户编号
    ,clearassets number(24,6) -- 净资产
    ,outdate date -- 退出日期
    ,compname varchar2(100) -- 公司名称
    ,inputorgid varchar2(12) -- 新增机构编号
    ,addflag varchar2(1) -- 新增标志：A-人工新增
    ,givencreditlimit number(24,6) -- 他行给我行的授信额度
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
grant select on ${iol_schema}.icms_wind_cust_info to ${iml_schema};
grant select on ${iol_schema}.icms_wind_cust_info to ${icl_schema};
grant select on ${iol_schema}.icms_wind_cust_info to ${idl_schema};
grant select on ${iol_schema}.icms_wind_cust_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_wind_cust_info is '同业主动授信wind客户清单';
comment on column ${iol_schema}.icms_wind_cust_info.compcode is '上市、非上市公司代码';
comment on column ${iol_schema}.icms_wind_cust_info.islisted is '是否上市';
comment on column ${iol_schema}.icms_wind_cust_info.totalassets is '资产合计';
comment on column ${iol_schema}.icms_wind_cust_info.inputuserid is '新增员工编号';
comment on column ${iol_schema}.icms_wind_cust_info.registercapital is '注册资本';
comment on column ${iol_schema}.icms_wind_cust_info.totalrights is '所有者权益合计';
comment on column ${iol_schema}.icms_wind_cust_info.inputdate is '新增日期';
comment on column ${iol_schema}.icms_wind_cust_info.updateuserid is '更新员工编号';
comment on column ${iol_schema}.icms_wind_cust_info.country is '国家名称';
comment on column ${iol_schema}.icms_wind_cust_info.registarea is '注册区域';
comment on column ${iol_schema}.icms_wind_cust_info.banktype is '银行类型:national-全国性的local-地区性的';
comment on column ${iol_schema}.icms_wind_cust_info.city is '城市名称';
comment on column ${iol_schema}.icms_wind_cust_info.customername is '关联客户名称';
comment on column ${iol_schema}.icms_wind_cust_info.bankclass is '银行性质:国有银行/政策银行/邮储银行/上市全国股份制银行/上市非全国性股份制银行/城商行/农商行';
comment on column ${iol_schema}.icms_wind_cust_info.updateorgid is '更新机构编号';
comment on column ${iol_schema}.icms_wind_cust_info.migtflag is '';
comment on column ${iol_schema}.icms_wind_cust_info.province is '省份名称';
comment on column ${iol_schema}.icms_wind_cust_info.reportperiod is '最新一期资产负债表合并报表';
comment on column ${iol_schema}.icms_wind_cust_info.sharecode is '上市代码';
comment on column ${iol_schema}.icms_wind_cust_info.updatedate is '更新日期';
comment on column ${iol_schema}.icms_wind_cust_info.updateflag is '操作标志:A-手动新增U-手动更新';
comment on column ${iol_schema}.icms_wind_cust_info.customerid is '关联客户编号';
comment on column ${iol_schema}.icms_wind_cust_info.clearassets is '净资产';
comment on column ${iol_schema}.icms_wind_cust_info.outdate is '退出日期';
comment on column ${iol_schema}.icms_wind_cust_info.compname is '公司名称';
comment on column ${iol_schema}.icms_wind_cust_info.inputorgid is '新增机构编号';
comment on column ${iol_schema}.icms_wind_cust_info.addflag is '新增标志：A-人工新增';
comment on column ${iol_schema}.icms_wind_cust_info.givencreditlimit is '他行给我行的授信额度';
comment on column ${iol_schema}.icms_wind_cust_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_wind_cust_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_wind_cust_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_wind_cust_info.etl_timestamp is 'ETL处理时间戳';
