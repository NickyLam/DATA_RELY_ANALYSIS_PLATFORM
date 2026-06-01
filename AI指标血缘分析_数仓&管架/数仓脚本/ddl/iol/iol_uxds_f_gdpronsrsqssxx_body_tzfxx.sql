/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_gdpronsrsqssxx_body_tzfxx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_gdpronsrsqssxx_body_tzfxx
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_gdpronsrsqssxx_body_tzfxx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_gdpronsrsqssxx_body_tzfxx(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,tzfxx varchar2(4000) -- 关联标签
    ,tzfhhhrmc varchar2(4000) -- 投资方（合伙人）名称
    ,tzfhhhrzjzl_dm varchar2(4000) -- 投资方（合伙人）证件种类代码
    ,gjhdqszmc varchar2(4000) -- 国家或地区数字名称
    ,tzfjjxzmc varchar2(4000) -- 投资方经济性质名称
    ,fpbl varchar2(4000) -- 分配比例
    ,tzje varchar2(4000) -- 投资金额
    ,uuid varchar2(4000) -- 唯一主键
    ,yxqq varchar2(4000) -- 有效期起
    ,tzfhhhrzjzlmc varchar2(4000) -- 投资方（合伙人）证件种类名称
    ,tzbl varchar2(4000) -- 投资比例
    ,dz varchar2(4000) -- 地址
    ,yxqz varchar2(4000) -- 有效期止
    ,tzfjjxz_dm varchar2(4000) -- 投资方经济性质代码
    ,tzfhhhrzjhm varchar2(4000) -- 投资方（合伙人）证件号码
    ,tzfhhrdjxh varchar2(4000) -- 投资方（合伙人）登记序号
    ,djxh varchar2(4000) -- 登记序号
    ,gjhdqsz_dm varchar2(4000) -- 国家或地区数字代码
    ,genmonth varchar2(4000) -- 
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.uxds_f_gdpronsrsqssxx_body_tzfxx to ${iml_schema};
grant select on ${iol_schema}.uxds_f_gdpronsrsqssxx_body_tzfxx to ${icl_schema};
grant select on ${iol_schema}.uxds_f_gdpronsrsqssxx_body_tzfxx to ${idl_schema};
grant select on ${iol_schema}.uxds_f_gdpronsrsqssxx_body_tzfxx to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_gdpronsrsqssxx_body_tzfxx is 'gdProNsrSqSsxx_body_TZFXX';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_tzfxx.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_tzfxx.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_tzfxx.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_tzfxx.tzfxx is '关联标签';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_tzfxx.tzfhhhrmc is '投资方（合伙人）名称';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_tzfxx.tzfhhhrzjzl_dm is '投资方（合伙人）证件种类代码';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_tzfxx.gjhdqszmc is '国家或地区数字名称';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_tzfxx.tzfjjxzmc is '投资方经济性质名称';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_tzfxx.fpbl is '分配比例';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_tzfxx.tzje is '投资金额';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_tzfxx.uuid is '唯一主键';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_tzfxx.yxqq is '有效期起';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_tzfxx.tzfhhhrzjzlmc is '投资方（合伙人）证件种类名称';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_tzfxx.tzbl is '投资比例';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_tzfxx.dz is '地址';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_tzfxx.yxqz is '有效期止';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_tzfxx.tzfjjxz_dm is '投资方经济性质代码';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_tzfxx.tzfhhhrzjhm is '投资方（合伙人）证件号码';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_tzfxx.tzfhhrdjxh is '投资方（合伙人）登记序号';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_tzfxx.djxh is '登记序号';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_tzfxx.gjhdqsz_dm is '国家或地区数字代码';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_tzfxx.genmonth is '';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_tzfxx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_tzfxx.etl_timestamp is 'ETL处理时间戳';
