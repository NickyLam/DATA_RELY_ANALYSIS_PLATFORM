/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_v_yjzb_hy
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_v_yjzb_hy
whenever sqlerror continue none;
drop table ${iol_schema}.pams_v_yjzb_hy purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_v_yjzb_hy(
    tjrq number(22,0) -- 统计日期
    ,zbdh number(22,0) -- 指标代号
    ,sdbs varchar2(3) -- 时段标识
    ,bz varchar2(9) -- 币种
    ,khdxdh number(22,0) -- 考核对象代号
    ,zbz number(25,4) -- 指标值
    ,zblxbz varchar2(6) -- 指标类型标志(0-原指标；1-比去年末基数；2-同比基数；3-比去年末净增；4-同比净增)
    ,yszbdh number(22) -- 映射指标代号
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
grant select on ${iol_schema}.pams_v_yjzb_hy to ${iml_schema};
grant select on ${iol_schema}.pams_v_yjzb_hy to ${icl_schema};
grant select on ${iol_schema}.pams_v_yjzb_hy to ${idl_schema};
grant select on ${iol_schema}.pams_v_yjzb_hy to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_v_yjzb_hy is '业绩指标-行员';
comment on column ${iol_schema}.pams_v_yjzb_hy.tjrq is '统计日期';
comment on column ${iol_schema}.pams_v_yjzb_hy.zbdh is '指标代号';
comment on column ${iol_schema}.pams_v_yjzb_hy.sdbs is '时段标识';
comment on column ${iol_schema}.pams_v_yjzb_hy.bz is '币种';
comment on column ${iol_schema}.pams_v_yjzb_hy.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_v_yjzb_hy.zbz is '指标值';
comment on column ${iol_schema}.pams_v_yjzb_hy.zblxbz is '指标类型标志(0-原指标；1-比去年末基数；2-同比基数；3-比去年末净增；4-同比净增)';
comment on column ${iol_schema}.pams_v_yjzb_hy.yszbdh is '映射指标代号';
comment on column ${iol_schema}.pams_v_yjzb_hy.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_v_yjzb_hy.etl_timestamp is 'ETL处理时间戳';
