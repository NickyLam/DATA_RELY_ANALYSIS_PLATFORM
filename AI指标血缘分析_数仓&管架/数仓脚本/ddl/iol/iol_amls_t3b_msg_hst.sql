/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amls_t3b_msg_hst
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amls_t3b_msg_hst
whenever sqlerror continue none;
drop table ${iol_schema}.amls_t3b_msg_hst purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amls_t3b_msg_hst(
    msg_id varchar2(96) -- 报文代码
    ,stat_dt date -- 数据日期
    ,rpt_id varchar2(96) -- 报告代码
    ,msg_type varchar2(2) -- 报文类型（参见[字典:aml0061]）
    ,packet_id varchar2(96) -- 数据包代码
    ,rpt_type varchar2(3) -- 报告类型（参见[字典:aml0062]）
    ,rpt_org_id varchar2(30) -- 报告机构编码
    ,send_dt date -- 报送日期
    ,send_char varchar2(12) -- 报送日期（字符串）
    ,bat_seq varchar2(12) -- 报送批次序号
    ,msg_seq varchar2(12) -- 报文序号
    ,msg_file varchar2(96) -- 报文文件名
    ,msg_file_path varchar2(192) -- 报文路径 + 文件名
    ,orig_msg_file varchar2(96) -- 原始报文文件名
    ,orig_msg_file_path varchar2(192) -- 原始报文路径 + 文件名
    ,orig_msg_id varchar2(96) -- 原始报文代码
    ,atht_file varchar2(96) -- 附件文件名
    ,atht_file_path varchar2(192) -- 附件文件名路径
    ,msg_sts varchar2(2) -- 报文状态
    ,create_tm varchar2(29) -- 创建时间
    ,creator varchar2(48) -- 创建人
    ,modify_tm varchar2(29) -- 修改时间
    ,modifier varchar2(48) -- 修改人
    ,msg_type_s varchar2(3) -- 报文子类型（参见[字典:aml0162]）
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
grant select on ${iol_schema}.amls_t3b_msg_hst to ${iml_schema};
grant select on ${iol_schema}.amls_t3b_msg_hst to ${icl_schema};
grant select on ${iol_schema}.amls_t3b_msg_hst to ${idl_schema};
grant select on ${iol_schema}.amls_t3b_msg_hst to ${iel_schema};

-- comment
comment on table ${iol_schema}.amls_t3b_msg_hst is '可疑报文（历史表）';
comment on column ${iol_schema}.amls_t3b_msg_hst.msg_id is '报文代码';
comment on column ${iol_schema}.amls_t3b_msg_hst.stat_dt is '数据日期';
comment on column ${iol_schema}.amls_t3b_msg_hst.rpt_id is '报告代码';
comment on column ${iol_schema}.amls_t3b_msg_hst.msg_type is '报文类型（参见[字典:aml0061]）';
comment on column ${iol_schema}.amls_t3b_msg_hst.packet_id is '数据包代码';
comment on column ${iol_schema}.amls_t3b_msg_hst.rpt_type is '报告类型（参见[字典:aml0062]）';
comment on column ${iol_schema}.amls_t3b_msg_hst.rpt_org_id is '报告机构编码';
comment on column ${iol_schema}.amls_t3b_msg_hst.send_dt is '报送日期';
comment on column ${iol_schema}.amls_t3b_msg_hst.send_char is '报送日期（字符串）';
comment on column ${iol_schema}.amls_t3b_msg_hst.bat_seq is '报送批次序号';
comment on column ${iol_schema}.amls_t3b_msg_hst.msg_seq is '报文序号';
comment on column ${iol_schema}.amls_t3b_msg_hst.msg_file is '报文文件名';
comment on column ${iol_schema}.amls_t3b_msg_hst.msg_file_path is '报文路径 + 文件名';
comment on column ${iol_schema}.amls_t3b_msg_hst.orig_msg_file is '原始报文文件名';
comment on column ${iol_schema}.amls_t3b_msg_hst.orig_msg_file_path is '原始报文路径 + 文件名';
comment on column ${iol_schema}.amls_t3b_msg_hst.orig_msg_id is '原始报文代码';
comment on column ${iol_schema}.amls_t3b_msg_hst.atht_file is '附件文件名';
comment on column ${iol_schema}.amls_t3b_msg_hst.atht_file_path is '附件文件名路径';
comment on column ${iol_schema}.amls_t3b_msg_hst.msg_sts is '报文状态';
comment on column ${iol_schema}.amls_t3b_msg_hst.create_tm is '创建时间';
comment on column ${iol_schema}.amls_t3b_msg_hst.creator is '创建人';
comment on column ${iol_schema}.amls_t3b_msg_hst.modify_tm is '修改时间';
comment on column ${iol_schema}.amls_t3b_msg_hst.modifier is '修改人';
comment on column ${iol_schema}.amls_t3b_msg_hst.msg_type_s is '报文子类型（参见[字典:aml0162]）';
comment on column ${iol_schema}.amls_t3b_msg_hst.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.amls_t3b_msg_hst.etl_timestamp is 'ETL处理时间戳';
