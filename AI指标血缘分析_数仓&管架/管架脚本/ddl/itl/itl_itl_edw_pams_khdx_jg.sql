/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_pams_khdx_jg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_pams_khdx_jg
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_pams_khdx_jg purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_pams_khdx_jg(
    khdxdh number(22) -- 考核对象代号
    ,jgdh varchar2(15) -- 机构代号
    ,jgmc varchar2(150) -- 机构名称
    ,jyjgbz varchar2(2) -- 经营机构标志
    ,pxbz number(22) -- 排序标志
    ,zxzt varchar2(2) -- 注销状态
    ,zxrq number(22) -- 注销日期
    ,fhdh varchar2(15) -- 分行代号
    ,fhbz varchar2(3) -- 分行标志
    ,jgdj varchar2(3) -- 机构登记
    ,jgqc varchar2(150) -- 机构全称
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.itl_edw_pams_khdx_jg to ${iol_schema};

-- comment
comment on table ${itl_schema}.itl_edw_pams_khdx_jg is '考核对象-机构';
comment on column ${itl_schema}.itl_edw_pams_khdx_jg.khdxdh is '考核对象代号';
comment on column ${itl_schema}.itl_edw_pams_khdx_jg.jgdh is '机构代号';
comment on column ${itl_schema}.itl_edw_pams_khdx_jg.jgmc is '机构名称';
comment on column ${itl_schema}.itl_edw_pams_khdx_jg.jyjgbz is '经营机构标志';
comment on column ${itl_schema}.itl_edw_pams_khdx_jg.pxbz is '排序标志';
comment on column ${itl_schema}.itl_edw_pams_khdx_jg.zxzt is '注销状态';
comment on column ${itl_schema}.itl_edw_pams_khdx_jg.zxrq is '注销日期';
comment on column ${itl_schema}.itl_edw_pams_khdx_jg.fhdh is '分行代号';
comment on column ${itl_schema}.itl_edw_pams_khdx_jg.fhbz is '分行标志';
comment on column ${itl_schema}.itl_edw_pams_khdx_jg.jgdj is '机构登记';
comment on column ${itl_schema}.itl_edw_pams_khdx_jg.jgqc is '机构全称';
comment on column ${itl_schema}.itl_edw_pams_khdx_jg.start_dt is '开始时间';
comment on column ${itl_schema}.itl_edw_pams_khdx_jg.end_dt is '结束时间';
comment on column ${itl_schema}.itl_edw_pams_khdx_jg.id_mark is '增删标志';
comment on column ${itl_schema}.itl_edw_pams_khdx_jg.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_edw_pams_khdx_jg.etl_timestamp is 'ETL处理时间戳';
