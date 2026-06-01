/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a63tacct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a63tacct
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a63tacct purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a63tacct(
    signno varchar2(38) -- 签约号
    ,acctno varchar2(39) -- 账号
    ,acctname varchar2(384) -- 账户名称
    ,custno varchar2(30) -- 客户号
    ,permit varchar2(2) -- 账户权限
    ,openbrcno varchar2(15) -- 开户机构号
    ,stat varchar2(2) -- 状态
    ,signdt varchar2(18) -- 签约日期
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
grant select on ${iol_schema}.mpcs_a63tacct to ${iml_schema};
grant select on ${iol_schema}.mpcs_a63tacct to ${icl_schema};
grant select on ${iol_schema}.mpcs_a63tacct to ${idl_schema};
grant select on ${iol_schema}.mpcs_a63tacct to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a63tacct is '账户签约信息表';
comment on column ${iol_schema}.mpcs_a63tacct.signno is '签约号';
comment on column ${iol_schema}.mpcs_a63tacct.acctno is '账号';
comment on column ${iol_schema}.mpcs_a63tacct.acctname is '账户名称';
comment on column ${iol_schema}.mpcs_a63tacct.custno is '客户号';
comment on column ${iol_schema}.mpcs_a63tacct.permit is '账户权限';
comment on column ${iol_schema}.mpcs_a63tacct.openbrcno is '开户机构号';
comment on column ${iol_schema}.mpcs_a63tacct.stat is '状态';
comment on column ${iol_schema}.mpcs_a63tacct.signdt is '签约日期';
comment on column ${iol_schema}.mpcs_a63tacct.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a63tacct.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a63tacct.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a63tacct.etl_timestamp is 'ETL处理时间戳';
