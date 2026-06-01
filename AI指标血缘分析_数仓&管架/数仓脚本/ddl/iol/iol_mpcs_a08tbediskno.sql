/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a08tbediskno
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a08tbediskno
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a08tbediskno purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a08tbediskno(
    diskno varchar2(24) -- 
    ,magbrn varchar2(9) -- 
    ,oprtlr varchar2(15) -- 
    ,chktlr varchar2(15) -- 
    ,firmcode varchar2(90) -- 
    ,protocolnb varchar2(90) -- 
    ,tempacct varchar2(48) -- 
    ,pktype varchar2(30) -- 
    ,bustype varchar2(8) -- 
    ,servtype varchar2(18) -- 
    ,transdt varchar2(12) -- 
    ,rndday varchar2(5) -- 
    ,retudt varchar2(12) -- 
    ,backdate varchar2(12) -- 
    ,status varchar2(2) -- 
    ,innerstatus varchar2(2) -- 
    ,totalnum varchar2(12) -- 
    ,totalamt varchar2(26) -- 
    ,succeedtotalnum varchar2(12) -- 
    ,succeedtotalamt varchar2(26) -- 
    ,innertotalnum varchar2(12) -- 
    ,innertotalamt varchar2(26) -- 
    ,innersucceedtotalnum varchar2(12) -- 
    ,innersucceedtotalamt varchar2(26) -- 
    ,outertotalnum varchar2(12) -- 
    ,outertotalamt varchar2(26) -- 
    ,outersucceedtotalnum varchar2(12) -- 
    ,outersucceedtotalamt varchar2(26) -- 
    ,opennode varchar2(9) -- 
    ,corpacct varchar2(48) -- 
    ,corpname varchar2(180) -- 
    ,message varchar2(375) -- 
    ,hostdate varchar2(12) -- 
    ,hostnbr varchar2(96) -- 
    ,bkcode varchar2(6) -- 凭证类型
    ,cobkcd varchar2(30) -- 凭证号码
    ,cobkdt varchar2(12) -- 出票日期
    ,vefysq varchar2(60) -- 验印流水
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
grant select on ${iol_schema}.mpcs_a08tbediskno to ${iml_schema};
grant select on ${iol_schema}.mpcs_a08tbediskno to ${icl_schema};
grant select on ${iol_schema}.mpcs_a08tbediskno to ${idl_schema};
grant select on ${iol_schema}.mpcs_a08tbediskno to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a08tbediskno is '小额定期往帐批次登记表';
comment on column ${iol_schema}.mpcs_a08tbediskno.diskno is '';
comment on column ${iol_schema}.mpcs_a08tbediskno.magbrn is '';
comment on column ${iol_schema}.mpcs_a08tbediskno.oprtlr is '';
comment on column ${iol_schema}.mpcs_a08tbediskno.chktlr is '';
comment on column ${iol_schema}.mpcs_a08tbediskno.firmcode is '';
comment on column ${iol_schema}.mpcs_a08tbediskno.protocolnb is '';
comment on column ${iol_schema}.mpcs_a08tbediskno.tempacct is '';
comment on column ${iol_schema}.mpcs_a08tbediskno.pktype is '';
comment on column ${iol_schema}.mpcs_a08tbediskno.bustype is '';
comment on column ${iol_schema}.mpcs_a08tbediskno.servtype is '';
comment on column ${iol_schema}.mpcs_a08tbediskno.transdt is '';
comment on column ${iol_schema}.mpcs_a08tbediskno.rndday is '';
comment on column ${iol_schema}.mpcs_a08tbediskno.retudt is '';
comment on column ${iol_schema}.mpcs_a08tbediskno.backdate is '';
comment on column ${iol_schema}.mpcs_a08tbediskno.status is '';
comment on column ${iol_schema}.mpcs_a08tbediskno.innerstatus is '';
comment on column ${iol_schema}.mpcs_a08tbediskno.totalnum is '';
comment on column ${iol_schema}.mpcs_a08tbediskno.totalamt is '';
comment on column ${iol_schema}.mpcs_a08tbediskno.succeedtotalnum is '';
comment on column ${iol_schema}.mpcs_a08tbediskno.succeedtotalamt is '';
comment on column ${iol_schema}.mpcs_a08tbediskno.innertotalnum is '';
comment on column ${iol_schema}.mpcs_a08tbediskno.innertotalamt is '';
comment on column ${iol_schema}.mpcs_a08tbediskno.innersucceedtotalnum is '';
comment on column ${iol_schema}.mpcs_a08tbediskno.innersucceedtotalamt is '';
comment on column ${iol_schema}.mpcs_a08tbediskno.outertotalnum is '';
comment on column ${iol_schema}.mpcs_a08tbediskno.outertotalamt is '';
comment on column ${iol_schema}.mpcs_a08tbediskno.outersucceedtotalnum is '';
comment on column ${iol_schema}.mpcs_a08tbediskno.outersucceedtotalamt is '';
comment on column ${iol_schema}.mpcs_a08tbediskno.opennode is '';
comment on column ${iol_schema}.mpcs_a08tbediskno.corpacct is '';
comment on column ${iol_schema}.mpcs_a08tbediskno.corpname is '';
comment on column ${iol_schema}.mpcs_a08tbediskno.message is '';
comment on column ${iol_schema}.mpcs_a08tbediskno.hostdate is '';
comment on column ${iol_schema}.mpcs_a08tbediskno.hostnbr is '';
comment on column ${iol_schema}.mpcs_a08tbediskno.bkcode is '凭证类型';
comment on column ${iol_schema}.mpcs_a08tbediskno.cobkcd is '凭证号码';
comment on column ${iol_schema}.mpcs_a08tbediskno.cobkdt is '出票日期';
comment on column ${iol_schema}.mpcs_a08tbediskno.vefysq is '验印流水';
comment on column ${iol_schema}.mpcs_a08tbediskno.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a08tbediskno.etl_timestamp is 'ETL处理时间戳';
