/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nibs_ibs_acp_attachment_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nibs_ibs_acp_attachment_info
whenever sqlerror continue none;
drop table ${iol_schema}.nibs_ibs_acp_attachment_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nibs_ibs_acp_attachment_info(
    tradeserno varchar2(16) -- 受理编号
    ,content varchar2(4000) -- 
    ,createtime varchar2(6) -- 创建时间
    ,createdate varchar2(10) -- 创建日期
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
grant select on ${iol_schema}.nibs_ibs_acp_attachment_info to ${iml_schema};
grant select on ${iol_schema}.nibs_ibs_acp_attachment_info to ${icl_schema};
grant select on ${iol_schema}.nibs_ibs_acp_attachment_info to ${idl_schema};
grant select on ${iol_schema}.nibs_ibs_acp_attachment_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.nibs_ibs_acp_attachment_info is '预受理附表';
comment on column ${iol_schema}.nibs_ibs_acp_attachment_info.tradeserno is '受理编号';
comment on column ${iol_schema}.nibs_ibs_acp_attachment_info.content is '';
comment on column ${iol_schema}.nibs_ibs_acp_attachment_info.createtime is '创建时间';
comment on column ${iol_schema}.nibs_ibs_acp_attachment_info.createdate is '创建日期';
comment on column ${iol_schema}.nibs_ibs_acp_attachment_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.nibs_ibs_acp_attachment_info.etl_timestamp is 'ETL处理时间戳';
