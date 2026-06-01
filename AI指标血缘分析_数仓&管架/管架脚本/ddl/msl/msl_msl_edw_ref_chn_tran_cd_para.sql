/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_ref_chn_tran_cd_para
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_ref_chn_tran_cd_para
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_ref_chn_tran_cd_para purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_ref_chn_tran_cd_para(
    etl_dt date
    ,chn_cd varchar2(30)
    ,tran_cd varchar2(30)
    ,intnal_tran_cd varchar2(30)
    ,msg_type_cd varchar2(30)
    ,tran_proc_cd varchar2(30)
    ,tran_name varchar2(500)
    ,bank_int_proc_cd varchar2(30)
    ,obank_proc_cd varchar2(30)
    ,status_cd varchar2(30)
    ,fobid_flg varchar2(10)
    ,deflt_memo_cd varchar2(30)
    ,memo_name varchar2(500)
    ,create_dt date
    ,update_dt date
    ,id_mark varchar2(10)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_ref_chn_tran_cd_para to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_ref_chn_tran_cd_para is '渠道交易代码参数表';
comment on column ${msl_schema}.msl_edw_ref_chn_tran_cd_para.etl_dt is 'ETL处理日期';
comment on column ${msl_schema}.msl_edw_ref_chn_tran_cd_para.chn_cd is '渠道代码';
comment on column ${msl_schema}.msl_edw_ref_chn_tran_cd_para.tran_cd is '交易代码';
comment on column ${msl_schema}.msl_edw_ref_chn_tran_cd_para.intnal_tran_cd is '内部交易代码';
comment on column ${msl_schema}.msl_edw_ref_chn_tran_cd_para.msg_type_cd is '报文类型代码';
comment on column ${msl_schema}.msl_edw_ref_chn_tran_cd_para.tran_proc_cd is '交易处理代码';
comment on column ${msl_schema}.msl_edw_ref_chn_tran_cd_para.tran_name is '交易名称';
comment on column ${msl_schema}.msl_edw_ref_chn_tran_cd_para.bank_int_proc_cd is '行内处理代码';
comment on column ${msl_schema}.msl_edw_ref_chn_tran_cd_para.obank_proc_cd is '他行处理代码';
comment on column ${msl_schema}.msl_edw_ref_chn_tran_cd_para.status_cd is '状态代码';
comment on column ${msl_schema}.msl_edw_ref_chn_tran_cd_para.fobid_flg is '禁用标志';
comment on column ${msl_schema}.msl_edw_ref_chn_tran_cd_para.deflt_memo_cd is '默认摘要代码';
comment on column ${msl_schema}.msl_edw_ref_chn_tran_cd_para.memo_name is '摘要名称';
comment on column ${msl_schema}.msl_edw_ref_chn_tran_cd_para.create_dt is '创建日期';
comment on column ${msl_schema}.msl_edw_ref_chn_tran_cd_para.update_dt is '更新日期';
comment on column ${msl_schema}.msl_edw_ref_chn_tran_cd_para.id_mark is '删除标识';
