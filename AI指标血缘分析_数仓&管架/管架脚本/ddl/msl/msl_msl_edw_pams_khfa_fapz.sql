/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_pams_khfa_fapz
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_pams_khfa_fapz
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_pams_khfa_fapz purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_pams_khfa_fapz(
    etl_dt date
    ,fabh number(22)
    ,famc varchar2(300)
    ,khnf number(22)
    ,khdx varchar2(30)
    ,pzms varchar2(3)
    ,jglb varchar2(4000)
    ,hylb varchar2(4000)
    ,khzq number(22)
    ,khqs varchar2(600)
    ,yyzlbh number(22)
    ,yybzz number(25,4)
    ,yysx number(25,4)
    ,yyxx number(25,4)
    ,zt varchar2(6)
    ,czr varchar2(36)
    ,czsj timestamp(6)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_pams_khfa_fapz to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_pams_khfa_fapz is '考核方案-方案配置';
comment on column ${msl_schema}.msl_edw_pams_khfa_fapz.etl_dt is 'ETL处理日期';
comment on column ${msl_schema}.msl_edw_pams_khfa_fapz.fabh is '方案编号';
comment on column ${msl_schema}.msl_edw_pams_khfa_fapz.famc is '方案名称';
comment on column ${msl_schema}.msl_edw_pams_khfa_fapz.khnf is '考核年份';
comment on column ${msl_schema}.msl_edw_pams_khfa_fapz.khdx is '考核对象：1-机构，2-行员';
comment on column ${msl_schema}.msl_edw_pams_khfa_fapz.pzms is '配置模式';
comment on column ${msl_schema}.msl_edw_pams_khfa_fapz.jglb is '机构类别';
comment on column ${msl_schema}.msl_edw_pams_khfa_fapz.hylb is '行员类别';
comment on column ${msl_schema}.msl_edw_pams_khfa_fapz.khzq is '考核周期';
comment on column ${msl_schema}.msl_edw_pams_khfa_fapz.khqs is '考核期数';
comment on column ${msl_schema}.msl_edw_pams_khfa_fapz.yyzlbh is '应用种类编号';
comment on column ${msl_schema}.msl_edw_pams_khfa_fapz.yybzz is '应用标准分';
comment on column ${msl_schema}.msl_edw_pams_khfa_fapz.yysx is '应用上限分';
comment on column ${msl_schema}.msl_edw_pams_khfa_fapz.yyxx is '应用下限分';
comment on column ${msl_schema}.msl_edw_pams_khfa_fapz.zt is '状态';
comment on column ${msl_schema}.msl_edw_pams_khfa_fapz.czr is '操作人';
comment on column ${msl_schema}.msl_edw_pams_khfa_fapz.czsj is '操作时间';
