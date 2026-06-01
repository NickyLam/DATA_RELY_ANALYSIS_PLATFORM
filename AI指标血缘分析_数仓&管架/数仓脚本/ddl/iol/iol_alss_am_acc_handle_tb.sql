/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol alss_am_acc_handle_tb
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.alss_am_acc_handle_tb
whenever sqlerror continue none;
drop table ${iol_schema}.alss_am_acc_handle_tb purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.alss_am_acc_handle_tb(
    acctno varchar2(4000) -- 账号
    ,spectp varchar2(75)
    ,invost varchar2(3)
    ,channelstatus varchar2(3)
    ,operateremarks varchar2(450)
    ,statusupdateorg varchar2(30)
    ,trandt date
    ,transq varchar2(75)
    ,frozdt date
    ,frozsq varchar2(30)
    ,unfrdt date
    ,unfrsq varchar2(30)
    ,frtransq varchar2(75)
    ,operatetype varchar2(3)
    ,freezetransno varchar2(75)
    ,freezeno varchar2(75)
    ,freezedate date
    ,freezestatus varchar2(30)
    ,statusid varchar2(30)
    ,reason varchar2(500)
    ,isdealsource varchar2(8)
    ,warn_id varchar2(75)
    ,form_id varchar2(19) -- 
    ,teller_id varchar2(100) -- 
    ,client_no varchar2(50) -- 
    ,trantime varchar2(50) -- 
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
grant select on ${iol_schema}.alss_am_acc_handle_tb to ${iml_schema};
grant select on ${iol_schema}.alss_am_acc_handle_tb to ${icl_schema};
grant select on ${iol_schema}.alss_am_acc_handle_tb to ${idl_schema};
grant select on ${iol_schema}.alss_am_acc_handle_tb to ${iel_schema};

-- comment
comment on table ${iol_schema}.alss_am_acc_handle_tb is '账户处置表';
comment on column ${iol_schema}.alss_am_acc_handle_tb.acctno is '账号';
comment on column ${iol_schema}.alss_am_acc_handle_tb.spectp is '账号类型';
comment on column ${iol_schema}.alss_am_acc_handle_tb.invost is '原交易渠道状态';
comment on column ${iol_schema}.alss_am_acc_handle_tb.channelstatus is '现交易渠道状态';
comment on column ${iol_schema}.alss_am_acc_handle_tb.operateremarks is '处置原因';
comment on column ${iol_schema}.alss_am_acc_handle_tb.statusupdateorg is '渠道状态变更机构';
comment on column ${iol_schema}.alss_am_acc_handle_tb.trandt is '核心交易日期';
comment on column ${iol_schema}.alss_am_acc_handle_tb.transq is '核心交易流水';
comment on column ${iol_schema}.alss_am_acc_handle_tb.frozdt is '止付日期';
comment on column ${iol_schema}.alss_am_acc_handle_tb.frozsq is '止付流水';
comment on column ${iol_schema}.alss_am_acc_handle_tb.unfrdt is '解止日期';
comment on column ${iol_schema}.alss_am_acc_handle_tb.unfrsq is '解止流水';
comment on column ${iol_schema}.alss_am_acc_handle_tb.frtransq is '止付解止付主机流水号';
comment on column ${iol_schema}.alss_am_acc_handle_tb.operatetype is '处置操作类型';
comment on column ${iol_schema}.alss_am_acc_handle_tb.freezetransno is '冻结流水号';
comment on column ${iol_schema}.alss_am_acc_handle_tb.freezeno is '冻结编号';
comment on column ${iol_schema}.alss_am_acc_handle_tb.freezedate is '冻结日期';
comment on column ${iol_schema}.alss_am_acc_handle_tb.freezestatus is '账户冻结状态';
comment on column ${iol_schema}.alss_am_acc_handle_tb.statusid is '账户状态';
comment on column ${iol_schema}.alss_am_acc_handle_tb.reason is '账户处置原因';
comment on column ${iol_schema}.alss_am_acc_handle_tb.isdealsource is '处置来源';
comment on column ${iol_schema}.alss_am_acc_handle_tb.warn_id is '预警编号';
comment on column ${iol_schema}.alss_am_acc_handle_tb.form_id is '';
comment on column ${iol_schema}.alss_am_acc_handle_tb.teller_id is '';
comment on column ${iol_schema}.alss_am_acc_handle_tb.client_no is '';
comment on column ${iol_schema}.alss_am_acc_handle_tb.trantime is '';
comment on column ${iol_schema}.alss_am_acc_handle_tb.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.alss_am_acc_handle_tb.etl_timestamp is 'ETL处理时间戳';
