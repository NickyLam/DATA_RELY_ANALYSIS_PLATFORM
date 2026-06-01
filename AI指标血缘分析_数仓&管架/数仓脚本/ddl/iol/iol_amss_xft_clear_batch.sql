/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amss_xft_clear_batch
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amss_xft_clear_batch
whenever sqlerror continue none;
drop table ${iol_schema}.amss_xft_clear_batch purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_xft_clear_batch(
    xft_batch_no varchar2(128) -- 批次流水号（主键）
    ,file_name varchar2(128) -- 文件名称
    ,clear_time timestamp -- 清分时间
    ,merch_num varchar2(32) -- 商户编号
    ,merch_name varchar2(128) -- 商户名称
    ,total_cnt number(10,0) -- 总笔数
    ,txn_total_amt number(15,2) -- 交易总金额
    ,succ_cnt number(10,0) -- 成功笔数
    ,succ_amt number(15,2) -- 成功金额
    ,fail_cnt number(10,0) -- 失败笔数
    ,fail_amt number(15,2) -- 失败金额
    ,bth_status number(2,0) -- 批次状态
    ,bth_status_msg varchar2(256) -- 批次状态信息
    ,chn_bat_seq_num varchar2(128) -- 清分请求批次流水号
    ,return_query_serial_no varchar2(128) -- 回盘查询流水号
    ,ledger_file_name varchar2(64) -- 
    ,valid_flag number(1,0) -- 有效标识（0-作废，1-正常）
    ,create_emp varchar2(32) -- 创建者
    ,create_time timestamp -- 创建时间（YYYY-MM-DD HH24:MI:SS.FF6）
    ,update_emp varchar2(32) -- 更新者
    ,update_time timestamp -- 更新时间（YYYY-MM-DD HH24:MI:SS.FF6）
    ,clear_type number(1,0) -- 1-自动清分 2-补清分 3-文件清分
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
grant select on ${iol_schema}.amss_xft_clear_batch to ${iml_schema};
grant select on ${iol_schema}.amss_xft_clear_batch to ${icl_schema};
grant select on ${iol_schema}.amss_xft_clear_batch to ${idl_schema};
grant select on ${iol_schema}.amss_xft_clear_batch to ${iel_schema};

-- comment
comment on table ${iol_schema}.amss_xft_clear_batch is '兴付通清分批次表';
comment on column ${iol_schema}.amss_xft_clear_batch.xft_batch_no is '批次流水号（主键）';
comment on column ${iol_schema}.amss_xft_clear_batch.file_name is '文件名称';
comment on column ${iol_schema}.amss_xft_clear_batch.clear_time is '清分时间';
comment on column ${iol_schema}.amss_xft_clear_batch.merch_num is '商户编号';
comment on column ${iol_schema}.amss_xft_clear_batch.merch_name is '商户名称';
comment on column ${iol_schema}.amss_xft_clear_batch.total_cnt is '总笔数';
comment on column ${iol_schema}.amss_xft_clear_batch.txn_total_amt is '交易总金额';
comment on column ${iol_schema}.amss_xft_clear_batch.succ_cnt is '成功笔数';
comment on column ${iol_schema}.amss_xft_clear_batch.succ_amt is '成功金额';
comment on column ${iol_schema}.amss_xft_clear_batch.fail_cnt is '失败笔数';
comment on column ${iol_schema}.amss_xft_clear_batch.fail_amt is '失败金额';
comment on column ${iol_schema}.amss_xft_clear_batch.bth_status is '批次状态';
comment on column ${iol_schema}.amss_xft_clear_batch.bth_status_msg is '批次状态信息';
comment on column ${iol_schema}.amss_xft_clear_batch.chn_bat_seq_num is '清分请求批次流水号';
comment on column ${iol_schema}.amss_xft_clear_batch.return_query_serial_no is '回盘查询流水号';
comment on column ${iol_schema}.amss_xft_clear_batch.ledger_file_name is '';
comment on column ${iol_schema}.amss_xft_clear_batch.valid_flag is '有效标识（0-作废，1-正常）';
comment on column ${iol_schema}.amss_xft_clear_batch.create_emp is '创建者';
comment on column ${iol_schema}.amss_xft_clear_batch.create_time is '创建时间（YYYY-MM-DD HH24:MI:SS.FF6）';
comment on column ${iol_schema}.amss_xft_clear_batch.update_emp is '更新者';
comment on column ${iol_schema}.amss_xft_clear_batch.update_time is '更新时间（YYYY-MM-DD HH24:MI:SS.FF6）';
comment on column ${iol_schema}.amss_xft_clear_batch.clear_type is '1-自动清分 2-补清分 3-文件清分';
comment on column ${iol_schema}.amss_xft_clear_batch.start_dt is '开始时间';
comment on column ${iol_schema}.amss_xft_clear_batch.end_dt is '结束时间';
comment on column ${iol_schema}.amss_xft_clear_batch.id_mark is '增删标志';
comment on column ${iol_schema}.amss_xft_clear_batch.etl_timestamp is 'ETL处理时间戳';
