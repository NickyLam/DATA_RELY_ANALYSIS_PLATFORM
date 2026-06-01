/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rwas_bis_sa_country
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rwas_bis_sa_country
whenever sqlerror continue none;
drop table ${iol_schema}.rwas_bis_sa_country purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rwas_bis_sa_country(
    ser_num number(22) -- 序号
    ,bis_country_cd varchar2(20) -- 计量注册国家代码
    ,bis_country_name varchar2(200) -- 注册国名称
    ,spc_rating_no number -- 评级序号
    ,spc_rating_cd varchar2(20) -- 标普评级代码
    ,car_regul_requir number(18,6) -- 当地监管资本充足率要求
    ,tier1_car_regul_requir number(18,6) -- 当地监管一级资本充足率要求
    ,core_tier1_car_regul_requir number(18,6) -- 当地监管核心一级资本充足率要求
    ,reserve_cap_regul_requir number(18,6) -- 当地监管储备资本要求要求
    ,concyc_cap_regul_requir number(18,6) -- 当地监管逆周期资本要求
    ,memo varchar2(512) -- 备注
    ,para_version_num varchar2(20) -- 参数版本号
    ,load_date timestamp -- 加载日期
    ,start_date date -- 开始日期
    ,end_date date -- 结束日期
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
grant select on ${iol_schema}.rwas_bis_sa_country to ${iml_schema};
grant select on ${iol_schema}.rwas_bis_sa_country to ${icl_schema};
grant select on ${iol_schema}.rwas_bis_sa_country to ${idl_schema};
grant select on ${iol_schema}.rwas_bis_sa_country to ${iel_schema};

-- comment
comment on table ${iol_schema}.rwas_bis_sa_country is '计量参数_国家';
comment on column ${iol_schema}.rwas_bis_sa_country.ser_num is '序号';
comment on column ${iol_schema}.rwas_bis_sa_country.bis_country_cd is '计量注册国家代码';
comment on column ${iol_schema}.rwas_bis_sa_country.bis_country_name is '注册国名称';
comment on column ${iol_schema}.rwas_bis_sa_country.spc_rating_no is '评级序号';
comment on column ${iol_schema}.rwas_bis_sa_country.spc_rating_cd is '标普评级代码';
comment on column ${iol_schema}.rwas_bis_sa_country.car_regul_requir is '当地监管资本充足率要求';
comment on column ${iol_schema}.rwas_bis_sa_country.tier1_car_regul_requir is '当地监管一级资本充足率要求';
comment on column ${iol_schema}.rwas_bis_sa_country.core_tier1_car_regul_requir is '当地监管核心一级资本充足率要求';
comment on column ${iol_schema}.rwas_bis_sa_country.reserve_cap_regul_requir is '当地监管储备资本要求要求';
comment on column ${iol_schema}.rwas_bis_sa_country.concyc_cap_regul_requir is '当地监管逆周期资本要求';
comment on column ${iol_schema}.rwas_bis_sa_country.memo is '备注';
comment on column ${iol_schema}.rwas_bis_sa_country.para_version_num is '参数版本号';
comment on column ${iol_schema}.rwas_bis_sa_country.load_date is '加载日期';
comment on column ${iol_schema}.rwas_bis_sa_country.start_date is '开始日期';
comment on column ${iol_schema}.rwas_bis_sa_country.end_date is '结束日期';
comment on column ${iol_schema}.rwas_bis_sa_country.start_dt is '开始时间';
comment on column ${iol_schema}.rwas_bis_sa_country.end_dt is '结束时间';
comment on column ${iol_schema}.rwas_bis_sa_country.id_mark is '增删标志';
comment on column ${iol_schema}.rwas_bis_sa_country.etl_timestamp is 'ETL处理时间戳';
