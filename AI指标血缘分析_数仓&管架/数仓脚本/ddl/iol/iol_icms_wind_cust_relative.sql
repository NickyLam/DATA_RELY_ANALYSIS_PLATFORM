/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_wind_cust_relative
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_wind_cust_relative
whenever sqlerror continue none;
drop table ${iol_schema}.icms_wind_cust_relative purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wind_cust_relative(
    serialno varchar2(40) -- 流水号
    ,relationship varchar2(20) -- 关联人类型:dongs-0董事长、dongs-1董事、hangs-0行长、gudong-0股东
    ,relpost varchar2(40) -- wind关联人担任职务
    ,migtflag varchar2(80) -- 
    ,inputdate date -- 新增日期
    ,inputuserid varchar2(8) -- 新增员工编号
    ,islisted varchar2(10) -- 是否上市公司
    ,updatedate date -- 更新日期
    ,introduction varchar2(3000) -- 简历
    ,holdrate number(24,6) -- 股东持股比率
    ,updateuserid varchar2(8) -- 更新员工编号
    ,relname varchar2(100) -- 关联人名称
    ,enddate date -- 持股截止日期
    ,inputorgid varchar2(12) -- 新增机构编号
    ,compcode varchar2(40) -- 公司代码
    ,updateorgid varchar2(12) -- 更新机构编号
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
grant select on ${iol_schema}.icms_wind_cust_relative to ${iml_schema};
grant select on ${iol_schema}.icms_wind_cust_relative to ${icl_schema};
grant select on ${iol_schema}.icms_wind_cust_relative to ${idl_schema};
grant select on ${iol_schema}.icms_wind_cust_relative to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_wind_cust_relative is '同业主动授信wind客户关联人信息';
comment on column ${iol_schema}.icms_wind_cust_relative.serialno is '流水号';
comment on column ${iol_schema}.icms_wind_cust_relative.relationship is '关联人类型:dongs-0董事长、dongs-1董事、hangs-0行长、gudong-0股东';
comment on column ${iol_schema}.icms_wind_cust_relative.relpost is 'wind关联人担任职务';
comment on column ${iol_schema}.icms_wind_cust_relative.migtflag is '';
comment on column ${iol_schema}.icms_wind_cust_relative.inputdate is '新增日期';
comment on column ${iol_schema}.icms_wind_cust_relative.inputuserid is '新增员工编号';
comment on column ${iol_schema}.icms_wind_cust_relative.islisted is '是否上市公司';
comment on column ${iol_schema}.icms_wind_cust_relative.updatedate is '更新日期';
comment on column ${iol_schema}.icms_wind_cust_relative.introduction is '简历';
comment on column ${iol_schema}.icms_wind_cust_relative.holdrate is '股东持股比率';
comment on column ${iol_schema}.icms_wind_cust_relative.updateuserid is '更新员工编号';
comment on column ${iol_schema}.icms_wind_cust_relative.relname is '关联人名称';
comment on column ${iol_schema}.icms_wind_cust_relative.enddate is '持股截止日期';
comment on column ${iol_schema}.icms_wind_cust_relative.inputorgid is '新增机构编号';
comment on column ${iol_schema}.icms_wind_cust_relative.compcode is '公司代码';
comment on column ${iol_schema}.icms_wind_cust_relative.updateorgid is '更新机构编号';
comment on column ${iol_schema}.icms_wind_cust_relative.start_dt is '开始时间';
comment on column ${iol_schema}.icms_wind_cust_relative.end_dt is '结束时间';
comment on column ${iol_schema}.icms_wind_cust_relative.id_mark is '增删标志';
comment on column ${iol_schema}.icms_wind_cust_relative.etl_timestamp is 'ETL处理时间戳';
