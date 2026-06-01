/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_sxd_company_tzfxx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_sxd_company_tzfxx
whenever sqlerror continue none;
drop table ${iol_schema}.icms_sxd_company_tzfxx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_sxd_company_tzfxx(
    id varchar2(32) -- 主键
    ,yxqz date -- 有效期止
    ,zjhm varchar2(60) -- 证件号码
    ,zj_mc varchar2(2) -- 证件类型
    ,tzje number(22,8) -- 投资金额
    ,yxqq date -- 有效期起
    ,serno varchar2(32) -- 业务流水号
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,tzbl number(11,8) -- 投资比例
    ,tzfmc varchar2(300) -- 投资方名称
    ,tzfjjxz_mc varchar2(100) -- 投资方经济性质名称
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
grant select on ${iol_schema}.icms_sxd_company_tzfxx to ${iml_schema};
grant select on ${iol_schema}.icms_sxd_company_tzfxx to ${icl_schema};
grant select on ${iol_schema}.icms_sxd_company_tzfxx to ${idl_schema};
grant select on ${iol_schema}.icms_sxd_company_tzfxx to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_sxd_company_tzfxx is '税兴贷企业纳税申报数据';
comment on column ${iol_schema}.icms_sxd_company_tzfxx.id is '主键';
comment on column ${iol_schema}.icms_sxd_company_tzfxx.yxqz is '有效期止';
comment on column ${iol_schema}.icms_sxd_company_tzfxx.zjhm is '证件号码';
comment on column ${iol_schema}.icms_sxd_company_tzfxx.zj_mc is '证件类型';
comment on column ${iol_schema}.icms_sxd_company_tzfxx.tzje is '投资金额';
comment on column ${iol_schema}.icms_sxd_company_tzfxx.yxqq is '有效期起';
comment on column ${iol_schema}.icms_sxd_company_tzfxx.serno is '业务流水号';
comment on column ${iol_schema}.icms_sxd_company_tzfxx.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_sxd_company_tzfxx.tzbl is '投资比例';
comment on column ${iol_schema}.icms_sxd_company_tzfxx.tzfmc is '投资方名称';
comment on column ${iol_schema}.icms_sxd_company_tzfxx.tzfjjxz_mc is '投资方经济性质名称';
comment on column ${iol_schema}.icms_sxd_company_tzfxx.start_dt is '开始时间';
comment on column ${iol_schema}.icms_sxd_company_tzfxx.end_dt is '结束时间';
comment on column ${iol_schema}.icms_sxd_company_tzfxx.id_mark is '增删标志';
comment on column ${iol_schema}.icms_sxd_company_tzfxx.etl_timestamp is 'ETL处理时间戳';
