/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a51ubcolltran
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a51ubcolltran
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a51ubcolltran purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a51ubcolltran(
    transdate varchar2(12) -- 交易日期
    ,workcode varchar2(12) -- 交易处理码
    ,systrace varchar2(12) -- 流水号
    ,transtime varchar2(15) -- 交易时间
    ,acptermnlid varchar2(12) -- 受理终端号
    ,priacct varchar2(53) -- 卡号
    ,transamt number(15,2) -- 交易金额
    ,rspcode varchar2(3) -- 响应码
    ,outacctnbr varchar2(53) -- 转出账号
    ,inacctnbr varchar2(53) -- 转入账号
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
grant select on ${iol_schema}.mpcs_a51ubcolltran to ${iml_schema};
grant select on ${iol_schema}.mpcs_a51ubcolltran to ${icl_schema};
grant select on ${iol_schema}.mpcs_a51ubcolltran to ${idl_schema};
grant select on ${iol_schema}.mpcs_a51ubcolltran to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a51ubcolltran is 'ATMC端流水表';
comment on column ${iol_schema}.mpcs_a51ubcolltran.transdate is '交易日期';
comment on column ${iol_schema}.mpcs_a51ubcolltran.workcode is '交易处理码';
comment on column ${iol_schema}.mpcs_a51ubcolltran.systrace is '流水号';
comment on column ${iol_schema}.mpcs_a51ubcolltran.transtime is '交易时间';
comment on column ${iol_schema}.mpcs_a51ubcolltran.acptermnlid is '受理终端号';
comment on column ${iol_schema}.mpcs_a51ubcolltran.priacct is '卡号';
comment on column ${iol_schema}.mpcs_a51ubcolltran.transamt is '交易金额';
comment on column ${iol_schema}.mpcs_a51ubcolltran.rspcode is '响应码';
comment on column ${iol_schema}.mpcs_a51ubcolltran.outacctnbr is '转出账号';
comment on column ${iol_schema}.mpcs_a51ubcolltran.inacctnbr is '转入账号';
comment on column ${iol_schema}.mpcs_a51ubcolltran.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a51ubcolltran.etl_timestamp is 'ETL处理时间戳';
