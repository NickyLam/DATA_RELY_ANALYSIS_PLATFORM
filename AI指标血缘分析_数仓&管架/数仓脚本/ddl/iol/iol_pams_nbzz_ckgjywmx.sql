/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_nbzz_ckgjywmx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_nbzz_ckgjywmx
whenever sqlerror continue none;
drop table ${iol_schema}.pams_nbzz_ckgjywmx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_nbzz_ckgjywmx(
    tjrq number(22) -- 统计日期
    ,jxdxdh number(22) -- 绩效对象代号
    ,khdxdh number(22) -- 考核对象代号
    ,jgkhdxdh number(22) -- 机构考核对象代号
    ,jgdh varchar2(30) -- 机构代号
    ,fpjs varchar2(30) -- 分配角色
    ,bz varchar2(30) -- 币种
    ,ckgjtfl number(25,4) -- 敞口国际业务投放量
    ,jjh varchar2(300) -- 借据号
    ,cph varchar2(180) -- 产品号
    ,cpmc varchar2(1500) -- 产品名称
    ,ybje number(25,4) -- 原币金额
    ,zrmbhl number(15,7) -- 折人民币汇率
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
grant select on ${iol_schema}.pams_nbzz_ckgjywmx to ${iml_schema};
grant select on ${iol_schema}.pams_nbzz_ckgjywmx to ${icl_schema};
grant select on ${iol_schema}.pams_nbzz_ckgjywmx to ${idl_schema};
grant select on ${iol_schema}.pams_nbzz_ckgjywmx to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_nbzz_ckgjywmx is '内部总账-敞口类国际业务投放量明细';
comment on column ${iol_schema}.pams_nbzz_ckgjywmx.tjrq is '统计日期';
comment on column ${iol_schema}.pams_nbzz_ckgjywmx.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_nbzz_ckgjywmx.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_nbzz_ckgjywmx.jgkhdxdh is '机构考核对象代号';
comment on column ${iol_schema}.pams_nbzz_ckgjywmx.jgdh is '机构代号';
comment on column ${iol_schema}.pams_nbzz_ckgjywmx.fpjs is '分配角色';
comment on column ${iol_schema}.pams_nbzz_ckgjywmx.bz is '币种';
comment on column ${iol_schema}.pams_nbzz_ckgjywmx.ckgjtfl is '敞口国际业务投放量';
comment on column ${iol_schema}.pams_nbzz_ckgjywmx.jjh is '借据号';
comment on column ${iol_schema}.pams_nbzz_ckgjywmx.cph is '产品号';
comment on column ${iol_schema}.pams_nbzz_ckgjywmx.cpmc is '产品名称';
comment on column ${iol_schema}.pams_nbzz_ckgjywmx.ybje is '原币金额';
comment on column ${iol_schema}.pams_nbzz_ckgjywmx.zrmbhl is '折人民币汇率';
comment on column ${iol_schema}.pams_nbzz_ckgjywmx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_nbzz_ckgjywmx.etl_timestamp is 'ETL处理时间戳';
