/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_mercht_recv_tran_para_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ref_mercht_recv_tran_para_h
whenever sqlerror continue none;
drop table ${iml_schema}.ref_mercht_recv_tran_para_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_mercht_recv_tran_para_h(
    tran_code varchar2(90) -- 交易码
    ,tran_name varchar2(750) -- 交易名称
    ,fin_tran_flg varchar2(10) -- 金融交易标志
    ,del_flg varchar2(10) -- 删除标志
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by range (end_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_default_20991231 values less than (maxvalue)
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.ref_mercht_recv_tran_para_h to ${icl_schema};
grant select on ${iml_schema}.ref_mercht_recv_tran_para_h to ${idl_schema};
grant select on ${iml_schema}.ref_mercht_recv_tran_para_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_mercht_recv_tran_para_h is '商户收单交易码参数历史';
comment on column ${iml_schema}.ref_mercht_recv_tran_para_h.tran_code is '交易码';
comment on column ${iml_schema}.ref_mercht_recv_tran_para_h.tran_name is '交易名称';
comment on column ${iml_schema}.ref_mercht_recv_tran_para_h.fin_tran_flg is '金融交易标志';
comment on column ${iml_schema}.ref_mercht_recv_tran_para_h.del_flg is '删除标志';
comment on column ${iml_schema}.ref_mercht_recv_tran_para_h.start_dt is '开始时间';
comment on column ${iml_schema}.ref_mercht_recv_tran_para_h.end_dt is '结束时间';
comment on column ${iml_schema}.ref_mercht_recv_tran_para_h.id_mark is '增删标志';
comment on column ${iml_schema}.ref_mercht_recv_tran_para_h.src_table_name is '源表名称';
comment on column ${iml_schema}.ref_mercht_recv_tran_para_h.job_cd is '任务编码';
comment on column ${iml_schema}.ref_mercht_recv_tran_para_h.etl_timestamp is 'ETL处理时间戳';
