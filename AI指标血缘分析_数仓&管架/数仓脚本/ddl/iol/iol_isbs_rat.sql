/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_rat
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_rat
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_rat purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_rat(
    inr varchar2(12) -- 主键inr
    ,mon varchar2(9) -- 月份
    ,cur varchar2(5) -- 币种
    ,rat number(18,7) -- 对美折算率
    ,dat date -- 更新日期
    ,ver varchar2(6) -- 版本号
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
grant select on ${iol_schema}.isbs_rat to ${iml_schema};
grant select on ${iol_schema}.isbs_rat to ${icl_schema};
grant select on ${iol_schema}.isbs_rat to ${idl_schema};
grant select on ${iol_schema}.isbs_rat to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_rat is '每月折算美元牌价';
comment on column ${iol_schema}.isbs_rat.inr is '主键inr';
comment on column ${iol_schema}.isbs_rat.mon is '月份';
comment on column ${iol_schema}.isbs_rat.cur is '币种';
comment on column ${iol_schema}.isbs_rat.rat is '对美折算率';
comment on column ${iol_schema}.isbs_rat.dat is '更新日期';
comment on column ${iol_schema}.isbs_rat.ver is '版本号';
comment on column ${iol_schema}.isbs_rat.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_rat.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_rat.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_rat.etl_timestamp is 'ETL处理时间戳';
