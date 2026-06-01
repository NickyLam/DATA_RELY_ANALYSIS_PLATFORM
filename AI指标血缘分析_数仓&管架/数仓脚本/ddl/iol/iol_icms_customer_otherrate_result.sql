/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_customer_otherrate_result
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_customer_otherrate_result
whenever sqlerror continue none;
drop table ${iol_schema}.icms_customer_otherrate_result purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_otherrate_result(
    serialno varchar2(32) -- 流水号
    ,customerid varchar2(32) -- 客户号
    ,ratetype varchar2(1) -- 评级类型（1.外部机构评级、2.监管评级/分类评级）
    ,rateenddate date -- 评级失效日
    ,updatetime date -- 更新时间
    ,rateorg varchar2(200) -- 评级机构
    ,ratebegindate date -- 评级生效日
    ,inputdate date -- 登记时间
    ,inputuserid varchar2(32) -- 登记人
    ,inputorgid varchar2(32) -- 登记机构
    ,raterisklevel varchar2(20) -- 评级结果
    ,ratedate date -- 评级日期
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
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
grant select on ${iol_schema}.icms_customer_otherrate_result to ${iml_schema};
grant select on ${iol_schema}.icms_customer_otherrate_result to ${icl_schema};
grant select on ${iol_schema}.icms_customer_otherrate_result to ${idl_schema};
grant select on ${iol_schema}.icms_customer_otherrate_result to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_customer_otherrate_result is '外部评级表';
comment on column ${iol_schema}.icms_customer_otherrate_result.serialno is '流水号';
comment on column ${iol_schema}.icms_customer_otherrate_result.customerid is '客户号';
comment on column ${iol_schema}.icms_customer_otherrate_result.ratetype is '评级类型（1.外部机构评级、2.监管评级/分类评级）';
comment on column ${iol_schema}.icms_customer_otherrate_result.rateenddate is '评级失效日';
comment on column ${iol_schema}.icms_customer_otherrate_result.updatetime is '更新时间';
comment on column ${iol_schema}.icms_customer_otherrate_result.rateorg is '评级机构';
comment on column ${iol_schema}.icms_customer_otherrate_result.ratebegindate is '评级生效日';
comment on column ${iol_schema}.icms_customer_otherrate_result.inputdate is '登记时间';
comment on column ${iol_schema}.icms_customer_otherrate_result.inputuserid is '登记人';
comment on column ${iol_schema}.icms_customer_otherrate_result.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_customer_otherrate_result.raterisklevel is '评级结果';
comment on column ${iol_schema}.icms_customer_otherrate_result.ratedate is '评级日期';
comment on column ${iol_schema}.icms_customer_otherrate_result.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_customer_otherrate_result.start_dt is '开始时间';
comment on column ${iol_schema}.icms_customer_otherrate_result.end_dt is '结束时间';
comment on column ${iol_schema}.icms_customer_otherrate_result.id_mark is '增删标志';
comment on column ${iol_schema}.icms_customer_otherrate_result.etl_timestamp is 'ETL处理时间戳';
