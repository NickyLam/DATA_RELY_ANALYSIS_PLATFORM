/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_sglr_hydjjg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_sglr_hydjjg
whenever sqlerror continue none;
drop table ${iol_schema}.pams_sglr_hydjjg purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_sglr_hydjjg(
    khdxdh number(22,0) -- 考核对象代号
    ,hydh varchar2(18) -- 行员代号
    ,hymc varchar2(150) -- 行员名称
    ,fhdh varchar2(15) -- 分行代号
    ,fhmc varchar2(150) -- 分行名称
    ,jgdh varchar2(15) -- 机构代号
    ,jgmc varchar2(150) -- 机构名称
    ,djbh varchar2(15) -- 等级编号
    ,zxmc varchar2(75) -- 职衔名称
    ,djmc varchar2(75) -- 等级名称
    ,yxqsrq number(22,0) -- 有效起始日期
    ,yxjsrq number(22,0) -- 有效结束日期
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
grant select on ${iol_schema}.pams_sglr_hydjjg to ${iml_schema};
grant select on ${iol_schema}.pams_sglr_hydjjg to ${icl_schema};
grant select on ${iol_schema}.pams_sglr_hydjjg to ${idl_schema};
grant select on ${iol_schema}.pams_sglr_hydjjg to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_sglr_hydjjg is '手工录入-行员等级结果';
comment on column ${iol_schema}.pams_sglr_hydjjg.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_sglr_hydjjg.hydh is '行员代号';
comment on column ${iol_schema}.pams_sglr_hydjjg.hymc is '行员名称';
comment on column ${iol_schema}.pams_sglr_hydjjg.fhdh is '分行代号';
comment on column ${iol_schema}.pams_sglr_hydjjg.fhmc is '分行名称';
comment on column ${iol_schema}.pams_sglr_hydjjg.jgdh is '机构代号';
comment on column ${iol_schema}.pams_sglr_hydjjg.jgmc is '机构名称';
comment on column ${iol_schema}.pams_sglr_hydjjg.djbh is '等级编号';
comment on column ${iol_schema}.pams_sglr_hydjjg.zxmc is '职衔名称';
comment on column ${iol_schema}.pams_sglr_hydjjg.djmc is '等级名称';
comment on column ${iol_schema}.pams_sglr_hydjjg.yxqsrq is '有效起始日期';
comment on column ${iol_schema}.pams_sglr_hydjjg.yxjsrq is '有效结束日期';
comment on column ${iol_schema}.pams_sglr_hydjjg.czr is '操作人代号';
comment on column ${iol_schema}.pams_sglr_hydjjg.czsj is '操作时间';
comment on column ${iol_schema}.pams_sglr_hydjjg.start_dt is '开始时间';
comment on column ${iol_schema}.pams_sglr_hydjjg.end_dt is '结束时间';
comment on column ${iol_schema}.pams_sglr_hydjjg.id_mark is '增删标志';
comment on column ${iol_schema}.pams_sglr_hydjjg.etl_timestamp is 'ETL处理时间戳';
