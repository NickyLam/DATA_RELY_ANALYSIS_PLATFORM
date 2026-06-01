/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a57tchnlconfirmshare
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a57tchnlconfirmshare
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a57tchnlconfirmshare purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a57tchnlconfirmshare(
    trndt varchar2(12) -- 交易日期
    ,chnl varchar2(12) -- 渠道
    ,confirmshare varchar2(27) -- 已确认份额
    ,memo varchar2(48) -- 备注
    ,reserve1 varchar2(96) -- 
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
grant select on ${iol_schema}.mpcs_a57tchnlconfirmshare to ${iml_schema};
grant select on ${iol_schema}.mpcs_a57tchnlconfirmshare to ${icl_schema};
grant select on ${iol_schema}.mpcs_a57tchnlconfirmshare to ${idl_schema};
grant select on ${iol_schema}.mpcs_a57tchnlconfirmshare to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a57tchnlconfirmshare is '';
comment on column ${iol_schema}.mpcs_a57tchnlconfirmshare.trndt is '交易日期';
comment on column ${iol_schema}.mpcs_a57tchnlconfirmshare.chnl is '渠道';
comment on column ${iol_schema}.mpcs_a57tchnlconfirmshare.confirmshare is '已确认份额';
comment on column ${iol_schema}.mpcs_a57tchnlconfirmshare.memo is '备注';
comment on column ${iol_schema}.mpcs_a57tchnlconfirmshare.reserve1 is '';
comment on column ${iol_schema}.mpcs_a57tchnlconfirmshare.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a57tchnlconfirmshare.etl_timestamp is 'ETL处理时间戳';
