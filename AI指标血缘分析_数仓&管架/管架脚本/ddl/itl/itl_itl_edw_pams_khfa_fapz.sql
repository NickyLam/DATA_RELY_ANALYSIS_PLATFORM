/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_pams_khfa_fapz
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_pams_khfa_fapz
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_pams_khfa_fapz purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_pams_khfa_fapz(
    fabh number(22) -- 方案编号
    ,famc varchar2(300) -- 方案名称
    ,khnf number(22) -- 考核年份
    ,khdx varchar2(30) -- 考核对象：1-机构，2-行员
    ,pzms varchar2(3) -- 配置模式
    ,jglb varchar2(4000) -- 机构类别
    ,hylb varchar2(4000) -- 行员类别
    ,khzq number(22) -- 考核周期
    ,khqs varchar2(600) -- 考核期数
    ,yyzlbh number(22) -- 应用种类编号
    ,yybzz number(25,4) -- 应用标准分
    ,yysx number(25,4) -- 应用上限分
    ,yyxx number(25,4) -- 应用下限分
    ,zt varchar2(6) -- 状态
    ,czr varchar2(36) -- 操作人
    ,czsj timestamp -- 操作时间
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
grant select on ${itl_schema}.itl_edw_pams_khfa_fapz to ${iol_schema};

-- comment
comment on table ${itl_schema}.itl_edw_pams_khfa_fapz is '考核方案-方案配置';
comment on column ${itl_schema}.itl_edw_pams_khfa_fapz.fabh is '方案编号';
comment on column ${itl_schema}.itl_edw_pams_khfa_fapz.famc is '方案名称';
comment on column ${itl_schema}.itl_edw_pams_khfa_fapz.khnf is '考核年份';
comment on column ${itl_schema}.itl_edw_pams_khfa_fapz.khdx is '考核对象：1-机构，2-行员';
comment on column ${itl_schema}.itl_edw_pams_khfa_fapz.pzms is '配置模式';
comment on column ${itl_schema}.itl_edw_pams_khfa_fapz.jglb is '机构类别';
comment on column ${itl_schema}.itl_edw_pams_khfa_fapz.hylb is '行员类别';
comment on column ${itl_schema}.itl_edw_pams_khfa_fapz.khzq is '考核周期';
comment on column ${itl_schema}.itl_edw_pams_khfa_fapz.khqs is '考核期数';
comment on column ${itl_schema}.itl_edw_pams_khfa_fapz.yyzlbh is '应用种类编号';
comment on column ${itl_schema}.itl_edw_pams_khfa_fapz.yybzz is '应用标准分';
comment on column ${itl_schema}.itl_edw_pams_khfa_fapz.yysx is '应用上限分';
comment on column ${itl_schema}.itl_edw_pams_khfa_fapz.yyxx is '应用下限分';
comment on column ${itl_schema}.itl_edw_pams_khfa_fapz.zt is '状态';
comment on column ${itl_schema}.itl_edw_pams_khfa_fapz.czr is '操作人';
comment on column ${itl_schema}.itl_edw_pams_khfa_fapz.czsj is '操作时间';
comment on column ${itl_schema}.itl_edw_pams_khfa_fapz.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_edw_pams_khfa_fapz.etl_timestamp is 'ETL处理时间戳';
