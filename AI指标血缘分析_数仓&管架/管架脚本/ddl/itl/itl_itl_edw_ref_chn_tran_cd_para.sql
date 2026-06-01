/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_ref_chn_tran_cd_para
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_ref_chn_tran_cd_para
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_ref_chn_tran_cd_para purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_ref_chn_tran_cd_para(
    chn_cd varchar2(30) -- 渠道代码
    ,tran_cd varchar2(30) -- 交易代码
    ,intnal_tran_cd varchar2(30) -- 内部交易代码
    ,msg_type_cd varchar2(30) -- 报文类型代码
    ,tran_proc_cd varchar2(30) -- 交易处理代码
    ,tran_name varchar2(500) -- 交易名称
    ,bank_int_proc_cd varchar2(30) -- 行内处理代码
    ,obank_proc_cd varchar2(30) -- 他行处理代码
    ,status_cd varchar2(30) -- 状态代码
    ,fobid_flg varchar2(10) -- 禁用标志
    ,deflt_memo_cd varchar2(30) -- 默认摘要代码
    ,memo_name varchar2(500) -- 摘要名称
    ,update_dt date -- 更新日期
    ,src_table_name varchar2(100) -- 源表名称
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.itl_edw_ref_chn_tran_cd_para to ${iol_schema};

-- comment
comment on table ${itl_schema}.itl_edw_ref_chn_tran_cd_para is '渠道交易代码参数表';
comment on column ${itl_schema}.itl_edw_ref_chn_tran_cd_para.chn_cd is '渠道代码';
comment on column ${itl_schema}.itl_edw_ref_chn_tran_cd_para.tran_cd is '交易代码';
comment on column ${itl_schema}.itl_edw_ref_chn_tran_cd_para.intnal_tran_cd is '内部交易代码';
comment on column ${itl_schema}.itl_edw_ref_chn_tran_cd_para.msg_type_cd is '报文类型代码';
comment on column ${itl_schema}.itl_edw_ref_chn_tran_cd_para.tran_proc_cd is '交易处理代码';
comment on column ${itl_schema}.itl_edw_ref_chn_tran_cd_para.tran_name is '交易名称';
comment on column ${itl_schema}.itl_edw_ref_chn_tran_cd_para.bank_int_proc_cd is '行内处理代码';
comment on column ${itl_schema}.itl_edw_ref_chn_tran_cd_para.obank_proc_cd is '他行处理代码';
comment on column ${itl_schema}.itl_edw_ref_chn_tran_cd_para.status_cd is '状态代码';
comment on column ${itl_schema}.itl_edw_ref_chn_tran_cd_para.fobid_flg is '禁用标志';
comment on column ${itl_schema}.itl_edw_ref_chn_tran_cd_para.deflt_memo_cd is '默认摘要代码';
comment on column ${itl_schema}.itl_edw_ref_chn_tran_cd_para.memo_name is '摘要名称';
comment on column ${itl_schema}.itl_edw_ref_chn_tran_cd_para.update_dt is '更新日期';
comment on column ${itl_schema}.itl_edw_ref_chn_tran_cd_para.src_table_name is '源表名称';
comment on column ${itl_schema}.itl_edw_ref_chn_tran_cd_para.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_edw_ref_chn_tran_cd_para.etl_timestamp is 'ETL处理时间戳';
