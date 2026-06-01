/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_csb_djlbpz
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_csb_djlbpz
whenever sqlerror continue none;
drop table ${iol_schema}.pams_csb_djlbpz purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_csb_djlbpz(
    djbh varchar2(15) -- 等级编号
    ,zxmc varchar2(75) -- 职衔名称
    ,djmc varchar2(75) -- 等级名称
    ,yxqsrq number(22,0) -- 生效日期起
    ,yxjsrq number(22,0) -- 生效日期止
    ,czr varchar2(18) -- 操作人代号
    ,czsj timestamp -- 操作时间
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
grant select on ${iol_schema}.pams_csb_djlbpz to ${iml_schema};
grant select on ${iol_schema}.pams_csb_djlbpz to ${icl_schema};
grant select on ${iol_schema}.pams_csb_djlbpz to ${idl_schema};
grant select on ${iol_schema}.pams_csb_djlbpz to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_csb_djlbpz is '参数表-行员等级配置';
comment on column ${iol_schema}.pams_csb_djlbpz.djbh is '等级编号';
comment on column ${iol_schema}.pams_csb_djlbpz.zxmc is '职衔名称';
comment on column ${iol_schema}.pams_csb_djlbpz.djmc is '等级名称';
comment on column ${iol_schema}.pams_csb_djlbpz.yxqsrq is '生效日期起';
comment on column ${iol_schema}.pams_csb_djlbpz.yxjsrq is '生效日期止';
comment on column ${iol_schema}.pams_csb_djlbpz.czr is '操作人代号';
comment on column ${iol_schema}.pams_csb_djlbpz.czsj is '操作时间';
comment on column ${iol_schema}.pams_csb_djlbpz.start_dt is '开始时间';
comment on column ${iol_schema}.pams_csb_djlbpz.end_dt is '结束时间';
comment on column ${iol_schema}.pams_csb_djlbpz.id_mark is '增删标志';
comment on column ${iol_schema}.pams_csb_djlbpz.etl_timestamp is 'ETL处理时间戳';
