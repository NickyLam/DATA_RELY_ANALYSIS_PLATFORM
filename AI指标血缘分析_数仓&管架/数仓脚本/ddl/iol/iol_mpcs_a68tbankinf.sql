/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a68tbankinf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a68tbankinf
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a68tbankinf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a68tbankinf(
    bkcd varchar2(21) -- 参与行行号
    ,bknm varchar2(90) -- 参与行行名
    ,chrgbkcd varchar2(21) -- 所属人行行号
    ,areacd varchar2(9) -- 地区代码
    ,ctycd varchar2(9) -- 所属城市代码
    ,bkadr varchar2(180) -- 参与行地址
    ,ctctnm varchar2(180) -- 参与行联系人姓名
    ,ctcttel varchar2(45) -- 参与行联系电话
    ,pstcd varchar2(9) -- 邮编
    ,email varchar2(90) -- 电子邮件地址
    ,rmk varchar2(381) -- 备注/附言
    ,lstdate varchar2(12) -- 上次修改日期
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
grant select on ${iol_schema}.mpcs_a68tbankinf to ${iml_schema};
grant select on ${iol_schema}.mpcs_a68tbankinf to ${icl_schema};
grant select on ${iol_schema}.mpcs_a68tbankinf to ${idl_schema};
grant select on ${iol_schema}.mpcs_a68tbankinf to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a68tbankinf is '深同城行名行号信息表';
comment on column ${iol_schema}.mpcs_a68tbankinf.bkcd is '参与行行号';
comment on column ${iol_schema}.mpcs_a68tbankinf.bknm is '参与行行名';
comment on column ${iol_schema}.mpcs_a68tbankinf.chrgbkcd is '所属人行行号';
comment on column ${iol_schema}.mpcs_a68tbankinf.areacd is '地区代码';
comment on column ${iol_schema}.mpcs_a68tbankinf.ctycd is '所属城市代码';
comment on column ${iol_schema}.mpcs_a68tbankinf.bkadr is '参与行地址';
comment on column ${iol_schema}.mpcs_a68tbankinf.ctctnm is '参与行联系人姓名';
comment on column ${iol_schema}.mpcs_a68tbankinf.ctcttel is '参与行联系电话';
comment on column ${iol_schema}.mpcs_a68tbankinf.pstcd is '邮编';
comment on column ${iol_schema}.mpcs_a68tbankinf.email is '电子邮件地址';
comment on column ${iol_schema}.mpcs_a68tbankinf.rmk is '备注/附言';
comment on column ${iol_schema}.mpcs_a68tbankinf.lstdate is '上次修改日期';
comment on column ${iol_schema}.mpcs_a68tbankinf.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a68tbankinf.etl_timestamp is 'ETL处理时间戳';
