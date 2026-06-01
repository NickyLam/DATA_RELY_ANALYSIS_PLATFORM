/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_total_number_shares_pledged
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_total_number_shares_pledged
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_total_number_shares_pledged purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_total_number_shares_pledged(
    seq number(20,0) -- 记录唯一标识
    ,ctime date -- 记录创建日期
    ,mtime date -- 记录修改日期
    ,rtime date -- 记录通讯到用户端日期
    ,sec_id varchar2(300) -- 证券id
    ,announcement_date date -- 公告日期
    ,ed date -- 截止日期
    ,holder_name varchar2(1800) -- 股东名称
    ,holder_id varchar2(1200) -- 股东id
    ,pledge_total_num number(24,0) -- 质押总数
    ,share_held_num number(24,0) -- 持股总数
    ,isvalid number(1,0) -- 是否有效
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
grant select on ${iol_schema}.uxds_total_number_shares_pledged to ${iml_schema};
grant select on ${iol_schema}.uxds_total_number_shares_pledged to ${icl_schema};
grant select on ${iol_schema}.uxds_total_number_shares_pledged to ${idl_schema};
grant select on ${iol_schema}.uxds_total_number_shares_pledged to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_total_number_shares_pledged is '中国股票股份质押总数';
comment on column ${iol_schema}.uxds_total_number_shares_pledged.seq is '记录唯一标识';
comment on column ${iol_schema}.uxds_total_number_shares_pledged.ctime is '记录创建日期';
comment on column ${iol_schema}.uxds_total_number_shares_pledged.mtime is '记录修改日期';
comment on column ${iol_schema}.uxds_total_number_shares_pledged.rtime is '记录通讯到用户端日期';
comment on column ${iol_schema}.uxds_total_number_shares_pledged.sec_id is '证券id';
comment on column ${iol_schema}.uxds_total_number_shares_pledged.announcement_date is '公告日期';
comment on column ${iol_schema}.uxds_total_number_shares_pledged.ed is '截止日期';
comment on column ${iol_schema}.uxds_total_number_shares_pledged.holder_name is '股东名称';
comment on column ${iol_schema}.uxds_total_number_shares_pledged.holder_id is '股东id';
comment on column ${iol_schema}.uxds_total_number_shares_pledged.pledge_total_num is '质押总数';
comment on column ${iol_schema}.uxds_total_number_shares_pledged.share_held_num is '持股总数';
comment on column ${iol_schema}.uxds_total_number_shares_pledged.isvalid is '是否有效';
comment on column ${iol_schema}.uxds_total_number_shares_pledged.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_total_number_shares_pledged.etl_timestamp is 'ETL处理时间戳';
