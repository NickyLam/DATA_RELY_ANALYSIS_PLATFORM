/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_pams_yjzb_hy_recal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_pams_yjzb_hy_recal
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_pams_yjzb_hy_recal purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_pams_yjzb_hy_recal(
    tjrq number(22) -- 数据日期
    ,recal_dt number(22) -- 重算日期
    ,zbdh number(22) -- 指标编号
    ,sdbs varchar2(3) -- 时段标识
    ,bz varchar2(9) -- 币种代码
    ,khdxdh number(22) -- 考核对象代号
    ,zbz number(25,4) -- 指标结果
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
grant select on ${itl_schema}.itl_edw_pams_yjzb_hy_recal to ${iol_schema};

-- comment
comment on table ${itl_schema}.itl_edw_pams_yjzb_hy_recal is '业绩指标-行员_重算';
comment on column ${itl_schema}.itl_edw_pams_yjzb_hy_recal.tjrq is '数据日期';
comment on column ${itl_schema}.itl_edw_pams_yjzb_hy_recal.recal_dt is '重算日期';
comment on column ${itl_schema}.itl_edw_pams_yjzb_hy_recal.zbdh is '指标编号';
comment on column ${itl_schema}.itl_edw_pams_yjzb_hy_recal.sdbs is '时段标识';
comment on column ${itl_schema}.itl_edw_pams_yjzb_hy_recal.bz is '币种代码';
comment on column ${itl_schema}.itl_edw_pams_yjzb_hy_recal.khdxdh is '考核对象代号';
comment on column ${itl_schema}.itl_edw_pams_yjzb_hy_recal.zbz is '指标结果';
comment on column ${itl_schema}.itl_edw_pams_yjzb_hy_recal.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_edw_pams_yjzb_hy_recal.etl_timestamp is 'ETL处理时间戳';
