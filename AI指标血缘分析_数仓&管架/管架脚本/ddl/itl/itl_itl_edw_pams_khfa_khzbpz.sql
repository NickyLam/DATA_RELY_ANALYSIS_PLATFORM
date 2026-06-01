/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_pams_khfa_khzbpz
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_pams_khfa_khzbpz
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_pams_khfa_khzbpz purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_pams_khfa_khzbpz(
    fabh number(22) -- 方案编号
    ,khzbdh number(22) -- 考核指标代号
    ,wdmc varchar2(150) -- 维度名称
    ,wdqz number(25,4) -- 维度权重
    ,zbqz number(25,4) -- 指标权重
    ,jldw varchar2(150) -- 计量单位
    ,bdz number(25,4) -- 
    ,fdz number(25,4) -- 
    ,mbbh number(22) -- 模板编号
    ,qjlx varchar2(30) -- 
    ,jsfs varchar2(30) -- 
    ,xh number(22) -- 序号
    ,tlbl number(19,5) -- 提留比例
    ,tjcx varchar2(90) -- 统计程序
    ,xmmc varchar2(600) -- 项目名称
    ,zswdqz varchar2(3) -- 
    ,zszbqz varchar2(3) -- 折算指标权重
    ,pjbh number(22) -- 评价编号
    ,khnr varchar2(4000) -- 考核内容
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
grant select on ${itl_schema}.itl_edw_pams_khfa_khzbpz to ${iol_schema};

-- comment
comment on table ${itl_schema}.itl_edw_pams_khfa_khzbpz is '考核方案_考核指标配置';
comment on column ${itl_schema}.itl_edw_pams_khfa_khzbpz.fabh is '方案编号';
comment on column ${itl_schema}.itl_edw_pams_khfa_khzbpz.khzbdh is '考核指标代号';
comment on column ${itl_schema}.itl_edw_pams_khfa_khzbpz.wdmc is '维度名称';
comment on column ${itl_schema}.itl_edw_pams_khfa_khzbpz.wdqz is '维度权重';
comment on column ${itl_schema}.itl_edw_pams_khfa_khzbpz.zbqz is '指标权重';
comment on column ${itl_schema}.itl_edw_pams_khfa_khzbpz.jldw is '计量单位';
comment on column ${itl_schema}.itl_edw_pams_khfa_khzbpz.bdz is '';
comment on column ${itl_schema}.itl_edw_pams_khfa_khzbpz.fdz is '';
comment on column ${itl_schema}.itl_edw_pams_khfa_khzbpz.mbbh is '模板编号';
comment on column ${itl_schema}.itl_edw_pams_khfa_khzbpz.qjlx is '';
comment on column ${itl_schema}.itl_edw_pams_khfa_khzbpz.jsfs is '';
comment on column ${itl_schema}.itl_edw_pams_khfa_khzbpz.xh is '序号';
comment on column ${itl_schema}.itl_edw_pams_khfa_khzbpz.tlbl is '提留比例';
comment on column ${itl_schema}.itl_edw_pams_khfa_khzbpz.tjcx is '统计程序';
comment on column ${itl_schema}.itl_edw_pams_khfa_khzbpz.xmmc is '项目名称';
comment on column ${itl_schema}.itl_edw_pams_khfa_khzbpz.zswdqz is '';
comment on column ${itl_schema}.itl_edw_pams_khfa_khzbpz.zszbqz is '折算指标权重';
comment on column ${itl_schema}.itl_edw_pams_khfa_khzbpz.pjbh is '评价编号';
comment on column ${itl_schema}.itl_edw_pams_khfa_khzbpz.khnr is '考核内容';
comment on column ${itl_schema}.itl_edw_pams_khfa_khzbpz.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_edw_pams_khfa_khzbpz.etl_timestamp is 'ETL处理时间戳';
