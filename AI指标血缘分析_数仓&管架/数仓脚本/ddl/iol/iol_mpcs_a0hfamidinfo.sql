/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a0hfamidinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a0hfamidinfo
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a0hfamidinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a0hfamidinfo(
    familyid varchar2(12) -- 家庭号
    ,custacc varchar2(60) -- 家长卡号
    ,familystate varchar2(2) -- 家庭状态 0-生效 1-失效
    ,createdate varchar2(15) -- 创建时间
    ,effectivedate varchar2(15) -- 生效时间
    ,abatedate varchar2(15) -- 废弃时间
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
grant select on ${iol_schema}.mpcs_a0hfamidinfo to ${iml_schema};
grant select on ${iol_schema}.mpcs_a0hfamidinfo to ${icl_schema};
grant select on ${iol_schema}.mpcs_a0hfamidinfo to ${idl_schema};
grant select on ${iol_schema}.mpcs_a0hfamidinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a0hfamidinfo is '家庭号表';
comment on column ${iol_schema}.mpcs_a0hfamidinfo.familyid is '家庭号';
comment on column ${iol_schema}.mpcs_a0hfamidinfo.custacc is '家长卡号';
comment on column ${iol_schema}.mpcs_a0hfamidinfo.familystate is '家庭状态 0-生效 1-失效';
comment on column ${iol_schema}.mpcs_a0hfamidinfo.createdate is '创建时间';
comment on column ${iol_schema}.mpcs_a0hfamidinfo.effectivedate is '生效时间';
comment on column ${iol_schema}.mpcs_a0hfamidinfo.abatedate is '废弃时间';
comment on column ${iol_schema}.mpcs_a0hfamidinfo.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a0hfamidinfo.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a0hfamidinfo.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a0hfamidinfo.etl_timestamp is 'ETL处理时间戳';
